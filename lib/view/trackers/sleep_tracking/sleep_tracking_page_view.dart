// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/view/trackers/sleep_tracking/bottom_sheet/sleep_checkin_complete.dart';
import 'package:aayu/view/trackers/sleep_tracking/pageview/how_did_you_sleep.dart';
import 'package:aayu/view/trackers/sleep_tracking/pageview/sleep_hours_check_in.dart';
import 'package:aayu/view/trackers/sleep_tracking/pageview/what_affected_your_sleep.dart';
import 'package:aayu/view/trackers/sleep_tracking/sleep_tracking_summary.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SleepTrackerPageView extends StatelessWidget {
  const SleepTrackerPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SleepTrackerController sleepTrackerController = Get.find();
    Future.delayed(Duration.zero, () {
      sleepTrackerController.setInitialValues();
    });

    AppBar customAppBar = AppBar(
      iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      backgroundColor: AppColors.sleepTrackerBackgroundLight,
      centerTitle: true,
      elevation: 0,
      title: GetBuilder<SleepTrackerController>(builder: (sliderController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            sliderController.totalPages,
            (index) {
              return AnimatedContainer(
                margin: (index == sliderController.totalPages - 1)
                    ? EdgeInsets.zero
                    : EdgeInsets.only(right: 5.w),
                height: 4.h,
                width: 25.h,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: (index == sliderController.pageIndex)
                      ? const Color(0xFF75CAE2)
                      : const Color(0xFF9D97E0),
                  borderRadius: BorderRadius.circular(2),
                ),
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
        );
      }),
      leading: IconButton(
        onPressed: () {
          handleBackNavigation(sleepTrackerController, context);
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            size: 25,
            color: Colors.white,
          ),
        )
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        handleBackNavigation(sleepTrackerController, context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.sleepTrackerBackgroundLight,
        appBar: customAppBar,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: sleepTrackerController.pageController,
                onPageChanged: (index) {
                  sleepTrackerController.pageIndex = index;
                  sleepTrackerController.update();
                },
                children: const [
                  HowDidYouSleepLastNight(),
                  WhatAffectedYourSleep(),
                  SleepHoursCheckIn(),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            GetBuilder<SleepTrackerController>(
              builder: (buttonController) => InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (buttonController.pageIndex == 2) {
                    buildShowDialog(context);
                    sleepTrackerController
                        .postSleepCheckIn()
                        .then((value) async {
                      late SleepTrackerSummaryController
                          sleepTrackerSummaryController;
                      if (SleepTrackerSummaryController().initialized) {
                        sleepTrackerSummaryController = Get.find();
                      } else {
                        sleepTrackerSummaryController =
                            Get.put(SleepTrackerSummaryController());
                      }
                      await sleepTrackerSummaryController
                          .getRecentSleepCheckIn();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Get.to(const SleepTrackerSummary());
                    });
                  } else {
                    buttonController.pageController.animateToPage(
                        buttonController.pageIndex + 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  height: 54.h,
                  width: buttonController.pageIndex == 2 ? 258.w : 154.w,
                  padding: EdgeInsets.symmetric(vertical: 17.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.sleepTrackerButtonBlueColor,
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                          offset: Offset(-5, 10),
                          blurRadius: 20),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      buttonController.pageIndex == 2
                          ? 'Complete Check-in'
                          : 'Next',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.sleepTrackerOptionsColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        height: 1.h,
                        fontFamily: "Circular Std",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            )
          ],
        ),
      ),
    );
  }

  handleBackNavigation(
      SleepTrackerController sleepTrackerController, BuildContext context) {
    if (sleepTrackerController.pageIndex == 0) {
      Navigator.pop(context);
    } else {
      sleepTrackerController.pageController.animateToPage(
          sleepTrackerController.pageIndex - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    }
  }

  showBottomSheet(
      BuildContext context, SleepTrackerController sleepTrackerController) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        builder: (context) => const SleepCheckInComplete()).then(
      (value) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SleepTrackerSummary(),
          ),
        );
      },
    );
  }
}
