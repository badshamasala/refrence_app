import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_calender_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/trackers/mood_tracking/view_mood_for_day.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoodTrackerCalendar extends StatelessWidget {
  const MoodTrackerCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoodTrackerCalenderController moodTrackerCalenderController =
        Get.put(MoodTrackerCalenderController());
    moodTrackerCalenderController.getDateWiseCheckIns();

    EventList<Event> markedDateMap = EventList<Event>(
      events: {
        DateTime(
            moodTrackerCalenderController.todaysDate.year,
            moodTrackerCalenderController.todaysDate.month,
            moodTrackerCalenderController.todaysDate.day): [
          Event(
            date: DateTime(
                moodTrackerCalenderController.todaysDate.year,
                moodTrackerCalenderController.todaysDate.month,
                moodTrackerCalenderController.todaysDate.day),
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
        color: Colors.white,
      ),
      child: GetBuilder<MoodTrackerCalenderController>(builder: (controller) {
        if (controller.dateWiseCheckInLoading.value == true) {
          return showLoading();
        }
        return CalendarCarousel<Event>(
          customGridViewPhysics: const NeverScrollableScrollPhysics(),
          headerText:
              DateFormat.yMMMM().format(controller.selectedMonth).toUpperCase(),
          headerTextStyle: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontFamily: 'Circular Std',
            fontSize: 14.sp,
            letterSpacing: 1.5.w,
            fontWeight: FontWeight.normal,
            height: 1.16.h,
          ),
          weekDayFormat: WeekdayFormat.narrow,
          weekdayTextStyle: TextStyle(
            color: AppColors.blackLabelColor,
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
                      ViewMoodForDay(selectedDate: changedTime),
                ),
              );
            }
          },
          markedDatesMap: markedDateMap,
          markedDateShowIcon: true,
          inactiveWeekendTextStyle: TextStyle(
            color: const Color(0xFFD2D9DA),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          inactiveDaysTextStyle: TextStyle(
            color: const Color(0xFFD2D9DA),
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          weekendTextStyle: TextStyle(
            color: AppColors.blackLabelColor,
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          selectedDayTextStyle: const TextStyle(
            color: AppColors.blackLabelColor,
          ),
          showIconBehindDayText: true,
          dayButtonColor: const Color(0xFFF0F3F7),
          daysHaveCircularBorder: true,
          iconColor: AppColors.primaryColor,
          todayBorderColor: Colors.transparent,
          todayTextStyle: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
          ),
          todayButtonColor: const Color(0xFFFFDD66),
          markedDateIconBuilder: (event) {
            return event.icon;
          },
          multipleMarkedDates: MultipleMarkedDates(
            markedDates: controller.checkInDates
                .map(
                  (e) => MarkedDate(
                    color: const Color(0xFFFFDD66),
                    date: DateTime(e.year, e.month, e.day),
                    textStyle: TextStyle(
                      color: AppColors.secondaryLabelColor,
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
