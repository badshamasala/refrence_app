import 'package:aayu/model/model.dart';
import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/model/subscription/subscription.carousel.model.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../services/services.dart';

class SubscriptionPackageController extends GetxController {
  Rx<SupcriptionPackagesModel?> subscriptionPackageData =
      SupcriptionPackagesModel().obs;
  RxBool isLoading = false.obs;
  RxBool isCarouselLoading = false.obs;
  RxBool isPromoCodeApplied = false.obs;
  RxBool isCommunicationLoading = false.obs;
  Rx<SubscriptionCarouselModel?> subscriptionCarouselModel =
      SubscriptionCarouselModel().obs;
  PromoCodesModelPromoCodes? appliedPromoCode;
  Rx<SubscriptionCommunicationModel?> subscriptionCommunicationData =
      SubscriptionCommunicationModel().obs;
  Rx<SubscriptionTestimonialModel?> subscriptionTestimonialData =
      SubscriptionTestimonialModel().obs;

  Future<void> getSubscriptionPackages(
      String subscriptionType, String purchaseType,
      [String? packageType, String? promoCode, String? offerOn]) async {
    try {
      isPromoCodeApplied.value = false;
      appliedPromoCode = null;
      isLoading(true);

      subscriptionPackageData.value = await PaymentService()
          .getSubscriptionPackages(subscriptionType, purchaseType);

      bool isRecommended = false;
      if (subscriptionPackageData.value != null &&
          subscriptionPackageData.value!.subscriptionPackages != null &&
          subscriptionPackageData.value!.subscriptionPackages!.isNotEmpty) {
        for (var element
            in subscriptionPackageData.value!.subscriptionPackages!) {
          if (element!.recommended == true) {
            element.isSelected = true;
            isRecommended = true;
            break;
          }
        }
        if (isRecommended == false) {
          subscriptionPackageData.value!.subscriptionPackages![0]!.isSelected =
              true;
          subscriptionPackageData.value!.subscriptionPackages![0]!.recommended =
              true;
        }
        if (packageType != null) {
          keepSinglePricePoint(packageType);
        }
        if (promoCode != null && offerOn != null) {
          String country = "";
          UserDetailsResponse? userDetailsResponse =
              await HiveService().getUserDetails();

          if (userDetailsResponse?.userDetails?.location != null &&
              userDetailsResponse!.userDetails!.location!.isNotEmpty) {
            country =
                userDetailsResponse.userDetails!.location!.first!.country ?? "";
          }

          dynamic postData = {
            "country": country,
            "promoCode": promoCode,
            "offerOn": offerOn
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
        }
        /* if (remoteConfigData != null &&
            remoteConfigData!.getString('SHOW_PRICE_POINT').isNotEmpty) {
          keepSinglePricePoint(
              remoteConfigData!.getString('SHOW_PRICE_POINT').toUpperCase());
        } */
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> getUpgradeSubscriptionPackages(
      {String? promoCode, String? offerOn}) async {
    try {
      isLoading(true);
      isPromoCodeApplied.value = false;
      appliedPromoCode = null;
      subscriptionPackageData.value =
          await PaymentService().getUpgradeSubscriptionPackages();

      bool isRecommended = false;
      if (subscriptionPackageData.value != null &&
          subscriptionPackageData.value!.subscriptionPackages != null &&
          subscriptionPackageData.value!.subscriptionPackages!.isNotEmpty) {
        for (var element
            in subscriptionPackageData.value!.subscriptionPackages!) {
          if (element!.recommended == true) {
            element.isSelected = true;
            isRecommended = true;
            break;
          }
        }
        if (isRecommended == false) {
          subscriptionPackageData.value!.subscriptionPackages![0]!.isSelected =
              true;
          subscriptionPackageData.value!.subscriptionPackages![0]!.recommended =
              true;
        }
      }
      if (promoCode != null && offerOn != null) {
        String country = "";
        UserDetailsResponse? userDetailsResponse =
            await HiveService().getUserDetails();

        if (userDetailsResponse?.userDetails?.location != null &&
            userDetailsResponse!.userDetails!.location!.isNotEmpty) {
          country =
              userDetailsResponse.userDetails!.location!.first!.country ?? "";
        }

        dynamic postData = {
          "country": country,
          "promoCode": promoCode,
          "offerOn": offerOn
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
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  setSelection(int selectedIndex) {
    for (var element in subscriptionPackageData.value!.subscriptionPackages!) {
      element!.isSelected = false;
    }
    subscriptionPackageData
        .value!.subscriptionPackages![selectedIndex]!.isSelected = true;
    update();
  }

  Future<void> getSubscriptionCarouselData() async {
    if (subscriptionCarouselModel.value!.grow == null) {
      isCarouselLoading.value = true;
      subscriptionCarouselModel.value = await SubscriptionService()
          .getFeaturesBannerCarousel(globalUserIdDetails?.userId);
      isCarouselLoading.value = false;
      update();
    }
  }

  void keepSinglePricePoint(String packageType) {
    if (packageType == 'ALL') {
      return;
    }
    int index = subscriptionPackageData.value!.subscriptionPackages!
        .indexWhere((element) => element!.packageType == packageType);
    if (index != -1) {
      subscriptionPackageData.value!.subscriptionPackages = [
        subscriptionPackageData.value!.subscriptionPackages![index]
      ];
    } else {
      subscriptionPackageData.value!.subscriptionPackages = [
        subscriptionPackageData.value!.subscriptionPackages!.last
      ];
    }
    subscriptionPackageData.value!.subscriptionPackages![0]!.isSelected = true;
    subscriptionPackageData.value!.subscriptionPackages![0]!.recommended = true;
  }

  applyCouponOffers(PromoCodesModelPromoCodes? promoCode) {
    if (promoCode?.offerDetails != null &&
        (promoCode?.offerOn == "SUBSCRIPTION" ||
            promoCode?.offerOn == "PERSONAL CARE" ||
            promoCode?.offerOn == "RENEWAL" ||
            promoCode?.offerOn == "UPGRADE SUBSCRIPTION")) {
      for (var element
          in subscriptionPackageData.value!.subscriptionPackages!) {
        int index = promoCode!.offerDetails!.indexWhere(
            (offer) => offer!.referenceId == element!.subscriptionPackageId!);
        element!.offerAmount = 0; //made it 0 to avoid multiple offers..
        if (index != -1) {
          appliedPromoCode = promoCode;
          isPromoCodeApplied.value = true;
          if (promoCode.offerDetails![index]!.isPercentage == true) {
            double offerAmount = 0;
            offerAmount = (element.purchaseAmount! *
                    promoCode.offerDetails![index]!.discount!) /
                100;
            element.offerAmount = offerAmount;
          } else {
            element.offerAmount = promoCode.offerDetails![index]!.discount!;
          }
        }
      }
      update();
    }
  }

  applyTemporaryDiscount(double percent) {
    isPromoCodeApplied.value = true;
    for (var element in subscriptionPackageData.value!.subscriptionPackages!) {
      element!.offerAmount = 0; //made it 0 to avoid multiple offers..

      double offerAmount = 0;
      offerAmount = (element.purchaseAmount! * percent) / 100;
      element.offerAmount = offerAmount;
    }
    update();
  }

  removeCoupon() {
    isPromoCodeApplied.value = false;
    appliedPromoCode = null;
    for (var element in subscriptionPackageData.value!.subscriptionPackages!) {
      element!.offerAmount = 0;
    }
    update();
  }

  Future<void> getCommunicationAndTestimonialData() async {
    if (subscriptionCommunicationData.value != null) {
      try {
        isCommunicationLoading(true);
        var response = await Future.wait([
          PaymentService().getSubscriptionCommunicationDetails(),
          PaymentService().getSubscriptionTestimonialDetails()
        ]);
        if (response[0] != null) {
          subscriptionCommunicationData.value =
              response[0] as SubscriptionCommunicationModel?;
        }
        if (response[1] != null) {
          subscriptionTestimonialData.value =
              response[1] as SubscriptionTestimonialModel?;
        }
      } finally {
        isCommunicationLoading(false);
      }
    }
  }
}
