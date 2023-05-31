import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConsultantNotAvailable extends StatelessWidget {
  final String consultationType;
  const ConsultantNotAvailable({Key? key, required this.consultationType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = "DOCTORS_ARE_NOT_AVAILAIBLE".tr;
    if (consultationType == "DOCTOR") {
      message = "DOCTORS_ARE_NOT_AVAILAIBLE".tr;
    } else if (consultationType == "THERAPIST") {
      message = "THERAPIST_ARE_NOT_AVAILAIBLE".tr;
    } else if (consultationType == "NUTRITIONIST") {
      message = "NUTRITIONIST_ARE_NOT_AVAILAIBLE".tr;
    } else if (consultationType == "PSYCHOLOGIST") {
      message = "PSYCHOLOGIST_ARE_NOT_AVAILAIBLE".tr;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150.h,
          ),
          Image(
            image: const AssetImage(Images.doctorConsultant3Image),
            width: 76.w,
            height: 96.h,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 24.h,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF8C98A5),
              fontFamily: 'Circular Std',
              fontSize: 14.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.4285714285714286.h,
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              width: 270.w,
              child: mainButton("DISMISS".tr),
            ),
          )
        ],
      ),
    );
  }
}
