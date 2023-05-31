// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/psychology_initial_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AssessmentActions extends StatelessWidget {
  final PsychologyInitialAssessmentController assessmentController;
  const AssessmentActions({Key? key, required this.assessmentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showSkipOption = true;
    if (assessmentController
            .initialAssessmentResponse.value!.assessments!.last!.assessmentId ==
        assessmentController
            .initialAssessmentResponse
            .value!
            .assessments![assessmentController.selectedQuestionIndex.value]!
            .assessmentId!) {
      showSkipOption = false;
    } else {
      showSkipOption = assessmentController
              .initialAssessmentResponse
              .value!
              .assessments![assessmentController.selectedQuestionIndex.value]!
              .skipable ??
          false;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 26.h),
      color: const Color(0xFFF8F5F5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: (assessmentController.questionHistory.isNotEmpty),
                    child: InkWell(
                      onTap: () {
                        assessmentController.getPreviousQuestion();
                      },
                      child: Container(
                        height: 54.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: AppColors.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.07000000029802322),
                                offset: Offset(-5, 10),
                                blurRadius: 20),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "PREVIOUS".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              height: 1.h,
                              fontFamily: "Circular Std",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () async {
                      //buildShowDialog(context);
                      await assessmentController.getNextQuestion();
                      //Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 150.w,
                      child: mainButton("Next"),
                    ),
                  ),
                ),
              )
            ],
          ),
          showSkipOption == true
              ? SizedBox(
                  height: 16.h,
                )
              : const Offstage(),
          showSkipOption == true
              ? InkWell(
                  onTap: () {
                    assessmentController.skipQuestion();
                  },
                  child: Text(
                    "Skip for now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 1.h,
                      fontFamily: "Circular Std",
                    ),
                  ),
                )
              : const Offstage(),
        ],
      ),
    );
  }
}
