import 'package:aayu/model/model.dart';
import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:get/get.dart';

class NutritionPlanController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<NutritionPlansModel?> nutritionPlansResponse = NutritionPlansModel().obs;
  RxBool isPromoCodeApplied = false.obs;
  PromoCodesModelPromoCodes? appliedPromoCode;
  String? autoApplyPromoCode;

  Future<void> getPlans(String packageType, String purchaseType) async {
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
        "packageType": packageType,
        "purchaseType": purchaseType
      };
      NutritionPlansModel? response =
          await PaymentService().getNutritionPlans(postData);
      if (response != null &&
          response.packages != null &&
          response.packages!.isNotEmpty) {
        nutritionPlansResponse.value = response;
      } else {
        nutritionPlansResponse.value = null;
      }
      if (autoApplyPromoCode != null) {
        dynamic postData = {
          "country": country,
          "promoCode": autoApplyPromoCode,
          "offerOn": "NUTRITION PLANS"
        };
        PromoCodesModelPromoCodes? response =
            await PaymentService().validateCouponText(postData);
        if (response != null) {
          // EventsService().sendEvent("Promo_Code_Search_Result", {
          //   "offer_on": response.offerOn,
          //   "promo_code_id": response.promoCodeId ?? "",
          //   "promo_code": response.promoCode ?? "",
          //   "title": response.title,
          // });
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
        promoCode?.offerOn == "NUTRITION PLANS") {
      for (var element in nutritionPlansResponse.value!.packages!) {
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
    for (var element in nutritionPlansResponse.value!.packages!) {
      element!.offerAmount = 0;
    }
    isPromoCodeApplied.value = false;
    appliedPromoCode = null;
    update();
  }

  setAutoApplyPromoCode(String s) {
    autoApplyPromoCode = s;
  }
}
