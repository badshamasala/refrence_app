import 'package:aayu/model/healing/weekly.health.card.model.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/hive.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'http.service.dart';
import 'request.id.service.dart';

const String healingServiceName = "healing-service";

class HealingService {
  Future<HealingListResponse?> getHealingList() async {
    String gender = "";
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();
    if (userDetailsResponse != null &&
        userDetailsResponse.userDetails != null) {
      gender = userDetailsResponse.userDetails?.gender ?? "";
    }
    String url = "v1/disease/list?requestId=${getRequestId()}";
    if (gender.isNotEmpty) {
      url = "v1/disease/list?requestId=${getRequestId()}&gender=$gender";
    }
    dynamic response = await httpGet(healingServiceName, url);
    if (response != null && response["success"] == true) {
      HealingListResponse healingListResponse = HealingListResponse();
      healingListResponse = HealingListResponse.fromJson(response["data"]);
      return healingListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<InitialStatusModel?> getStatus(String subscriptionId) async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/assessment/initial/status/$subscriptionId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      InitialStatusModel initialStatusResponse = InitialStatusModel();
      initialStatusResponse = InitialStatusModel.fromJson(response);

      return initialStatusResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> completeAssessmentCategory(
      String userId, String userIdentificationId, String categoryId) async {
    dynamic response = await httpPost(
        healingServiceName,
        'v1/disease/assessment/initial/isComplete/category/$userIdentificationId/$categoryId?requestId=${getRequestId()}',
        {
          "data": {"isCompleted": true}
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

  Future<DiseaseDetailsResponse?> getDiseaseDetails(
      DiseaseDetailsRequest diseaseDetailsRequest) async {
    dynamic response = await httpPost(
        healingServiceName,
        'v1/disease/details?requestId=${getRequestId()}',
        {"data": diseaseDetailsRequest.toJson()});
    if (response != null && response["success"] == true) {
      DiseaseDetailsResponse diseaseDetailsResponse = DiseaseDetailsResponse();
      diseaseDetailsResponse =
          DiseaseDetailsResponse.fromJson(response["data"]);
      return diseaseDetailsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<DiseaseDetailsResponse?> getPersonalCareDetialsDetails() async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/details/personalCare?requestId=${getRequestId()}');
    if (response != null && response["success"] == true) {
      DiseaseDetailsResponse diseaseDetailsResponse = DiseaseDetailsResponse();
      diseaseDetailsResponse =
          DiseaseDetailsResponse.fromJson({"details": response["data"]});
      return diseaseDetailsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<TestimonialResponse?> getTestimonials(
      DiseaseDetailsRequest diseaseDetailsRequest) async {
    dynamic response = await httpPost(
        healingServiceName,
        'v1/disease/testimonials?requestId=${getRequestId()}',
        {"data": diseaseDetailsRequest.toJson()});
    if (response != null && response["success"] == true) {
      TestimonialResponse testimonialResponse = TestimonialResponse();
      testimonialResponse = TestimonialResponse.fromJson(response["data"]);
      return testimonialResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<InitialAssessment?> getInitialAssessment(
      String userId, String userIdentificationId) async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/assessment/initial/get/$userIdentificationId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      InitialAssessment initialAssessmentResponse = InitialAssessment();
      initialAssessmentResponse = InitialAssessment.fromJson(response["data"]);
      return initialAssessmentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool?> submitInitialAssessmentAnswer(
      String userId, String userIdentificationId, dynamic postJson) async {
    dynamic response = await httpPost(
        healingServiceName,
        'v1/disease/assessment/initial/submit/$userIdentificationId?requestId=${getRequestId()}',
        {"data": postJson},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> getInitialAssessmentStatus(
      String userId, String userIdentificationId) async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/assessment/initial/isComplete/$userIdentificationId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return response["data"]["isCompleted"];
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool?> submitCompleteAssessment(
      String userId, String userIdentificationId) async {
    dynamic response = await httpPatch(
        healingServiceName,
        'v1/disease/assessment/initial/isComplete/$userIdentificationId?requestId=${getRequestId()}',
        {
          "data": {
            "isCompleted": true,
          },
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

  Future<WeeklyHealthCardModel?> getWeeklyInsight(
      String userId, String subscriptionId) async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/assessment/followup/healthCard/$subscriptionId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      WeeklyHealthCardModel weeklyHealthCardModel = WeeklyHealthCardModel();
      weeklyHealthCardModel = WeeklyHealthCardModel.fromJson(response["data"]);
      return weeklyHealthCardModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<FollowupAssessmentResponse?> getFolloupAssessmentQuestion(
      String userId, String subscriptionId) async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/assessment/followup/$subscriptionId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      FollowupAssessmentResponse followupAssessmentResponse =
          FollowupAssessmentResponse();
      followupAssessmentResponse =
          FollowupAssessmentResponse.fromJson(response["data"]);
      return followupAssessmentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postFolloupAssessmentQuestion(
      String userId,
      String subscriptionId,
      FollowupAssessmentResponsePostAssessment?
          followupAssessmentResponse) async {
    dynamic postJson = followupAssessmentResponse!.toJson();
    postJson.removeWhere((key, value) => key == "objective");
    postJson.removeWhere((key, value) => key == "generalResponse");
    postJson.removeWhere((key, value) => key == "isCompleted");
    postJson.removeWhere((key, value) => key == "priority");
    postJson.removeWhere((key, value) => key == "questionType");
    postJson.removeWhere((key, value) => key == "assessmentType");
    postJson.removeWhere((key, value) => key == "question");

    dynamic response = await httpPost(
        healingServiceName,
        'v1/disease/assessment/followup/$subscriptionId?requestId=${getRequestId()}',
        {"data": postJson},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<InsightCardResponse?> getInsightCardDetails() async {
    dynamic response = await httpGet(healingServiceName,
        'onboarding-service/v1/healing/insightCard?requestId=${getRequestId()}');
    if (response != null && response["success"] == true) {
      InsightCardResponse insightCardResponse = InsightCardResponse();
      insightCardResponse = InsightCardResponse.fromJson(response["data"]);
      return insightCardResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<InitialHealthCardResponse?>? getInitialHealthCardDetails(
      String userId, String userIdentification) async {
    dynamic response = await httpGet(healingServiceName,
        'v1/disease/assessment/initial/healthCard/$userIdentification?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      InitialHealthCardResponse initialHealthCardResponse =
          InitialHealthCardResponse();
      initialHealthCardResponse =
          InitialHealthCardResponse.fromJson(response["data"]);
      return initialHealthCardResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<UserIdentificationResponse?>? getUserIdentificationDetails(
      String userId,
      String identificationType,
      DiseaseDetailsRequest diseaseDetailsRequest,
      String subscriptionId) async {
    dynamic postData = {"data": diseaseDetailsRequest.toJson()};
    postData["data"]["subscriptionId"] = subscriptionId;

    dynamic response = await httpPost(
        healingServiceName,
        'v1/userIdentification/${Uri.encodeComponent(identificationType)}?requestId=${getRequestId()}',
        postData,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UserIdentificationResponse userIdentificationResponse =
          UserIdentificationResponse();
      userIdentificationResponse =
          UserIdentificationResponse.fromJson(response["data"]);
      return userIdentificationResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool?> updateIdentificationId(
      String userId,
      String identificationId,
      String subscriptionId,
      DiseaseDetailsRequest diseaseDetailsRequest) async {
    dynamic response = await httpPatch(
        healingServiceName,
        'v1/userIdentification/$identificationId/$subscriptionId?requestId=${getRequestId()}',
        {"data": diseaseDetailsRequest.toJson()},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }
}
