// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/did_you_know_controller.dart';
import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/trackers/water_intake/intro/water_intake_intro_2.dart';
import 'package:aayu/view/trackers/water_intake/water_intake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaterIntakeIntro extends StatelessWidget {
  const WaterIntakeIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DidYouKnowController didYouKnowController = Get.put(DidYouKnowController());
    Future.delayed(const Duration(seconds: 1), () async {
      WaterIntakesController waterIntakesController = Get.find();
      await Future.wait([
        didYouKnowController.getDidYouKnow("WATER"),
        waterIntakesController.getTodaysIntake(),
        waterIntakesController.getRecommendedContent(),
      ]);
      HiveService().isFirstTimeWaterIntake().then((value) async {
        if (value == true) {
          WaterIntakesController waterIntakesController = Get.find();
          waterIntakesController.enableDailyTarget.value = true;
          waterIntakesController.enableWaterReminder.value = true;
          Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WaterIntakeIntro2(),
            ),
          );
        } else {
          Navigator.of(Get.context!).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const WaterIntake(),
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
            Image(
              image: const AssetImage("assets/images/water-intake/glass.png"),
              height: 133.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              'Water Intake',
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
