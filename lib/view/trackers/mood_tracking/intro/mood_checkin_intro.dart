// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_summary_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/trackers/mood_tracking/intro/mood_checkin_intro_1.dart';
import 'package:aayu/view/trackers/mood_tracking/mood_tracker_page_view.dart';
import 'package:aayu/view/trackers/mood_tracking/mood_tracker_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MoodCheckInIntro extends StatelessWidget {
  final String pageSource;
  const MoodCheckInIntro({Key? key, this.pageSource = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () async {
      late MoodTrackerSummaryController moodTrackerSummaryController;
      if (MoodTrackerSummaryController().initialized) {
        moodTrackerSummaryController = Get.find();
      } else {
        moodTrackerSummaryController = Get.put(MoodTrackerSummaryController());
      }
      await moodTrackerSummaryController.getTodaysMoodSummary();
      HiveService().isFirstTimeMoodCkeckIn().then((value) {
        if (value == true) {
          Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MoodCheckInIntro1(pageSource: pageSource),
            ),
          );
        } else if (moodTrackerSummaryController.todaysMoodSummary.value ==
            null) {
          Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MoodTrackerPageView(pageSource: pageSource),
            ),
          );
        } else {
          if (pageSource == "MENTAL_WEELBEING") {
            Navigator.of(Get.context!).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    MoodTrackerPageView(pageSource: pageSource),
              ),
            );
          } else {
            Navigator.of(Get.context!).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MoodTrackerSummary(
                  pageSource: pageSource,
                  allowCheckIn: true,
                ),
              ),
            );
          }
        }
      });
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/mood-tracker/mood-tracker.svg",
              width: 171.09.w,
              height: 170.h,
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              'Mood Tracker',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFDCE2E9),
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
