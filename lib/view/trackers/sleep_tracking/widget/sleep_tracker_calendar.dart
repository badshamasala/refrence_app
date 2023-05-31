import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_calendar_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/trackers/sleep_tracking/view_sleep_checkin_for_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui_helper/ui_helper.dart';

class SleepTrackerCalendar extends StatelessWidget {
  const SleepTrackerCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SleepTrackerCalenderController sleepTrackerCalenderController =
        Get.put(SleepTrackerCalenderController());
    sleepTrackerCalenderController.getDateWiseCheckIns();
    EventList<Event> markedDateMap = EventList<Event>(
      events: {
        DateTime(
            sleepTrackerCalenderController.todaysDate.year,
            sleepTrackerCalenderController.todaysDate.month,
            sleepTrackerCalenderController.todaysDate.day): [
          Event(
            date: DateTime(
                sleepTrackerCalenderController.todaysDate.year,
                sleepTrackerCalenderController.todaysDate.month,
                sleepTrackerCalenderController.todaysDate.day),
            icon: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: const [],
                ),
                Positioned(
                  bottom: -14.h,
                  child: const CircleAvatar(
                    radius: 3.5,
                    backgroundColor: Color(0xFFDB5A52),
                  ),
                )
              ],
            ),
          ),
        ]
      },
    );

    return Container(
      height: 440.h,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: AppColors.sleepTrackerBackgroundLight),
      child: GetBuilder<SleepTrackerCalenderController>(builder: (controller) {
        if (controller.dateWiseCheckInLoading.value == true) {
          return showLoading();
        }
        return CalendarCarousel<Event>(
          customGridViewPhysics: const NeverScrollableScrollPhysics(),
          headerText: DateFormat('MMM, yyyy').format(controller.selectedMonth),
          headerTextStyle:
              AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
          weekDayFormat: WeekdayFormat.narrow,
          weekdayTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 15.sp,
          ),
          weekDayMargin: EdgeInsets.only(bottom: 8.h),
          maxSelectedDate: controller.maxSelectedDate,
          onCalendarChanged: (DateTime changedTime) {
            controller.setSelectedMonth(changedTime);
          },
          onDayPressed: (DateTime changedTime, events) {
            if (controller.checkInDates.any((element) =>
                element.year == changedTime.year &&
                element.day == changedTime.day &&
                element.month == changedTime.month)) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ViewSleepCheckInForDay(selectedDate: changedTime),
                ),
              );
            }
          },
          markedDatesMap: markedDateMap,
          markedDateShowIcon: true,
          inactiveWeekendTextStyle: TextStyle(
            color: const Color(0xFFECECEC).withOpacity(0.3),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          inactiveDaysTextStyle: TextStyle(
            color: const Color(0xFFECECEC).withOpacity(0.3),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          weekendTextStyle: TextStyle(
            color: const Color(0xFF7C8D9A),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          selectedDayTextStyle: const TextStyle(
            color: AppColors.blackLabelColor,
          ),
          daysTextStyle: TextStyle(
            color: const Color(0xFF7C8D9A),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          showIconBehindDayText: true,
          dayButtonColor: const Color(0xFF2F277B),
          daysHaveCircularBorder: true,
          iconColor: AppColors.sleepTrackerButtonBlueColor,
          todayBorderColor: Colors.transparent,
          todayTextStyle: TextStyle(
            color: const Color(0xFF413194),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          todayButtonColor: const Color(0xFF76C8E2),
          markedDateIconBuilder: (event) {
            return event.icon;
          },
          multipleMarkedDates: MultipleMarkedDates(
            markedDates: controller.checkInDates
                .map(
                  (e) => MarkedDate(
                    color: const Color(0xFF76C8E2),
                    date: DateTime(e.year, e.month, e.day),
                    textStyle: TextStyle(
                      color: const Color(0xFF413194),
                      fontSize: 15.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                )
                .toList(),
          ),

          markedDateMoreShowTotal:
              null, // null for not showing hidden events indicator
          // markedDateIconMargin: 2,
          markedDateIconMaxShown: 1,
          // markedDateIconOffset: 2,
          dayPadding: 6.5,
          showOnlyCurrentMonthDate: true,
        );
      }),
    );
  }
}