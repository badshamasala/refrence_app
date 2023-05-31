// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/consultant/feedback_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_session_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CoachSessionFeedback extends StatelessWidget {
  final String coachType;
  final CoachPendingReviewsModelPendingReviews sessionDetails;
  final int rating;

  const CoachSessionFeedback({
    Key? key,
    required this.coachType,
    required this.sessionDetails,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FeedbackController feedbackController = Get.put(FeedbackController());
    feedbackController.updateRating(rating);
    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 26.h,
            ),
            SizedBox(
              width: 253.w,
              child: Text(
                "HOW_WAS_YOUR_EXPERIENCE".tr,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Baskerville',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            circularConsultImage(
                coachType, sessionDetails.coach!.profilePic, 120, 120),
            SizedBox(
              height: 14.h,
            ),
            Text(
              sessionDetails.coach!.coachName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                height: 1.5.h,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
                text: "DATE".tr,
                children: <TextSpan>[
                  TextSpan(
                    text: DateFormat.yMMMd()
                        .format(dateFromTimestamp(sessionDetails.fromTime!)),
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
                text: "TIME".tr,
                children: <TextSpan>[
                  TextSpan(
                    text: DateFormat.jm()
                        .format(dateFromTimestamp(sessionDetails.fromTime!)),
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            GetBuilder<FeedbackController>(builder: (ratingController) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) {
                    return InkWell(
                      onTap: () async {
                        ratingController.updateRating(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 18),
                        child: SvgPicture.asset(
                          (index <= ratingController.rating)
                              ? AppIcons.ratingFilledSVG
                              : AppIcons.ratingUnfilledSVG,
                          width: 40,
                          height: 40,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            SizedBox(
              height: 16.h,
            ),
            SizedBox(
              width: 320.w,
              child: TextField(
                controller: feedbackController.textController,
                maxLength: 500,
                maxLines: null,
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {},
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: const Color(0xFF5B7081),
                ),
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                    color: const Color.fromRGBO(143, 157, 168, 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  hintStyle: TextStyle(
                    color: const Color.fromRGBO(140, 140, 140, 0.4),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baskerville',
                  ),
                  hintText: 'LEAVE_REVIEW_TEXT'.tr,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  focusColor: const Color.fromRGBO(247, 247, 247, 0),
                  hoverColor: const Color.fromRGBO(247, 247, 247, 0),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: pagePadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<FeedbackController>(builder: (buttonController) {
              if (buttonController.rating >= 0) {
                return InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    buildShowDialog(context);
                    String profession = "";
                    if (coachType == "DOCTOR") {
                      profession = "Doctor";
                    } else if (coachType == "TRAINER") {
                      profession = "Trainer";
                    }else if (coachType == "NUTRITIONIST") {
                      profession = "Nutritionist";
                    }
                    bool isSubmitted = await buttonController.postFeedback(
                        profession,
                        sessionDetails.coach!.coachId!,
                        sessionDetails.sessionId ?? "");
                    Navigator.of(context).pop();
                    if (isSubmitted == true) {
                      showCustomSnackBar(context, "FEEDBACK_TEXT".tr);
                      if (coachType == "DOCTOR") {
                        DoctorSessionController doctorSessionController =
                            Get.find();
                        doctorSessionController.getPendingReviews();
                        Navigator.of(context).pop("updated");
                      }else if (coachType == "TRAINER") {
                        TrainerSessionController trainerSessionController =
                            Get.find();
                        trainerSessionController.getPendingReviews();
                        Navigator.of(context).pop("updated");
                      }else if (coachType == "NUTRITIONIST") {
                        NutritionSessionController nutritionSessionController =
                            Get.find();
                        nutritionSessionController.getPendingReviews();
                        Navigator.of(context).pop("updated");
                      }
                    }
                  },
                  child: mainButton("SUBMIT".tr),
                );
              } else {
                return disabledButton("SUBMIT".tr);
              }
            })
          ],
        ),
      ),
    );
  }
}
