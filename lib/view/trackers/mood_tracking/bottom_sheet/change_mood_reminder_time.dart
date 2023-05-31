import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ChangeMoodReminderTime extends StatefulWidget {
  const ChangeMoodReminderTime({Key? key}) : super(key: key);

  @override
  State<ChangeMoodReminderTime> createState() => _ChangeMoodReminderTimeState();
}

class _ChangeMoodReminderTimeState extends State<ChangeMoodReminderTime> {
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
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<MoodTrackerSummaryController>(
                  id: 'reminder',
                  builder: (controller) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 67.h,
                        ),
                        Text(
                          'Track your mood\nregularly at',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Baskerville',
                              color: AppColors.blackLabelColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 200.h,
                          child: NewCupertinoDatePicker(
                            textColor: AppColors.blackLabelColor,
                            initialDateTime: controller.reminderTime!,
                            mode: NewCupertinoDatePickerMode.time,
                            minuteInterval: 1,
                            overlayColor:
                                AppColors.primaryColor.withOpacity(0.2),
                            onDateTimeChanged: (dateTime) {
                              controller.setMoodReminderTime(dateTime);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        controller.isReminderLoading.value == true
                            ? const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : InkWell(
                                child: mainButton('Save'),
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
            top: -46.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.moodClockImage,
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
