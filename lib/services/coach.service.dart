import 'package:aayu/model/model.dart';
import 'package:aayu/view/shared/shared.dart';
import 'http.service.dart';
import 'request.id.service.dart';

const String coachServiceName = "consultant-service";

class CoachService {
  Future<CoachListModel?> getCoachList(String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/coach/list/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachListModel coachListResponse = CoachListModel();
      coachListResponse = CoachListModel.fromJson(response["data"]);
      return coachListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachProfileModel?> getCoachProfile(
      String userId, String coachId) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/coach/profile/$coachId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachProfileModel coachProfileResponse = CoachProfileModel();
      coachProfileResponse = CoachProfileModel.fromJson(response["data"]);
      return coachProfileResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachAvailableSlotsModel?> getCoachAvailableSlots(
      String userId, String profession, String coachId) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/coach/availableSlots/$coachId/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachAvailableSlotsModel availableSlotsResponse =
          CoachAvailableSlotsModel();
      availableSlotsResponse =
          CoachAvailableSlotsModel.fromJson(response["data"]);
      return availableSlotsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  //BOOK SESSION APIS

  Future<bool> checkIsBooked(String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/session/isBooked/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isBooked"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> blockSlot(String userId, dynamic postData) async {
    dynamic response = await httpPost(coachServiceName,
        'v1/user/session/block?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isBlocked"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> confirmSlot(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        coachServiceName,
        'v1/user/session/confirm?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isConfimed"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> bookSlot(String userId, dynamic postData) async {
    dynamic response = await httpPost(coachServiceName,
        'v1/user/session/book?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isBooked"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> rescheduleSlot(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        coachServiceName,
        'v1/user/session/reschedule?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["isRescheduled"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> addSessions(String userId, dynamic postData) async {
    dynamic response = await httpPost(coachServiceName,
        'v1/user/session/add?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isAdded"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  //Sessions APIs
  Future<CoachUpcomingSessionsModel?> upcomingSessions(
      String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/sessions/upcoming/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachUpcomingSessionsModel sessionListResponse =
          CoachUpcomingSessionsModel();
      sessionListResponse =
          CoachUpcomingSessionsModel.fromJson(response["data"]);
      return sessionListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachPendingSessionsModel?> pendingSessions(
      String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/sessions/pending/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachPendingSessionsModel sessionListResponse =
          CoachPendingSessionsModel();
      sessionListResponse =
          CoachPendingSessionsModel.fromJson(response["data"]);
      return sessionListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachPastSessionsModel?> pastSessions(
      String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/sessions/past/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachPastSessionsModel sessionListResponse = CoachPastSessionsModel();
      sessionListResponse = CoachPastSessionsModel.fromJson(response["data"]);
      return sessionListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachSessionSummaryModel?> getSessionsSummary(
      String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/sessions/summary/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachSessionSummaryModel sessionListResponse = CoachSessionSummaryModel();
      sessionListResponse = CoachSessionSummaryModel.fromJson(response["data"]);
      return sessionListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachRecentlyConsultedModel?> recentlyConsulted(
      String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/sessions/recently/consulted/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachRecentlyConsultedModel sessionListResponse =
          CoachRecentlyConsultedModel();
      sessionListResponse =
          CoachRecentlyConsultedModel.fromJson(response["data"]);
      return sessionListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CoachJoinSessionModel?> joinSession(
      String userId, dynamic postData) async {
    dynamic response = await httpPost(coachServiceName,
        'v1/user/session/join?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachJoinSessionModel joinSessionResponse = CoachJoinSessionModel();
      joinSessionResponse = CoachJoinSessionModel.fromJson(response["data"]);
      return joinSessionResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> updateAttendStatus(String userId, dynamic postData) async {
    dynamic response = await httpPatch(
        coachServiceName,
        'v1/user/session/status/attend?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] == true) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> submitReview(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        coachServiceName,
        'v1/user/session/review?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<CoachPendingReviewsModel?> getPendingReviews(
      String userId, String profession) async {
    dynamic response = await httpGet(coachServiceName,
        'v1/user/session/review/pending/$profession?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      CoachPendingReviewsModel pendingReviewsList =
          CoachPendingReviewsModel();
      pendingReviewsList =
          CoachPendingReviewsModel.fromJson(response["data"]);
      return pendingReviewsList;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
