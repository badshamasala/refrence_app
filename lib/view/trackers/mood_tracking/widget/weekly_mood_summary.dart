import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_weekly_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/trackers/mood_tracking/view_mood_for_day.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/weekly_mood_checkin_details.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../model/model.dart';

class WeeklyMoodSummary extends StatelessWidget {
  const WeeklyMoodSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late MoodTrackerWeeklySummaryController moodTrackerWeeklySummaryController;
    if (MoodTrackerWeeklySummaryController().initialized == false) {
      moodTrackerWeeklySummaryController =
          Get.put(MoodTrackerWeeklySummaryController());
    } else {
      moodTrackerWeeklySummaryController = Get.find();
    }
    Future.delayed(Duration.zero, (){
      moodTrackerWeeklySummaryController.getWeeklySummary();
    });
    return Obx(
      () {
        if (moodTrackerWeeklySummaryController.isLoading.value == true) {
          return Container(
            alignment: Alignment.center,
            height: 1000.h,
            width: double.infinity,
            child: showLoading(),
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 71.h,
              ),
              WeeklyInsight(
                  moodTrackerWeeklySummaryController:
                      moodTrackerWeeklySummaryController),
              if (moodTrackerWeeklySummaryController
                      .weeklyMoodCheckInModel.value?.dayWiseCheckIns !=
                  null)
                SizedBox(
                  height: 54.h,
                ),
              if (moodTrackerWeeklySummaryController
                      .weeklyMoodCheckInModel.value?.insight !=
                  null)
                WeeklyMoodCheckInDetails(
                    insightData: moodTrackerWeeklySummaryController
                        .weeklyMoodCheckInModel.value!.insight!),
            ],
          ),
        );
      },
    );
  }
}

class WeeklyInsight extends StatelessWidget {
  final MoodTrackerWeeklySummaryController moodTrackerWeeklySummaryController;
  const WeeklyInsight(
      {Key? key, required this.moodTrackerWeeklySummaryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Your Weekly Insights',
          style: AppTheme.secondarySmallFontTitleTextStyle,
        ),
        SizedBox(
          height: 17.h,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                moodTrackerWeeklySummaryController.setPreviousWeekSummary();
              },
              icon: const Icon(
                Icons.chevron_left,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
            Obx(() {
              return Text(
                moodTrackerWeeklySummaryController.range.value,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
              );
            }),
            IconButton(
              onPressed: () {
                moodTrackerWeeklySummaryController.setNextWeekSummary();
              },
              icon: const Icon(
                Icons.chevron_right,
                color: AppColors.primaryColor,
                size: 30,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 19.h,
        ),
        SizedBox(
          width: 320.w,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                moodTrackerWeeklySummaryController.dayWiseCheckIns!.length,
                (index) {
                  if (moodTrackerWeeklySummaryController
                          .dayWiseCheckIns?[index] ==
                      null) {
                    return const Offstage();
                  }
                  return Expanded(
                    child: MoodWiseSummary(
                        summaryData: moodTrackerWeeklySummaryController
                            .dayWiseCheckIns![index]!),
                  );
                },
              ),
            );
          }),
        )
      ],
    );
  }
}

class MoodWiseSummary extends StatelessWidget {
  final WeeklyMoodCheckInModelDayWiseCheckIns summaryData;
  const MoodWiseSummary({Key? key, required this.summaryData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('EEE').format(summaryData.checkInDate!).toUpperCase(),
          style: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontSize: 12.sp,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w400,
            fontFamily: "Circular Std",
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          summaryData.checkInDate!.day.toString(),
          style: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            fontFamily: "Circular Std",
          ),
        ),
        SizedBox(
          height: 11.h,
        ),
        if (summaryData.moods != null && summaryData.moods!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: summaryData.moods!.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: summaryData.moods![index]!.checkIns! > 0
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewMoodForDay(
                              selectedDate: summaryData.checkInDate!,
                              moodType: summaryData.moods![index]!.mood ?? "",
                            ),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  margin: EdgeInsets.only(bottom: 28.h),
                  child: Stack(
                    alignment: Alignment.topRight,
                    clipBehavior: Clip.none,
                    children: [
                      summaryData.moods![index]!.checkIns! > 0
                          ? Image.asset(
                              summaryData.moods?[index]?.icon ?? "",
                              color: const Color(0xFFFFE488),
                              width: 34.61.w,
                              fit: BoxFit.fitWidth,
                            )
                          : Image.asset(
                              'assets/images/mood-tracker/blank-mood.png',
                              width: 34.61.w,
                              fit: BoxFit.fitWidth,
                            ),
                      Visibility(
                        visible: summaryData.moods![index]!.checkIns! > 1,
                        child: Positioned(
                          top: -8.h,
                          right: -5.w,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            height: 16.h,
                            width: 16.h,
                            child: Text(
                              '${summaryData.moods![index]!.checkIns ?? 0}',
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontSize: 12.sp,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Circular Std",
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
      ],
    );
  }
}
