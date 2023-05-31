import 'package:aayu/controller/consultant/nutrition/nutrition_initial_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/initial_assessment/widgets/assessment_question.dart';
import 'package:aayu/view/consulting/nutrition/initial_assessment/widgets/subjective_options.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widgets/assessment_actions.dart';
import 'widgets/assessment_header.dart';
import 'widgets/objective_options.dart';

class NutritionInitialAssessment extends StatelessWidget {
  final bool navigate;
  final String pageSource;
  const NutritionInitialAssessment({
    Key? key,
    this.navigate = false,
    this.pageSource = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NutritionInitialAssessmentController assessmentController = Get.find();
    if (navigate) {
      Future.delayed(const Duration(milliseconds: 100), () {
        assessmentController.checkAndNavigateToQuestionNotAnswered(pageSource);
      });
    }
    return WillPopScope(
      onWillPop: () => leavingMidWay(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssessmentHeader(closeFunction: () {
              leavingMidWay(context);
            }),
            GetBuilder<NutritionInitialAssessmentController>(
                builder: (assessmentController) {
              if (assessmentController.isLoading.value == true) {
                return Expanded(child: showLoading());
              }
              if (assessmentController.initialAssessmentResponse.value ==
                  null) {
                return const Offstage();
              } else if (assessmentController
                      .initialAssessmentResponse.value!.assessments ==
                  null) {
                return const Offstage();
              } else if (assessmentController
                  .initialAssessmentResponse.value!.assessments!.isEmpty) {
                return const Offstage();
              }

              return Expanded(
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.only(
                      top: 26.h, right: 26.w, bottom: 0.h, left: 26.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F5F5),
                  ),
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: assessmentController.pageController,
                    itemCount: assessmentController
                        .initialAssessmentResponse.value!.assessments!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, questionIndex) {
                      assessmentController.selectedQuestionIndex.value =
                          questionIndex;

                      String assessmentCategory = assessmentController
                          .initialAssessmentResponse
                          .value!
                          .assessments![
                              assessmentController.selectedQuestionIndex.value]!
                          .category!
                          .toUpperCase();

                      if (assessmentCategory == "OBJECTIVE" &&
                          assessmentController
                                  .initialAssessmentResponse
                                  .value!
                                  .assessments![assessmentController
                                      .selectedQuestionIndex.value]!
                                  .objective!
                                  .multiChoice ==
                              false) {
                        NutritionInitialAssessmentModelAssessmentsObjectiveOptions?
                            otherOption = assessmentController
                                .initialAssessmentResponse
                                .value!
                                .assessments![assessmentController
                                    .selectedQuestionIndex.value]!
                                .objective!
                                .options!
                                .firstWhereOrNull((element) =>
                                    element!.selected == true &&
                                    element.option!.toUpperCase() == "OTHER");
                        if (otherOption != null) {
                          assessmentController.showOtherInputBox = true;
                          assessmentController.otherInputController.text =
                              assessmentController
                                      .initialAssessmentResponse
                                      .value!
                                      .assessments![assessmentController
                                          .selectedQuestionIndex.value]!
                                      .objective!
                                      .otherOptionAnswer ??
                                  "";
                        } else {
                          assessmentController.showOtherInputBox = false;
                          assessmentController.otherInputController.text = "";
                        }
                      } else {
                        assessmentController.showOtherInputBox = false;
                        assessmentController.otherInputController.text = "";
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AssessmentQuestion(
                              index: questionIndex,
                              question: assessmentController
                                  .initialAssessmentResponse
                                  .value!
                                  .assessments![assessmentController
                                      .selectedQuestionIndex.value]!
                                  .assessment!),
                          SizedBox(
                            height: 26.h,
                          ),
                          (assessmentCategory == "OBJECTIVE")
                              ? Expanded(
                                  child: ObjectiveOptions(
                                      assessmentController:
                                          assessmentController),
                                )
                              : const Offstage(),
                          (assessmentCategory == "SUBJECTIVE")
                              ? Expanded(
                                  child: SubjectiveOptions(
                                      assessmentController:
                                          assessmentController),
                                )
                              : const Offstage(),
                        ],
                      );
                    },
                  ),
                ),
              );
            })
          ],
        ),
        bottomNavigationBar: GetBuilder<NutritionInitialAssessmentController>(
            builder: (buttonController) {
          if (assessmentController.isLoading.value == true) {
            return const Offstage();
          }
          if (assessmentController.initialAssessmentResponse.value == null) {
            return const Offstage();
          } else if (assessmentController
                  .initialAssessmentResponse.value!.assessments ==
              null) {
            return const Offstage();
          } else if (assessmentController
              .initialAssessmentResponse.value!.assessments!.isEmpty) {
            return const Offstage();
          }
          return AssessmentActions(
              assessmentController: buttonController, pageSource: pageSource);
        }),
      ),
    );
  }

  Future<bool> leavingMidWay(context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LEAVING_MIDWAY'.tr,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                'FINISH_YOUR_ASSESSMENT'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Circular Std",
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color.fromRGBO(86, 103, 137, 0.26),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 9.h,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'DO_IT_LATER'.tr,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Circular Std",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 9.h,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'CONTINUE'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ).then((exit) {
      if (exit == true) {
        return Future<bool>.value(true);
      }
      return Future<bool>.value(exit);
    });
  }
}
