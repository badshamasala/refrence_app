// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/personalised_care_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/healing/disease_details_controller.dart';

class PersonalCareCard extends StatelessWidget {
  final bool fromSwitch;
  const PersonalCareCard({Key? key, required this.fromSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProgramRecommendationController programRecommendationController =
        Get.find();
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!.subscriptionDetails!.programId!.isNotEmpty) {
      if (subscriptionCheckResponse!.subscriptionDetails!.disease!.length > 1) {
        return const Offstage();
      }
    }
    if (programRecommendationController.recommendation.value != null &&
        programRecommendationController.recommendation.value!.recommendation !=
            null &&
        programRecommendationController
                .recommendation.value!.recommendation!.programType !=
            "SINGLE DISEASE") {
      return const Offstage();
    }
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!.subscriptionDetails!.allowPersonalCare ==
            false) {
      return const Offstage();
    }

    return Container(
      color: Color.fromRGBO(253, 207, 207, 0.4),
      width: double.infinity,
      padding: EdgeInsets.only(top: 29.h, bottom: 38.h),
      child: Column(
        children: [
          Text(
            'Other Health Needs?',
            style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontFamily: 'Baskerville',
              fontWeight: FontWeight.w400,
              fontSize: 24.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 63.h,
          ),
          InkWell(
            onTap: () {
              handleNavigation(context);
            },
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  margin: EdgeInsets.symmetric(horizontal: 26.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.h),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.07),
                        blurRadius: 28.51,
                        offset: Offset(0, 1.68),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 68.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          fromSwitch
                              ? 'If you need help with more than one chronic disease, switch to our Personalised Care Program.'
                              : 'Get your customized health program curated by expert Doctors for your unique health needs.',
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      InkWell(
                        onTap: () {
                          handleNavigation(context);
                        },
                        child: mainButton('Access Personalised Care'),
                      ),
                      SizedBox(
                        height: 29.h,
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: -45.h,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.h,
                      child: Padding(
                        padding: EdgeInsets.all(17.h),
                        child: Image.asset(
                          Images.personalisedCareLogo,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  handleNavigation(BuildContext context) async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({"screenName": "PERSONALIZED_CARE"});
      return;
    }
    buildShowDialog(context);
    SubscriptionController subscriptionController = Get.find();
    bool blockHealingAccess = await subscriptionController.checkHealingAccess();
    Navigator.pop(context);
    if (blockHealingAccess == true) {
      showCustomSnackBar(context,
          "Soon you'll find out which healing program is perfect for you. Wait just a little longer and take the right step forward with the doctor's recommendation.");
    } else {
      Get.put(DiseaseDetailsController());
      Get.to(const PersonalisedCareSubscription(
          subscribeVia: "PERSONAL_CARE_CARD", isProgramRecommended: false));
    }
  }
}
