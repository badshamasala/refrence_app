import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/trackers/sleep_tracking/bottom_sheet/change_sleep_reminder_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SleepReminderSection extends StatelessWidget {
  const SleepReminderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepTrackerSummaryController>(
      id: 'reminder',
      builder: (controller) => InkWell(
        onTap: controller.isReminderActive.value == true
            ? () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  builder: (context) => const ChangeSleepReminderTime(),
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
            color: AppColors.sleepTrackerSummaryBoxesbackground,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: controller.reminderTime == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Set a reminder to track your mood consistently.',
                            style: TextStyle(
                              color: const Color(0xFFBDB6FA),
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
                                color: const Color(0xFFBDB6FA),
                                fontSize: 14.sp,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Circular Std",
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('hh:mm a')
                                .format(controller.reminderTime!),
                            style: TextStyle(
                                color: Colors.white,
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
                activeColor: AppColors.sleepTrackerButtonBlueColor,
                value: controller.isReminderActive.value &&
                    controller.reminderTime != null,
                onChanged: (boolean) {
                  if (controller.reminderTime == null) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      builder: (context) => const ChangeSleepReminderTime(),
                    ).then((value) {
                      controller.switchReminderActive();
                      controller.updateReminderTime();
                    });
                  } else {
                    controller.switchReminderActive();
                    controller.updateReminderTime();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
