// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/weight_tracking/weight_details.dart';
import 'package:aayu/view/trackers/weight_tracking/intro/weight_first_checkin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightTrackingLoader extends StatelessWidget {
  const WeightTrackingLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      WeightDetailsController weightDetailsController = Get.find();
      weightDetailsController.getUserDetails();
      await weightDetailsController.getTodaysWeightDetails();
      if (weightDetailsController.height != null &&
          weightDetailsController.height!.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WeightDetails(),
          ),
        );
      } else {
        weightDetailsController.enableReminder = true;
        weightDetailsController.enableWeightGoal = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WeightFirstCheckIn(),
          ),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Weight Progress Tracker",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 56.h,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Images.weightImage,
                  height: 68.h,
                  fit: BoxFit.fitHeight,
                ),
                Image.asset(
                  Images.weightLoaderImage,
                  height: 244.h,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
