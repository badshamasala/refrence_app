import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/services/third-party/firestore.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../view/live_events/live_events_feedback.dart';
import '../../view/video_call_agora/live_stream_agora.dart';

class LiveEventsController extends GetxController {
  Rx<UpcomingLiveEventsModel?> upcomingLiveEvents =
      UpcomingLiveEventsModel().obs;
  Rx<UpcomingLiveEventsModel?> upcoming48HoursLiveEvents =
      UpcomingLiveEventsModel().obs;
  Rx<LiveEventDetailsModel?> liveEventDetails = LiveEventDetailsModel().obs;
  RxBool isLoading = false.obs;
  RxBool isDetailLoading = false.obs;
  Color appBarTextColor = AppColors.blackLabelColor;
  DateTime? eventStartTime;
  TextEditingController liveEventsCountController = TextEditingController();
  RxBool changeLiveCountLoading = false.obs;

  UpcomingLiveEventsModelUpcomingEvents? selectedLiveEvent;
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0);
  DatePickerController datePickerController = DatePickerController();
  Iterable<UpcomingLiveEventsModelUpcomingEvents?>? dayWiseLiveEvents = [];

  Iterable<UpcomingLiveEventsModelUpcomingEvents?>? artistWiseLiveEvents = [];
  Rx<String> selectedArtistId = "".obs;
  Rx<LiveEventsTrainerListModel?> eventTrainerList =
      LiveEventsTrainerListModel().obs;

  Iterable<UpcomingLiveEventsModelUpcomingEvents?>? mentalWellBeingEvents = [];

  Future<void> getUpcomingLiveEvents() async {
    isLoading(true);
    try {
      UpcomingLiveEventsModel? response = await LiveEventService()
          .getUpcomingLiveEvents(globalUserIdDetails?.userId, "7 Days");
      if (response != null && response.upcomingEvents != null) {
        upcomingLiveEvents.value = response;
        DateTime temDate = dateFromTimestamp(
            response.upcomingEvents?.first?.schedule?.epochTime?.startTime ??
                0);
        DateTime firstEventDate =
            DateTime(temDate.year, temDate.month, temDate.day, 0, 0, 0, 0);
        getDateWiseLiveEvents(firstEventDate, false);
      } else {
        upcomingLiveEvents.value = null;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
      update();
    }
  }

  getTodaysEventsForMentalWellBeing() async {
    try {
      if (upcomingLiveEvents.value == null) {
        await getUpcomingLiveEvents();
      }
      String todaysDate = DateFormat('dd MMM yyyy').format(DateTime.now());
      mentalWellBeingEvents = upcomingLiveEvents.value?.upcomingEvents?.where(
          (element) =>
              element!.eventType == "MEDITATION" &&
              DateFormat('dd MMM yyyy').format(dateFromTimestamp(
                      element.schedule!.epochTime!.startTime!)) ==
                  todaysDate);
    } catch (e) {
    } finally {
      update(["MentalWellBeingEvents"]);
    }
  }

  Future<void> getUpcoming48HoursLiveEvents(String liveEventId) async {
    isLoading(true);
    try {
      UpcomingLiveEventsModel? response = await LiveEventService()
          .getUpcomingLiveEvents(globalUserIdDetails?.userId, "48 Hours");
      if (response != null && response.upcomingEvents != null) {
        upcoming48HoursLiveEvents.value = response;
        upcoming48HoursLiveEvents.value!.upcomingEvents!
            .removeWhere((element) => element!.liveEventId == liveEventId);
      } else {
        upcoming48HoursLiveEvents.value = null;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> getLiveEventDetails(String liveEventId) async {
    isDetailLoading(true);
    try {
      liveEventDetails.value = null;
      LiveEventDetailsModel? response = await LiveEventService()
          .getLiveEventDetails(globalUserIdDetails?.userId, liveEventId);
      if (response != null && response.eventDetails != null) {
        liveEventDetails.value = response;
        eventStartTime = DateTime.fromMillisecondsSinceEpoch(
          response.eventDetails!.schedule!.epochTime!.startTime ?? 0,
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      isDetailLoading(false);
    }
  }

  Future<bool> attendEvent(String liveEventId, bool isAttending) async {
    bool isUpdated = false;
    try {
      isUpdated = await LiveEventService().attendLiveEvent(
          globalUserIdDetails!.userId!, liveEventId, isAttending);

      if (isUpdated) {
        liveEventDetails.value!.eventDetails!.attendee!.totalAttendees =
            liveEventDetails.value!.eventDetails!.attendee!.totalAttendees! + 1;
        liveEventDetails.value!.eventDetails!.attendee!.isAttending = true;
        update();
      }
    } catch (e) {
      rethrow;
    } finally {}
    return isUpdated;
  }

  Future<void> joinLiveEvent(String liveEventId, BuildContext context,
      String trainerName, String trainerGender) async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({"screenName": "LIVE_EVENT", "liveEventId": liveEventId});
      return;
    }
    try {
      buildShowDialog(context);
      LiveEventsJoinModel? liveEventsJoinModel = await LiveEventService()
          .joinLiveEvent(globalUserIdDetails!.userId!, liveEventId);
      Get.back();
      if (liveEventsJoinModel != null &&
          liveEventsJoinModel.eventDetails != null &&
          liveEventsJoinModel.agoraDetails!.agoraToken != null &&
          liveEventsJoinModel.eventDetails!.schedule != null) {
        EventsService().sendEvent("Join_Event_Success", {
          "live_event_id": liveEventsJoinModel.eventDetails!.liveEventId!,
          "live_event_name": liveEventsJoinModel.eventDetails!.eventTitle!,
        });

        await FirestoreService()
            .joinChannel(liveEventsJoinModel.eventDetails!.liveEventId ?? "");
        Get.to(LiveStreamAgora(
                drName: trainerName,
                drGender: trainerGender,
                channelName:
                    liveEventsJoinModel.eventDetails!.liveEventId ?? "",
                clientRole: ClientRole.Audience,
                token: liveEventsJoinModel.agoraDetails!.agoraToken ?? "",
                secondsRemaining: liveEventsJoinModel
                        .eventDetails!.schedule!.secondsRemaining ??
                    0,
                timeLapsed:
                    liveEventsJoinModel.eventDetails!.schedule!.timeLapsed ??
                        0))!
            .then((value) async {
          buildShowDialog(context);
          await Future.wait([
            getUpcomingLiveEvents(),
            getUpcoming48HoursLiveEvents(liveEventId),
          ]);
          Get.back();
          if (liveEventsJoinModel.allowFeedback == true) {
            Get.to(
              LiveEventFeedback(
                liveEventId: liveEventId,
                liveEventPreview:
                    liveEventDetails.value!.eventDetails!.eventImages!.preview!,
              ),
            );
          }
        });
      } else {
        showGreenSnackBar(context, 'Live Event has ended!');
      }
    } catch (e) {
      rethrow;
    } finally {}
  }

  removeEventFrom48Hours(String liveEventId) {
    if (upcoming48HoursLiveEvents.value != null &&
        upcoming48HoursLiveEvents.value!.upcomingEvents != null) {
      upcoming48HoursLiveEvents.value!.upcomingEvents!
          .removeWhere((element) => element!.liveEventId == liveEventId);
    }
  }

  setSelectedLiveEvent(UpcomingLiveEventsModelUpcomingEvents event) {
    selectedLiveEvent = event;
    update();
  }

  Future<void> sendSmile(String liveEventId) async {
    try {
      await LiveEventService()
          .postSmiles(globalUserIdDetails!.userId!, liveEventId);
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future<void> sendLiveEventCount(String liveEventId) async {
    changeLiveCountLoading(true);
    await FirestoreService().changeLiveCount(
        liveEventId, int.parse(liveEventsCountController.text));
    changeLiveCountLoading(false);
  }

  Future<bool> checkIfChangeLiveCountAllowed() async {
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();
    if (userDetailsResponse != null &&
        userDetailsResponse.userDetails != null &&
        userDetailsResponse.userDetails!.mobileNumber != null) {
      List<String> list = [
        "918779937179",
        "919930104412",
        "919967541071",
        "919773493959",
        "919870833699",
        "919920792789",
        "919892620764"
      ];
      if (list.contains(userDetailsResponse.userDetails!.mobileNumber)) {
        return true;
      }
    }
    return false;
  }

  getDateWiseLiveEvents(DateTime calenderDate, bool doUpdate) {
    DateTime nextDate = calenderDate.add(const Duration(days: 1));
    selectedDate = calenderDate;
    dayWiseLiveEvents = [];
    dayWiseLiveEvents = upcomingLiveEvents.value?.upcomingEvents?.where(
        (element) =>
            (element?.schedule?.epochTime?.startTime ?? 0) >
                calenderDate.millisecondsSinceEpoch &&
            (element?.schedule?.epochTime?.startTime ?? 0) <
                nextDate.millisecondsSinceEpoch);
    if (doUpdate == true) {
      update();
    }
  }

  getArtistWiseLiveEvents(String trainerId, bool doUpdate) {
    selectedArtistId.value = trainerId;
    artistWiseLiveEvents = [];
    artistWiseLiveEvents = upcomingLiveEvents.value?.upcomingEvents
        ?.where((element) => element?.trainer?.trainerId == trainerId);
    if (doUpdate == true) {
      update([
        "ArtistWiseLiveEvents",
        "LiveEventTrainerList",
        "TrainerWiseEventDetails"
      ]);
    }
  }

  markAsAttending(String liveEventId) {
    upcomingLiveEvents.value?.upcomingEvents
        ?.firstWhere((element) => element?.liveEventId == liveEventId)
        ?.isAttending = true;
    update();
  }

  Future<void> getEventTrainerList() async {
    try {
      LiveEventsTrainerListModel? response = await LiveEventService()
          .getEventTrainerList(globalUserIdDetails?.userId);
      if (response != null) {
        eventTrainerList.value = response;
      } else {
        eventTrainerList.value = null;
      }
    } catch (e) {
      rethrow;
    } finally {
      update(["LiveEventTrainerList", "TrainerWiseEventDetails"]);
    }
  }
}
