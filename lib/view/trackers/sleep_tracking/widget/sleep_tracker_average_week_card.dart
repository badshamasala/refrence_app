import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_weekly_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/pillow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SleeptrackerAverageWeekCard extends StatelessWidget {
  const SleeptrackerAverageWeekCard({Key? key}) : super(key: key);
  final textColor = const Color(0xFFA79AC9);
  Widget buildChip(String text) {
    return Container(
      height: 38.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color(0xFF5550B6),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
      constraints: BoxConstraints(minWidth: 80.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          fontFamily: "Circular Std",
        ),
      ),
    );
  }

  Widget buildBoxes(String image, String title, List<String?> list) {
    return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.sleepTrackerSummaryBoxesbackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 49.h,
                ),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Circular Std',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: textColor),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 8.w,
                  spacing: 8.h,
                  children: List.generate(
                      list.length, (index) => buildChip(list[index]!)),
                ),
                SizedBox(
                  height: 30.h,
                )
              ],
            ),
          ),
          Positioned(
            top: -26.h,
            child: Image.asset(
              image,
              width: 82.w,
              fit: BoxFit.fitWidth,
            ),
          )
        ]);
  }

  Widget buildTile(String image, String title, String time) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.sleepTrackerSummaryBoxesbackground,
        ),
        padding: pageVerticalPadding(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 24.h,
              fit: BoxFit.fitHeight,
              color: const Color(0xFF706CA7),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Circular Std',
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              time,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Circular Std',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepTrackerWeeklySummaryController>(
        builder: (controller) {
      if (controller.isLoading.value == true) {
        return showLoading();
      }
      if (controller.weeklySleepCheckInModel.value?.insight == null) {
        return const Offstage();
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 165.h,
              decoration: BoxDecoration(
                color: AppColors.sleepTrackerSummaryBoxesbackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(180.h),
                  topRight: Radius.circular(180.h),
                  bottomLeft: Radius.circular(16.h),
                  bottomRight: Radius.circular(16.h),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 38.h,
                  ),
                  Text(
                    'SLEEP QUALITY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Circular Std',
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  PillowImage(
                      icon: controller.weeklySleepCheckInModel.value?.insight
                              ?.sleepQuality?.icon ??
                          "",
                      active: true,
                      fit: BoxFit.fitHeight,
                      height: 48.h),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    controller.weeklySleepCheckInModel.value?.insight
                            ?.sleepQuality?.sleep ??
                        "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Circular Std',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildTile(
                    Images.sleeptrackerMoon,
                    'AVERAGE\nBEDTIME',
                    DateFormat('hh:mm a')
                        .format(DateTime.fromMillisecondsSinceEpoch(controller
                                .weeklySleepCheckInModel
                                .value
                                ?.insight
                                ?.average
                                ?.bedTime ??
                            0))
                        .toUpperCase()),
                SizedBox(
                  width: 4.w,
                ),
                buildTile(
                    Images.sleeptrackerSun,
                    'AVERAGE\nWAKE-UP',
                    DateFormat('hh:mm a')
                        .format(DateTime.fromMillisecondsSinceEpoch(controller
                                .weeklySleepCheckInModel
                                .value
                                ?.insight
                                ?.average
                                ?.wakeupTime ??
                            0))
                        .toUpperCase()),
                SizedBox(
                  width: 4.w,
                ),
                buildTile(
                  Images.sleeptrackerSparkles,
                  'AVERAGE\nSLEEP HOURS',
                  '${(controller.weeklySleepCheckInModel.value?.insight?.average?.sleepHours ?? 0).toStringAsFixed(2).replaceFirst(".", ":")} Hrs',
                ),
              ],
            ),
            SizedBox(
              height: 71.h,
            ),
            /* buildBoxes(
                Images.sleepEyeThumbsUp,
                'What helped you sleep',
                controller.weeklySleepCheckInModel.value!.insight!.becauseOf!
                    .map((e) => e?.identification ?? "")
                    .toList()),
            SizedBox(
              height: 56.h,
            ),
            buildBoxes(
                Images.sleepEyeThumbsDown,
                'What kept you up at night',
                controller.weeklySleepCheckInModel.value!.insight!.becauseOf!
                    .map((e) => e?.identification ?? "")
                    .toList()), */
          ],
        ),
      );
    });
  }

  String formatTime(int time) {
    if (time == 0 || time == 288) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    return '$hours:${minutes < 10 ? '0$minutes' : minutes} ${hours <= 12 ? 'AM' : 'PM'}';
  }

  String formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 288 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return '$hours:${minutes < 10 ? '0$minutes' : minutes}h';
  }
}
