import 'package:aayu/controller/consultant/nutrition/nutrition_plan_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_plans/nutrition_plan_pricing.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:aayu/view/subscription/offers/widgets/coupon_applied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NutritionExtendPlan extends StatelessWidget {
  final String packageType;
  final String coachId;
  const NutritionExtendPlan(
      {Key? key, required this.packageType, required this.coachId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late NutritionPlanController nutritionPlanController;
    if (NutritionPlanController().initialized == false) {
      nutritionPlanController = Get.put(NutritionPlanController());
    } else {
      nutritionPlanController = Get.find();
    }
    nutritionPlanController.getPlans(packageType, "UPGRADE");
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appBarWithImage("Extend your plan", () {
          Navigator.pop(context);
        }),
        Expanded(
          child: Obx(() {
            if (nutritionPlanController.isLoading.value == true) {
              return showLoading();
            } else if (nutritionPlanController.nutritionPlansResponse.value ==
                null) {
              return showLoading();
            } else if (nutritionPlanController
                    .nutritionPlansResponse.value!.packages ==
                null) {
              return showLoading();
            } else if (nutritionPlanController
                .nutritionPlansResponse.value!.packages!.isEmpty) {
              return showLoading();
            }
            return ListView(
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
                  child:
                      nutritionPlanController.isPromoCodeApplied.value == false
                          ? const ApplyCoupon(
                              offerOn: "NUTRITION PLANS",
                            )
                          : CouponApplied(
                              offerOn: "NUTRITION PLANS",
                              appliedPromoCode:
                                  nutritionPlanController.appliedPromoCode!,
                              removeFunction: () {
                                nutritionPlanController.removeCoupon();
                              }),
                ),
                NutritionPlanPricing(
                  extendPlan: true,
                  nutritionPlanController: nutritionPlanController,
                  coachId: coachId,
                ),
              ],
            );
          }),
        )
      ],
    ));
  }
}
