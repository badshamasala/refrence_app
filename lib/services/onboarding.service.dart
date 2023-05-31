import 'dart:io';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/http.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';

const String onboardingServiceName = "onboarding-service";

class OnboardingService {
  Future<CheckAppVersionResponse?> checkAppVersion(
      String platform,
      String environment,
      String currentVersion,
      String currentBuildNumber) async {
    dynamic response = await httpPost(
        onboardingServiceName, 'v1/version/check?requestId=${getRequestId()}', {
      "data": {
        "platform": platform,
        "environment": environment,
        "currentVersion": currentVersion,
        "currentBuildNumber": currentBuildNumber,
      }
    });
    if (response != null && response["success"] == true) {
      CheckAppVersionResponse checkAppVersionResponse =
          CheckAppVersionResponse();
      checkAppVersionResponse =
          CheckAppVersionResponse.fromJson(response["data"]);

      return checkAppVersionResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<UserRegistrationResponse?> registerUser(
      String mobileNumber,
      String emailId,
      String version,
      OnbardingRequestLocation onbardingRequestLocation) async {
    dynamic response = await httpPost(
        onboardingServiceName, 'v1/user/register?requestId=${getRequestId()}', {
      "data": {
        "mobileNumber": mobileNumber.isEmpty ? "" : mobileNumber,
        "emailId": emailId.isEmpty ? "" : emailId,
        "platform": Platform.isAndroid
            ? "Android"
            : Platform.isIOS
                ? "IOS"
                : "Other",
        "version": version,
        "source": "",
        "timeOffset": DateTime.now().timeZoneOffset.inMinutes,
        "location": [
          {
            "country": onbardingRequestLocation.country ?? "",
            "state": onbardingRequestLocation.state ?? "",
            "city": onbardingRequestLocation.city ?? "",
            "pinCode": onbardingRequestLocation.pinCode ?? ""
          }
        ]
      }
    });
    if (response != null && response["success"] == true) {
      UserRegistrationResponse userRegistrationResponse =
          UserRegistrationResponse();
      userRegistrationResponse =
          UserRegistrationResponse.fromJson(response["data"]);
      return userRegistrationResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<CheckRegistrationResponseModel?> checkIfRegistered(
      String mobileNumber, String emailId) async {
    dynamic response = await httpPost(onboardingServiceName,
        'v1/user/isRegistered?requestId=${getRequestId()}', {
      "data": {"mobileNumber": mobileNumber, "email": emailId}
    });
    if (response != null && response["success"] == true) {
      CheckRegistrationResponseModel checkRegistrationResponse =
          CheckRegistrationResponseModel();
      checkRegistrationResponse =
          CheckRegistrationResponseModel.fromJson(response["data"]);
      return checkRegistrationResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<OnboardAssessmentModel?> getOnboardingAssessment(String userId) async {
    dynamic response = await httpGet(onboardingServiceName,
        'v1/onboardingAssessment?requestId=${getRequestId()}${userId.isEmpty ? "" : '&userId=$userId'}');
    if (response != null && response["success"] == true) {
      OnboardAssessmentModel onboardAssessmentResponse =
          OnboardAssessmentModel();
      onboardAssessmentResponse =
          OnboardAssessmentModel.fromJson(response["data"]);
      return onboardAssessmentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubmitAssessmentResponseModel?> submitAssessmentAnswers(
      String userId, SubmitAssessmentRequestModel request) async {
    dynamic response = await httpPost(
        onboardingServiceName,
        'v1/onboardingAssessment?userId=$userId&requestId=${getRequestId()}',
        {"data": request.toJson()});
    if (response != null && response["success"] == true) {
      SubmitAssessmentResponseModel submitAssessmentResponse =
          SubmitAssessmentResponseModel();
      submitAssessmentResponse =
          SubmitAssessmentResponseModel.fromJson(response["data"]);
      return submitAssessmentResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  sendFirebaseToken(String userId, String notificationToken) async {
    dynamic response = await httpPost(
      onboardingServiceName,
      'v1/user/firebase/token?requestId=${getRequestId()}',
      {
        "data": {"userId": userId, "notificationToken": notificationToken}
      },
    );
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<EventResponse?> getEventDetails() async {
    dynamic response = await httpGet(
        onboardingServiceName, 'v1/event?requestId=${getRequestId()}}');
    if (response != null && response["success"] == true) {
      EventResponse eventResponse = EventResponse();
      eventResponse = EventResponse.fromJson(response["data"]);
      return eventResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> deleteUser(String mobileNumber) async {
    dynamic response = await httpDelete(onboardingServiceName,
        'v1/user/remove?mobileNo=$mobileNumber&requestId=${getRequestId()}',
        customHeaders: null);
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }
}
