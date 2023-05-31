// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProgramPostSelection extends StatefulWidget {
  final bool isProgramSwitch;
  final bool isRecommendedProgramSwitch;
  const ProgramPostSelection(
      {Key? key,
      required this.isProgramSwitch,
      required this.isRecommendedProgramSwitch})
      : super(key: key);

  @override
  State<ProgramPostSelection> createState() => _ProgramPostSelectionState();
}

class _ProgramPostSelectionState extends State<ProgramPostSelection> {
  String message = "THOUGHT_MSG".tr;
  @override
  initState() {
    updateProgramEntry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 180.w,
              height: 360.h,
              image: const AssetImage(Images.ballGirlAnimationImage),
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: 265.w,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Baskerville',
                  fontSize: 22.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.18.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateProgramEntry() async {
    bool isUpdated = false;

    print(widget.isProgramSwitch);
    print(widget.isRecommendedProgramSwitch);

    if (widget.isProgramSwitch == true &&
        widget.isRecommendedProgramSwitch == false) {
      isUpdated = await switchProgram();
    } else if (widget.isProgramSwitch == true &&
        widget.isRecommendedProgramSwitch == true) {
      isUpdated = await switchRecommendedProgram();
    } else {
      isUpdated = await startProgram();
    }

    if (isUpdated == true) {
      Timer(const Duration(seconds: 2), () {
        setState(() {
          message = "CUSTOMIZE_HEALING_PROGRAM".tr;
        });
      });
      Timer(const Duration(seconds: 4), () {
        setState(() {
          message = "YOUR_PROGRAM_IS_READY".tr;
        });
      });
      Timer(const Duration(seconds: 5), () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(
              selectedTab: 1,
            ),
          ),
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  startProgram() async {
    bool isUpdated = false;
    try {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null &&
          subscriptionCheckResponse!.subscriptionDetails!.programId!.isEmpty) {
        SubscriptionController subscriptionController = Get.find();
        bool isStarted = await subscriptionController.startProgram();

        if (isStarted == true) {
          isUpdated = true;
          await subscriptionController.fetchBackgroundData();
        } else {
          showCustomSnackBar(
            context,
            "FAILED_TO_UPDATE_SUBSCRIPTION".tr,
          );
        }
      } else {
        showSnackBar(context, "YOU_HAVE_ALREADY_SUBSCRIBED".tr,
            SnackBarMessageTypes.Info);
      }
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }

  switchProgram() async {
    bool isUpdated = false;
    try {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null &&
          subscriptionCheckResponse!
              .subscriptionDetails!.programId!.isNotEmpty) {
        SubscriptionController subscriptionController = Get.find();
        bool isSwitched = await subscriptionController
            .switchProgram(widget.isRecommendedProgramSwitch);
        if (isSwitched == true) {
          isUpdated = true;
          await subscriptionController.fetchBackgroundData();
        }
      } else {
        showSnackBar(context, "YOU_HAVE_ALREADY_SUBSCRIBED".tr,
            SnackBarMessageTypes.Info);
      }
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }

  switchRecommendedProgram() async {
    bool isUpdated = false;
    try {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null &&
          subscriptionCheckResponse!
              .subscriptionDetails!.programId!.isNotEmpty) {
        SubscriptionController subscriptionController = Get.find();

        bool isSwitched = await subscriptionController.switchRecommendedProgram(
            subscriptionCheckResponse!.subscriptionDetails!.packageType!);
        if (isSwitched == true) {
          isUpdated = true;
          await subscriptionController.fetchBackgroundData();
        }
      } else {
        showSnackBar(context, "YOU_HAVE_ALREADY_SUBSCRIBED".tr,
            SnackBarMessageTypes.Info);
      }
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }
}
