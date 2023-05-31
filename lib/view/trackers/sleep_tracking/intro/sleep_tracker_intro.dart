// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/trackers/sleep_tracking/intro/sleep_tracker_intro_page1.dart';
import 'package:aayu/view/trackers/sleep_tracking/sleep_tracking_page_view.dart';
import 'package:aayu/view/trackers/sleep_tracking/sleep_tracking_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SleepTrackerIntro extends StatelessWidget {
  const SleepTrackerIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () async {
      late SleepTrackerSummaryController sleepTrackerSummaryController;
      if (SleepTrackerSummaryController().initialized) {
        sleepTrackerSummaryController = Get.find();
      } else {
        sleepTrackerSummaryController =
            Get.put(SleepTrackerSummaryController());
      }
      await sleepTrackerSummaryController.getRecentSleepCheckIn();
      HiveService().isFirstTimeSleepCkeckIn().then((value) {
        if (value == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SleepTrackerIntroPage1(),
            ),
          );
        } else if (sleepTrackerSummaryController
                .recentSleepCheckInModel.value !=
            null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SleepTrackerSummary(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SleepTrackerPageView(),
            ),
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.sleepTrackerBackgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/sleep-tracker/sleep-tracker.svg",
              width: 142.67.w,
              height: 131.19.h,
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              'Sleep Tracker',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF2A236D),
                fontFamily: 'Baskerville',
                fontSize: 30.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.06.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
