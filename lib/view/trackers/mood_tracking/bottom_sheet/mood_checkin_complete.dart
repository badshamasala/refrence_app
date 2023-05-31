import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoodCheckinComplete extends StatelessWidget {
  const MoodCheckinComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoodTrackerController moodTrackerController = Get.find();
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
              SizedBox(
                height: 51.h,
              ),
              const Text(
                'Check-in Complete',
                style: AppTheme.secondarySmallFontTitleTextStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'We appreciate you looking\nout for yoursellf.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: const Color(0xFF5B7081)),
              ),
              SizedBox(
                height: 35.h,
              ),
              GetBuilder<MoodTrackerSummaryController>(builder: (controller) {
                if (controller.reminderTime == null) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Image.asset(
                        Images.moodClockImage,
                        height: 77.h,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 11.47.h,
                      ),
                      Image.asset(
                        Images.ellipseImage,
                        height: 9.h,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Text(
                        'Track your mood\nregularly at',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Baskerville',
                          color: AppColors.blackLabelColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 200.h,
                        child: NewCupertinoDatePicker(
                          textColor: AppColors.blackLabelColor,
                          initialDateTime: DateTime.now(),
                          mode: NewCupertinoDatePickerMode.time,
                          minuteInterval: 1,
                          overlayColor: AppColors.primaryColor.withOpacity(0.2),
                          onDateTimeChanged: (dateTime) {
                            controller.setMoodReminderTime(dateTime);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        child: mainButton('Submit'),
                        onTap: () async {
                          buildShowDialog(context);
                          await controller.updateReminderTime();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Skip",
                          style: skipButtonTextStyle(),
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                    ],
                  );
                }
                return const Offstage();
              })
            ],
          ),
        ),
        Positioned(
          top: -28.h,
          child: Container(
            width: 69.22.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(-4, 4),
                  blurRadius: 8,
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
                bottomLeft: Radius.circular(31),
                bottomRight: Radius.circular(31),
              ),
            ),
            child: Image.asset(
              moodTrackerController.selectedMood.value.icon!,
              width: 69.22.w,
              color: const Color(0xFFFFE488),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
  }
}
