// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProgramPostLoading extends StatefulWidget {
  const ProgramPostLoading({
    Key? key,
  }) : super(key: key);

  @override
  State<ProgramPostLoading> createState() => _ProgramPostLoadingState();
}

class _ProgramPostLoadingState extends State<ProgramPostLoading> {
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
}
