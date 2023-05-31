// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/did_you_know_controller.dart';
import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/water_intake/water_intake.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaterIntakeLoader extends StatelessWidget {
  const WaterIntakeLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WaterIntakesController waterIntakesController = Get.find();
    Future.delayed(const Duration(seconds: 1), () async {
      await waterIntakesController.getTodaysIntake();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WaterIntake(),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Setting up your goals",
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
                  Images.waterGlassImage,
                  height: 133.h,
                  fit: BoxFit.fitHeight,
                ),
                Image.asset(
                  Images.waterIntakeLoaderImage,
                  height: 250.h,
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
