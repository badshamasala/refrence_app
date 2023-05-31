import 'dart:async';

import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThankYou extends StatefulWidget {
  final PageController pageController;
  const ThankYou({Key? key, required this.pageController}) : super(key: key);

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    /* timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        widget.pageController.animateToPage(1,
            duration: Duration(milliseconds: defaultAnimateToPageDuration),
            curve: Curves.easeIn);
      });
    }); */
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 26.h),
      child: InkWell(
        onTap: () {
          widget.pageController.animateToPage(1,
              duration: Duration(milliseconds: defaultAnimateToPageDuration),
              curve: Curves.easeIn);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 45.h,
            ),
            Image(
              width: 87.w,
              height: 140.h,
              image: const AssetImage(Images.thankYouFlowerImage),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              "FOR_REACHING_OUT_MSG".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: 'Baskerville',
                fontSize: 24.sp,
                fontWeight: FontWeight.normal,
                height: 1.25.h,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 42.w),
              child: Text(
                "MOST_POWERFUL_THING_YOU_CAN_DO_FOR_YOURSELF".tr,
                textAlign: TextAlign.center,
                style: primaryFontPrimaryLabelSmallTextStyle(),
              ),
            ),
            SizedBox(
              height: 26.h,
            ),
            pageBottomHeight()
          ],
        ),
      ),
    );
  }
}
