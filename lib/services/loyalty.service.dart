import 'package:aayu/config.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/request.id.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'http.service.dart';

const String loyaltyServiveName = "loyalty-service";
String loyaltyAppId = Config.apiBaseUrl[loyaltyServiveName]["appId"];

class LoyaltyService {
  Future<LoyaltyUserPointsModel?> getUserPoints() async {
    dynamic response = await httpGet(loyaltyServiveName,
        'v1/app/user/points/$loyaltyAppId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      LoyaltyUserPointsModel loyaltyResponse = LoyaltyUserPointsModel();
      loyaltyResponse = LoyaltyUserPointsModel.fromJson(response["data"]);
      return loyaltyResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LoyaltyUserPendingPointsModel?> getPendingPointsList() async {
    dynamic response = await httpGet(loyaltyServiveName,
        'v1/app/user/points/pending/$loyaltyAppId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      LoyaltyUserPendingPointsModel loyaltyPendingResponse =
          LoyaltyUserPendingPointsModel();
      loyaltyPendingResponse =
          LoyaltyUserPendingPointsModel.fromJson(response["data"]);
      return loyaltyPendingResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LoyaltyRedeemListModel?> getRedeemStoreList() async {
    dynamic response = await httpGet(loyaltyServiveName,
        'v1/app/user/redeem/store/$loyaltyAppId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      LoyaltyRedeemListModel redeemResponse = LoyaltyRedeemListModel();
      redeemResponse = LoyaltyRedeemListModel.fromJson(response["data"]);
      return redeemResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LoyaltyUserCouponListModel?> getCouponList() async {
    dynamic response = await httpGet(loyaltyServiveName,
        'v1/app/user/coupon/$loyaltyAppId?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      LoyaltyUserCouponListModel couponResponse = LoyaltyUserCouponListModel();
      couponResponse = LoyaltyUserCouponListModel.fromJson(response["data"]);
      return couponResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LoyaltyCliamPointsModel?> claimPendingPoints(
      String transactionId) async {
    dynamic response = await httpPost(loyaltyServiveName,
        'v1/app/user/points/claim/$loyaltyAppId?requestId=${getRequestId()}', {
      "data": {"transactionId": transactionId}
    },
        customHeaders: {
          "x-user-id": globalUserIdDetails?.userId
        });
    if (response != null && response["success"] == true) {
      LoyaltyCliamPointsModel loyaltyClaimPoints = LoyaltyCliamPointsModel();
      loyaltyClaimPoints = LoyaltyCliamPointsModel.fromJson(response["data"]);
      return loyaltyClaimPoints;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LoyaltyRedeemPointsModel?> redeemPoints(
      String appRedeemId, redeemOn) async {
    dynamic response = await httpPost(loyaltyServiveName,
        'v1/app/user/redeem/store/$loyaltyAppId?requestId=${getRequestId()}', {
      "data": {"appRedeemId": appRedeemId, "redeemOn": redeemOn}
    },
        customHeaders: {
          "x-user-id": globalUserIdDetails?.userId
        });
    if (response != null && response["success"] == true) {
      LoyaltyRedeemPointsModel redeemYourAtoms = LoyaltyRedeemPointsModel();
      redeemYourAtoms = LoyaltyRedeemPointsModel.fromJson(response["data"]);

      return redeemYourAtoms;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<LoyaltyUserPointTransactionsModel?> getTransactonList() async {
    dynamic response = await httpGet(loyaltyServiveName,
        'v1/app/user/points/transactions/$loyaltyAppId?requestId=${getRequestId()}&perPage=50',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      LoyaltyUserPointTransactionsModel loyaltyPendingResponse =
          LoyaltyUserPointTransactionsModel();
      loyaltyPendingResponse =
          LoyaltyUserPointTransactionsModel.fromJson(response["data"]);
      return loyaltyPendingResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
