import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnlockAllContent extends StatelessWidget {
  const UnlockAllContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180.w,
            child: Text(
              "Unlock All The Content You Need!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 19.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
                height: 1.h,
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          buildPointers()
        ]);
  }

  buildPointers() {
    List<String> pointers = [
      "Integrative Healing program designed by SVYASA",
      "Thousands of minutes of Mindful music, audios, and videos",
      "Daily Live yoga with Aayu Therapist",
      "Expert’s informative talks on Yoga, Healing, Breathing practices and on more other topics",
      "Track your health score with timely assessments",
      "Fresh New content every Week",
    ];

    return SizedBox(
      width: 300.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(pointers.length, (index) {
          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AppIcons.checkCircleSVG,
                  width: 32.h,
                  fit: BoxFit.fitWidth,
                  color: AppColors.secondaryLabelColor,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Text(
                    pointers[index],
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1.2.h,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
