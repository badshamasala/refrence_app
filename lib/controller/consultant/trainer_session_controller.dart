import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/recommendation/video_call_feedback.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/video_call_agora/video_call_agora.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainerSessionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<bool> isLoadingUpcomingSessions = false.obs;
  Rx<bool> isLoadingPastSessions = false.obs;
  Rx<bool> isLoadingSessionsSummary = false.obs;
  RxBool showAll = true.obs;
  Rx<CoachUpcomingSessionsModel?> upcomingSessionsList =
      CoachUpcomingSessionsModel().obs;
  Rx<CoachPastSessionsModel?> pastSessionsList = CoachPastSessionsModel().obs;
  Rx<CoachSessionSummaryModel?> sessionsSummaryList =
      CoachSessionSummaryModel().obs;
  Rx<CoachPendingReviewsModel?> pendingReviewsList =
      CoachPendingReviewsModel().obs;

  @override
  void onInit() async {
    getSessionSummary();
    super.onInit();
  }

  setShowAll(bool val) {
    showAll.value = val;
    update();
  }

  Future<void> getUpcomingSessions() async {
    try {
      isLoadingUpcomingSessions.value = true;
      CoachUpcomingSessionsModel? response = await CoachService()
          .upcomingSessions(globalUserIdDetails!.userId!, "Trainer");
      if (response != null &&
          response.upcomingSessions != null &&
          response.upcomingSessions!.isNotEmpty) {
        upcomingSessionsList.value = response;
      } else {
        upcomingSessionsList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoadingUpcomingSessions.value = false;
      update();
    }
  }

  Future<void> getPastSessions() async {
    try {
      isLoadingPastSessions.value = true;
      CoachPastSessionsModel? response = await CoachService()
          .pastSessions(globalUserIdDetails!.userId!, "Trainer");
      if (response != null && response.pastSessions!.isNotEmpty) {
        pastSessionsList.value = response;
      } else {
        pastSessionsList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoadingPastSessions.value = false;
      update();
    }
  }

  Future<void> getSessionSummary() async {
    try {
      isLoadingSessionsSummary.value = true;
      CoachSessionSummaryModel? response = await CoachService()
          .getSessionsSummary(globalUserIdDetails!.userId!, "Trainer");
      if (response != null && response.sessionSummary!.isNotEmpty) {
        sessionsSummaryList.value = response;
      } else {
        sessionsSummaryList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoadingSessionsSummary.value = false;
      update();
    }
  }

  updateUserStatusAsAttended(String coachId, String sessionId) async {
    try {
      dynamic postData = {
        "profession": "Trainer",
        "coachId": coachId,
        "sessionId": sessionId,
      };
      bool isUpdated = await CoachService()
          .updateAttendStatus(globalUserIdDetails!.userId!, postData);
      if (isUpdated == true) {
        getSessionSummary();
      }
    } catch (exp) {
      print(exp);
    } finally {}
  }

  handleCallJoin(
      BuildContext context, String trainerId, String sessionId) async {
    buildShowDialog(context);
    dynamic postData = {
      "profession": "Trainer",
      "coachId": trainerId,
      "sessionId": sessionId,
      "mediator": "AGORA"
    };
    CoachJoinSessionModel? joinCallDetails = await CoachService()
        .joinSession(globalUserIdDetails!.userId!, postData);
    Navigator.pop(context);
    if (joinCallDetails != null &&
        joinCallDetails.session != null &&
        joinCallDetails.agoraDetails != null) {
      if (joinCallDetails.agoraDetails != null) {
        joinCallViaAgora(context, joinCallDetails);
      } else {
        showGreenSnackBar(context,
            'Call Details Not Available, kindly contact our customer care');
      }
    }
  }

  joinCallViaAgora(
      BuildContext context, CoachJoinSessionModel joinCallDetails) async {
    if (joinCallDetails.agoraDetails!.token != null) {
      updateUserStatusAsAttended(
          joinCallDetails.coach!.coachId!, joinCallDetails.session!.sessionId!);
      EventsService().sendEvent("Trainer_Session_Call_Join", {
        "session_id": joinCallDetails.session!.sessionId,
        "trainer_id": joinCallDetails.coach!.coachId!,
        "trainer_name": joinCallDetails.coach!.coachName,
        "scheduled_date": joinCallDetails.session!.fromTime!,
        "slot_time": joinCallDetails.session!.fromTime!,
        "mediator": "Agora",
        "call_join_link": ""
      });

      await Permission.camera.request();
      await Permission.microphone.request();

      Get.to(VideoCallAgora(
        profession: "Trainer",
        coachName: joinCallDetails.coach!.coachName ?? "",
        secondsRemaining:
            joinCallDetails.agoraDetails!.secondsRemaining ?? 1800,
        channelName: joinCallDetails.session!.sessionId,
        clientRole: ClientRole.Broadcaster,
        token: joinCallDetails.agoraDetails!.token,
      ))!
          .then((value) {
        Get.to(
          VideoCallFeedback(
            coachType: "TRAINER",
            coachId: joinCallDetails.coach!.coachId ?? '',
            coachName: joinCallDetails.coach!.coachName ?? '',
            profilePic: joinCallDetails.coach!.profilePic ?? '',
            sessionId: joinCallDetails.session!.sessionId ?? '',
          ),
        );
      });
    } else {
      showCustomSnackBar(context, "Token Missing");
    }
  }

  getPendingReviews() async {
    try {
      pendingReviewsList.value = null;
      CoachPendingReviewsModel? response = await CoachService()
          .getPendingReviews(globalUserIdDetails!.userId!, "Trainer");
      if (response != null && response.pendingReviews!.isNotEmpty) {
        pendingReviewsList.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      update(["NutritionistSessionReviews"]);
    }
  }
}
