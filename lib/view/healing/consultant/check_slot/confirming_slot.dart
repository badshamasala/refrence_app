import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmingSlot extends StatelessWidget {
  final Function bookCall;
  final bool isScheduled;
  final String consultationType;
  const ConfirmingSlot(
      {Key? key,
      required this.bookCall,
      required this.isScheduled,
      required this.consultationType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      bookCall();
    });

    String message = "";
    if (isScheduled == true) {
      if (consultationType == "DOCTOR") {
        message = "Scheduling your session with the doctor";
      } else if (consultationType == "THERAPIST") {
        message = "Scheduling your session with the yoga therapist";
      } else if (consultationType == "NUTRITIONIST") {
        message = "Scheduling your session with the nutritionist";
      }
    } else {
      message = "CONFIRM_SLOT".tr;
    }

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
                    height: 1.18.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
