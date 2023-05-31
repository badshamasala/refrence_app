import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/app_colors.dart';
import '../../../shared/ui_helper/images.dart';

class ExploreHealingWidget extends StatelessWidget {
  const ExploreHealingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180.h,
          width: 155.w,
          decoration: const BoxDecoration(
              color: AppColors.shareAayuBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.only(top: 42.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Programs",
                  style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Circular Std"),
                ),
                const SizedBox(
                  height: 7.0,
                ),
                Text(
                  "Don’t let Diabetes, Anxiety, PCOS, BP or any disease to control you.",
                  style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Circular Std"),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Take Charge',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF3E3A93),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 11.h,
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 10.w,
          top: -20,
          child: Image.asset(
            Images.myRoutineExplore,
            height: 55.h,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}
