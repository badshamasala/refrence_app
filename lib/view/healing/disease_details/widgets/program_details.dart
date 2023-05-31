import 'package:aayu/model/healing/disease.details.response.model.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/healing/disease_details_controller.dart';
import '../../../../model/deeplinks/deeplink.disease.details.model.dart';
import '../../../../theme/app_colors.dart';

import '../../../shared/network_image.dart';
import '../../../shared/ui_helper/images.dart';

class ProgramDetails extends StatelessWidget {
  final String programName;
  final DeeplinkDiseaseDetailModel deeplinkDiseaseDetailModel;
  const ProgramDetails(
      {Key? key,
      this.programName = "",
      required this.deeplinkDiseaseDetailModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    DiseaseDetailsController diseaseDetailsController = Get.find();

    List<Widget> children = [];
    if (diseaseDetailsController.diseaseDetails.value!.details!.overview !=
            null &&
        diseaseDetailsController.diseaseDetails.value!.details!.overview!
            .trim()
            .isNotEmpty) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'OVERVIEW'.tr,
            style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp),
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            diseaseDetailsController.diseaseDetails.value!.details!.overview ??
                "",
            style: TextStyle(
              color: AppColors.secondaryLabelColor.withOpacity(0.8),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.5.h,
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ));
    }
    if (deeplinkDiseaseDetailModel.details!.list != null &&
        deeplinkDiseaseDetailModel.details!.list!.isNotEmpty) {
      for (var element in deeplinkDiseaseDetailModel.details!.list!) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(element!.icon!, width: 45.w, fit: BoxFit.fitWidth),
              const SizedBox(
                width: 13,
              ),
              Expanded(
                child: Text(
                    programName == 'Insomnia Care'
                        ? element.text!.replaceAll('/ 60', '')
                        : element.text!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color.fromRGBO(91, 112, 129, 0.8),
                      fontWeight: FontWeight.w400,
                    )),
              )
            ],
          ),
        ));
      }
    }
    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40.h,
          width: double.infinity,
        ),
        Text(
          'Time Commitment',
          style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp),
        ),
        SizedBox(
          height: 14.h,
        ),
        Text(
          "If you practice daily, it takes about two weeks to start seeing results and about 3 months for the change to reflect significantly in your health conditions.",
          style: TextStyle(
            color: AppColors.secondaryLabelColor.withOpacity(0.8),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            height: 1.5.h,
          ),
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    ));

    if (deeplinkDiseaseDetailModel.details!.addOns != null &&
        deeplinkDiseaseDetailModel.details!.addOns!.isNotEmpty) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40.h,
            width: double.infinity,
          ),
          Text(
            'ADD_ONS'.tr,
            style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp),
          ),
          SizedBox(
            height: 14.h,
          ),
        ],
      ));

      for (var element in deeplinkDiseaseDetailModel.details!.addOns!) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                element!.icon!,
                width: 30.w,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Text(element.text!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color.fromRGBO(91, 112, 129, 0.8),
                      fontWeight: FontWeight.w400,
                    )),
              )
            ],
          ),
        ));
      }
    }

    if (diseaseDetailsController.diseaseDetails.value!.details!.tabs != null &&
        diseaseDetailsController
            .diseaseDetails.value!.details!.tabs!.isNotEmpty) {
      List<DiseaseDetailsResponseDetailsTabsContent?>? benefits =
          diseaseDetailsController.diseaseDetails.value!.details!.tabs!
              .firstWhere(
                  (element) => element!.tabName!.toUpperCase() == "BENEFITS")!
              .content;

      if (benefits != null && benefits.isNotEmpty) {
        children.add(Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 40.h,
              ),
              Text(
                'Benefits',
                style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp),
              ),
              SizedBox(
                height: 20.h,
              ),
            ]));
        for (var element in benefits) {
          children.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ShowNetworkImage(
                    imgPath: element!.icon!,
                    imgHeight: 22.w,
                    imgWidth: 22.w,
                    boxFit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: Text(
                      element.text!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color.fromRGBO(91, 112, 129, 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }
    }
    if (deeplinkDiseaseDetailModel.details!.svyasa != null) {
      children.add(Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.h,
          ),
          Text(
            "About S-VYASA",
            style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp),
          ),
          SizedBox(
            height: 20.h,
          ),
          DropCapText(
            deeplinkDiseaseDetailModel.details!.svyasa!,
            style: TextStyle(
              height: 1.5.h,
              fontSize: 14.sp,
              color: const Color.fromRGBO(91, 112, 129, 0.8),
              fontWeight: FontWeight.w400,
            ),
            dropCapPosition: DropCapPosition.start,
            dropCap: DropCap(
              width: 132.w,
              height: 100.h,
              child: Container(
                margin: EdgeInsets.only(right: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 34.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  Images.svyasaImage,
                  width: 90.5.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ],
      ));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(bottom: 80.h),
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 26.w),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(1, 8),
              color: Color.fromRGBO(91, 112, 129, 0.08),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(32.w),
              bottomLeft: Radius.circular(32.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...children,
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
