// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:aayu/controller/consultant/nutrition/nutrition_initial_assessment_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/nutritionist_list.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PostInitialAssessment extends StatefulWidget {
  final String pageSource;
  const PostInitialAssessment({Key? key, required this.pageSource})
      : super(key: key);

  @override
  State<PostInitialAssessment> createState() => _PostInitialAssessmentState();
}

class _PostInitialAssessmentState extends State<PostInitialAssessment> {
  @override
  initState() {
    Timer(const Duration(seconds: 3), () async {
      if (widget.pageSource == "COMPLETE_ASSESSMENT") {
        NutritionInitialAssessmentController
            nutritionInitialAssessmentController = Get.find();
        await nutritionInitialAssessmentController.getInitialAssessmentStatus();
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        EventsService().sendClickNextEvent(
            "PostInitialAssessment", "Next", "NutritionistList");
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NutritionistList(
              pageSource: "",
            ),
          ),
        );
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
              width: 260.w,
              height: 250.h,
              image: const AssetImage(Images.foodBowlImage),
            ),
            SizedBox(height: 26.h),
            Container(
              height: 100.h,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Text(
                "Fuel your body right with our expert nutritionist.",
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
