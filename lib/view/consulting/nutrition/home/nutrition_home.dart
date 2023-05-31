// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/controller/daily_records/did_you_know_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/home/nutrition_sessions.dart';
import 'package:aayu/view/consulting/nutrition/home/widgets/complete_assessment.dart';
import 'package:aayu/view/consulting/nutrition/home/widgets/dos_n_dont_widget.dart';
import 'package:aayu/view/consulting/nutrition/home/widgets/food_plan_widget.dart';
import 'package:aayu/view/consulting/nutrition/home/widgets/navigation_grid.dart';
import 'package:aayu/view/cross_promotions/did_you_know.dart';
import 'package:aayu/view/consulting/nutrition/home/your_nutritionist_plan.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/you_tracker/user_tracker_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NutritionHome extends StatelessWidget {
  const NutritionHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late NutritionController nutritionController;
    DidYouKnowController didYouKnowController = Get.put(DidYouKnowController());
    Future.delayed(Duration.zero, () {
      didYouKnowController.getDidYouKnow("NUTRITION");
    });
    if (NutritionController().initialized == false) {
      nutritionController = Get.put(NutritionController());
    } else {
      nutritionController = Get.find();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  "Your Nutrition Plan",
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
            YourNutritionistPlan(
                userNutritionDetails:
                    nutritionController.userNutritionDetails.value!),
            SizedBox(
              height: 26.h,
            ),
            NutritionSessions(
                coachId: nutritionController
                    .userNutritionDetails.value!.currentTrainer!.coachId!),
            const FoodPlanWidget(),
            SizedBox(height: 26.h,),
            const NavigationGrid(),
            SizedBox(height: 26.h,),
            const DosNDontWidget(),
            const UserTrackerList(),
            //const NutritionTipsWidget(),
            const DidYouKnow(category: "NUTRITION"),
            const CompleteNutritionAssessment(),
            SizedBox(
              height: 26.h,
            ),
          ],
        ),
      ),
    );
  }
}
