import 'package:aayu/data/mood_tracking_data.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/trackers/mood_tracking/mood_tracker_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoodCheckInIntro2 extends StatelessWidget {
  final String pageSource;
  const MoodCheckInIntro2({Key? key, this.pageSource = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageContent =
        MoodTrackerIntroPageModel.fromJson(moodTrackingPage2Data);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.blackLabelColor,
              size: 25,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 18.h,
            ),
            Image.asset(
              pageContent.image!,
              width: 333.w,
              height: 302.h,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              height: 32.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.w),
              child: Text(
                pageContent.title!,
                textAlign: TextAlign.center,
                style: AppTheme.secondarySmallFontTitleTextStyle,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 272.w,
              child: Text(
                pageContent.subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => MoodTrackerPageView(pageSource: pageSource),
                      ),
                    )
                    .then((value) => HiveService().initFirstTimeMoodCkeckIn());
              },
              child: Container(
                width: 70.w,
                height: 70.h,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
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
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
