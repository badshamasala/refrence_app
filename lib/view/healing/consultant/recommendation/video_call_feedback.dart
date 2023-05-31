import 'package:aayu/controller/consultant/feedback_controller.dart';
import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/recommendation/post_call_score_card.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../controller/healing/user_identification_controller.dart';
import '../../../../model/healing/disease.details.requset.model.dart';

class VideoCallFeedback extends StatelessWidget {
  final String coachType;
  final String coachId;
  final String coachName;
  final String profilePic;
  final String sessionId;

  const VideoCallFeedback({
    Key? key,
    required this.coachType,
    required this.coachId,
    required this.coachName,
    required this.profilePic,
    required this.sessionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FeedbackController feedbackController = Get.put(FeedbackController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 96.h,
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
              circularConsultImage(coachType, profilePic, 120, 120),
              SizedBox(
                height: 14.h,
              ),
              Text(
                coachName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5.h,
                ),
              ),
              SizedBox(
                height: 26.h,
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
                height: 26.h,
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
      ),
      bottomNavigationBar: SizedBox(
        height: 150.h,
        child: Padding(
          padding: pagePadding(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<FeedbackController>(builder: (buttonController) {
                if (buttonController.rating >= 0) {
                  return InkWell(
                    onTap: () async {
                      buildShowDialog(context);
                      String profession = "";
                      if (coachType == "DOCTOR") {
                        profession = "Doctor";
                      } else if (coachType == "TRAINER") {
                        profession = "Trainer";
                      }
                      await buttonController.postFeedback(
                          profession, coachId, sessionId);
                      showCustomSnackBar(context, "FEEDBACK_TEXT".tr);
                      Navigator.of(context).pop();
                      redirectToScoreCard(context);
                    },
                    child: mainButton("SUBMIT".tr),
                  );
                } else {
                  return disabledButton("SUBMIT".tr);
                }
              }),
              SizedBox(
                height: 16.h,
              ),
              InkWell(
                onTap: () async {
                  redirectToScoreCard(context);
                },
                child: Text(
                  "SKIP".tr,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    fontFamily: "Circular Std",
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  redirectToScoreCard(BuildContext context) async {
    buildShowDialog(context);
    ProgramRecommendationController programRecommendationController =
        Get.find();
    await programRecommendationController
        .getProgramRecommendationForSessionId(sessionId);

    if (programRecommendationController.recommendation.value != null &&
        programRecommendationController.recommendation.value!.recommendation !=
            null) {
      String subscriptionId = '';
      UserIdentificationController userIdentificationController =
          Get.put(UserIdentificationController());
      DiseaseDetailsRequest diseaseDetailsRequest = DiseaseDetailsRequest();
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        subscriptionId =
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId ??
                "";
      }

      diseaseDetailsRequest.disease = [];
      for (var element in programRecommendationController
          .recommendation.value!.recommendation!.disease!) {
        diseaseDetailsRequest.disease!
            .add(DiseaseDetailsRequestDisease(diseaseId: element!.diseaseId));
      }
      await userIdentificationController.getUserIdentificationId(
          "Initial Assessment", diseaseDetailsRequest, subscriptionId);
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostCallScoreCard(sessionId: sessionId),
        ),
      );
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
