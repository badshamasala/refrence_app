import 'package:aayu/controller/program/followup_assessment_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/healing/programme/pop-ups/thank_you_progress_better.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FollowupAssessment extends StatelessWidget {
  const FollowupAssessment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowupAssessmentController followupAssessmentController = Get.find();

    return Obx(() {
      if (followupAssessmentController.isQuestionLoading.value == true) {
        return const Offstage();
      } else if (followupAssessmentController
              .followupAssessmentQuestion.value ==
          null) {
        return const Offstage();
      } else if (followupAssessmentController
              .followupAssessmentQuestion.value!.postAssessment ==
          null) {
        return const Offstage();
      } else {
        return GetBuilder<FollowupAssessmentController>(
            builder: (optionController) {
          if (optionController.followupAssessmentQuestion.value!.postAssessment!
                  .isCompleted ==
              true) {
            return const Offstage();
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 41.h),
            margin: EdgeInsets.only(left: 26.w, right: 26.h, bottom: 60.h),
            decoration: BoxDecoration(
              color: AppColors.lightPrimaryColor,
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "TODAY_QUESTION".tr,
                  style: TextStyle(
                      color: const Color(0xFFF39D9D),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 1.5.w,
                      fontWeight: FontWeight.normal,
                      height: 1.1666666666666667.h),
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
                Text(
                  followupAssessmentController.followupAssessmentQuestion.value!
                      .postAssessment!.question!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 24.sp,
                      letterSpacing: 1.5.w,
                      fontWeight: FontWeight.normal,
                      height: 1.1666666666666667.h),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    optionController.followupAssessmentQuestion.value!
                        .postAssessment!.subjective!.length,
                    (optionIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: InkWell(
                          onTap: (followupAssessmentController
                                      .followupAssessmentQuestion
                                      .value!
                                      .postAssessment!
                                      .isCompleted ==
                                  false)
                              ? () {
                                  optionController
                                      .updateTodaysQuestionAnswer(optionIndex);
                                }
                              : null,
                          child: Container(
                            height: 37.h,
                            width: 131.w,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(30.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 13.w,
                                ),
                                CircleCheckbox(
                                  activeColor: AppColors.primaryColor,
                                  inactiveColor: AppColors.lightSecondaryColor,
                                  value: optionController
                                      .followupAssessmentQuestion
                                      .value!
                                      .postAssessment!
                                      .subjective![optionIndex]!
                                      .selected!,
                                  disabled: optionController
                                      .followupAssessmentQuestion
                                      .value!
                                      .postAssessment!
                                      .isCompleted!,
                                  onChanged: (value) {
                                    optionController.updateTodaysQuestionAnswer(
                                        optionIndex);
                                  },
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: Text(
                                    optionController
                                        .followupAssessmentQuestion
                                        .value!
                                        .postAssessment!
                                        .subjective![optionIndex]!
                                        .text!
                                        .trim(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.secondaryLabelColor,
                                      fontFamily: 'Circular Std',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                InkWell(
                  onTap: (optionController.followupAssessmentQuestion.value!
                              .postAssessment!.isCompleted ==
                          false)
                      ? () async {
                          buildShowDialog(context);
                          bool isSubmitted =
                              await optionController.submitTodaysAnswer();

                          String diseaseId = "";
                          for (var element in subscriptionCheckResponse!
                              .subscriptionDetails!.disease!) {
                            if (diseaseId.isEmpty) {
                              diseaseId = element!.diseaseId!;
                            } else {
                              diseaseId =
                                  diseaseId + ", " + element!.diseaseId!;
                            }
                          }

                          String diseaseNames = "";
                          for (var element in subscriptionCheckResponse!
                              .subscriptionDetails!.disease!) {
                            if (diseaseNames.isEmpty) {
                              diseaseNames = element!.diseaseName!;
                            } else {
                              diseaseNames =
                                  diseaseNames + ", " + element!.diseaseName!;
                            }
                          }

                          if (isSubmitted == true) {
                            EventsService()
                                .sendEvent("Followup_Assessment_Completed", {
                              "program_id": subscriptionCheckResponse!
                                  .subscriptionDetails!.programId,
                              "program_name": subscriptionCheckResponse!
                                  .subscriptionDetails!.programName,
                              "disease_id": diseaseId,
                              "disease_name": diseaseNames,
                              "question_id": optionController
                                  .followupAssessmentQuestion
                                  .value!
                                  .postAssessment!
                                  .questionId,
                              "question": optionController
                                  .followupAssessmentQuestion
                                  .value!
                                  .postAssessment!
                                  .question,
                              "status": "Success",
                            });
                          } else {
                            EventsService()
                                .sendEvent("Followup_Assessment_Failed", {
                              "program_id": subscriptionCheckResponse!
                                  .subscriptionDetails!.programId,
                              "program_name": subscriptionCheckResponse!
                                  .subscriptionDetails!.programName,
                              "disease_id": diseaseId,
                              "disease_name": diseaseNames,
                              "question_id": optionController
                                  .followupAssessmentQuestion
                                  .value!
                                  .postAssessment!
                                  .questionId,
                              "question": optionController
                                  .followupAssessmentQuestion
                                  .value!
                                  .postAssessment!
                                  .question,
                              "status": "Failed",
                            });
                          }

                          Navigator.pop(context);

                          if (isSubmitted == true) {
                            Get.bottomSheet(
                              const ThankYouProgressBetter(),
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: false,
                            );
                          } else {
                            showGetSnackBar("Failed to submit answer!",
                                SnackBarMessageTypes.Info);
                          }
                        }
                      : null,
                  child: (optionController.followupAssessmentQuestion.value!
                              .postAssessment!.isCompleted ==
                          false)
                      ? mainButton("Submit")
                      : Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.primaryColor.withOpacity(0.4),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.07000000029802322),
                                  offset: Offset(-5, 10),
                                  blurRadius: 20),
                            ],
                          ),
                          child: Center(
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                SvgPicture.asset(
                                  AppIcons.completedSVG,
                                  color: Colors.white,
                                  width: 20.h,
                                  height: 20.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "SUBMITTED".tr,
                                  textAlign: TextAlign.center,
                                  style: mainButtonTextStyle(),
                                ),
                              ])),
                        ),
                ),
              ],
            ),
          );
        });
      }
    });
  }
}
