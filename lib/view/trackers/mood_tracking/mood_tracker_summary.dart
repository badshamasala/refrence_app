import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/trackers/mood_tracking/mood_tracker_page_view.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/mood_reminder_section.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/mood_tracker_calendar.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/recommended_mood_content.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/todays_mood_checkin_details.dart';
import 'package:aayu/view/trackers/mood_tracking/widget/weekly_mood_summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoodTrackerSummary extends StatelessWidget {
  final String pageSource;
  final bool allowCheckIn;
  const MoodTrackerSummary({
    Key? key,
    this.pageSource = "",
    required this.allowCheckIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: allowCheckIn
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MoodTrackerPageView(),
                  ),
                );
              },
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.h,
              ),
            )
          : null,
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
                  color: AppColors.blackLabelColor,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(height: 120.h),
              centerTitle: true,
              title: Text(
                date(DateTime.now()),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Baskerville',
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            expandedHeight: 120.h,
            backgroundColor: AppColors.pageBackgroundColor,
            leading: IconButton(
              onPressed: () {
                showCalender(context);
              },
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                const MoodReminderSection(),
                SizedBox(
                  height: 16.h,
                ),
                const TodaysMoodCheckInDetails(),
                SizedBox(
                  height: 26.h,
                ),
                const RecommendedMoodContent(),
                SizedBox(
                  height: 26.h,
                ),
                const WeeklyMoodSummary()
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
      builder: (context) => const MoodTrackerCalendar(),
    );
  }
}
