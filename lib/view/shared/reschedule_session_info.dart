import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RescheduleSessionInfo extends StatelessWidget {
  const RescheduleSessionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      padding: pagePadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.secondaryLabelColor,
                size: 24,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                "RESCHEDULE".tr,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 18.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  height: 1.5.h,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 26.h,
          ),
          Text(
            'RESCHEDULE_MSG'.tr,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 16.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.5.h,
            ),
          )
        ],
      ),
    );
  }
}
