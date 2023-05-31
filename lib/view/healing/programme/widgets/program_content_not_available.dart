import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgramContentNotAvailable extends StatelessWidget {
  const ProgramContentNotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Image.asset(
            "assets/images/placeholder/default_home.jpg",
            width: double.infinity,
            height: (538 + kToolbarHeight),
            fit: BoxFit.fitHeight,
          ),
          Positioned(
            bottom: 56.h,
            left: 0,
            right: 0,
            child: Text(
              "Today's content not available!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
