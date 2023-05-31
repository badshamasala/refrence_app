import 'package:aayu/model/model.dart';
import 'package:aayu/model/response.error.dart';
import 'package:aayu/model/subscription/subscription.carousel.model.dart';
import 'package:aayu/services/http.service.dart';
import 'package:aayu/services/request.id.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';

const String subscriptionServiceName = "subscription-service";

class SubscriptionService {
  Future<SubscriptionCheckResponse?> checkSubscription(String userId) async {
    dynamic response = await httpGet(subscriptionServiceName,
        'v1/subscribe/check?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionDetailsResponse?> getSubscriptionDetails(
      String userId) async {
    dynamic response = await httpGet(subscriptionServiceName,
        'v1/subscribe/details?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionDetailsResponse subscriptionDetailsResponse =
          SubscriptionDetailsResponse();
      subscriptionDetailsResponse =
          SubscriptionDetailsResponse.fromJson(response["data"]);
      return subscriptionDetailsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> postSubscription(
      String userId, SubscriptionPostData postData) async {
    dynamic response = await httpPost(subscriptionServiceName,
        'v1/subscribe?requestId=${getRequestId()}', {"data": postData.toJson()},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> deleteSubscription(String mobileNumber) async {
    dynamic response = await httpDelete(subscriptionServiceName,
        'v1/subscribe/remove/$mobileNumber?requestId=${getRequestId()}',
        customHeaders: null);
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<SubscriptionCheckResponse?> updateStartDate(
      String userId, String subscriptionId, String startDate) async {
    dynamic response = await httpPatch(subscriptionServiceName,
        'v1/subscribe/startDate/$subscriptionId?requestId=${getRequestId()}', {
      "data": {"startDate": startDate}
    },
        customHeaders: {
          "x-user-id": userId
        });
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> postAayuSubscription(
      String userId, dynamic postData) async {
    dynamic response = await httpPost(subscriptionServiceName,
        'v1/subscribe/aayu?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> startProgram(
      String userId,
      String subscriptionId,
      SubscriptionPostData postData,
      bool isRecommended) async {
    Map<String, dynamic> data = postData.toJson();
    data['isRecommended'] = isRecommended;
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/subscribe/program/start/$subscriptionId?requestId=${getRequestId()}',
        {"data": data},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> switchProgram(
      String userId,
      String subscriptionId,
      SubscriptionPostData postData,
      bool isRecommended) async {
    Map<String, dynamic> data = postData.toJson();
    data['isRecommended'] = isRecommended;
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/subscribe/program/switch/$subscriptionId?requestId=${getRequestId()}',
        {"data": data},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      ResponseError responseError = ResponseError.fromJson(response["error"]);
      showCustomSnackBar(Get.context!, "${responseError.message}");
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> switchRecommendedProgram(String userId,
      String subscriptionId, SwitchRecommendeProgramPostData postData) async {
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/healing/program/recommended/switch/$subscriptionId?requestId=${getRequestId()}',
        {"data": postData.toJson()},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      ResponseError responseError = ResponseError.fromJson(response["error"]);
      showCustomSnackBar(Get.context!, "${responseError.message}");
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> postAayuRenewal(
      String userId, String subscriptionId, dynamic postData) async {
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/subscribe/renew/$subscriptionId?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCheckResponse?> postAayuUpgradePlan(
      String userId, String subscriptionId, dynamic postData) async {
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/subscribe/upgrade/plan/$subscriptionId?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionCarouselModel?> getFeaturesBannerCarousel(
      String? userId) async {
    dynamic response = await httpGet(subscriptionServiceName,
        'v1/subscribe/featuresBanner?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCarouselModel subscriptionCarouselModel =
          SubscriptionCarouselModel();
      subscriptionCarouselModel =
          SubscriptionCarouselModel.fromJson(response["data"]);
      return subscriptionCarouselModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<SubscriptionDetailsResponse?> getPreviousSubscriptionDetails(
      String userId) async {
    dynamic response = await httpGet(subscriptionServiceName,
        'v1/subscribe/program/previous?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionDetailsResponse subscriptionDetailsResponse =
          SubscriptionDetailsResponse();
      subscriptionDetailsResponse =
          SubscriptionDetailsResponse.fromJson(response["data"]);
      return subscriptionDetailsResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> checkHealingAccess(String userId) async {
    dynamic response = await httpGet(subscriptionServiceName,
        'v1/healing/program/access/check?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["blocked"] != null) {
        return response["data"]["blocked"] as bool;
      } else {
        return true;
      }
    } else {
      showError(response["error"]);
      return true;
    }
  }

  Future<bool> blockHealingAccess(String userId, String sessionId) async {
    dynamic response = await httpPost(
        subscriptionServiceName,
        'v1/healing/program/access/block/$sessionId?requestId=${getRequestId()}',
        null,
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return true;
    }
  }

  Future<bool> checkFreeSwitchForYearly() async {
    dynamic response = await httpGet(subscriptionServiceName,
        'v1/healing/program/extend/check?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails!.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null &&
          response["data"]["allowProgram"] != null) {
        return response["data"]["allowProgram"] as bool;
      } else {
        return false;
      }
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> updatePersonalCarePayment(
      String userId, String subscriptionId, dynamic postData) async {
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/subscribe/program/payment/personalCare/$subscriptionId?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<SubscriptionCheckResponse?> extendExpiryDate(
      String userId, String subscriptionId, dynamic postData) async {
    dynamic response = await httpPatch(
        subscriptionServiceName,
        'v1/subscribe/extend/expiryDate/$subscriptionId?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      SubscriptionCheckResponse subscriptionCheckResponse =
          SubscriptionCheckResponse();
      subscriptionCheckResponse =
          SubscriptionCheckResponse.fromJson(response["data"]);
      return subscriptionCheckResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
