import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/healing/disease_details_controller.dart';
import '../../../shared/ui_helper/ui_helper.dart';

class HowToProceed extends StatelessWidget {
  const HowToProceed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiseaseDetailsController diseaseDetailsController =
        Get.put(DiseaseDetailsController());

    return Obx((() {
      if (diseaseDetailsController.isLoading.value == true) {
        return showLoading();
      } else if (diseaseDetailsController.howToProceedContent.value == null) {
        return showLoading();
      } else if (diseaseDetailsController.howToProceedContent.value.data ==
          null) {
        return showLoading();
      }

      return SingleChildScrollView(
        child: Container(
          height: 466.h,
          width: 375.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 51.0.w, top: 35.h),
                child: Text("HOW_TO_PROCEED".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              SizedBox(
                height: 324.h,
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: diseaseDetailsController
                        .howToProceedContent.value.data!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: (index == 0.h) ? 51.0 : 0.h),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: 43.0.w, top: 10.h, left: 10.w),
                              height: 324.h,
                              width: 215.w,
                              decoration: const BoxDecoration(
                                color: AppColors.howToProceedBgColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                bottom: 10.w,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 28.0.h,
                                  ),
                                  Image(
                                    height: 120.h,
                                    image: AssetImage(diseaseDetailsController
                                            .howToProceedContent
                                            .value
                                            .data![index]
                                            .image ??
                                        ''),
                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(
                                    height: 24.h,
                                  ),
                                  SizedBox(
                                    width: 172.w,
                                    child: Text(
                                      diseaseDetailsController
                                              .howToProceedContent
                                              .value
                                              .data![index]
                                              .title ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.blackLabelColor,
                                        fontFamily: 'Circular Std',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      diseaseDetailsController
                                              .howToProceedContent
                                              .value
                                              .data![index]
                                              .description ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.secondaryLabelColor,
                                        fontFamily: 'Circular Std',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              child: Container(
                                height: 43.0,
                                width: 43.0,
                                decoration: const BoxDecoration(
                                    color: AppColors.howToProceedRoundBgColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: AppColors.secondaryLabelColor,
                                      fontFamily: 'Circular Std',
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
