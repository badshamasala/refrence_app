import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/widgets/subscription_pricing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../services/payment.service.dart';
import '../payment/payment_pop_ups/renewal_payment_success.dart';
import 'widgets/heres_what_you_get_subscription.dart';

class RenewSubscription extends StatelessWidget {
  final String renewalVia;
  final String? promoCode;
  const RenewSubscription({Key? key, required this.renewalVia, this.promoCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionController subscriptionController = Get.find();
    SubscriptionPackageController subscriptionPackageController =
        Get.put(SubscriptionPackageController());
    Future.delayed(Duration.zero, () {
      subscriptionPackageController.getSubscriptionPackages(
          "AAYU", "RENEWAL", null, promoCode, 'RENEWAL');
      subscriptionPackageController.getCommunicationAndTestimonialData();
    });

    return WillPopScope(
      onWillPop: () async {
        if (renewalVia == "PREVIOUS_SUBSCRIPTION") {
          EventsService().sendEvent("Renewal_Selection_Back", {
            "renewal_via": renewalVia,
            "subscription_id": subscriptionController
                .previousSubscriptionDetails
                .value!
                .subscriptionDetails!
                .subscriptionId,
            "package_type": subscriptionController.previousSubscriptionDetails
                .value!.subscriptionDetails!.packageType
          });
        } else {
          EventsService().sendEvent("Renewal_Selection_Back", {
            "renewal_via": renewalVia,
            "subscription_id":
                subscriptionCheckResponse!.subscriptionDetails!.subscriptionId,
            "package_type":
                subscriptionCheckResponse!.subscriptionDetails!.packageType
          });
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5FC),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              Images.subscribeTaAayuBackgroundImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 56.h,
                  ),
                  Text(
                    "Renew Subscription",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontFamily: 'Baskerville',
                        fontSize: 24.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text(
                    'Continue your yoga routine to\nsee lifelong results.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 14.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text(
                    "SELECT YOUR PLAN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.2.h,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  const SubscriptionPricing(
                    offerOn: 'RENEWAL',
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  const HeresWhatYouGetSubscription(),
                  SizedBox(
                    height: 26.h,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 34,
              right: 20,
              child: IconButton(
                  onPressed: () {
                    if (renewalVia == "PREVIOUS_SUBSCRIPTION") {
                      EventsService().sendEvent("Renewal_Selection_Close", {
                        "renewal_via": renewalVia,
                        "subscription_id": subscriptionController
                            .previousSubscriptionDetails
                            .value!
                            .subscriptionDetails!
                            .subscriptionId,
                        "package_type": subscriptionController
                            .previousSubscriptionDetails
                            .value!
                            .subscriptionDetails!
                            .packageType
                      });
                    } else {
                      EventsService().sendEvent("Renewal_Selection_Close", {
                        "renewal_via": renewalVia,
                        "subscription_id": subscriptionCheckResponse!
                            .subscriptionDetails!.subscriptionId,
                        "package_type": subscriptionCheckResponse!
                            .subscriptionDetails!.packageType
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                    size: 25,
                  )),
            ),
          ],
        ),
        bottomNavigationBar: bottomNavigationBar(
            context, subscriptionPackageController, subscriptionController),
      ),
    );
  }

  String showDate(SubscriptionController subscriptionController) {
    if (renewalVia == "PREVIOUS_SUBSCRIPTION") {
      return formatDatetoThForm(dateFromTimestamp(subscriptionController
              .previousSubscriptionDetails
              .value!
              .subscriptionDetails!
              .epochTimes!
              .expiryDate!)
          .add(const Duration(days: 1)));
    } else if (subscriptionCheckResponse!.subscriptionDetails!.status ==
        "ACTIVE") {
      return formatDatetoThForm(dateFromTimestamp(subscriptionController
              .previousSubscriptionDetails
              .value!
              .subscriptionDetails!
              .epochTimes!
              .expiryDate!)
          .add(const Duration(days: 1)));
    } else {
      return formatDatetoThForm(DateTime.now());
    }
  }

  bottomNavigationBar(
      BuildContext context,
      SubscriptionPackageController subscriptionPackageController,
      SubscriptionController subscriptionController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            SupcriptionPackagesModelSubscriptionPackages? selectedPackage =
                subscriptionPackageController
                    .subscriptionPackageData.value!.subscriptionPackages!
                    .firstWhereOrNull((element) => element!.isSelected == true);

            if (selectedPackage != null) {
              double totalPayment = selectedPackage.purchaseAmount! -
                  selectedPackage.offerAmount!;
              if (selectedPackage.country == "IN") {
                totalPayment = totalPayment.floorToDouble();
              }
              dynamic customData;
              if (renewalVia == "PREVIOUS_SUBSCRIPTION") {
                customData = {
                  "renewalVia": renewalVia,
                  "subscriptionId": subscriptionController
                      .previousSubscriptionDetails
                      .value!
                      .subscriptionDetails!
                      .subscriptionId,
                  "selectedPackage": selectedPackage.toJson(),
                  "promoCodeDetails": {
                    "isApplied":
                        subscriptionPackageController.isPromoCodeApplied.value,
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
              } else {
                customData = {
                  "renewalVia": renewalVia,
                  "subscriptionId": subscriptionCheckResponse!
                      .subscriptionDetails!.subscriptionId!,
                  "selectedPackage": selectedPackage.toJson(),
                  "promoCodeDetails": {
                    "isApplied":
                        subscriptionPackageController.isPromoCodeApplied.value,
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
              EventsService().sendEvent("Renewal_Option_Selected", {
                "renewal_via": renewalVia,
                "package_name": selectedPackage.packageName,
                "package_type": selectedPackage.packageType,
                "purchase_type": selectedPackage.purchaseType,
                "subscription_type": selectedPackage.subscriptionType,
                "renewal_charges": selectedPackage.subscriptionCharges,
                "is_percentage": selectedPackage.isPercentage,
                "discount": selectedPackage.discount,
                "purchase_amount": selectedPackage.purchaseAmount,
                "currency": selectedPackage.currency!.billing ?? "",
                "subscription_package_id":
                    selectedPackage.subscriptionPackageId,
                "subscription_id": (renewalVia == "PREVIOUS_SUBSCRIPTION")
                    ? subscriptionController.previousSubscriptionDetails.value!
                        .subscriptionDetails!.subscriptionId
                    : subscriptionCheckResponse!
                        .subscriptionDetails!.subscriptionId!,
                "promo_code_applied":
                    subscriptionPackageController.isPromoCodeApplied.value,
                "promo_code_id": subscriptionPackageController
                        .appliedPromoCode?.promoCodeId ??
                    "",
                "promo_code":
                    subscriptionPackageController.appliedPromoCode?.promoCode ??
                        "",
                "promo_code_name": subscriptionPackageController
                        .appliedPromoCode?.promoCodeName ??
                    "",
              });
              if (totalPayment == 0) {
                Navigator.pop(context);
                freeRenewal(subscriptionPackageController, customData);
              } else {
                EventsService().sendClickNextEvent(
                    "RenewalToAayu", "Make Payment", "Payment");

                Navigator.pop(context);

                Get.to(JuspayPayment(
                  pageSource: "AAYU_RENEWAL",
                  totalPayment: totalPayment,
                  currency: selectedPackage.currency!.billing ?? "",
                  paymentEvent: "AAYU_RENEWAL",
                  customData: customData,
                ));
              }
            }
          },
          child: SizedBox(
            width: 320.w,
            child: mainButton("Pay Now"),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () {
            launchCustomUrl("https://www.resettech.in/terms-of-use.html");
          },
          child: Text(
            'Terms and Privacy',
            style: TextStyle(
              color: const Color(0xFF717171),
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }

  Future<void> freeRenewal(
      SubscriptionPackageController subscriptionPackageController,
      dynamic customData) async {
    if (subscriptionPackageController.isPromoCodeApplied.value == true &&
        subscriptionPackageController.appliedPromoCode?.promoCodeId != null) {
      EventsService().sendEvent("Promo_Code_Transaction", {
        "pageSource": "AAYU_RENEWAL",
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
      await startAayuRenewal("FREE_SUBSCRIPTION", customData);

      Get.bottomSheet(
        RenewalPaymentSuccess(
          customData: customData,
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );
    }
  }

  Future<bool> startAayuRenewal(
      String paymentOrderId, dynamic customData) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isRenewed = await subscriptionController.postAayuRenewal(
        paymentOrderId,
        customData["subscriptionId"],
        customData["selectedPackage"],
        customData["renewalVia"]);
    Get.back();
    if (isRenewed == true) {
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());
      await subscriptionController.getSubscriptionDetails();
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isRenewed;
  }
}
