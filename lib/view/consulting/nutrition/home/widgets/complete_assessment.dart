import 'package:aayu/controller/consultant/nutrition/nutrition_initial_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/initial_assessment/initial_assessment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CompleteNutritionAssessment extends StatelessWidget {
  const CompleteNutritionAssessment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NutritionInitialAssessmentController nutritionInitialAssessmentController =
        Get.put(NutritionInitialAssessmentController());
    Future.delayed(Duration.zero, () {
      nutritionInitialAssessmentController.getInitialAssessmentStatus();
    });
    return GetBuilder<NutritionInitialAssessmentController>(
        id: "InitialAssessmentStatus",
        builder: (controller) {
          if (nutritionInitialAssessmentController
                  .initialAssessmentStatus.value ==
              null) {
            return const Offstage();
          } else if (nutritionInitialAssessmentController
                  .initialAssessmentStatus.value!.assessmentStatus ==
              null) {
            return const Offstage();
          } else if (nutritionInitialAssessmentController
                  .initialAssessmentStatus
                  .value!
                  .assessmentStatus!
                  .isCompleted ==
              true) {
            return const Offstage();
          }
          return Container(
            margin: EdgeInsets.only(left: 26.w, right: 26.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.sp),
              shape: BoxShape.rectangle,
              color: const Color(0xffFFF1F0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: const AssetImage(
                    Images.editAssessment,
                  ),
                  width: 56.w,
                  height: 56.h,
                ),
                Text(
                  "Assessment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontFamily: "Circular Std",
                    fontWeight: FontWeight.w400,
                    height: 1.5.h,
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xff3E3A93),
                    elevation: 0,
                    padding: EdgeInsets.only(right: 10.w),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    await nutritionInitialAssessmentController
                        .getInitialAssessment();
                    Navigator.push(
                      navState.currentState!.context,
                      MaterialPageRoute(
                        builder: (context) => const NutritionInitialAssessment(
                            navigate: false, pageSource: "COMPLETE_ASSESSMENT"),
                      ),
                    );
                  },
                  child: Text(
                    "Complete now",
                    style: TextStyle(
                      fontSize: 13.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.18.h,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
