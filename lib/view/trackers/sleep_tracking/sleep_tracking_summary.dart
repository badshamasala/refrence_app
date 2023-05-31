import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/recommended_sleep_content.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/sleep_card.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/sleep_reminder_section.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/sleep_tracker_average_week_card.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/sleep_tracker_calendar.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/sleep_tracker_weekly_insight_table.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepTrackerSummary extends StatelessWidget {
  const SleepTrackerSummary({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sleepTrackerBackgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            titleSpacing: 0,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                height: 120.h,
              ),
              centerTitle: true,
              title: Text(
                date(DateTime.now()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Baskerville',
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            expandedHeight: 120.h,
            backgroundColor: AppColors.sleepTrackerBackgroundLight,
            leading: IconButton(
              onPressed: () {
                showCalender(context);
              },
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.white,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SleepReminderSection(),
                SizedBox(
                  height: 54.h,
                ),
                GetBuilder<SleepTrackerSummaryController>(
                    id: 'recentSleep',
                    builder: (controller) {
                      if (controller.todaysSummaryLoading.value == true) {
                        return showLoading();
                      } else if (controller.recentSleepCheckInModel.value ==
                          null) {
                        return const Offstage();
                      }
                      return SleepCard(
                          icon: controller
                                  .recentSleepCheckInModel.value?.sleep?.icon ??
                              "",
                          duration:
                              controller.recentSleepCheckInModel.value?.sleepHours ??
                                  0,
                          howWasSleep: controller.recentSleepCheckInModel.value
                                  ?.sleep?.sleep ??
                              "",
                          inTime: DateFormat('hh:mm a')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  controller.recentSleepCheckInModel.value?.bedTime ??
                                      0))
                              .toUpperCase(),
                          outTime: DateFormat('hh:mm a')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  controller.recentSleepCheckInModel.value?.wakeupTime ?? 0))
                              .toUpperCase(),
                          listReasons: controller.recentSleepCheckInModel.value!.identifications!.map((e) => e?.identification ?? "").toList());
                    }),
                const RecommendedSleepContent(),
                const SleepTrackerWeeklyInsightTable(),
                const SleeptrackerAverageWeekCard(),
                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String date(DateTime dateTime) {
    return 'Today, ${DateFormat.d().format(dateTime)} ${DateFormat.MMM().format(dateTime)}, ${DateFormat.y().format(dateTime)}';
  }

  showCalender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => const SleepTrackerCalendar(),
    );
  }
}
