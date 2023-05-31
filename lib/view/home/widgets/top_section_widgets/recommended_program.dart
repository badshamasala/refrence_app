import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../healing/disease_details/disease_details.dart';

class RecommendedProgram extends StatelessWidget {
  final HomePageTopSectionResponseDetailsProgram programData;
  const RecommendedProgram({Key? key, required this.programData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.w),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ShowNetworkImage(
            imgPath: programData.diseaseImage!,
            imgWidth: double.infinity.w,
            imgHeight: 360.h,
            boxFit: BoxFit.cover,
            placeholderImage: "assets/images/placeholder/default_home.jpg",
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 270.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 1),
                    Color.fromRGBO(0, 0, 0, 0)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "RECOMMENDED".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Circular Std',
                    fontSize: 12.sp,
                    letterSpacing: 1.5.w,
                    fontWeight: FontWeight.normal,
                    height: 1.1666666666666667.h,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  programData.diseaseName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Baskerville',
                    fontSize: 28.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1.h,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 26.h,
            child: InkWell(
              onTap: () {
                HealingListController healingListController =
                    Get.put(HealingListController());
                healingListController.diseaseDetailsRequest.disease = [];
                healingListController.selectedDiseaseNames = [];
                healingListController.selectedDiseaseDetailsRequest.disease =
                    [];
                healingListController.selectedDiseaseNames
                    .add(programData.diseaseName!);
                healingListController.diseaseDetailsRequest.disease!
                    .add(DiseaseDetailsRequestDisease.fromJson({
                  "diseaseId": programData.diseaseId!,
                }));

                healingListController.selectedDiseaseDetailsRequest.disease!
                    .add(SelectedDiseaseDetailsRequestDisease.fromJson({
                  "diseaseId": programData.diseaseId!,
                  "diseaseName": programData.diseaseName!,
                }));
                Get.put(DiseaseDetailsController());
                Get.to(const DiseaseDetails(
                  pageSource: "",
                  fromThankYou: false,
                ));
              },
              child: SizedBox(
                width: 200.w,
                height: 44.h,
                child: mainButton("VIEW_PROGRAM".tr),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
