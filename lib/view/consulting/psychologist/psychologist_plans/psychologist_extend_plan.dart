import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:aayu/view/subscription/offers/widgets/coupon_applied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/psychologist/psychology_plan_controller.dart';
import 'psychologist_plan_pricing.dart';

class PsychologyExtendPlan extends StatelessWidget {
  const PsychologyExtendPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyPlanController psychologyPlanController =
        Get.put(PsychologyPlanController());
    psychologyPlanController.getPlans("FIRST TIME");

    return Obx(() {
      if (psychologyPlanController.isLoading.value == true) {
        return showLoading();
      } else if (psychologyPlanController.psychologyPlansResponse.value ==
          null) {
        return showLoading();
      } else if (psychologyPlanController
              .psychologyPlansResponse.value!.packages ==
          null) {
        return showLoading();
      } else if (psychologyPlanController
          .psychologyPlansResponse.value!.packages!.isEmpty) {
        return showLoading();
      }

      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBarWithImage("Extend your plan", () {
              Navigator.pop(context);
            }),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    "Select your package",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 20.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Padding(
                    padding: pageHorizontalPadding(),
                    child: psychologyPlanController.isPromoCodeApplied.value ==
                            false
                        ? const ApplyCoupon(
                            offerOn: "PSYCHOLOGY PLANS",
                          )
                        : CouponApplied(
                            offerOn: "PSYCHOLOGY PLANS",
                            appliedPromoCode:
                                psychologyPlanController.appliedPromoCode!,
                            removeFunction: () {
                              psychologyPlanController.removeCoupon();
                            }),
                  ),
                  PsychologyPlanPricing(
                    extendPlan: true,
                    psychologyPlanController: psychologyPlanController,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
