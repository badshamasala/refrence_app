import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:aayu/model/model.dart';
import 'package:aayu/services/http.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../controller/payment/juspay_controller.dart';
import '../view/splash_screen.dart';
import 'request.id.service.dart';

const String profileServiceName = "profile-service";

class ProfileService {
  Future<UpdateProfileResponse?> updateProfile(
      String userId, OnbardingRequest request) async {
    dynamic response = await httpPatch(profileServiceName,
        'v1/user?requestId=${getRequestId()}', {"data": request.toJson()},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UpdateProfileResponse updateProfileResponse = UpdateProfileResponse();
      updateProfileResponse = UpdateProfileResponse.fromJson(response["data"]);
      return updateProfileResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<UserDetailsResponse?> getUserDetails(String userId) async {
    UserDetailsResponse? userDetailsResponse;
    int counter = 3;
    while (userDetailsResponse == null && counter > 0) {
      dynamic response = await httpGet(
          profileServiceName, 'v1/user/userDetails?requestId=${getRequestId()}',
          customHeaders: {"x-user-id": userId});
      if (response != null && response["success"] == true) {
        userDetailsResponse = UserDetailsResponse();
        userDetailsResponse = UserDetailsResponse.fromJson(response["data"]);
        return userDetailsResponse;
      } else if (response["error"]["message"] == "Failed host lookup") {
        showNetworkDialog(null, () async {
          JuspayController juspayController = Get.find();
          await juspayController.terminateHyperSDK();
          SystemNavigator.pop().then((value) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.off(const SplashScreen(
                callWhenAppResumed: true,
              ));
            });
          });
        }, "Network Error!",
            "This app requires active network connection to work.\nPlease check your network settings and relaunch.");
        print("NO NETWORK - getUserDetails");

        break;
      } else {
        showError(response["error"]);
      }
      print("CALLING FOR USER DETAILS=======>>> $userDetailsResponse");
      counter--;
    }
    return userDetailsResponse;
  }

  Future<UserDetailsResponse?> callUserDetails(String userId) async {
    return null;
  }

  Future<UserDetailsResponse?> getUserByMobileEmail(
      String mobileNumber, String emailId) async {
    dynamic response = await httpPost(profileServiceName,
        'v1/user/userByMobileEmail?requestId=${getRequestId()}', {
      "data": {"mobileNumber": mobileNumber, "email": emailId}
    });
    if (response != null && response["success"] == true) {
      UserDetailsResponse userDetailsResponse = UserDetailsResponse();
      userDetailsResponse = UserDetailsResponse.fromJson(response["data"]);
      return userDetailsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool?> updateLastLogin(String userId) async {
    dynamic response = await httpPost(profileServiceName,
        'v1/user/lastlogin?requestId=${getRequestId()}', null,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool?> updateLatestVersionNumber(String userId) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    String buildNumber = "${info.version}+${info.buildNumber}";
    dynamic response = await httpPost(profileServiceName,
        'v1/user/latestVersion?requestId=${getRequestId()}', {
      "data": {
        "version": buildNumber,
      }
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

  Future<ProfileImageUploadResponse?> uploadProfileImage(
      String userId, http.MultipartFile multipartFile) async {
    dynamic response = await httpFileUpload(
        profileServiceName,
        'v1/user/profileUpload?requestId=${getRequestId()}',
        null,
        multipartFile,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      ProfileImageUploadResponse profileImageUploadResponse =
          ProfileImageUploadResponse();
      profileImageUploadResponse =
          ProfileImageUploadResponse.fromJson(response["data"]);
      return profileImageUploadResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool?> removeProfileImage(String userId) async {
    dynamic response = await httpPatch(profileServiceName,
        'v1/user/removeProfilePic?requestId=${getRequestId()}', null,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool?> postHelpSupport(String userId, String type, String category,
      String issue, String description) async {
    dynamic response = await httpPost(
        profileServiceName, 'v1/support?requestId=${getRequestId()}', {
      "data": {
        "appName": "Aayu",
        "type": type,
        "category": category,
        "issue": issue,
        "description": description,
      }
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

  Future<UserPnGetModal?> getUserPnSwitchList() async {
    dynamic response = await httpGet(
        profileServiceName, 'v1/user/pnType/choice?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId});
    if (response != null && response["success"] == true) {
      UserPnGetModal userPnResponse = UserPnGetModal();
      userPnResponse = UserPnGetModal.fromJson(response);

      return userPnResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<UserPnPostModal?> postUserPnSwitchList(
      String pnTypeId, bool isEnable) async {
    dynamic response = await httpPost(profileServiceName,
        'v1/user/pnType/choice?requestId=${getRequestId()}', {
      "data": {"pnTypeId": pnTypeId, "enabled": isEnable}
    },
        customHeaders: {
          "x-user-id": globalUserIdDetails!.userId
        });
    if (response != null && response["success"] == true) {
      UserPnPostModal userPostBoolen = UserPnPostModal();
      userPostBoolen = UserPnPostModal.fromJson(response);

      return userPostBoolen;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
