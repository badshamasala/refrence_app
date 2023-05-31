import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/programme_selection/program_selection.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SwitchProgram extends StatelessWidget {
  final bool fromDoctorRecommended;
  const SwitchProgram({Key? key, this.fromDoctorRecommended = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiseaseDetailsController diseaseDetailsController = Get.find();
    HealingListController healingListController = Get.find();
    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 36.h,
            ),
            Text(
              'Switch Program',
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontSize: 24.sp,
                fontFamily: "Baskerville",
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            Text(
              'Are you sure you want to switch from your ${subscriptionCheckResponse!.subscriptionDetails!.diseaseName} Program to ${diseaseDetailsController.diseaseDetails.value!.details!.disease} Program?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              'You can only switch your program once.\nYour practice routine will re-start from Day 1.\nThink through your decision and make your choice.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            buildSwitchDiseaseDetails(
                diseaseDetailsController, healingListController),
            SizedBox(
              height: 26.h,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 44.h),
                        elevation: 0,
                        primary: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.symmetric(vertical: 9.h)),
                    onPressed: () async {
                      // if (fromDoctorRecommended == true) {
                      //   print("TODO");
                      //   return;
                      // }
                      buildShowDialog(context);
                      diseaseDetailsController.setSelectedHealthProblem();
                      PostAssessmentController postAssessmentController =
                          Get.put(PostAssessmentController());
                      bool isDataAvailable = await postAssessmentController
                          .getProgramDurationDetails();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      if (isDataAvailable == true) {
                        Get.bottomSheet(
                          ProgramSelection(
                            isProgramSwitch: true,
                            isRecommendedProgramSwitch: fromDoctorRecommended,
                          ),
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: false,
                        );
                      } else {
                        showSnackBar(
                            context,
                            "PERFERENCES_DETAILS_NOT_AVAILABLE".tr,
                            SnackBarMessageTypes.Info);
                      }
                    },
                    child: Text(
                      'Switch',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 26.h,
            ),
          ],
        ),
      ),
      Positioned(
        top: 22,
        right: 22,
        child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              size: 25,
              color: AppColors.blackLabelColor,
            )),
      )
    ]);
  }

  buildSwitchDiseaseDetails(DiseaseDetailsController diseaseDetailsController,
      HealingListController healingListController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEAF0F2), width: 1)),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                  color: AppColors.blueGreyAssessmentColor,
                  fontSize: 13.sp,
                  fontFamily: "Circular Std",
                  fontWeight: FontWeight.w400),
              children: [
                const TextSpan(
                  text: 'Duration : ',
                ),
                TextSpan(
                  text:
                      "${subscriptionCheckResponse!.subscriptionDetails!.duration ?? ""} mins",
                  style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 14.sp,
                      fontFamily: "Circular Std",
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFFF9FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEAF0F2), width: 1)),
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
                  diseaseDetailsController
                          .diseaseDetails.value!.details!.disease ??
                      "",
                  diseaseDetailsController.diseaseDetails.value!.details!
                          .silverAppBar!.image!.imageUrl ??
                      "",
                ),
              ],
            ),
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
      height: 140.h,
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
                  child: ShowNetworkImage(
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
