import 'package:aayu/controller/healing/user_identification_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:get/get.dart';

class ProgrammeController extends GetxController {
  Color appBarTextColor = AppColors.blackLabelColor;

  DateTime selectedMonth = DateTime.now();
  bool showPopupAssesmentComplete = false;

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  DatePickerController datePickerController = DatePickerController();

  Rx<bool> isLoading = false.obs;
  Rx<bool> isContentLoading = false.obs;

  EventList<Event> markedDateMap = EventList<Event>(
    events: {},
  );

  Rx<DayZeroContentResponse?> dayZeroContent = DayZeroContentResponse().obs;
  Rx<HealingProgramContentResponse?> healingProgrammeContent =
      HealingProgramContentResponse().obs;
  Rx<HealingProgramContentResponseProgramDetailsDays?> todaysContent =
      HealingProgramContentResponseProgramDetailsDays().obs;
  RxBool initialAssessmentCompleted = false.obs;
  bool canStartProgram = false;

  ProgrammeController(bool _canStartProgram) {
    canStartProgram = _canStartProgram;
  }

  @override
  onInit() async {
    if (canStartProgram == true) {
      await getDayWiseProgramContent();
      if (todaysContent.value != null && todaysContent.value?.day != null) {
        sendProgramStartedEvent(todaysContent.value?.day! as int);
      }
    } else {
      await getDayZeroContent();
      sendProgramStartedEvent(0);
    }
    super.onInit();
  }

  getDayZeroContent() async {
    try {
      isContentLoading.value = true;
      DayZeroContentResponse? response = await ProgrameService()
          .getDayZeroContent(
              globalUserIdDetails!.userId!,
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
              subscriptionCheckResponse!.subscriptionDetails!.programId!);

      if (response != null) {
        dayZeroContent.value = response;
      } else {
        dayZeroContent.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isContentLoading.value = false;
      update();
    }
  }

  setShowPopupAssessment(bool val) {
    showPopupAssesmentComplete = val;
  }

  getInitialAssessmentStatus() async {
    try {
      UserIdentificationController userIdentificationController = Get.find();
      initialAssessmentCompleted.value = await HealingService()
          .getInitialAssessmentStatus(
              globalUserIdDetails!.userId!,
              userIdentificationController.userIndentification.value!
                  .identificationDetails!.userIdentification!);
    } catch (exp) {
      print(exp);
    } finally {
      update();
    }
  }

  getDayWiseProgramContent() async {
    try {
      isContentLoading.value = true;
      HealingProgramContentResponse? response =
          await ProgrameService().getDayWiseProgramContent(
        globalUserIdDetails!.userId!,
        subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
        subscriptionCheckResponse!.subscriptionDetails!.programId!,
      );

      if (response != null) {
        healingProgrammeContent.value = response;
        if (healingProgrammeContent.value!.programDetails != null &&
            healingProgrammeContent.value!.programDetails!.days != null &&
            healingProgrammeContent.value!.programDetails!.days!.isNotEmpty) {
          int openIndex = healingProgrammeContent.value!.programDetails!.days!
              .lastIndexWhere(
                  (element) => element!.status!.toUpperCase() == "OPEN");

          if (openIndex == -1) {
            todaysContent.value =
                healingProgrammeContent.value!.programDetails!.days![0];
          } else {
            todaysContent.value =
                healingProgrammeContent.value!.programDetails!.days![openIndex];
          }
          updateMarkedDate();
        } else {
          healingProgrammeContent.value = null;
        }
      }
    } catch (exp) {
      print(exp);
    } finally {
      isContentLoading.value = false;
      update();
    }
  }

  updateMarkedDate() {
    markedDateMap.clear();
    selectedMonth = DateTime.now();

    List<String> startDatePart =
        healingProgrammeContent.value!.programDetails!.startDate!.split("-");
    startDate.value = DateTime(int.parse(startDatePart[0]),
        int.parse(startDatePart[1]), int.parse(startDatePart[2]));

    List<String> endDatePart =
        healingProgrammeContent.value!.programDetails!.endDate!.split("-");
    endDate.value = DateTime(int.parse(endDatePart[0]),
        int.parse(endDatePart[1]), int.parse(endDatePart[2]));

    int noOfDays = endDate.value.difference(startDate.value).inDays;

    print(
        "-------------updateMarkedDate-------------\nstartDate:$startDate\nendDate:$endDate\nnoOfDays:$noOfDays");

    for (int index = 0; index < noOfDays; index++) {
      DateTime newDate = startDate.value.add(Duration(days: index));
      DateTime markedDate = DateTime(newDate.year, newDate.month, newDate.day);
      String status = "";
      if (index < healingProgrammeContent.value!.programDetails!.days!.length &&
          healingProgrammeContent.value!.programDetails!.days![index] != null) {
        status = healingProgrammeContent
                .value!.programDetails!.days![index]!.status ??
            "";
      }

      if (index == todaysContent.value!.day) {
        selectedDate.value = markedDate;
        selectedMonth = markedDate;
      }

      switch (status.toUpperCase()) {
        case "VIEWED":
          markedDateMap.add(
            markedDate,
            Event(
              date: markedDate,
              title: healingProgrammeContent
                  .value!.programDetails!.days![index]!.content!.contentId!,
              icon: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 3),
                ),
              ),
            ),
          );
          break;
        case "OPEN":
          //selectedDate.value = markedDate;
          markedDateMap.add(
            markedDate,
            Event(
              date: markedDate,
              title: healingProgrammeContent
                  .value!.programDetails!.days![index]!.content!.contentId!,
              icon: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
          break;
        default:
          markedDateMap.add(
            markedDate,
            Event(
              date: markedDate,
              title: 'LOCKED_CONTENT_$index',
              icon: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
          break;
      }
    }

    update();
  }

  setSelectedMonth(DateTime changedTime) {
    selectedMonth = changedTime;
    update();
  }

  setOnThatDayContent(DateTime changedTime) {
    int noOfDays = changedTime.difference(startDate.value).inDays;
    print("noOfDays => $noOfDays");
    selectedDate.value = changedTime;

    print(
        "-------------setOnThatDayContent-------------\nchangedTime:$changedTime\nselectedDate:$selectedDate\nnoOfDays:$noOfDays");

    if (noOfDays <
            healingProgrammeContent.value!.programDetails!.days!.length &&
        healingProgrammeContent.value!.programDetails!.days![noOfDays] !=
            null) {
      if (healingProgrammeContent
                  .value!.programDetails!.days![noOfDays]!.status!
                  .toUpperCase() ==
              "VIEWED" ||
          healingProgrammeContent
                  .value!.programDetails!.days![noOfDays]!.status!
                  .toUpperCase() ==
              "OPEN") {
        todaysContent.value =
            healingProgrammeContent.value!.programDetails!.days![noOfDays]!;

        Get.back();
      } else {
        showGetSnackBar(
            "Content is locked for selected date", SnackBarMessageTypes.Info);
      }
    } else {
      showGetSnackBar(
          "Content not available for selected date", SnackBarMessageTypes.Info);
    }

    update();
  }

  updateDayZeroContentViewStatus() async {
    if (todaysContent.value != null) {
      await ProgrameService().updateContentViewStatus(
          globalUserIdDetails!.userId!,
          subscriptionCheckResponse!.subscriptionDetails!.programId!,
          subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
          "0",
          "Viewed");
    }
  }

  updateContentViewStatus(String programId) async {
    if (todaysContent.value != null) {
      await ProgrameService().updateContentViewStatus(
          globalUserIdDetails!.userId!,
          subscriptionCheckResponse!.subscriptionDetails!.programId!,
          subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
          todaysContent.value!.day!.toString(),
          "Viewed");
    }
  }

  sendProgramStartedEvent(int day) {
    try {
      String selectedDiseaseId = "";
      String selectedDisease = "";

      for (var element
          in subscriptionCheckResponse!.subscriptionDetails!.disease!) {
        if (selectedDiseaseId.isEmpty) {
          selectedDiseaseId = element!.diseaseId!;
        } else {
          selectedDiseaseId = selectedDiseaseId + ", " + element!.diseaseId!;
        }

        if (selectedDisease.isEmpty) {
          selectedDisease = element.diseaseName!;
        } else {
          selectedDisease = selectedDisease + ", " + element.diseaseName!;
        }
      }

      dynamic eventData = {
        "user_id": globalUserIdDetails!.userId,
        "disease_id": selectedDiseaseId,
        "disease_name": selectedDisease,
        "program_type":
            subscriptionCheckResponse!.subscriptionDetails!.disease!.length == 1
                ? "Single"
                : "Personal Care",
        "program_name":
            subscriptionCheckResponse!.subscriptionDetails!.programName ?? "",
        "time_duration":
            subscriptionCheckResponse!.subscriptionDetails!.duration ?? "",
        "time_period":
            subscriptionCheckResponse!.subscriptionDetails!.period ?? "",
        "program_start_date":
            subscriptionCheckResponse!.subscriptionDetails!.startDate,
        "program_end_date":
            subscriptionCheckResponse!.subscriptionDetails!.expiryDate,
        "day": day,
        "start_date": DateTime.now().toString()
      };

      EventsService().sendEvent("Program_Started", eventData);
    } catch (e) {}
  }

  sendProgramContentViewEvent(
      int day, Content content, bool contentFinished, DateTime startDate) {
    try {
      String selectedDiseaseId = "";
      String selectedDisease = "";

      for (var element
          in subscriptionCheckResponse!.subscriptionDetails!.disease!) {
        if (selectedDiseaseId.isEmpty) {
          selectedDiseaseId = element!.diseaseId!;
        } else {
          selectedDiseaseId = selectedDiseaseId + ", " + element!.diseaseId!;
        }

        if (selectedDisease.isEmpty) {
          selectedDisease = element.diseaseName!;
        } else {
          selectedDisease = selectedDisease + ", " + element.diseaseName!;
        }
      }
      int playDuration = DateTime.now().difference(startDate).inSeconds;
      dynamic eventData = {
        "user_id": globalUserIdDetails!.userId,
        "disease_id": selectedDiseaseId,
        "disease_name": selectedDisease,
        "program_type":
            subscriptionCheckResponse!.subscriptionDetails!.disease!.length == 1
                ? "Single"
                : "Personal Care",
        "program_name":
            subscriptionCheckResponse!.subscriptionDetails!.programName ?? "",
        "time_duration":
            subscriptionCheckResponse!.subscriptionDetails!.duration ?? "",
        "time_period":
            subscriptionCheckResponse!.subscriptionDetails!.period ?? "",
        "program_start_date":
            subscriptionCheckResponse!.subscriptionDetails!.startDate,
        "program_end_date":
            subscriptionCheckResponse!.subscriptionDetails!.expiryDate,
        "day": day,
        "content_id": content.contentId,
        "content_name": content.contentName,
        "content_type": content.contentType,
        "content_duration": content.metaData!.duration!,
        "artist_id": content.artist!.artistId!,
        "artist_name": content.artist!.artistName!,
        "play_duration": playDuration,
        "content_finished": contentFinished
      };

      EventsService().sendEvent("Program_Content_Viewed", eventData);
    } catch (e) {}
  }
}
