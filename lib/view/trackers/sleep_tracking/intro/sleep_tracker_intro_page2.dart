import 'package:aayu/data/sleep_tracking_data.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/trackers/sleep_tracking/sleep_tracking_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepTrackerIntroPage2 extends StatelessWidget {
  const SleepTrackerIntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageContent =
        SleepTrackerIntroPageModel.fromJson(sleepTrackingPage2Data);
    return Scaffold(
      backgroundColor: AppColors.sleepTrackerBackgroundLight,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.sleepTrackerBackgroundLight,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
              height: 20.h,
            ),
            Image.asset(
              pageContent.image!,
              height: 300.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: 28.h,
              width: double.infinity,
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
                Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => const SleepTrackerPageView(),
                    ))
                    .then((value) => HiveService().initFirstTimeSleepCkeckIn());
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
