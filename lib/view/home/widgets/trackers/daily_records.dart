// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/controller/daily_records/step_tracker/step_details_controller.dart';
import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_first_checkin_controller.dart';
import 'package:aayu/data/daily_records_data.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/view/trackers/sleep_tracking/intro/sleep_tracker_intro.dart';
import 'package:aayu/view/trackers/water_intake/intro/water_intake_intro.dart';
import 'package:aayu/view/trackers/weight_tracking/intro/weight_tracking_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../theme/theme.dart';
import '../../../trackers/mood_tracking/intro/mood_checkin_intro.dart';
import '../../../shared/shared.dart';

class DailyRecords extends StatelessWidget {
  const DailyRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 18.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 26.w),
          child: Text(
            "Daily Records",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 16.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        SizedBox(
          height: 26.h,
        ),
        SizedBox(
          width: double.infinity,
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: dailyRecordsData.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 13.w,
              );
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  if (dailyRecordsData[index]['navigation'] == null) {
                    showGreenSnackBar(context, 'Coming Soon');
                  } else {
                    switch (dailyRecordsData[index]['navigation']
                        .toString()
                        .toUpperCase()) {
                      case 'MOOD_TRACKING':
                        EventsService().sendClickNextEvent("Home_Daily_Records",
                            "Mood_Tracking", "MoodCheckInIntro");
                        if (MoodTrackerController().initialized == false) {
                          Get.put(MoodTrackerController());
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MoodCheckInIntro(),
                          ),
                        );

                        break;
                      case 'SLEEP_TRACKING':
                        EventsService().sendClickNextEvent("Home_Daily_Records",
                            "Sleep_Tracking", "SleepTrackerIntro");
                        if (SleepTrackerController().initialized == false) {
                          Get.put(SleepTrackerController());
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SleepTrackerIntro(),
                          ),
                        );
                        break;
                      case 'WATER_INTAKE_TRACKING':
                        EventsService().sendClickNextEvent("Home_Daily_Records",
                            "Water_Intake", "WaterIntakeIntro");
                        Get.put(WaterIntakesController());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WaterIntakeIntro(),
                          ),
                        );
                        break;
                      case 'WEIGHT_TRACKING':
                        EventsService().sendClickNextEvent("Home_Daily_Records",
                            "Water_Tracking", "WeightTrackingIntro");
                        Get.put(WeightDetailsController());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WeightTrackingIntro(),
                          ),
                        );
                        break;
                        case 'STEP_TRACKING':
                        EventsService().sendClickNextEvent("Home_Daily_Records",
                            "Water_Tracking", "WeightTrackingIntro");
                        Get.put(StepsDetailsController());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WeightTrackingIntro(),
                          ),
                        );
                        break;
                      default:
                        showGreenSnackBar(context, "Coming Soon!");
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: (index == 0) ? 26.w : 0.w,
                      right:
                          (index == dailyRecordsData.length - 1) ? 26.w : 0.w),
                  child: Image(
                    image: AssetImage(dailyRecordsData[index]['image'] ?? ""),
                    height: 154.2.h,
                    width: 274.2.h,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
