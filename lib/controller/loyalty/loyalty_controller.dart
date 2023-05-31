import 'package:aayu/model/model.dart';
import 'package:aayu/services/loyalty.service.dart';
import 'package:get/get.dart';

class LoyaltyController extends GetxController {
  Rx<bool> isLoading = false.obs;

  Rx<LoyaltyUserPointsModel?> userPoints = LoyaltyUserPointsModel().obs;
  Rx<LoyaltyUserPendingPointsModel?> pendingPointList =
      LoyaltyUserPendingPointsModel().obs;
  Rx<LoyaltyRedeemListModel?> redeemStoreList = LoyaltyRedeemListModel().obs;
  Rx<LoyaltyUserCouponListModel?> couponList = LoyaltyUserCouponListModel().obs;
  Rx<LoyaltyUserPointTransactionsModel?> userPointTransactionList =
      LoyaltyUserPointTransactionsModel().obs;

  Future<void> getUserPoints() async {
    try {
      isLoading.value = true;
      LoyaltyUserPointsModel? response = await LoyaltyService().getUserPoints();
      if (response != null && response.points != null) {
        userPoints.value = response;
      } else {
        userPoints.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getPendingPointsList() async {
    try {
      isLoading.value = true;
      LoyaltyUserPendingPointsModel? response =
          await LoyaltyService().getPendingPointsList();
      if (response != null && response.result != null) {
        pendingPointList.value = response;
      } else {
        pendingPointList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getRedeemStoreList() async {
    try {
      isLoading.value = true;
      LoyaltyRedeemListModel? response =
          await LoyaltyService().getRedeemStoreList();
      if (response != null && response.redeemList != null) {
        redeemStoreList.value = response;
      } else {
        redeemStoreList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getCouponList() async {
    try {
      isLoading.value = true;
      LoyaltyUserCouponListModel? response =
          await LoyaltyService().getCouponList();
      if (response != null && response.userCoupons != null) {
        couponList.value = response;
      } else {
        couponList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<bool> claimPoints(String transactionId) async {
    bool isClaimed = false;
    try {
      LoyaltyCliamPointsModel? response =
          await LoyaltyService().claimPendingPoints(transactionId);
      if (response != null &&
          response.userPointId != null &&
          response.userPointId!.isNotEmpty) {
        isClaimed = true;
      }
    } catch (exp) {
      print(exp);
    }
    return isClaimed;
  }

  Future<bool> redeemPoints(String appRedeemId, String redeemOn) async {
    bool isRedeemed = false;
    try {
      LoyaltyRedeemPointsModel? response =
          await LoyaltyService().redeemPoints(appRedeemId, redeemOn);
      if (response != null && response.isRedeemed == true) {
        isRedeemed = true;
      }
    } catch (exp) {
      print(exp);
    }
    return isRedeemed;
  }

  Future<void> getTransactonList() async {
    try {
      isLoading.value = true;
      LoyaltyUserPointTransactionsModel? response =
          await LoyaltyService().getTransactonList();
      if (response != null && response.result != null) {
        userPointTransactionList.value = response;
      } else {
        userPointTransactionList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
