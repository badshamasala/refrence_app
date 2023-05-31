import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/home/food_plan.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FoodPlanWidget extends StatelessWidget {
  const FoodPlanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late NutritionController nutritionController;
    if (NutritionController().initialized == false) {
      nutritionController = Get.put(NutritionController());
    } else {
      nutritionController = Get.find();
    }
    nutritionController.getDietPlans();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const FoodPlan(),
          ),
        );
      },
      child: Container(
        margin: pagePadding(),
        width: 322.w,
        padding: pagePadding(),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.sp),
          color: AppColors.aayuScoreBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Food Plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    height: 1.18.h,
                  ),
                ),
                GetBuilder<NutritionController>(
                    id: "FoodPlanWidget",
                    builder: (controller) {
                      if (nutritionController.isLoading.value == true) {
                        return const Offstage();
                      } else if (nutritionController.userNutritionDietPlans ==
                          null) {
                        return const Offstage();
                      } else if (nutritionController
                              .userNutritionDietPlans!.dietPlans ==
                          null) {
                        return const Offstage();
                      } else if (nutritionController
                          .userNutritionDietPlans!.dietPlans!.isEmpty) {
                        return const Offstage();
                      }
                      return Text(
                        nutritionController.userNutritionDietPlans!.dietPlans
                                ?.last?.headerText ??
                            "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 13.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          height: 1.18.h,
                        ),
                      );
                    }),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "Nutritional guideline for\nconsumption.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 12.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    height: 1.18.h,
                  ),
                ),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomRight,
              children: [
                Image(
                  image: const AssetImage(Images.foodPlan),
                  width: 70.w,
                  height: 70.h,
                ),
                Positioned(
                  right: -8,
                  bottom: -8,
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: const BoxDecoration(
                      color: Color(0xff3E3A93),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
