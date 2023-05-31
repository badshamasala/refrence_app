import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NutritionTipsWidget extends StatelessWidget {
  const NutritionTipsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 322.w,
          padding: EdgeInsets.symmetric(vertical: 20.h),
          margin: EdgeInsets.only(top: 64.h, bottom: 44.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.sp),
              topRight: Radius.circular(5.sp),
              bottomLeft: Radius.circular(45.sp),
              bottomRight: Radius.circular(45.sp),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(91, 112, 129, 0.08),
                offset: Offset(1, 8),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                "#aayutips",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor.withOpacity(0.8),
                  fontFamily: "BaskerVille",
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              Text(
                "Drinking a glass full of milk\nwith a pinch of nutmeg can help\ninduce sound sleep.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor.withOpacity(0.8),
                  fontFamily: "BaskerVille",
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  height: 1.2.h,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Image(
            image: const AssetImage(Images.aayuTip),
            width: 124.w,
            height: 106.h,
          ),
        ),
      ],
    );
  }
}
