import '../model/model.dart';
import '../view/shared/ui_helper/ui_helper.dart';
import 'http.service.dart';
import 'request.id.service.dart';

const String psychologyServiceName = "psychology-service";

class PsychologyService {
  Future<UserPsychologyDetailsModel?> getUserPsychologyDetails(
      String userId) async {
    dynamic response = await httpGet(psychologyServiceName,
        'v1/user/psychology/details?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UserPsychologyDetailsModel userPsychologyDetails =
          UserPsychologyDetailsModel();
      userPsychologyDetails =
          UserPsychologyDetailsModel.fromJson(response["data"]);
      return userPsychologyDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> startUserPsychology(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        psychologyServiceName,
        'v1/user/psychology/entry?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      /* {
        "userNutritionMasterId": "9bd4c0a0-bf25-11ed-8b6b-7b930b85fb1b",
        "started": true,
        "sessionsAdded": true
      } */
      if (response["data"] != null && response["data"]["started"] != null) {
        if (response["data"]["started"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> extendPsychologyPlan(String userId, dynamic postData) async {
    dynamic response = await httpPut(
        psychologyServiceName,
        'v1/user/psychology/extend?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      /* {
        "userNutritionMasterId": "9bd4c0a0-bf25-11ed-8b6b-7b930b85fb1b",
        "extended": true,
        "sessionsAdded": true
      } */
      if (response["data"] != null && response["data"]["extended"] != null) {
        if (response["data"]["extended"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> updateConsent(String userId, dynamic postData) async {
    dynamic response = await httpPatch(
        psychologyServiceName,
        'v1/user/psychology/consent?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<NutritionInitialAssessmentModel?> getInitialAssessment(
      String userId) async {
    dynamic response = await httpGet(psychologyServiceName,
        'v1/user/psychology/assessment/initial?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      NutritionInitialAssessmentModel initialAssessmentResponse =
          NutritionInitialAssessmentModel();
      initialAssessmentResponse =
          NutritionInitialAssessmentModel.fromJson(response["data"]);
      return initialAssessmentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> submitAssessment(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        psychologyServiceName,
        'v1/user/psychology/assessment/initial?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["userAssessmentId"] != null &&
          response["data"]["userAssessmentId"] != "") {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> completeAssessment(String userId, dynamic postData) async {
    dynamic response = await httpPatch(
        psychologyServiceName,
        'v1/user/psychology/assessment/initial?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<UserPsychologyJournalLogsModel?> getJournalEntries(
      String userId) async {
    dynamic response = await httpGet(psychologyServiceName,
        'v1/user/psychology/journal/logs?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UserPsychologyJournalLogsModel journalLogs =
          UserPsychologyJournalLogsModel();
      journalLogs = UserPsychologyJournalLogsModel.fromJson(response["data"]);
      return journalLogs;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<PsychologyRandomJournalModel?> getRandomJournal(String userId) async {
    dynamic response = await httpGet(psychologyServiceName,
        'v1/user/psychology/journal?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      PsychologyRandomJournalModel journalLogs = PsychologyRandomJournalModel();
      journalLogs = PsychologyRandomJournalModel.fromJson(response["data"]);
      return journalLogs;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> submitJournalAnswer(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        psychologyServiceName,
        'v1/user/psychology/journal?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["userJournalId"] != null) {
        return true;
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }
}
