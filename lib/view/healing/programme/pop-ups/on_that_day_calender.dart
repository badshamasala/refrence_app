import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OnThatDayCalender extends StatelessWidget {
  const OnThatDayCalender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding(),
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              GetBuilder<ProgrammeController>(builder: (programmeController) {
                return CalendarCarousel<Event>(
                  height: MediaQuery.of(context).size.height * 0.45,
                  childAspectRatio: 1.25,
                  customGridViewPhysics: const NeverScrollableScrollPhysics(),
                  onCalendarChanged: (DateTime changedTime) {
                    programmeController.setSelectedMonth(changedTime);
                  },
                  onDayPressed: (date, events) {
                    programmeController.setOnThatDayContent(date);
                  },
                  thisMonthDayBorderColor: Colors.grey,
                  headerText: DateFormat.yMMMM()
                      .format(programmeController.selectedMonth),
                  headerTextStyle: TextStyle(
                    color: const Color(0xFF333333),
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    letterSpacing: 1.5.w,
                    fontWeight: FontWeight.normal,
                    height: 1.16.h,
                  ),
                  weekFormat: false,
                  weekDayFormat: WeekdayFormat.narrow,
                  weekDayMargin: const EdgeInsets.only(bottom: 4),
                  weekendTextStyle: const TextStyle(
                    color: AppColors.blackLabelColor,
                  ),
                  showWeekDays: true,

                  selectedDateTime: programmeController.selectedDate.value,
                  minSelectedDate: programmeController.startDate.value,
                  maxSelectedDate: programmeController.endDate.value,

                  selectedDayTextStyle: const TextStyle(
                    color: AppColors.blackLabelColor,
                  ),
                  selectedDayBorderColor: const Color(0xFFEBEBEB),
                  selectedDayButtonColor: const Color(0xFFEBEBEB),
                  
                  showIconBehindDayText: true,
                  daysHaveCircularBorder: null,
                  iconColor: AppColors.primaryColor,
                  todayTextStyle: const TextStyle(
                    color: AppColors.blackLabelColor,
                  ),
                  todayButtonColor: const Color(0xFFEBEBEB),
                  todayBorderColor: const Color(0xFFEBEBEB),
                  markedDateIconMaxShown: 1,
                  markedDateShowIcon: true,
                  markedDateIconBuilder: (event) {
                    return event.icon ?? const Icon(Icons.help_outline);
                  },
                  markedDatesMap: programmeController.markedDateMap,
                  markedDateMoreShowTotal:
                      null, // null for not showing hidden events indicator
                  markedDateIconMargin: 2,
                  markedDateIconOffset: 2,
                  dayPadding: 0,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
