import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_summary_controller.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/mood_checkin_details.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TodaysMoodCheckInDetails extends StatelessWidget {
  const TodaysMoodCheckInDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late MoodTrackerSummaryController moodTrackerSummaryController;
    if (MoodTrackerSummaryController().initialized) {
      moodTrackerSummaryController = Get.find();
    } else {
      moodTrackerSummaryController = Get.put(MoodTrackerSummaryController());
    }
    Future.delayed(Duration.zero, () async {
      moodTrackerSummaryController.getTodaysMoodSummary();
    });
    return Obx(
      () {
        if (moodTrackerSummaryController.todaysSummaryLoading.value == true) {
          return showLoading();
        } else if (moodTrackerSummaryController.todaysMoodSummary.value ==
            null) {
          return const Offstage();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 58.h,
            ),
            MoodCheckInDetails(
              checkInDetails:
                  moodTrackerSummaryController.todaysMoodSummary.value!,
            ),
          ],
        );
      },
    );
  }
}
