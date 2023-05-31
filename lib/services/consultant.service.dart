import 'package:aayu/model/model.dart';
import 'package:aayu/view/shared/shared.dart';
import 'http.service.dart';
import 'request.id.service.dart';

const String consultantServiceName = "consultant-service";

class ConsultantService {
  Future<RecommendedProgramResponse?> getProgramRecommendationForSessionId(
      String userId, String sessionId) async {
    dynamic response = await httpGet(consultantServiceName,
        'v1/user/recommendation/program/$sessionId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      RecommendedProgramResponse recommendedProgramResponse =
          RecommendedProgramResponse();
      recommendedProgramResponse =
          RecommendedProgramResponse.fromJson(response["data"]);
      return recommendedProgramResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<RecommendedProgramResponse?> getProgramRecommendation(
      String userId) async {
    dynamic response = await httpGet(consultantServiceName,
        'v1/user/recommendation/program?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      RecommendedProgramResponse recommendedProgramResponse =
          RecommendedProgramResponse();
      recommendedProgramResponse =
          RecommendedProgramResponse.fromJson(response["data"]);
      return recommendedProgramResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> deleteDoctorsRecommendation(String sessionId) async {
    dynamic response = await httpDelete(
      consultantServiceName,
      'v1/user/recommendation/program/$sessionId?requestId=${getRequestId()}',
      customHeaders: {'x-user-id': globalUserIdDetails!.userId},
    );
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<String?> getAgoraChatToken(String userId) async {
    dynamic response = await httpGet(consultantServiceName,
        'v1/user/session/agoraToken?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return response["data"]["token"];
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
