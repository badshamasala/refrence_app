import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/view/healing/programme_selection/personal_care/personal_care_program_selection.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/healing/post_assessment_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_theme.dart';
import '../../../shared/constants.dart';
import '../../../shared/network_image.dart';
import '../../../shared/ui_helper/images.dart';
import '../../programme_selection/program_selection.dart';

class PersonalCareSwitchYearlySubBottomSheet extends StatelessWidget {
  const PersonalCareSwitchYearlySubBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealingListController healingListController = Get.find();
    ProgramRecommendationController programRecommendationController =
        Get.find();
    return Container(
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
            height: 30.h,
          ),
          AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Switch Program',
                style: AppTheme.secondarySmallFontTitleTextStyle,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.blackLabelColor,
                    ))
              ]),
          Text(
            'Are you sure you want to switch from your yearly ${subscriptionCheckResponse!.subscriptionDetails!.diseaseName} Program to Personalised Care Program?',
            style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            'Please note your practice routine will re-start from Day 1.',
            style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEAF0F2), width: 1)),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: const Color(0xFFEAF0F2), width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      diseaseDetails(
                          subscriptionCheckResponse!
                                  .subscriptionDetails!.diseaseName ??
                              "",
                          healingListController.getImageFromDiseaseName(
                            subscriptionCheckResponse!
                                    .subscriptionDetails!.diseaseName ??
                                "",
                          )),
                      Stack(alignment: Alignment.center, children: [
                        Container(
                          height: 200,
                          color: const Color(0xFFEAF0F2),
                          width: 1,
                        ),
                        Image.asset(
                          Images.switchProgramArrowImage,
                          width: 40,
                          fit: BoxFit.fitWidth,
                        )
                      ]),
                      diseaseDetails(
                        'Personalised Care',
                        'PERSONAL CARE',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          InkWell(
            onTap: () async {
              buildShowDialog(context);
              DiseaseDetailsController diseaseDetailsController =
                  Get.put(DiseaseDetailsController());
              await diseaseDetailsController.getPersonalCareDetails();

              HealingListController healingListController = Get.find();
              ProgramRecommendationController programRecommendationController =
                  Get.find();
              List<String> diseaseList = programRecommendationController
                  .recommendation.value!.recommendation!.disease!
                  .map((element) => element!.diseaseId!)
                  .toList();

              healingListController
                  .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);
              PostAssessmentController postAssessmentController =
                  Get.put(PostAssessmentController());

              String programId = programRecommendationController
                      .recommendation.value!.recommendation!.programId ??
                  "";
              bool isDataAvailable =
                  await postAssessmentController.getProgramDetails(programId);

              Navigator.pop(context);
              if (isDataAvailable == true) {
                Navigator.pop(context);
                Get.bottomSheet(
                  const PersonalCareProgramSelection(
                    startProgram: true,
                  ),
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: false,
                );

                // Get.bottomSheet(
                //   const ProgramSelection(
                //       isProgramSwitch: true, isRecommendedProgramSwitch: true),
                //   isScrollControlled: true,
                //   isDismissible: true,
                //   enableDrag: false,
                // );
              } else {
                showSnackBar(context, "PERFERENCES_DETAILS_NOT_AVAILABLE".tr,
                    SnackBarMessageTypes.Info);
              }
            },
            child: mainButton('Switch'),
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }

  diseaseDetails(String diseaseName, String diseaseImage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8.54,
              offset: Offset(2.44, 3.66),
              color: Color.fromRGBO(0, 0, 0, 0.03),
            )
          ]),
      width: 115.h,
      height: 150.h,
      padding:
          EdgeInsets.only(top: 22.h, bottom: 12.h, left: 9.2.w, right: 9.2.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 8.h,
          ),
          Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 67.h,
                  width: 86.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: -13.h,
                  child: diseaseImage == 'PERSONAL CARE'
                      ? Image.asset(
                          Images.personalisedCareLogo,
                          height: 64.h,
                          fit: BoxFit.fitHeight,
                        )
                      : ShowNetworkImage(
                          imgPath: diseaseImage,
                          imgHeight: 64.h,
                          boxFit: BoxFit.fitHeight,
                        ),
                ),
              ]),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              diseaseName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
