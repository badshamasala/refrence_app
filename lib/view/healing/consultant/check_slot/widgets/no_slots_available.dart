import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoSlotsAvailable extends StatelessWidget {
  final String profession;
  const NoSlotsAvailable({Key? key, required this.profession}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 200.h,
      alignment: Alignment.center,
      child: Text(
        'All Slots are either booked or ${profession} is not available for today. Please check another day for slots availability.',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.secondaryLabelColor.withOpacity(0.6),
            fontFamily: 'Circular Std',
            fontSize: 14.sp,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1.4285714285714286),
      ),
    );
  }
}
