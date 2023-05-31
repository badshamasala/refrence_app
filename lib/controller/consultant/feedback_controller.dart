import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  int rating = -1;
  TextEditingController textController = TextEditingController();
  updateRating(int _rating) {
    rating = _rating;
    update();
  }

  Future<bool> postLiveEventFeedBack(String liveEventId) async {
    bool isSubmitted = false;
    try {
      EventsService().sendEvent("Live_Event_Feedback", {
        "live_event_id": liveEventId,
        "rating": (rating + 1),
      });
      isSubmitted = await LiveEventService().postFeedbackLiveEvent(
          globalUserIdDetails!.userId!,
          liveEventId,
          (rating + 1),
          textController.text.trim());
    } catch (error) {
      print(error);
    } finally {}
    return isSubmitted;
  }

  Future<bool> postFeedback(
      String profession, String coachId, String sessionId) async {
    bool isSubmitted = false;
    try {
      dynamic postData = {
        "profession": profession,
        "coachId": coachId,
        "sessionId": sessionId,
        "rating": (rating + 1),
        "review": textController.text.trim()
      };
      isSubmitted = await CoachService()
          .submitReview(globalUserIdDetails!.userId!, postData);
    } catch (error) {
      print(error);
    } finally {}
    return isSubmitted;
  }
}
