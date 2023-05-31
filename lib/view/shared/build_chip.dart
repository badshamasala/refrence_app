import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  const BuildChip({Key? key, required this.title, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.w),
        color: (isSelected)
            ? AppColors.primaryColor
            : AppColors.lightSecondaryColor,
      ),
      child: Center(
        child: Text(
          title.toString(),
          textAlign: TextAlign.center,
          style: (isSelected == true)
              ? TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Circular Std",
                )
              : TextStyle(
                  color: AppColors.primaryLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Circular Std",
                ),
        ),
      ),
    );
  }
}
