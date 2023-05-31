// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/water_intake/water_intake_loader.dart';
import 'package:aayu/view/trackers/water_intake/widgets/daily_target.dart';
import 'package:aayu/view/trackers/water_intake/widgets/water_reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WaterIntakeIntro2 extends StatelessWidget {
  const WaterIntakeIntro2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 192.w,
              child: Text(
                "Stay Hydrated, Drink Water",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFFCAFAF),
                  fontFamily: "Baskerville",
                  fontSize: 30.sp,
                  height: 1.2.h,
                ),
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            SizedBox(
              width: 235.w,
              child: Text(
                "Logging your water intake is a simple yet effective way to track how much water you're drinking every day.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontSize: 14.sp,
                  height: 1.2.h,
                ),
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            const DailyTarget(callApi: false, showToggle: false),
            SizedBox(
              height: 26.h,
            ),
            const WaterReminder(
              showSaveButton: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: pagePadding(),
        child: InkWell(
          onTap: () async {
            WaterIntakesController waterIntakesController = Get.find();
            buildShowDialog(context);
            List<bool> updateResponse = await Future.wait([
              waterIntakesController.saveReminder(),
              waterIntakesController.postDailyTarget(),
            ]);
            if (updateResponse[0] == true && updateResponse[1] == true) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              await HiveService().initFirstTimeWaterIntake();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WaterIntakeLoader(),
                ),
              );
            } else {
              showGetSnackBar(
                  "Failed to save details!", SnackBarMessageTypes.Error);
            }
          },
          child: SizedBox(
            width: 322.w,
            child: mainButton("SAVE"),
          ),
        ),
      ),
    );
  }
}
