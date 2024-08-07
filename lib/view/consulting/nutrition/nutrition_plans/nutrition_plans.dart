import 'package:aayu/controller/consultant/nutrition/nutrition_plan_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_plans/nutrition_plan_pricing.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:aayu/view/subscription/offers/widgets/coupon_applied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../selected_health_coach.dart';

class NutritionPlans extends StatelessWidget {
  final CoachListModelCoachList coachDetails;
  final String packageType;
  const NutritionPlans(
      {Key? key, required this.coachDetails, required this.packageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appBarWithImage("Healing Nutrition Packages", () {
            Navigator.pop(context);
          }),
          SelectedHealthCoach(
              coachDetails: coachDetails, displayText: "Nutritionist"),
          Expanded(
            child: ChooseNutritionPlans(
              coachDetails: coachDetails,
              packageType: packageType,
            ),
          )
        ],
      ),
    );
  }
}

class ChooseNutritionPlans extends StatelessWidget {
  final CoachListModelCoachList coachDetails;
  final String packageType;
  const ChooseNutritionPlans(
      {Key? key, required this.coachDetails, required this.packageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late NutritionPlanController nutritionPlanController;
    if (NutritionPlanController().initialized == false) {
      nutritionPlanController = Get.put(NutritionPlanController());
    } else {
      nutritionPlanController = Get.find();
    }
    nutritionPlanController.getPlans(packageType, "FIRST TIME");
    return Obx(() {
      if (nutritionPlanController.isLoading.value == true) {
        return showLoading();
      } else if (nutritionPlanController.nutritionPlansResponse.value == null) {
        return showLoading();
      } else if (nutritionPlanController
              .nutritionPlansResponse.value!.packages ==
          null) {
        return showLoading();
      } else if (nutritionPlanController
          .nutritionPlansResponse.value!.packages!.isEmpty) {
        return showLoading();
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 26.h,
          ),
          Text(
            "Select your package",
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
          nutritionPlanController.isPromoCodeApplied.value == false
              ? const ApplyCoupon(
                  offerOn: "NUTRITION PLANS",
                )
              : CouponApplied(
                  offerOn: "NUTRITION PLANS",
                  appliedPromoCode: nutritionPlanController.appliedPromoCode!,
                  removeFunction: () {
                    nutritionPlanController.removeCoupon();
                  }),
          Expanded(
            child: NutritionPlanPricing(
              extendPlan: false,
              nutritionPlanController: nutritionPlanController,
              coachId: coachDetails.coachId!,
            ),
          )
        ],
      );
    });
  }
}
