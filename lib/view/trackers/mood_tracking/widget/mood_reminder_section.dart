import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_summary_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../bottom_sheet/change_mood_reminder_time.dart';

class MoodReminderSection extends StatelessWidget {
  const MoodReminderSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodTrackerSummaryController>(
        id: 'reminder',
        builder: (switchDailyReminderController) {
          return InkWell(
            onTap: switchDailyReminderController.isReminderActive.value == true
                ? () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32))),
                      builder: (context) => const ChangeMoodReminderTime(),
                    );
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 25.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF7F7F7),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  child: switchDailyReminderController.reminderTime == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Set a reminder to track your mood consistently.',
                              style: TextStyle(
                                color: const Color(0xFF5B7081),
                                fontSize: 14.sp,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Circular Std",
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "We'll remind you to check in at",
                                style: TextStyle(
                                  color: const Color(0xFF5B7081),
                                  fontSize: 14.sp,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Circular Std",
                                ),
                              ),
                            ),
                            Text(
                              DateFormat('hh:mm a').format(
                                  switchDailyReminderController.reminderTime!),
                              style: TextStyle(
                                  color: const Color(0xFF5B6381),
                                  fontSize: 16.sp,
                                  fontFamily: 'Circular Std',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                CupertinoSwitch(
                  activeColor: AppColors.primaryColor,
                  value: switchDailyReminderController.isReminderActive.value &&
                      switchDailyReminderController.reminderTime != null,
                  onChanged: (boolean) {
                    if (switchDailyReminderController.reminderTime == null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        builder: (context) => const ChangeMoodReminderTime(),
                      ).then((value) {
                        switchDailyReminderController.switchReminderActive();
                        switchDailyReminderController.updateReminderTime();
                      });
                    } else {
                      switchDailyReminderController.switchReminderActive();
                      switchDailyReminderController.updateReminderTime();
                    }
                  },
                ),
              ]),
            ),
          );
        });
  }
}
