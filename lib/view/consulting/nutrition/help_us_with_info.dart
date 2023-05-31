// ignore_for_file: use_build_context_synchronously

import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/consulting/nutrition/initial_assessment/initial_assessment.dart';
import 'package:aayu/view/consulting/nutrition/nutritionist_list.dart';
import 'package:aayu/view/profile/need_profile_info.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/consultant/nutrition/nutrition_initial_assessment_controller.dart';

class HelpUsWithInfo extends StatefulWidget {
  const HelpUsWithInfo({Key? key}) : super(key: key);

  @override
  State<HelpUsWithInfo> createState() => _HelpUsWithInfoState();
}

class _HelpUsWithInfoState extends State<HelpUsWithInfo> {
  bool completedAssessment = false;
  bool startedAssessment = false;
  bool _isInit = true;
  bool buttonLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      NutritionInitialAssessmentController
          nutritionInitialAssessmentController =
          Get.put(NutritionInitialAssessmentController());
      await nutritionInitialAssessmentController.getInitialAssessmentStatus();
      setState(() {
        completedAssessment = nutritionInitialAssessmentController
                .initialAssessmentStatus.value?.assessmentStatus?.isCompleted ??
            false;
        startedAssessment = nutritionInitialAssessmentController
                .initialAssessmentStatus.value?.assessmentStatus?.isStarted ??
            false;
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
        EventsService()
            .sendClickBackEvent("HelpUsWithInfo", "Back", "HowItWorks");
      }),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 140.w,
              image: const AssetImage(Images.foodBowlImage),
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: 300.h,
              child: Text(
                completedAssessment
                    ? "Great Job!"
                    : startedAssessment
                        ? "Conclude your valuable assessment."
                        : "Accurate information yields precise results ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 22.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                  height: 1.18.h,
                ),
              ),
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: 300.h,
              child: Text(
                completedAssessment
                    ? "You've completed your\nassessment"
                    : startedAssessment
                        ? ""
                        : "Help us with your assessment",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  height: 1.18.h,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buttonLoading
          ? Row(
              children: const [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                Spacer(),
              ],
            )
          : completedAssessment
              ? Padding(
                  padding: pagePadding(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            buttonLoading = true;
                          });

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);

                          Get.to(const NutritionistList(pageSource: ""));
                        },
                        child: mainButton("Select your Nutritionist"),
                      ),
                      TextButton(
                          onPressed: () async {
                            NutritionInitialAssessmentController
                                assessmentController =
                                Get.put(NutritionInitialAssessmentController());
                            await assessmentController.getInitialAssessment();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              navState.currentState!.context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NutritionInitialAssessment(),
                              ),
                            );
                          },
                          child: Text(
                            "Re-assess yourself?",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp),
                          ))
                    ],
                  ),
                )
              : startedAssessment
                  ? Padding(
                      padding: pagePadding(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                buttonLoading = true;
                              });
                              NutritionInitialAssessmentController
                                  assessmentController = Get.put(
                                      NutritionInitialAssessmentController());
                              await assessmentController.getInitialAssessment();

                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                navState.currentState!.context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NutritionInitialAssessment(
                                    navigate: true,
                                  ),
                                ),
                              );
                            },
                            child: mainButton("Continue assessment"),
                          ),
                          TextButton(
                              onPressed: () async {
                                NutritionInitialAssessmentController
                                    assessmentController = Get.put(
                                        NutritionInitialAssessmentController());
                                await assessmentController
                                    .getInitialAssessment();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  navState.currentState!.context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NutritionInitialAssessment(),
                                  ),
                                );
                              },
                              child: Text(
                                "Start over again",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.sp),
                              ))
                        ],
                      ),
                    )
                  : Container(
                      width: 322.w,
                      padding: pagePadding(),
                      child: InkWell(
                        onTap: () async {
                          NutritionInitialAssessmentController
                              assessmentController =
                              Get.put(NutritionInitialAssessmentController());

                          UserDetailsResponse? userDetailsResponse =
                              await HiveService().getUserDetails();
                          if (userDetailsResponse != null &&
                              userDetailsResponse.userDetails != null) {
                            if (userDetailsResponse
                                    .userDetails!.firstName!.isEmpty ||
                                userDetailsResponse
                                    .userDetails!.gender!.isEmpty ||
                                userDetailsResponse.userDetails!.dob!.isEmpty) {
                              EventsService().sendClickNextEvent(
                                  "HelpUsWithInfo", "Next", "NeedProfileInfo");
                              String? result = await Get.bottomSheet(
                                const NeedProfileInfo(),
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: false,
                              );
                              if (result != null && result.isNotEmpty) {
                                assessmentController.getInitialAssessment();
                                EventsService().sendClickNextEvent(
                                    "HelpUsWithInfo",
                                    "Next",
                                    "NutritionInitialAssessment");
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  navState.currentState!.context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NutritionInitialAssessment(),
                                  ),
                                );
                              }
                            } else {
                              assessmentController.getInitialAssessment();
                              EventsService().sendClickNextEvent(
                                  "HelpUsWithInfo",
                                  "Next",
                                  "NutritionInitialAssessment");
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                navState.currentState!.context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NutritionInitialAssessment(),
                                ),
                              );
                            }
                          } else {
                            assessmentController.getInitialAssessment();
                            EventsService().sendClickNextEvent("HelpUsWithInfo",
                                "Next", "NutritionInitialAssessment");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              navState.currentState!.context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NutritionInitialAssessment(),
                              ),
                            );
                          }
                        },
                        child: mainButton("Next"),
                      ),
                    ),
    );
  }
}
