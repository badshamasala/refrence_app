import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user.details.model.dart';
import '../../view/subscription/offers/widgets/price_after_discount_bottom_sheet.dart';
import '../consultant/doctor_controller.dart';
import '../consultant/personal_trainer_controller.dart';
import '../payment/subscription_package_controller.dart';

class OffersController extends GetxController {
  TextEditingController applyOfferEditingController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isApplyOfferLoading = false.obs;
  String errorMessage = '';
  Rx<PromoCodesModel?> promoCodeDetails = PromoCodesModel().obs;

  getPromoCodeDetails(String offerOn) async {
    try {
      applyOfferEditingController.text = "";
      errorMessage = "";
      promoCodeDetails.value = null;
      isLoading(true);
      if (offerOn == "DOCTOR SESSIONS") {
        offerOn = "DOCTOR CONSULTATION";
      } else if (offerOn == "TRAINER SESSIONS") {
        offerOn = "THERAPIST CONSULTATION";
      }
      PromoCodesModel? response = await PaymentService().getPromoCodes(offerOn);
      if (response != null && response.active != null) {
        promoCodeDetails.value = response;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> postCouponCodeText(String _offerOn) async {
    try {
      isApplyOfferLoading(true);
      update();
      String country = "";
      UserDetailsResponse? userDetailsResponse =
          await HiveService().getUserDetails();

      if (userDetailsResponse?.userDetails?.location != null &&
          userDetailsResponse!.userDetails!.location!.isNotEmpty) {
        country =
            userDetailsResponse.userDetails!.location!.first!.country ?? "";
      }

      String offerOn = _offerOn;
      if (offerOn == "DOCTOR SESSIONS") {
        offerOn = "DOCTOR CONSULTATION";
      } else if (offerOn == "TRAINER SESSIONS") {
        offerOn = "THERAPIST CONSULTATION";
      }

      dynamic postData = {
        "country": country,
        "promoCode": applyOfferEditingController.text.trim(),
        "offerOn": offerOn
      };
      PromoCodesModelPromoCodes? response =
          await PaymentService().postCouponCodeText(postData);
      if (response != null) {
        EventsService().sendEvent("Promo_Code_Search_Result", {
          "offer_on": response.offerOn,
          "promo_code_id": response.promoCodeId ?? "",
          "promo_code": response.promoCode ?? "",
          "title": response.title,
        });
        errorMessage = '';
        Get.bottomSheet(
            PriceAfterDiscountBottomSheet(
              active: true,
              promoCode: response,
              offerOn: _offerOn,
            ),
            isScrollControlled: true);
      } else {
        errorMessage = 'Coupon code not valid.';
      }
    } finally {
      isApplyOfferLoading(false);
      update();
    }
  }
}
