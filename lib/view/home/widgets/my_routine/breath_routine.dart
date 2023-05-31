import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/app_colors.dart';
import '../../../shared/ui_helper/images.dart';

class BreathingRoutineWidget extends StatelessWidget {
  const BreathingRoutineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180.h,
          width: 155.w,
          decoration: const BoxDecoration(
              color: AppColors.myRoutineBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.only(top: 42.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Breathwork",
                  style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Circular Std"),
                ),
                const SizedBox(
                  height: 7.0,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 13.sp,
                        fontFamily: "Circular Std",
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: 'Take a minute.',
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 13.sp,
                            fontFamily: "Circular Std",
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: ' \nInhale. Exhale.',
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 13.sp,
                            fontFamily: "Circular Std",
                            fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' \nGround yourself.',
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 13.sp,
                            fontFamily: "Circular Std",
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Get relax',
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
          right: 20.w,
          top: -25,
          child: Image.asset(
            Images.lotusImage,
            height: 60.h,
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}