import 'package:aayu/controller/healing/initial_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectiveAssessment extends StatelessWidget {
  final InitialAssessmentController subjectiveAssessmentController;
  const SubjectiveAssessment({
    Key? key,
    required this.subjectiveAssessmentController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          subjectiveAssessmentController
              .currentCategory
              .value!
              .question![
                  subjectiveAssessmentController.selectedQuestionIndex.value]!
              .subjective!
              .length,
          (index) {
            return InkWell(
              onTap: () {
                subjectiveAssessmentController
                    .setSubjectiveAssessmentAnswer(index);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleCheckbox(
                      activeColor: AppColors.primaryColor,
                      inactiveColor: AppColors.whiteColor,
                      value: subjectiveAssessmentController
                          .currentCategory
                          .value!
                          .question![subjectiveAssessmentController
                              .selectedQuestionIndex.value]!
                          .subjective![index]!
                          .selected!,
                      onChanged: (value) {
                        subjectiveAssessmentController
                            .setSubjectiveAssessmentAnswer(index);
                      },
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Text(
                        subjectiveAssessmentController
                            .currentCategory
                            .value!
                            .question![subjectiveAssessmentController
                                .selectedQuestionIndex.value]!
                            .subjective![index]!
                            .text!,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
