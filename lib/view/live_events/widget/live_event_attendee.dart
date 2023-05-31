import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LiveEventAttendee extends StatelessWidget {
  final int totalAttendees;
  const LiveEventAttendee({Key? key, required this.totalAttendees})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.attendingUsersSVG,
            width: 14.45.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            "$totalAttendees Attending",
            style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
