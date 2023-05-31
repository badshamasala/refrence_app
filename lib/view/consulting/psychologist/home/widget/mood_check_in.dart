import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/mood_tracking/intro/mood_checkin_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoodCheckInWidget extends StatelessWidget {
  const MoodCheckInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (MoodTrackerController().initialized == false) {
          Get.put(MoodTrackerController());
        }
        Navigator.of(Get.context!).push(
          MaterialPageRoute(
            builder: (context) => const MoodCheckInIntro(
              pageSource: "MENTAL_WEELBEING",
            ),
          ),
        );
      },
      child: Container(
        margin: pagePadding(),
        width: 322.w,
        height: 110.h,
        padding: pagePadding(),
        decoration: BoxDecoration(
          color: const Color(0xffFBF7E7),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              Images.todaysMoodVive,
              width: 68.w,
              height: 86.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mood check",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Today's vibe?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
