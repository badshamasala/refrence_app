import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FeatureComingSoon extends StatelessWidget {
  const FeatureComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'COMING_SOON'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 40.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
          SizedBox(height: 40.h),
          Image.asset(
            Images.underMaintainanceImage,
            height: 168.h,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: 295.w,
            child: Text(
              'THANK_YOU_COMING_SOON_MSG'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 18.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.4.h,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: SizedBox(
              width: 256.w,
              child: mainButton("NOTIFY_ME".tr),
            ),
          )
        ],
      ),
    );
  }
}
