import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/consulting/psychologist/home/psychology_home.dart';
import 'package:aayu/view/trackers/mood_tracking/mood_tracker_summary.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExpressYourself extends StatelessWidget {
  final String pageSource;
  final PageController pageController;
  const ExpressYourself(
      {Key? key, required this.pageController, this.pageSource = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoodTrackerController moodTrackerController = Get.find();

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Journaling'.toUpperCase(),
            style: moodTrackerPinkTitle(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          const Text(
            'Express yourself',
            style: AppTheme.secondarySmallFontTitleTextStyle,
          ),
          SizedBox(
            height: 15.h,
          ),
          Image.asset(
            Images.expressYourselfImage,
            width: 180.49.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            width: 251.w,
            child: Text(
              'Writing what\'s on your mind can help you process your feelings. This space is for your eyes only. Fill it up, without fear of judgement.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 14.sp,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w400,
                fontFamily: "Circular Std",
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            constraints: BoxConstraints(minHeight: 172.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(horizontal: 27.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromRGBO(247, 247, 247, 0.7),
            ),
            child: TextFormField(
              controller: moodTrackerController.expressYourselfTextController,
              maxLines: null,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baskerville',
                    color: const Color(0xFF8C8C8C)),
                hintText: 'Start typing...',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: InkWell(
              onTap: () async {
                buildShowDialog(context);
                moodTrackerController.completeCheckin().then((value) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  if (pageSource == "MENTAL_WEELBEING") {
                    Get.to(const PsychologyHome());
                  } else {
                    Get.to(MoodTrackerSummary(
                      pageSource: pageSource,
                      allowCheckIn: false,
                    ));
                  }
                });
              },
              child: mainButton('Complete Check-in'),
            ),
          ),
          SizedBox(
            height: 33.h,
          )
        ],
      ),
    );
  }
}
