import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConsultationHeader extends StatelessWidget {
  final String consultationType;
  const ConsultationHeader({Key? key, required this.consultationType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 151.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.planSummaryBGImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0.w,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
          Text(
            consultationType == "DOCTOR" ? "BOOK_CONSULTATION".tr : "PERSONAL_TRAINER".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              fontWeight: FontWeight.normal,
              height: 1.h,
            ),
          ),
        ],
      ),
    );
  }
}
