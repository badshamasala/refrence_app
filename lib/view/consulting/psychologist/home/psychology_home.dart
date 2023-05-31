// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/psychologist/home/widget/journal_entries.dart';
import 'package:aayu/view/consulting/psychologist/home/widget/todays_live_events.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'widget/mood_check_in.dart';
import 'widget/pratice_for_today.dart';
import 'widget/psychology_sessions.dart';
import 'widget/todays_affiramtion.dart';

class PsychologyHome extends StatelessWidget {
  const PsychologyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyController psychologyController;
    if (PsychologyController().initialized == false) {
      psychologyController = Get.put(PsychologyController());
    } else {
      psychologyController = Get.find();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 95.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  Images.planSummaryBGImage,
                ),
              ),
            ),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              title: Text(
                "Self Help Program",
                style: appBarTextStyle(),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 20.w,
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackLabelColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (psychologyController.isLoading.value == true) {
                return showLoading();
              } else if (psychologyController.userPsychologyDetails.value ==
                  null) {
                return const Offstage();
              } else if (psychologyController
                      .userPsychologyDetails.value!.selectedPackage ==
                  null) {
                return const Offstage();
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    TodaysAffirmation(),
                    SizedBox(
                      height: 8,
                    ),
                    PsychologySessions(),
                    MoodCheckInWidget(),
                    PraticeForToday(),
                    TodaysLiveEvents(),
                    JournalFeelingLog(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class JournalFeelingLog extends StatelessWidget {
  const JournalFeelingLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const JournalEntries(),
          ),
        );
      },
      child: Container(
        margin: pagePadding(),
        width: 322.w,
        height: 110.h,
        padding: pagePadding(),
        decoration: BoxDecoration(
          color: const Color(0xFFFCAFAF).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Images.journalImage,
              width: 63.w,
              height: 93.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gratitude Check In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Express Today",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
