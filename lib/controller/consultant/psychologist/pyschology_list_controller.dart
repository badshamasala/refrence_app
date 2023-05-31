// ignore_for_file: depend_on_referenced_packages

import 'package:aayu/services/coach.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/get.dart';
import '../../../model/model.dart';
import 'package:intl/intl.dart';

class PsychologyListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isProfileLoading = false.obs;
  Rx<bool> isSlotDetailsLoading = false.obs;

  Rx<CoachListModel?> psychologyListResponse = CoachListModel().obs;
  Rx<CoachAvailableSlotsModel?> availableSlotsList =
      CoachAvailableSlotsModel().obs;
  Rx<CoachProfileModel?> coachProfile = CoachProfileModel().obs;

  DateTime selectedDate = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();
  DateTime minSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<CoachAvailableSlotsModelAvailableSlots> selectedDateSlots = [];
  CoachAvailableSlotsModelAvailableSlots? selectedSlot;

  DatePickerController datePickerController = DatePickerController();

  Future<void> getPsychologyList() async {
    try {
      isLoading(true);
      CoachListModel? response = await CoachService()
          .getCoachList(globalUserIdDetails?.userId ?? "", "Psychologist");
      if (response != null &&
          response.coachList != null &&
          response.coachList!.isNotEmpty) {
        psychologyListResponse.value = response;
      } else {
        psychologyListResponse.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getPsychologyProfile(String psychologistId) async {
    try {
      isProfileLoading(true);
      coachProfile.value = null;
      CoachProfileModel? response = await CoachService()
          .getCoachProfile(globalUserIdDetails?.userId ?? "", psychologistId);
      if (response != null && response.coachDetails != null) {
        coachProfile.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isProfileLoading(false);
      update();
    }
  }

  Future<void> getPsychologyAvailableSlots(String psychologistId) async {
    try {
      isSlotDetailsLoading.value = true;
      availableSlotsList.value = null;
      selectedDateSlots = [];
      CoachAvailableSlotsModel? response = await CoachService()
          .getCoachAvailableSlots(globalUserIdDetails?.userId ?? "",
              "Psychologist", psychologistId);
      if (response != null &&
          response.availableSlots != null &&
          response.availableSlots!.isNotEmpty) {
        availableSlotsList.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isSlotDetailsLoading.value = false;
      setSelectedDate(selectedDate);
      update();
    }
  }

  setSelectedDate(DateTime changedDate) {
    if (changedDate.compareTo(minSelectedDate) >= 0) {
      selectedDate = changedDate;
      selectedDateSlots = [];
      if (availableSlotsList.value != null) {
        for (var element in availableSlotsList.value!.availableSlots!) {
          element!.selected = false;
        }
        for (var element in availableSlotsList.value!.availableSlots!) {
          if (DateFormat.yMMMd().format(selectedDate).toString() ==
              DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                element!.fromTime!,
              ))) {
            selectedDateSlots.add(element);
          }
        }
      }
    }
    update(["SlotCalender", "AvailableSlots", "AvailableSlotAction"]);
  }

  checkSlotSeleted() {
    bool isSelected = false;
    if (availableSlotsList.value != null) {
      CoachAvailableSlotsModelAvailableSlots? userSelectedSlot =
          availableSlotsList.value!.availableSlots!
              .firstWhereOrNull((element) => element!.selected == true);
      if (userSelectedSlot != null) {
        selectedSlot = userSelectedSlot;
        isSelected = userSelectedSlot.selected!;
      } else {
        selectedSlot = null;
      }
    }
    return isSelected;
  }

  Future<bool> bookSlot(String psycholgistId, String sessionId,
      String consultType, String bookType, String paymentOrderId) async {
    bool isBooked = false;
    if (sessionId.isNotEmpty) {
      String subscriptionId = "";
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!;
      }
      dynamic postData = {
        "profession": "Psychologist",
        "coachId": psycholgistId,
        "sessionId": sessionId,
        "consultType": consultType,
        "sessionBookType": bookType,
        "mediator": "AGORA",
        "subscriptionId": subscriptionId,
        "paymentOrderId": paymentOrderId
      };
      isBooked =
          await CoachService().bookSlot(globalUserIdDetails!.userId!, postData);
      if (isBooked == true) {}
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBooked;
  }

  Future<bool> rescheduleSlot(
      String previousPsychologistId,
      String previousSessionId,
      String psychologistId,
      String consultType,
      String bookType,
      String sessionId) async {
    bool isBooked = false;
    if (sessionId.isNotEmpty) {
      String subscriptionId = "";
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!;
      }
      dynamic postData = {
        "profession": "Psychologist",
        "mediator": "AGORA",
        "previousSession": {
          "coachId": previousPsychologistId,
          "sessionId": previousSessionId
        },
        "newSession": {
          "coachId": psychologistId,
          "sessionId": sessionId,
          "consultType": consultType,
          "sessionBookType": bookType,
          "subscriptionId": subscriptionId
        },
      };
      isBooked = await CoachService()
          .rescheduleSlot(globalUserIdDetails!.userId!, postData);
      if (isBooked == true) {}
    } else {
      showGetSnackBar("Please select any slot", SnackBarMessageTypes.Info);
    }
    return isBooked;
  }
}
