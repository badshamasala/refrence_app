import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/trackers/sleep_tracking/intro/sleep_tracker_intro_page2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/sleep_tracking_data.dart';

class SleepTrackerIntroPage1 extends StatelessWidget {
  const SleepTrackerIntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageContent =
        SleepTrackerIntroPageModel.fromJson(sleepTrackingPage1Data);
    return Scaffold(
      backgroundColor: AppColors.sleepTrackerBackgroundLight,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: AppColors.sleepTrackerBackgroundLight,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 25,
            ),
          )
        ],
      ),
      body: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            Container(
              height: size.height * 0.55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.sleepTrackerBackgroundDark,
                borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(size.width + 200, 60.h)),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 30.h,
            ),
            Image.asset(
              pageContent.image!,
              width: 309.w,
              height: 309.h,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 28.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.w),
              child: Text(
                pageContent.title!,
                textAlign: TextAlign.center,
                style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
              ),
            ),
            SizedBox(
              height: 11.h,
            ),
            SizedBox(
              width: 278.w,
              child: Text(pageContent.subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTheme.sleepTrackerSubtitleTextStyle),
            ),
            SizedBox(
              height: 20.h,
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SleepTrackerIntroPage2(),
                ));
              },
              child: Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: const BoxDecoration(
                    color: AppColors.sleepTrackerButtonBlueColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07),
                          offset: Offset(-5, 10),
                          blurRadius: 20),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.sleepTrackerOptionsColor,
                    size: 32.sp,
                  )),
            ),
            SizedBox(
              height: 30.h,
            )
          ],
        ),
      ]),
    );
  }
}
