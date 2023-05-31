import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllDone extends StatelessWidget {
  const AllDone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: Padding(
        padding: pagePadding(),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: 87.w,
                  height: 140.h,
                  fit: BoxFit.contain,
                  image: const AssetImage(Images.thankYouFlowerImage),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  "ALL_DONE".tr,
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
                SizedBox(
                  width: 246.w,
                  child: Text(
                    "YOUR_JOURNEY_TOWARDS_HEALTH_MSG".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.16.h,
                    ),
                  ),
                ),
                pageBottomHeight(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: mainButton("CONTINUE".tr),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
