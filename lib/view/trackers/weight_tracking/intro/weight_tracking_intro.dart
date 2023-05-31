// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/did_you_know_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/weight_tracking/weight_details.dart';
import 'package:aayu/view/trackers/weight_tracking/intro/weight_first_checkin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightTrackingIntro extends StatelessWidget {
  const WeightTrackingIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DidYouKnowController didYouKnowController = Get.put(DidYouKnowController());
    Future.delayed(const Duration(seconds: 1), () async {
      WeightDetailsController weightDetailsController = Get.find();
      await Future.wait([
        weightDetailsController.getUserDetails(),
        didYouKnowController.getDidYouKnow("WEIGHT"),
        weightDetailsController.getTodaysWeightDetails(),
        weightDetailsController.getRecommendedContent(),
      ]);
      HiveService().isFirstTimeWeightTracker().then((value) async {
        if (value == true) {
          weightDetailsController.enableReminder = true;
          weightDetailsController.enableWeightGoal = true;
          Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WeightFirstCheckIn(),
            ),
          );
        } else {
          weightDetailsController.getWeightSummary();
          Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WeightDetails(),
            ),
          );
        }
      });
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Images.weightImage,
              height: 88.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: 14.h,
            ),
            Image.asset(
              Images.ellipseImage,
              width: 78.h,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              'Weight Tracker',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFDCE2E9),
                fontFamily: 'Baskerville',
                fontSize: 30.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.06.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
