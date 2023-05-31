import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/program_recommendation_controller.dart';
import '../../../../controller/healing/healing_list_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../shared/network_image.dart';
import '../../../shared/ui_helper/images.dart';
import '../../../shared/ui_helper/ui_helper.dart';

class RecommendedProgramReady extends StatelessWidget {
  const RecommendedProgramReady({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    Future.delayed(Duration.zero, () {
      subscriptionController.getSubscriptionDetails();
    });
    HealingListController healingListController = Get.find();
    ProgramRecommendationController programRecommendationController =
        Get.find();
    return Obx(() {
      if (programRecommendationController.isLoading.value == true) {
        return const Offstage();
      }
      if (programRecommendationController.recommendation.value == null) {
        return const Offstage();
      }
      if (programRecommendationController
              .recommendation.value!.recommendation ==
          null) {
        return const Offstage();
      }
      return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 34.w),
              decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 55.h,
                  ),
                  Text(
                    programRecommendationController.recommendation.value!
                                .recommendation!.programType == "SINGLE DISEASE"
                        ? 'Your Program is ready'
                        : 'Your Personalised Care\nProgram is ready',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Baskerville",
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackLabelColor,
                        fontSize: 24.sp),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    '${programRecommendationController.recommendation.value!.recommendation!.doctorDetails!.doctorName} has created a program after your consultation session. Here are expert recommendations customised for your unique healing needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0x0ff5f9ff).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        'Chronic health conditions included:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(
                        color: Color(0xFFE9E9E9),
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        height: 130.h,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: programRecommendationController
                              .recommendation
                              .value!
                              .recommendation!
                              .disease!
                              .length,
                          itemBuilder: (context, index) => Container(
                            width: 70.h,
                            margin: EdgeInsets.symmetric(horizontal: 10.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ShowNetworkImage(
                                    imgHeight: 50.h,
                                    boxFit: BoxFit.fitHeight,
                                    imgPath: healingListController
                                        .getImageFromDiseaseId(
                                            programRecommendationController
                                                    .recommendation
                                                    .value!
                                                    .recommendation!
                                                    .disease![index]!
                                                    .diseaseId ??
                                                "")),
                                SizedBox(
                                  height: 13.h,
                                ),
                                Text(
                                  programRecommendationController
                                          .recommendation
                                          .value!
                                          .recommendation!
                                          .disease![index]!
                                          .diseaseName ??
                                      "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.blueGreyAssessmentColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 15.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  subscriptionController.subscriptionDetailsResponse.value !=
                              null &&
                          subscriptionController.subscriptionDetailsResponse
                                  .value!.subscriptionDetails !=
                              null &&
                          subscriptionController.subscriptionDetailsResponse
                              .value!.subscriptionDetails!.programId!.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).pop();

                            programRecommendationController
                                .handleProgramRecommendation(
                                    subscriptionController);
                          },
                          child: mainButton('Let\'s Begin'),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            programRecommendationController
                                .handleProgramRecommendation(
                                    subscriptionController);
                          },
                          child: mainButton(programRecommendationController
                                      .recommendation
                                      .value!
                                      .recommendation!
                                      .disease!
                                      .length <=
                                  1
                              ? 'Start Recommended Program'
                              : 'Start Personalised Care Program'),
                        ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                  )),
            ),
            Positioned(
              top: -37.h,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40.5.h,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    Images.personalisedCareLogo,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            )
          ]);
    });
  }
}
