// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_first_checkin_controller.dart';
import 'package:aayu/services/hive.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/weight_tracking/weight_details.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/weight_goal.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/weight_reminder.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YourBMI extends StatelessWidget {
  const YourBMI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeightFirstCheckInController weightFirstCheckInController = Get.find();

    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            bmiDetails(weightFirstCheckInController),
            SizedBox(
              height: 26.h,
            ),
            const WeightGoal(
              callApi: false,
              showToggle: false,
            ),
            SizedBox(
              height: 26.h,
            ),
            const WeightReminder(
              showSaveButton: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: pagePadding(),
        child: InkWell(
          onTap: () async {
            WeightDetailsController weightDetailsController = Get.find();
            List<String> repeatList = [];
            for (var element in weightDetailsController.reminderDaysList) {
              if (element["selected"] == true) {
                repeatList.add(element["value"].toString());
              }
            }
            if (repeatList.isEmpty &&
                weightDetailsController.enableReminder == true) {
              showGetSnackBar(
                  "Please select repeat days!", SnackBarMessageTypes.Success);
              return;
            }
            buildShowDialog(context);
            List<bool> updateResponse = await Future.wait([
              weightDetailsController.postWeightGoal(),
              weightDetailsController.saveReminder()
            ]);
            if (updateResponse[0] == true && updateResponse[1] == true) {
              await Future.wait([
                weightDetailsController.getUserDetails(),
                weightDetailsController.getTodaysWeightDetails(),
                weightDetailsController.getWeightSummary(),
              ]);
              Navigator.of(context).popUntil((route) => route.isFirst);
              await HiveService().initFirstTimeWeightTracker();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WeightDetails(),
                ),
              );
            } else {
              showGetSnackBar(
                  "Failed to save details!", SnackBarMessageTypes.Error);
            }
          },
          child: mainButton("Continue"),
        ),
      ),
    );
  }

  bmiDetails(WeightFirstCheckInController weightFirstCheckInController) {
    String userName = "";
    if (weightFirstCheckInController.userDetails.value != null &&
        weightFirstCheckInController.userDetails.value?.userDetails != null) {
      userName = weightFirstCheckInController
              .userDetails.value?.userDetails?.firstName ??
          "";
    }

    return Container(
      padding: pageHorizontalPadding(),
      margin: pageHorizontalPadding(),
      width: 322.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.w),
        color: const Color(0xffF7F7F7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 26.h,
          ),
          Text(
            "Your BMI is: ${weightFirstCheckInController.bmiValue.toStringAsFixed(2)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFF39D9D),
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          SizedBox(
            width: 250.w,
            child: Text(
              "${userName.isEmpty ? "Hey" : userName}, your BMI indicates that you are ${weightFirstCheckInController.weightRange}.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.4.h,
              ),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
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
            height: 26.h,
          ),
        ],
      ),
    );
  }
}
