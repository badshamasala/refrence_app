import 'package:aayu/model/model.dart';
import 'package:aayu/services/request.id.service.dart';
import '../view/shared/ui_helper/ui_helper.dart';
import 'http.service.dart';

const String eventServiceName = "event-service";

class LiveEventService {
  Future<UpcomingLiveEventsModel?> getUpcomingLiveEvents(
      String? userId, String duration) async {
    dynamic response = await httpGet(eventServiceName,
        'v1/liveEvent/upcoming/$duration?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UpcomingLiveEventsModel upcomingLiveEventsModel =
          UpcomingLiveEventsModel();
      upcomingLiveEventsModel =
          UpcomingLiveEventsModel.fromJson(response["data"]);
      return upcomingLiveEventsModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LiveEventDetailsModel?> getLiveEventDetails(
      String? userId, String liveEventId) async {
    dynamic response = await httpGet(eventServiceName,
        'v1/liveEvent/$liveEventId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      LiveEventDetailsModel liveEventDetailsModel = LiveEventDetailsModel();
      liveEventDetailsModel = LiveEventDetailsModel.fromJson(response["data"]);
      return liveEventDetailsModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> attendLiveEvent(
      String userId, String liveEventId, bool isAttending) async {
    dynamic response = await httpPost(eventServiceName,
        'v1/liveEvent/attend/$liveEventId?requestId=${getRequestId()}', {
      "data": {"isAttending": isAttending}
    },
        customHeaders: {
          "x-user-id": userId
        });
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<LiveEventsJoinModel?> joinLiveEvent(
      String userId, String liveEventId) async {
    dynamic response = await httpGet(eventServiceName,
        'v1/liveEvent/join/$liveEventId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      LiveEventsJoinModel liveEventsJoinModel = LiveEventsJoinModel();
      liveEventsJoinModel = LiveEventsJoinModel.fromJson(response['data']);

      return liveEventsJoinModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postFeedbackLiveEvent(
      String userId, String liveEventId, int rating, String feedback) async {
    dynamic response = await httpPost(eventServiceName,
        'v1/liveEvent/feedback/$liveEventId?requestId=${getRequestId()}', {
      "data": {"rating": rating, "feedback": feedback.trim()}
    },
        customHeaders: {
          "x-user-id": userId
        });
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<LiveEventScheduleModel?> getLiveEventSchedule(String userId) async {
    dynamic response = await httpGet(
        eventServiceName, 'v1/liveEvent/schedule?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      LiveEventScheduleModel liveEventScheduleModel = LiveEventScheduleModel();
      liveEventScheduleModel =
          LiveEventScheduleModel.fromJson(response["data"]);
      return liveEventScheduleModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postSmiles(String userId, String liveEventId) async {
    dynamic response = await httpPost(eventServiceName,
        'v1/liveEvent/smile/$liveEventId?requestId=${getRequestId()}', {
      "data": {"isSmiled": true}
    },
        customHeaders: {
          "x-user-id": userId
        });
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<PastLiveEventsModel?> getPastLiveEvents(
      String? userId, String trainerId) async {
    dynamic response = await httpGet(eventServiceName,
        'v1/liveEvent/past/$trainerId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      PastLiveEventsModel pastLiveEventsModel = PastLiveEventsModel();
      pastLiveEventsModel = PastLiveEventsModel.fromJson(response["data"]);
      return pastLiveEventsModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> joinPastEvent(String userId, String liveEventId) async {
    dynamic response = await httpGet(eventServiceName,
        'v1/liveEvent/past/join/$liveEventId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<LiveEventsTrainerListModel?> getEventTrainerList(
      String? userId) async {
    dynamic response = await httpGet(eventServiceName,
        'v1/liveEvent/trainer/list?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      LiveEventsTrainerListModel trainerListResponse =
          LiveEventsTrainerListModel();
      trainerListResponse =
          LiveEventsTrainerListModel.fromJson(response["data"]);
      return trainerListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
