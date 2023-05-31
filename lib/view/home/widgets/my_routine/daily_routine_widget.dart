import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/app_colors.dart';

class DailyRoutineWidget extends StatelessWidget {
  const DailyRoutineWidget({
    Key? key,
    this.networkImage,
    required this.title,
    required this.subtitle,
    required this.topImage,
    required this.bgColor,
    required this.ctaText,
  }) : super(key: key);
  final String title, subtitle, topImage, ctaText;

  final Color bgColor;
  final String? networkImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180.h,
          width: 155.w,
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.only(top: 42.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  subtitle,
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
                      ctaText,
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
          left: 105,
          bottom: 147.0,
          child: networkImage != null
              ? Image.network(
                  networkImage!,
                  height: 60.h,
                  fit: BoxFit.fitHeight,
                )
              : Image.asset(
                  topImage,
                  height: 45.h,
                  fit: BoxFit.fitHeight,
                ),
        ),
      ],
    );
  }
}
