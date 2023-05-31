import 'package:aayu/model/model.dart';
import 'package:aayu/view/shared/shared.dart';
import 'http.service.dart';
import 'request.id.service.dart';

const String nutritionServiceName = "nutrition-service";

class NutritionService {
  Future<NutritionInitialAssessmentStatusModel?> getInitialAssessmentStatus(
      String userId) async {
    dynamic response = await httpGet(nutritionServiceName,
        'v1/user/nutrition/assessment/initial/status?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      NutritionInitialAssessmentStatusModel initialAssessmentResponse =
          NutritionInitialAssessmentStatusModel();
      initialAssessmentResponse =
          NutritionInitialAssessmentStatusModel.fromJson(response["data"]);
      return initialAssessmentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool?> submitInitialAssessmentStatus(
      String userId, dynamic postData) async {
    dynamic response = await httpPost(
        nutritionServiceName,
        'v1/user/nutrition/assessment/initial/status?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<NutritionInitialAssessmentModel?> getInitialAssessment(
      String userId) async {
    dynamic response = await httpGet(nutritionServiceName,
        'v1/user/nutrition/assessment/initial?requestId=${getRequestId()}',
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
        nutritionServiceName,
        'v1/user/nutrition/assessment/answer?requestId=${getRequestId()}',
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

  Future<UserNutritionDetailsModel?> getUserNutritionDetails(
      String userId) async {
    dynamic response = await httpGet(nutritionServiceName,
        'v1/user/nutrition/details?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UserNutritionDetailsModel userNutritionDetails =
          UserNutritionDetailsModel();
      userNutritionDetails =
          UserNutritionDetailsModel.fromJson(response["data"]);
      return userNutritionDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> startUserNutrition(String userId, dynamic postData) async {
    dynamic response = await httpPost(
        nutritionServiceName,
        'v1/user/nutrition/entry?requestId=${getRequestId()}',
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

  Future<bool> extendNutritionPlan(String userId, dynamic postData) async {
    dynamic response = await httpPut(
        nutritionServiceName,
        'v1/user/nutrition/extend?requestId=${getRequestId()}',
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

  Future<UserNutritionDietPlanModel?> getDietPlanDetails(String userId) async {
    dynamic response = await httpGet(
        nutritionServiceName, 'v1/user/dietPlan/?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UserNutritionDietPlanModel userNutritionDietPlans =
          UserNutritionDietPlanModel();
      userNutritionDietPlans =
          UserNutritionDietPlanModel.fromJson(response["data"]);
      return userNutritionDietPlans;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
