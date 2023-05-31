import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SleepHoursCheckIn extends StatefulWidget {
  const SleepHoursCheckIn({Key? key}) : super(key: key);

  @override
  State<SleepHoursCheckIn> createState() => _SleepHoursCheckInState();
}

class _SleepHoursCheckInState extends State<SleepHoursCheckIn> {
  late int initTime;

  late int endTime;

  int inBedTime = 0;

  int outBedTime = 0;

  @override
  void initState() {
    initTime = 276;
    endTime = 84;
    inBedTime = initTime;
    outBedTime = endTime;
    super.initState();
  }

  Widget buildTile(
      String title, String image, String time, String bottomSubTitle) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E2679).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.only(top: 18.h, bottom: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                image,
                height: 14,
                fit: BoxFit.fitHeight,
                color: const Color(0xFFA79AC9),
              ),
              SizedBox(
                width: 4.5.w,
              ),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Circular Std',
                  color: const Color(0xFFA79AC9),
                ),
              )
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Circular Std',
              fontSize: 24.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            bottomSubTitle.toUpperCase(),
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Circular Std',
              color: const Color(0xFFECECEC).withOpacity(0.5),
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sleep Hours'.toUpperCase(),
            style: AppTheme.pageViewSleepTrackerTitle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 14.h,
          ),
          const Text(
            'For how long did you sleep?',
            style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 23.h,
          ),
          GetBuilder<SleepTrackerController>(
            builder: (controller) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        Images.sleeptrackerMoonClock,
                        height: 309,
                        width: 309,
                        fit: BoxFit.cover,
                      ),
                      DoubleCircularSlider(
                        288,
                        initTime,
                        endTime,
                        height: 343.0,
                        width: 343.0,
                        secondarySectors: 24,
                        baseColor: Colors.transparent,
                        selectionColor:
                            const Color(0xFF9DDAE9).withOpacity(0.7),
                        handlerColor: const Color(0xFF9DDAE9),
                        handlerOutterRadius: 20.0,
                        onSelectionChange: (int init, int end, int temp) {
                          controller.updateSleepTime(
                              inTime: init, outTime: end);
                          setState(() {
                            inBedTime = init;
                            outBedTime = end;
                          });
                        },
                        showHandlerOutter: true,
                        sliderStrokeWidth: 34.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "You slept for".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(0xFF282392),
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                formatIntervalTime(inBedTime, outBedTime),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(0xFF282392),
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 28.w,
                    ),
                    buildTile(
                        'Bedtime',
                        Images.sleeptrackerMoon,
                        formatTime(controller.inBedTime.value),
                        inBedTime ~/ 12 > DateTime.now().hour ||
                                outBedTime ~/ 12 > DateTime.now().hour
                            ? 'Yesterday'
                            : 'Today'),
                    SizedBox(
                      width: 15.w,
                    ),
                    buildTile(
                        'Wake up',
                        Images.sleeptrackerSun,
                        formatTime(controller.outBedTime.value),
                        outBedTime ~/ 12 > DateTime.now().hour
                            ? 'Yesterday'
                            : 'Today'),
                    SizedBox(
                      width: 28.w,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateLabels(int init, int end, int temp) {
    setState(() {
      inBedTime = init;
      outBedTime = end;
    });
  }

  String formatTime(int time) {
    if (time == 0 || time == 288) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    return '${hours % 12}:${minutes < 10 ? '0$minutes' : minutes} ${hours <= 12 ? 'AM' : 'PM'}';
  }

  String formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 288 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return '$hours:${minutes < 10 ? '0$minutes' : minutes}h';
  }

  // void showBedTime() async {
  //   final TimeOfDay? newTime = await showTimePicker(
  //       context: context, initialTime: bedTime, helpText: "Bed Time");
  //   if (newTime != null) {
  //     setState(() {
  //       bedTime = newTime;
  //     });
  //   }
  // }

  // void showWakeUpTime() async {
  //   final TimeOfDay? newTime = await showTimePicker(
  //       context: context, initialTime: wakeUpTime, helpText: "Wakeup Time");
  //   if (newTime != null) {
  //     setState(() {
  //       wakeUpTime = newTime;
  //     });
  //   }
}
