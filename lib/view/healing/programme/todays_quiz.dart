import 'package:aayu/controller/program/todays_quiz_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TodaysQuiz extends StatelessWidget {
  final dynamic programId;
  final dynamic diseaseId;
  const TodaysQuiz({Key? key, required this.programId, required this.diseaseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodaysProgrammeQuizController todaysProgrammeQuizController =
        Get.put(TodaysProgrammeQuizController());
    return Obx(() {
      if (todaysProgrammeQuizController.isQuizLoading.value == true) {
        return const Offstage();
      } else if (todaysProgrammeQuizController
              .healingQuizResponse.value!.todaysQuiz ==
          null) {
        return const Offstage();
      } else if (todaysProgrammeQuizController
              .healingQuizResponse.value!.todaysQuiz!.quiz ==
          null) {
        return const Offstage();
      } else {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 322.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(184.w),
                  bottomRight: Radius.circular(184.w),
                  topLeft: Radius.circular(24.w),
                  topRight: Radius.circular(24.w),
                ),
              ),
              margin: EdgeInsets.only(top: 100.h, bottom: 26.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 166.h,
                  ),
                  Text(
                    "WELLNESS_QUOTIENT".tr,
                    style: TextStyle(
                      color: const Color(0xFFF39D9D),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 1.5.w,
                      fontWeight: FontWeight.normal,
                      height: 1.1666666666666667.h,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 20.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDD0D0),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 46.w),
                    child: SizedBox(
                      width: 232.w,
                      child: Text(
                        todaysProgrammeQuizController
                            .healingQuizResponse.value!.todaysQuiz!.quiz!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontFamily: 'Baskerville',
                            fontSize: 24.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.1666666666666667.h),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GetBuilder<TodaysProgrammeQuizController>(
                      builder: (optionController) {
                    if (optionController.healingQuizResponse.value!.todaysQuiz!
                            .answerSubmitted ==
                        true) {
                      HealingQuizResponseTodaysQuizOptions? correctOption =
                          optionController
                              .healingQuizResponse.value!.todaysQuiz!.options!
                              .firstWhereOrNull(
                                  (element) => element!.correctAnswer == true);

                      if (correctOption == null) {
                        return const Offstage();
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 228.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8EF29B),
                              borderRadius: BorderRadius.circular(40.w),
                            ),
                            child: Center(
                              child: Text(
                                correctOption.option!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 16.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 27.h,
                          ),
                          SizedBox(
                            width: 257.w,
                            child: Text(
                              optionController.healingQuizResponse.value!
                                      .todaysQuiz!.details ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.4285714285714286.h),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          optionController.healingQuizResponse.value!
                              .todaysQuiz!.options!.length, (index) {
                        return InkWell(
                          onTap: () {
                            optionController.updateTodaysQuizAnswer(index);
                          },
                          child: Container(
                            width: 228.w,
                            height: 48.h,
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                              color: optionController.getTodaysQuizColor(index),
                              borderRadius: BorderRadius.circular(40.w),
                            ),
                            child: Center(
                              child: Text(
                                optionController.healingQuizResponse.value!
                                    .todaysQuiz!.options![index]!.option!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: (optionController
                                                  .healingQuizResponse
                                                  .value!
                                                  .todaysQuiz!
                                                  .options![index]!
                                                  .selected ==
                                              true &&
                                          optionController
                                                  .healingQuizResponse
                                                  .value!
                                                  .todaysQuiz!
                                                  .options![index]!
                                                  .correctAnswer ==
                                              false)
                                      ? AppColors.whiteColor
                                      : AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 16.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.h,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                  SizedBox(
                    height: 92.h,
                  ),
                ],
              ),
            ),
            Image(
              width: 264.w,
              height: 237.h,
              image: const AssetImage(Images.healingQuizImage),
              fit: BoxFit.contain,
            ),
          ],
        );
      }
    });
  }
}
