import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/onboarding.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalizedContentSuggestion extends StatelessWidget {
  const PersonalizedContentSuggestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(26.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 221.w,
            child: Text(
              'WHAT_YOU_ARE_LOOKING_FOR'.tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontFamily: 'Circular Std',
                fontSize: 30.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
                height: 1.1333333333333333.h,
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          SizedBox(
            width: 254.w,
            child: Text(
              'PERSONALISED_CONTENT_SUGGESTIONS'.tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: const Color.fromRGBO(144, 144, 144, 1),
                  fontFamily: 'Circular Std',
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.5.h),
            ),
          ),
          SizedBox(
            height: 19.h,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Onboarding(showSkip: false),
                ),
              );
            },
            child: Container(
              height: 43.h,
              width: 175.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFD9D9D9),
              ),
              child: Center(
                child: Text(
                  "GET_STARTED".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    height: 1.h,
                    fontFamily: "Circular Std",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
