import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AssessmentHeader extends StatelessWidget {
  final Function closeFunction;
  const AssessmentHeader({Key? key, required this.closeFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding(),
      margin: EdgeInsets.only(top: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ASSESSING_FOR".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'Circular Std',
                    fontSize: 12.sp,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.normal,
                    height: 1.16.h),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                toTitleCase("Mental Wellbeing"),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: "Baskerville",
                  fontSize: 24.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              closeFunction();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.blackLabelColor,
            ),
          )
        ],
      ),
    );
  }
}
