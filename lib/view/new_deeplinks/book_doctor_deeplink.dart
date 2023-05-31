import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/view/new_deeplinks/widgets/select_disease.dart';
import 'package:aayu/view/onboarding/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../onboarding/onboarding_bottom_sheet.dart';
import '../shared/ui_helper/images.dart';
import '../shared/ui_helper/ui_helper.dart';

class BookDoctorDeeplink extends StatelessWidget {
  final Map<String, dynamic> deeplinkData;
  const BookDoctorDeeplink({Key? key, required this.deeplinkData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingularDeepLinkController singularDeepLinkController = Get.find();
    Get.put(OnboardingBottomSheetController(true));

    return WillPopScope(
      onWillPop: () async {
        Get.close(2);
        Get.to(const GetStarted());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  Get.close(2);
                  Get.to(const GetStarted());
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                )),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Image(
                height: 106.27.h,
                image: const AssetImage(Images.doctorConsultant2Image),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 23.22.h,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 62, right: 63, top: 15.0, bottom: 6),
              child: Text(
                "FREE_DOCTOR_CONSULT".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 24.sp,
                    fontFamily: "Baskerville"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 31,
                right: 31,
              ),
              child: Text(
                "WE_NEED_TO_MENTION_MSG".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Circular Std"),
              ),
            ),
            SizedBox(
              height: 101.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 46.0, right: 94.0),
                child: Text(
                  'PREREQUISITE'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Circular Std"),
                ),
              ),
            ),
            containerWidget(),
            const SizedBox(
              height: 50.0,
            ),
            onBoardButton("GET_STARTED".tr, () {
              EventsService().sendEvent("DL_DOC_LP", {"click": "get_started"});
              if (deeplinkData['diseaseId'] != null) {
                singularDeepLinkController
                    .setDeepLinkDataContinued(deeplinkData);
                singularDeepLinkController.nullDeepLinkData();
                Get.bottomSheet(
                  const OnboardingBottomSheet(),
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: false,
                );
              } else {
                HealingListController healingListController =
                    Get.put(HealingListController());
                healingListController.getHealingList();
                Get.to(SelectDisease(
                  deepLinkData: deeplinkData,
                ));
              }
            })
          ],
        ),
      ),
    );
  }

  containerWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.onboardingContainerbg,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: 166.h,
        width: 285.w,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 20.0, right: 15.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check,
                      color: AppColors.secondaryAssessmentColor, size: 18),
                  const SizedBox(
                    width: 14.0,
                  ),
                  Text(
                    "CHOOSE_FROM_OUR_PANEL".tr,
                    style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Circular Std"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check,
                        color: AppColors.secondaryAssessmentColor, size: 18),
                    const SizedBox(
                      width: 14.0,
                    ),
                    Text(
                      "GET_EVALUATED_IN_15_MINUTES".tr,
                      style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Circular Std"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check,
                        color: AppColors.secondaryAssessmentColor, size: 18),
                    const SizedBox(
                      width: 14.0,
                    ),
                    Text(
                      "FREE_CONSULT_IS_ONE_TIME_OPPORTUNITY".tr,
                      style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Circular Std"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget onBoardButton(String buttonText, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 54.h,
        width: 331.h,
        decoration: AppTheme.mainButtonDecoration,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: mainButtonTextStyle(),
          ),
        ),
      ),
    );
  }
}
