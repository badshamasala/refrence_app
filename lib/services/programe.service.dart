import 'package:aayu/model/model.dart';
import 'package:aayu/services/http.service.dart';
import 'package:aayu/services/request.id.service.dart';
import 'package:aayu/view/shared/shared.dart';

const String programServiceName = "program-service";

class ProgrameService {
  Future<ProgramDurationPeriodResponse?> getProgramDurationPackages(
      String diseaseId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/duration/$diseaseId?requestId=${getRequestId()}');
    if (response != null && response["success"] == true) {
      ProgramDurationPeriodResponse programDurationResponse =
          ProgramDurationPeriodResponse();
      programDurationResponse =
          ProgramDurationPeriodResponse.fromJson(response["data"]);
      return programDurationResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<DayZeroContentResponse?> getDayZeroContent(
      String userId, String subscriptionId, String programId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/content/dayZero/$subscriptionId/$programId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      DayZeroContentResponse dayZeroContentResponse = DayZeroContentResponse();
      dayZeroContentResponse =
          DayZeroContentResponse.fromJson(response["data"]);
      return dayZeroContentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<HealingProgramContentResponse?> getDayWiseProgramContent(
      String userId, String subscriptionId, String programId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/content/$subscriptionId/$programId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      HealingProgramContentResponse healingProgrammeContentResponse =
          HealingProgramContentResponse();
      healingProgrammeContentResponse =
          HealingProgramContentResponse.fromJson(response["data"]);
      return healingProgrammeContentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> updateContentViewStatus(String userId, String programId,
      String subscriptionId, String day, String status) async {
    dynamic response = await httpPost(
      programServiceName,
      'v1/content/viewed?requestId=${getRequestId()}',
      {
        "data": {
          "programId": programId,
          "subscriptionId": subscriptionId,
          "day": day,
          "status": status
        }
      },
      customHeaders: {"x-user-id": userId},
    );
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<HealingQuizResponse?> getTodaysQuiz(
      String userId, String diseaseId, String programId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/todays/quiz/$diseaseId/$programId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      HealingQuizResponse healingQuizResponse = HealingQuizResponse();
      healingQuizResponse = HealingQuizResponse.fromJson(response["data"]);
      return healingQuizResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> submitTodaysTipAnswer(
      String userId, HealingQuizSubmitAnswerRequest postData) async {
    dynamic response = await httpPost(
        programServiceName,
        'v1/todays/quiz?requestId=${getRequestId()}',
        {"data": postData.toJson()},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<HealingTipsResponse?> getTodaysTip(
      String userId, String diseaseId, String programId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/todays/tip/$diseaseId/$programId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      HealingTipsResponse healingTipsResponse = HealingTipsResponse();
      healingTipsResponse = HealingTipsResponse.fromJson(response["data"]);
      return healingTipsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<ProgramReminderDetails?> getProgramReminderDetails(
      String userId, String subscriptionId, String programId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/reminderTime/$subscriptionId/$programId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ProgramReminderDetails programReminderDetails = ProgramReminderDetails();
      programReminderDetails =
          ProgramReminderDetails.fromJson(response["data"]);
      return programReminderDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> updateProgramReminderTime(String userId, String subscriptionId,
      String programId, dynamic postData) async {
    dynamic response = await httpPost(
        programServiceName,
        'v1/reminderTime/$subscriptionId/$programId?requestId=${getRequestId()}',
        {
          "data": postData,
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

  Future<ProgramDurationPeriodResponse?> getProgramDetailsOnProgramId(
      String programId) async {
    dynamic response = await httpGet(programServiceName,
        'v1/duration/program/$programId?requestId=${getRequestId()}');
    if (response != null && response["success"] == true) {
      ProgramDurationPeriodResponse programDurationResponse =
          ProgramDurationPeriodResponse();
      programDurationResponse =
          ProgramDurationPeriodResponse.fromJson(response["data"]);
      return programDurationResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
