import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../shared/ui_helper/new_cupertino_date_picker.dart';

class SleepCheckInComplete extends StatelessWidget {
  const SleepCheckInComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime duration = DateTime.now();
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
              SizedBox(
                height: 38.h,
              ),
              const Text(
                'Check-in Complete',
                style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'We appreciate you looking\nout for yoursellf.',
                textAlign: TextAlign.center,
                style: AppTheme.sleepTrackerSubtitleTextStyle,
              ),
              SizedBox(
                height: 28.h,
              ),
              GetBuilder<SleepTrackerController>(builder: (controller) {
                if (controller.sleepRemindTime.value == null) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Image.asset(
                        Images.sleepClockImage,
                        height: 77.h,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 15.67.h,
                      ),
                      Image.asset(
                        Images.ellipseImage,
                        height: 6.h,
                        color: const Color(0xFF24196A),
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 17.h,
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
                            initialDateTime: DateTime.now(),
                            mode: NewCupertinoDatePickerMode.time,
                            minuteInterval: 1,
                            overlayColor:
                                Color.fromARGB(51, 8, 2, 44).withOpacity(0.2),
                            onDateTimeChanged: (dateTime1) {
                              duration = dateTime1;
                            },
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        child: Container(
                          height: 54.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 17.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: AppColors.sleepTrackerButtonBlueColor,
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
                                color: AppColors.sleepTrackerOptionsColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                height: 1.h,
                                fontFamily: "Circular Std",
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.setSleepReminderTime(duration);
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
                          style: skipButtonSleepCheckinTextStyle(),
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
          top: -26.h,
          child: Image.asset(
            'assets/images/sleeptracker/Good_pillow_icon_active.png',
            width: 56.w,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
