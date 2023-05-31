import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaterReminderTime extends StatelessWidget {
  final String timeType;
  const WaterReminderTime({Key? key, required this.timeType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WaterIntakesController waterIntakesController = Get.find();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                toTitleCase(
                  timeType.toLowerCase(),
                ),
                style: TextStyle(
                  fontFamily: "Baskerville",
                  color: AppColors.blackLabelColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200.h,
          width: 322.w,
          child: NewCupertinoDatePicker(
            mode: NewCupertinoDatePickerMode.time,
            overlayColor: AppColors.primaryColor.withOpacity(0.2),
            textColor: AppColors.blackLabelColor,
            initialDateTime: (timeType == "FROM TIME")
                ? waterIntakesController.fromTime.value
                : waterIntakesController.toTime.value,
            onDateTimeChanged: (DateTime changedTime) {
              DateTime nowDate = DateTime.now();
              DateTime selectedTime = DateTime(nowDate.year, nowDate.month,
                  nowDate.day, changedTime.hour, changedTime.minute, 0);
              if (timeType == "FROM TIME") {
                waterIntakesController.fromTime.value = selectedTime;
              } else {
                waterIntakesController.toTime.value = selectedTime;
              }
            },
          ),
        ),
        Padding(
          padding: pagePadding(),
          child: InkWell(
            onTap: () {
              waterIntakesController.update(["WaterReminderValues"]);
              Navigator.of(context).pop();
            },
            child: mainButton("Done"),
          ),
        )
      ],
    );
  }
}
