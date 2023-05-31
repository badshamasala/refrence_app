import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:aayu/view/subscription/offers/widgets/coupon_applied.dart';
import 'package:aayu/view/subscription/widgets/pricing_ui_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubscriptionPricing extends StatelessWidget {
  final bool addShadow;
  final String offerOn;
  final bool showApplyPromocode;
  const SubscriptionPricing({
    Key? key,
    this.addShadow = false,
    this.showApplyPromocode = true,
    required this.offerOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionPackageController>(
        builder: (subscriptionPackageController) {
      if (subscriptionPackageController.isLoading.value == true) {
        return showLoading();
      } else if (subscriptionPackageController.subscriptionPackageData.value ==
          null) {
        return showLoading();
      } else if (subscriptionPackageController
              .subscriptionPackageData.value!.subscriptionPackages ==
          null) {
        return showLoading();
      }

      return Column(
        children: [
          showApplyPromocode
              ? subscriptionPackageController.isPromoCodeApplied == false
                  ? ApplyCoupon(
                      offerOn: offerOn,
                    )
                  : CouponApplied(
                      offerOn: offerOn,
                      appliedPromoCode:
                          subscriptionPackageController.appliedPromoCode!,
                      removeFunction: () {
                        subscriptionPackageController.removeCoupon();
                      })
              : const Offstage(),
          SizedBox(
            height: 26.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              subscriptionPackageController
                  .subscriptionPackageData.value!.subscriptionPackages!.length,
              (index) {
                if (subscriptionPackageController.subscriptionPackageData.value
                        ?.subscriptionPackages?[index] ==
                    null) {
                  return const Offstage();
                }
                return PricingUI2(
                    subscriptionPackageController:
                        subscriptionPackageController,
                    addShadow: true,
                    package: subscriptionPackageController
                        .subscriptionPackageData
                        .value!
                        .subscriptionPackages![index]!,
                    index: index);
              },
            ),
          ),
        ],
      );
    });
  }
}
