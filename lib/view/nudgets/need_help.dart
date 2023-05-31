import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../profile/help_and_support.dart';
import '../shared/ui_helper/images.dart';

class NeedHelp extends StatelessWidget {
  const NeedHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const HelpAndSupport());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(252, 175, 175, 0.2),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 12.h, bottom: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.helpAndSupportImage,
                    width: 70.w,
                    fit: BoxFit.fitWidth,
                  ),
                  Spacer(),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    "Need a hand to book\nyour appointment?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 24.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1.h,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(252, 175, 175, 0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.w),
                    bottomRight: Radius.circular(16.w),
                  )),
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                'Request a Call Back',
                style: TextStyle(
                    color: Color(0xFF597393),
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
