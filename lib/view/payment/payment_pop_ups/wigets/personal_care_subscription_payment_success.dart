// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/programme_selection/personal_care/personal_care_program_selection.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/consultant/program_recommendation_controller.dart';

class PersonalCareSubscriptionPaymentSuccess extends StatelessWidget {
  const PersonalCareSubscriptionPaymentSuccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F5FC),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              SizedBox(
                height: 35.h,
                width: double.infinity,
              ),
              Image.asset(
                Images.paymentSuccess2Image,
                height: 135.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                'Smile!\nYour payment is successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGreyAssessmentColor,
                  fontSize: 20.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Your Personalised Care Program\nsubscription is now active.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blueGreyAssessmentColor,
                  fontSize: 14.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.w),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Start Date:',
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDatetoThForm(dateFromTimestamp(
                          subscriptionCheckResponse!.subscriptionDetails!
                              .epochTimes!.subscribeDate!)),
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                endIndent: 45.w,
                indent: 45.w,
                color: const Color(0xFFD1D9E5),
                thickness: 1.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.w),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'End Date:',
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatDatetoThForm(dateFromTimestamp(subscriptionCheckResponse!
                              .subscriptionDetails!.epochTimes!.expiryDate!)),
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: 67.h, bottom: 56.h, left: 37.w, right: 37.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Remember this about your',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 16.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Personalised Care Program',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackLabelColor,
                              fontSize: 24.sp,
                              fontFamily: 'Baskerville',
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            'Before you begin your program, believe that you can achieve your health goal. Commit to it and stay positive. You\'ll see the results. ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 14.sp,
                              height: 1.5,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -40.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 49.h,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            Images.personalisedCareLogo,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -19.h,
                      child: InkWell(
                        onTap: () async {
                          buildShowDialog(Get.context!);
                          HealingListController healingListController =
                              Get.find();
                          ProgramRecommendationController
                              programRecommendationController = Get.find();
                          List<String> diseaseList =
                              programRecommendationController.recommendation
                                  .value!.recommendation!.disease!
                                  .map((element) => element!.diseaseId!)
                                  .toList();

                          healingListController
                              .setSelectedDiseaseFromMultiDiseaseIds(
                                  diseaseList);
                          PostAssessmentController postAssessmentController =
                              Get.put(PostAssessmentController());

                          String programId = programRecommendationController
                                  .recommendation
                                  .value!
                                  .recommendation!
                                  .programId ??
                              "";
                          bool isDataAvailable = await postAssessmentController
                              .getProgramDetails(programId);
                          Navigator.pop(context);

                          if (isDataAvailable == true) {
                            Get.bottomSheet(
                              const PersonalCareProgramSelection(
                                startProgram: false,
                              ),
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: false,
                            );
                          } else {
                            showSnackBar(
                                Get.context!,
                                "PERFERENCES_DETAILS_NOT_AVAILABLE".tr,
                                SnackBarMessageTypes.Info);
                          }
                        },
                        child: Container(
                          height: 50.h,
                          width: 209.w,
                          decoration: AppTheme.mainButtonDecoration,
                          child: Center(
                            child: Text(
                              'Let\'s get started',
                              textAlign: TextAlign.center,
                              style: mainButtonTextStyle(),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
              const Spacer()
            ]),
          ),
        ));
  }
}
