import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ChangeSleepReminderTime extends StatelessWidget {
  const ChangeSleepReminderTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.sleepTrackerBackgroundLight,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<SleepTrackerSummaryController>(
                  id: 'reminder',
                  builder: (controller) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 92.h,
                        ),
                        const Text(
                          'Track Your Sleep\nDaily At',
                          textAlign: TextAlign.center,
                          style: AppTheme
                              .secondarySmallFontTitleTextStyleSleeptracker,
                        ),
                        SizedBox(
                            height: 200.h,
                            child: NewCupertinoDatePicker(
                              textColor: Colors.white,
                              initialDateTime: controller.reminderTime,
                              mode: NewCupertinoDatePickerMode.time,
                              minuteInterval: 1,
                              overlayColor: const Color.fromARGB(51, 8, 2, 44)
                                  .withOpacity(0.2),
                              onDateTimeChanged: (dateTime) {
                                controller.setSleepReminderTime(dateTime);
                              },
                            )),
                        SizedBox(
                          height: 20.h,
                        ),
                        controller.isReminderLoading.value == true
                            ? const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : InkWell(
                                child: Container(
                                  height: 54.h,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 17.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color:
                                        AppColors.sleepTrackerButtonBlueColor,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color.fromRGBO(
                                              0, 0, 0, 0.07000000029802322),
                                          offset: Offset(-5, 10),
                                          blurRadius: 20),
                                    ],
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Save',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            AppColors.sleepTrackerOptionsColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                        height: 1.h,
                                        fontFamily: "Circular Std",
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  await controller.updateReminderTime();
                                  Navigator.of(context).pop();
                                },
                              ),
                        SizedBox(
                          height: 32.h,
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
            top: -39.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.sleepClockImage,
                  height: 77.h,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 11.h,
                ),
                Image.asset(
                  Images.ellipseImage,
                  height: 9.h,
                  color: const Color(0xFF24196A),
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ]);
  }
}
