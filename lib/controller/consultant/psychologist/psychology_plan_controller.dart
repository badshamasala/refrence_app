import 'package:aayu/model/model.dart';
import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:get/get.dart';

class PsychologyPlanController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<PsychologyPlansModel?> psychologyPlansResponse =
      PsychologyPlansModel().obs;
  Rx<PsychologyPlansModel?> dummyPsychologyPlansResponse =
      PsychologyPlansModel().obs;
  RxBool isPromoCodeApplied = false.obs;
  PromoCodesModelPromoCodes? appliedPromoCode;
  String? autoApplyPromoCode;

  Future<void> getPlans(String purchaseType) async {
    try {
      isLoading(true);
      String country = "";
      UserDetailsResponse? userDetailsResponse =
          await HiveService().getUserDetails();
      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        if (userDetailsResponse.userDetails!.location != null &&
            userDetailsResponse.userDetails!.location!.isNotEmpty) {
          country =
              userDetailsResponse.userDetails!.location!.first!.country ?? "";
        }
      }
      dynamic postData = {
        "country": country,
        "purchaseType": purchaseType
      };
      PsychologyPlansModel? response =
          await PaymentService().getPsychologyPlans(postData);
      if (response != null &&
          response.packages != null &&
          response.packages!.isNotEmpty) {
        psychologyPlansResponse.value = response;
        dummyPsychologyPlansResponse.value = response;
      } else {
        psychologyPlansResponse.value = null;
        dummyPsychologyPlansResponse.value = null;
      }
      if (autoApplyPromoCode != null) {
        dynamic postData = {
          "country": country,
          "promoCode": autoApplyPromoCode,
          "offerOn": "PSYCHOLOGY PLANS"
        };
        PromoCodesModelPromoCodes? response =
            await PaymentService().validateCouponText(postData);
        if (response != null) {
          applyCouponOffers(response);
        }
        autoApplyPromoCode = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
    }
  }

  applyCouponOffers(PromoCodesModelPromoCodes? promoCode) {
    if (promoCode?.offerDetails != null &&
        promoCode?.offerOn == "PSYCHOLOGY PLANS") {
      for (var element in psychologyPlansResponse.value!.packages!) {
        int index = promoCode!.offerDetails!
            .indexWhere((offer) => offer!.referenceId == element!.packageId!);
        if (index != -1) {
          appliedPromoCode = promoCode;
          isPromoCodeApplied.value = true;
          if (promoCode.offerDetails![index]!.isPercentage == true) {
            double offerAmount = 0;
            offerAmount = (element!.purchaseAmount! *
                    promoCode.offerDetails![index]!.discount!) /
                100;
            element.offerAmount = offerAmount;
          } else {
            element!.offerAmount = promoCode.offerDetails![index]!.discount!;
          }
        }
      }
      update();
    }
  }

  removeCoupon() {
    for (var element in psychologyPlansResponse.value!.packages!) {
      element!.offerAmount = 0;
    }
    isPromoCodeApplied.value = false;
    appliedPromoCode = null;
    update();
  }

  applyDummyCouponOffers(PromoCodesModelPromoCodes? promoCode) {
    if (promoCode?.offerDetails != null &&
        promoCode?.offerOn == "PSYCHOLOGY PLANS") {
      if (dummyPsychologyPlansResponse.value?.packages != null) {
        for (var element in dummyPsychologyPlansResponse.value!.packages!) {
          int index = promoCode!.offerDetails!
              .indexWhere((offer) => offer!.referenceId == element!.packageId!);
          if (index != -1) {
            appliedPromoCode = promoCode;
            isPromoCodeApplied.value = true;
            if (promoCode.offerDetails![index]!.isPercentage == true) {
              double offerAmount = 0;
              offerAmount = (element!.purchaseAmount! *
                      promoCode.offerDetails![index]!.discount!) /
                  100;
              element.offerAmount = offerAmount;
            } else {
              element!.offerAmount = promoCode.offerDetails![index]!.discount!;
            }
          }
        }
        update();
      }
    }
  }

  setAutoApplyPromoCode(String s) {
    autoApplyPromoCode = s;
  }
}
