import 'package:aayu/controller/deeplink/disease_details_deeplink_controller.dart';
import 'package:aayu/model/healing/disease.details.response.model.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/deeplinks/deeplink.disease.details.model.dart';
import '../../../theme/app_colors.dart';
import '../../shared/network_image.dart';
import '../../shared/ui_helper/images.dart';

class ProgramDetailsDeeplink extends StatelessWidget {
  final String programName;
  final DeeplinkDiseaseDetailModel deeplinkDiseaseDetailModel;
  const ProgramDetailsDeeplink(
      {Key? key,
      required this.deeplinkDiseaseDetailModel,
      required this.programName})
      : super(key: key);
  // Widget howToProceedCard(
  //     DeeplinkDiseaseDetailModelDetailsHowtoproceed data, int index) {
  //   return Stack(
  //       clipBehavior: Clip.none,
  //       alignment: Alignment.topLeft,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.symmetric(vertical: 15.h),
  //           padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: const Color(0xFFF7F7F7),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Stack(
  //                 clipBehavior: Clip.none,
  //                 alignment: Alignment.topCenter,
  //                 children: [
  //                   Container(
  //                     width: double.infinity,
  //                     height: 128.h,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20)),
  //                   ),
  //                   Positioned(
  //                       bottom: 23.h,
  //                       child: Image.asset(
  //                         data.image!,
  //                         height: 117.h,
  //                         fit: BoxFit.fitHeight,
  //                       )),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 25.h,
  //               ),
  //               Text(
  //                 data.title!,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     color: AppColors.blueGreyAssessmentColor,
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 22.sp),
  //               ),
  //               SizedBox(
  //                 height: 16.h,
  //               ),
  //               Text(
  //                 data.description!,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     color: AppColors.blueGreyAssessmentColor,
  //                     fontWeight: FontWeight.w400,
  //                     fontSize: 16.sp),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Positioned(
  //             child: CircleAvatar(
  //           radius: 30.h,
  //           backgroundColor: const Color(0xFFC4E6DD),
  //           child: Text(
  //             index.toString(),
  //             style: TextStyle(
  //                 color: AppColors.blueGreyAssessmentColor,
  //                 fontWeight: FontWeight.w700,
  //                 fontSize: 42.sp),
  //           ),
  //         ))
  //       ]);
  // }

  @override
  Widget build(BuildContext context) {
    DiseaseDetailsDeeplinkController diseaseDetailsDeeplinkController =
        Get.find();
    List<Widget> children = [];

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
          height: 20.h,
        ),
        Text(
          diseaseDetailsDeeplinkController
                  .diseaseDetails.value!.details!.description ??
              "Our ${diseaseDetailsDeeplinkController.isPersonalizedCare.value ? "Personalised Care" : diseaseDetailsDeeplinkController.diseaseDetails.value!.details!.disease ?? ""} program is inclusive and open to all. There are no restrictions based on age, gender or body-type.. Our program offers Daily Online Practice with compassionate, trained and professional experts.",
          style: TextStyle(
              color: const Color.fromRGBO(91, 112, 129, 0.8),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp),
        ),
        SizedBox(
          height: 20.h,
        )
      ],
    ));

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
            height: 20.h,
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
                width: 22.h,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                width: 25.w,
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
              height: 1.5,
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

          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 34.h),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFF7F7F7),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Image.asset(
          //         Images.svyasaImage,
          //         width: 90.5.w,
          //         fit: BoxFit.fitWidth,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 14.w,
          //     ),
          //     Expanded(
          //       child: Text(deeplinkDiseaseDetailModel.details!.svyasa!,
          //           style: TextStyle(
          //             fontSize: 14.sp,
          //             color: const Color.fromRGBO(91, 112, 129, 0.8),
          //             fontWeight: FontWeight.w400,
          //           )),
          //     )
          //   ],
          // )
        ],
      ));
    }
    // if (deeplinkDiseaseDetailModel.details!.howtoproceed != null &&
    //     deeplinkDiseaseDetailModel.details!.howtoproceed!.isNotEmpty) {
    //   children.add(Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       SizedBox(
    //         height: 30.h,
    //         width: double.infinity,
    //       ),
    //       Text(
    //         'How to proceed',
    //         style: TextStyle(
    //             color: AppColors.blueGreyAssessmentColor,
    //             fontWeight: FontWeight.w700,
    //             fontSize: 16.sp),
    //       ),
    //       SizedBox(
    //         height: 20.h,
    //       ),
    //     ],
    //   ));
    //   for (int i = 0;
    //       i < deeplinkDiseaseDetailModel.details!.howtoproceed!.length;
    //       i++) {
    //     children.add(howToProceedCard(
    //         deeplinkDiseaseDetailModel.details!.howtoproceed![i]!, i + 1));
    //   }
    // }
    if (diseaseDetailsDeeplinkController.diseaseDetails.value!.details!.tabs !=
            null &&
        diseaseDetailsDeeplinkController
            .diseaseDetails.value!.details!.tabs!.isNotEmpty) {
      List<DiseaseDetailsResponseDetailsTabsContent?>? benefits =
          diseaseDetailsDeeplinkController.diseaseDetails.value!.details!.tabs!
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
                    imgHeight: 22.h,
                    imgWidth: 22.h,
                    boxFit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 25.w,
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
              height: 60.h,
            ),
          ],
        ),
      ),
    );
  }
}
