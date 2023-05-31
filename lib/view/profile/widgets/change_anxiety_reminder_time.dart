import 'package:aayu/controller/program/program_reminder_controller.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';

class ChangeAnxietyReminderTime extends StatefulWidget {
  const ChangeAnxietyReminderTime({Key? key}) : super(key: key);

  @override
  State<ChangeAnxietyReminderTime> createState() =>
      _ChangeAnxietyReminderTimeState();
}

class _ChangeAnxietyReminderTimeState extends State<ChangeAnxietyReminderTime> {
  @override
  Widget build(BuildContext context) {
    Get.put(ProgramReminderController());
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 104.h,
                ),
                Text(
                  "SET_A_TIME_FOR_YOUR_DAILY_PRACTICE".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Baskerville',
                      color: AppColors.blackLabelColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 7.h,
                ),
                SizedBox(
                  width: 266.w,
                  child: Text(
                    "NOTIFY_YOU_15_MINUTES".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.5.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 200.h,
                  width: 322.w,
                  child: GetBuilder<ProgramReminderController>(
                    builder: (controller) {
                      return NewCupertinoDatePicker(
                        textColor: AppColors.blackLabelColor,
                        overlayColor: AppColors.primaryColor.withOpacity(0.2),
                        mode: NewCupertinoDatePickerMode.time,
                        initialDateTime: controller.reminderTime,
                        onDateTimeChanged: (DateTime changedTime) {
                          controller.setReminderTime(changedTime);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 27.h,
                ),
                GetBuilder<ProgramReminderController>(
                  builder: (controller) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        controller.weekDays!.length,
                        (index) => Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              controller.selectWeekDays(index);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  boxShadow: controller
                                              .weekDays![index]!.selected ==
                                          true
                                      ? [
                                          const BoxShadow(
                                            offset: Offset(-4, 2),
                                            blurRadius: 5,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.04),
                                          )
                                        ]
                                      : null,
                                  color:
                                      controller.weekDays![index]!.selected ==
                                              true
                                          ? const Color(0xFFFFEEEE)
                                          : const Color(0xFFF4F4F4),
                                  shape: BoxShape.circle),
                              child: Text(
                                controller.weekDays![index]!.day.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      controller.weekDays![index]!.selected ==
                                              true
                                          ? AppColors.blackLabelColor
                                          : const Color(0xFF768897),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 39.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: mainButton('SAVE'.tr),
                ),
                SizedBox(
                  height: 32.h,
                ),
              ],
            ),
          ),
          Positioned(
            top: -46.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.yogaClockImage,
                  height: 77.h,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 11.h,
                ),
                Image.asset(
                  Images.ellipseImage,
                  height: 9.h,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ]);
  }
}
