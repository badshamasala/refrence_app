import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../shared/ui_helper/images.dart';

class FreeDoctorConsultTab extends StatelessWidget {
  final Function function;
  const FreeDoctorConsultTab({Key? key, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 80.h),
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 26.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32.w),
            bottomLeft: Radius.circular(32.w)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: Image.asset(
              Images.doctorConsultatTab,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            'BOOK_ONE_TO_ONE'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: () {
              function();
            },
            child: Text(
              'BOOK_NOW'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                fontSize: 18.sp,
              ),
            ),
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
