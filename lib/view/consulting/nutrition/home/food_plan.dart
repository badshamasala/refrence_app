import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/consulting/nutrition/home/view_diet_plan_pdf.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FoodPlan extends StatelessWidget {
  const FoodPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late NutritionController nutritionController;
    if (NutritionController().initialized == false) {
      nutritionController = Get.put(NutritionController());
    } else {
      nutritionController = Get.find();
    }
    Future.delayed(Duration.zero, () {
      nutritionController.getDietPlans();
    });
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(Images.planSummaryBGImage),
              ),
            ),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              title: Text(
                "Your Food Plans",
                style: appBarTextStyle(),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 20.w,
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackLabelColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<NutritionController>(
                id: "FoodPlanList",
                builder: (controller) {
                  if (controller.isLoading.value == true) {
                    return showLoading();
                  } else if (controller.userNutritionDietPlans == null) {
                    return dietPlanIsNotReady();
                  } else if (controller.userNutritionDietPlans!.dietPlans ==
                      null) {
                    return dietPlanIsNotReady();
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: pageHorizontalPadding(),
                    itemCount:
                        controller.userNutritionDietPlans!.dietPlans!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  controller.userNutritionDietPlans!
                                      .dietPlans![index]!.headerText!,
                                  style: TextStyle(
                                    color: AppColors.secondaryLabelColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(ViewDietPlanPDF(
                                        pdfUrl: controller
                                            .userNutritionDietPlans!
                                            .dietPlans![index]!
                                            .dietPlanUrl!,
                                        headerText: controller
                                            .userNutritionDietPlans!
                                            .dietPlans![index]!
                                            .headerText!));
                                  },
                                  child: Text(
                                    "View",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "From: ${DateFormat('dd MMMM, yyyy').format(dateFromTimestamp(controller.userNutritionDietPlans!.dietPlans![index]!.fromDate!))}",
                                  style: TextStyle(
                                    color: const Color(0xFF768897),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "To: ${DateFormat('dd MMMM, yyyy').format(dateFromTimestamp(controller.userNutritionDietPlans!.dietPlans![index]!.toDate!))}",
                                  style: TextStyle(
                                    color: const Color(0xFF768897),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1.h,
                        color: AppColors.secondaryLabelColor.withOpacity(0.5),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  dietPlanIsNotReady() {
    return SizedBox(
      width: 322.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            width: 180.w,
            height: 360.h,
            image: const AssetImage(Images.ballGirlAnimationImage),
          ),
          Text(
            "Hey there! We're hard at work creating a personalized nutrition plan just for you!\nHang tight, and we'll have it ready for you shortly. Trust us, it'll be worth the wait!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
