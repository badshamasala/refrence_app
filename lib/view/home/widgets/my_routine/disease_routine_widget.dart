import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/app_colors.dart';

class DiseaseRoutineWidget extends StatelessWidget {
  const DiseaseRoutineWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.topImage,
      this.networkImage,
      required this.day})
      : super(key: key);
  final String title, subtitle, topImage, day;
  final String? networkImage;

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
            padding: EdgeInsets.only(top: 14.h, left: 16.w, right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Circular Std"),
                ),
                SizedBox(
                  height: 25.h,
                ),
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
                      "Today’s session",
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
          right: 30,
          top: -20,
          child: networkImage != null && networkImage!.isNotEmpty
              ? Image.network(
                  networkImage!,
                  height: 55.h,
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
