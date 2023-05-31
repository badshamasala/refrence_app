import 'dart:async';

import 'package:aayu/controller/home/home_top_section_controller.dart';
import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PostPayment extends StatefulWidget {
  const PostPayment({Key? key}) : super(key: key);

  @override
  _PostPaymentState createState() => _PostPaymentState();
}

class _PostPaymentState extends State<PostPayment> {
  String message = "THOUGHT_MSG".tr;
  @override
  initState() {
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
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());
      buildShowDialog(context);
      bool isSubscribed = await subscriptionController.postSubscription();
      if (isSubscribed == true) {
        if (subscriptionCheckResponse != null &&
            subscriptionCheckResponse!.subscriptionDetails != null) {
          ProgrammeController programmeController = Get.put(ProgrammeController(
              subscriptionCheckResponse!
                  .subscriptionDetails!.canStartProgram!));
          programmeController.setShowPopupAssessment(true);
        }
        Get.back();
        Navigator.of(context).popUntil((route) => route.isFirst);
        EventsService().sendClickNextEvent("PostPayment", "Timer", "Healing");

        HomeTopSectionController homeTopSectionController = Get.find();
        homeTopSectionController.getHomePageTopSectionContent();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(
              selectedTab: 1,
            ),
          ),
        );
      } else {
        showGetSnackBar(
            "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
      }
    });
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
            Container(
              height: 100.h,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 50.w),
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
}
