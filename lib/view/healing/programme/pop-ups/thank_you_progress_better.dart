import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThankYouProgressBetter extends StatelessWidget {
  const ThankYouProgressBetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 38.h),
              padding: EdgeInsets.only(top: 300.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.pageBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.w),
                  topRight: Radius.circular(30.w),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "THANK_YOU".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 24.sp,
                      letterSpacing: 1.5.w,
                      fontWeight: FontWeight.normal,
                      height: 1.16.h,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "THIS_HELPS_US_MAP_YOUR_PROGRESS_BETTER".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.16.h,
                    ),
                  ),
                  pageBottomHeight()
                ],
              ),
            ),
            Image(
              width: 163.w,
              height: 312.h,
              image: const AssetImage(Images.thankYouProgressImage),
              fit: BoxFit.contain,
            ),
            Positioned(
              top: 60,
              right: 26,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
