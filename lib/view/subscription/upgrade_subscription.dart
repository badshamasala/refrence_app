import 'package:aayu/view/subscription/widgets/subscription_pricing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/payment/subscription_package_controller.dart';
import '../../controller/subscription/subscription_controller.dart';
import '../../model/payment/subscription.packages.model.dart';
import '../../services/payment.service.dart';
import '../../services/third-party/events.service.dart';
import '../../theme/theme.dart';
import '../payment/juspay_payment.dart';
import '../shared/shared.dart';

class UpgradeSubscription extends StatelessWidget {
  final String subscribeVia;
  final SubscriptionController subscriptionController;

  const UpgradeSubscription({
    Key? key,
    required this.subscribeVia,
    required this.subscriptionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionPackageController subscriptionPackageController = Get.find();

    String returnTextFromPackageType(
        String packageType, bool alreadySubscribed, bool healing) {
      switch (packageType.toUpperCase()) {
        case "MONTHLY":
          return healing ? '1-month' : 'a month';
        case "HALF YEARLY":
          return alreadySubscribed ? '6-month' : '6 months';
        case "YEARLY":
          return alreadySubscribed ? 'yearly' : 'year';
        case "QUARTERLY":
          return alreadySubscribed ? '3-month' : '3 months';

        default:
          return 'yearly';
      }
    }

    String description = '';
    if (subscriptionController.subscriptionDetailsResponse.value!
                .subscriptionDetails!.programId !=
            null &&
        subscriptionController.subscriptionDetailsResponse.value!
            .subscriptionDetails!.programId!.isNotEmpty) {
      description =
          'Your current subscription is for a ${returnTextFromPackageType(subscriptionController.subscriptionDetailsResponse.value!.subscriptionDetails!.packageType ?? "", true, true)} ${subscriptionController.subscriptionDetailsResponse.value!.subscriptionDetails!.silverAppBar!.title}. Switch to a longer duration to see the maximum health benefits.';
    } else {
      description =
          'Your current subscription is for ${returnTextFromPackageType(subscriptionController.subscriptionDetailsResponse.value!.subscriptionDetails!.packageType ?? "", true, false)}. Switch to a longer duration to see the maximum health benefits.';
    }

    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        decoration: const BoxDecoration(
            color: Color(0xFFF1F5FC),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 47.h,
            ),
            const Text(
              'Upgrade Your Program',
              textAlign: TextAlign.center,
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.blueGreyAssessmentColor,
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            const SubscriptionPricing(
              offerOn: 'UPGRADE SUBSCRIPTION',
              addShadow: true,
            ),
            SizedBox(
              height: 21.h,
            ),
            InkWell(
              onTap: () {
                SupcriptionPackagesModelSubscriptionPackages? selectedPackage =
                    subscriptionPackageController
                        .subscriptionPackageData.value!.subscriptionPackages!
                        .firstWhereOrNull(
                            (element) => element!.isSelected == true);

                if (selectedPackage != null) {
                  double totalPayment = selectedPackage.purchaseAmount! -
                      selectedPackage.offerAmount!;
                  if (selectedPackage.country == "IN") {
                    totalPayment = totalPayment.floorToDouble();
                  }
                  dynamic customData = {};
                  if (subscribeVia == "MY_SUBSCRIPTION") {
                    customData = {
                      "subscribeVia": subscribeVia,
                      "subscriptionId": subscriptionController
                              .subscriptionDetailsResponse
                              .value!
                              .subscriptionDetails!
                              .subscriptionId ??
                          "",
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  } else if (subscribeVia == "PROMOTION") {
                    customData = {
                      "subscribeVia": subscribeVia,
                      "subscriptionId": subscriptionController
                              .subscriptionDetailsResponse
                              .value!
                              .subscriptionDetails!
                              .subscriptionId ??
                          "",
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  }
                  String eventName = "Sub_Select";
                  if (subscribeVia == "MY_SUBSCRIPTION") {
                    eventName = "Sub_Sel_Upgd_Subscription";
                  } else if (subscribeVia == "PROMOTION") {
                    eventName = "Sub_Sel_Upgd_Promotion";
                  }

                  EventsService().sendEvent(eventName, {
                    "subscribe_via": subscribeVia,
                    "package_name": selectedPackage.packageName,
                    "package_type": selectedPackage.packageType,
                    "purchase_type": selectedPackage.purchaseType,
                    "subscription_type": selectedPackage.subscriptionType,
                    "subscription_charges": selectedPackage.subscriptionCharges,
                    "is_percentage": selectedPackage.isPercentage,
                    "discount": selectedPackage.discount,
                    "purchase_amount": selectedPackage.purchaseAmount,
                    "currency": selectedPackage.currency!.billing ?? "",
                    "subscription_package_id":
                        selectedPackage.subscriptionPackageId,
                    "promo_code_applied":
                        subscriptionPackageController.isPromoCodeApplied.value,
                    "promo_code_id": subscriptionPackageController
                            .appliedPromoCode?.promoCodeId ??
                        "",
                    "promo_code": subscriptionPackageController
                            .appliedPromoCode?.promoCode ??
                        "",
                    "promo_code_name": subscriptionPackageController
                            .appliedPromoCode?.promoCodeName ??
                        "",
                  });

                  if (totalPayment == 0) {
                    Navigator.pop(context);
                    freeUpgradeSubscription(
                        subscriptionPackageController, customData);
                  } else {
                    EventsService().sendClickNextEvent(
                        "UpgradeSubscription", "Make Payment", "Payment");

                    Navigator.pop(context);
                    Get.to(JuspayPayment(
                      pageSource: "UPGRADE_SUBSCRIPTION",
                      totalPayment: totalPayment,
                      currency: selectedPackage.currency!.billing ?? "",
                      paymentEvent: "UPGRADE_SUBSCRIPTION",
                      customData: customData,
                    ));
                  }
                }
              },
              child: mainButton('Pay Now'),
            ),
            SizedBox(
              height: 31.h,
            ),
          ],
        ),
      ),
      Positioned(
        top: 34.h,
        left: 7.w,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blueGreyAssessmentColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    ]);
  }

  Future<void> freeUpgradeSubscription(
      SubscriptionPackageController subscriptionPackageController,
      dynamic customData) async {
    if (subscriptionPackageController.isPromoCodeApplied.value == true &&
        subscriptionPackageController.appliedPromoCode?.promoCodeId != null) {
      EventsService().sendEvent("Promo_Code_Transaction", {
        "pageSource": "UPGRADE_SUBSCRIPTION",
        "promo_code_id":
            subscriptionPackageController.appliedPromoCode?.promoCodeId ?? "",
        "promo_code":
            subscriptionPackageController.appliedPromoCode?.promoCode ?? "",
        "order_id": "FREE-PROMO-CODE",
        "currency": customData["selectedPackage"]["currency"],
        "total_payment": 0
      });
      dynamic postPromoCodeData = {
        "promoCodeId":
            subscriptionPackageController.appliedPromoCode?.promoCodeId,
        "orderId": "FREE-PROMO-CODE"
      };
      await PaymentService().postPromoCodeTransaction(postPromoCodeData);
      await startAayuUpgradePlan("FREE_SUBSCRIPTION", customData).then((value) {
        if (value) {
          showGreenSnackBar(Get.context,
              'Great decision! Your program is successfully upgraded.');
        }
      });
    }
  }

  Future<bool> startAayuUpgradePlan(
      String paymentOrderId, dynamic customData) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isUpgraded = await subscriptionController.postAayuUpgradePlan(
      paymentOrderId,
      customData["subscriptionId"],
      customData["selectedPackage"],
    );
    Get.back();
    if (isUpgraded == true) {
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());
      await subscriptionController.getSubscriptionDetails();
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isUpgraded;
  }
}
