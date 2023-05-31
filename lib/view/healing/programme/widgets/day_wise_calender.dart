import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DaywiseCalender extends StatelessWidget {
  const DaywiseCalender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgrammeController>(builder: (calenderController) {
      return DatePicker(
        calenderController.startDate.value,
        controller: calenderController.datePickerController,
        height: 77.h,
        width: 50.w,
        initialSelectedDate: calenderController.selectedDate.value,
        selectionColor: AppColors.primaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.secondaryLabelColor,
          fontWeight: FontWeight.w700,
        ),
        monthTextStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.secondaryLabelColor,
          fontWeight: FontWeight.w400,
        ),
        dayTextStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.secondaryLabelColor,
          fontWeight: FontWeight.w400,
        ),
        onDateChange: (selectedDate) {
          calenderController.setOnThatDayContent(selectedDate);
          calenderController.datePickerController.animateToDate(selectedDate);
        },
      );
    });
  }
}
