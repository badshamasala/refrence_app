import 'package:aayu/controller/daily_records/did_you_know_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DidYouKnow extends StatelessWidget {
  final String category;
  const DidYouKnow({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DidYouKnowController didYouKnowController = Get.find();
    return Obx(() {
      if (didYouKnowController.isLoading.value == true) {
        return const Offstage();
      } else if (didYouKnowController.didYouKnowDetails == null) {
        return const Offstage();
      } else if (didYouKnowController.didYouKnowDetails?.details == null) {
        return const Offstage();
      }
      return Container(
        width: 322.w,
        margin: pagePadding(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sp),
          color: const Color(0xFF7FE3F0).withOpacity(0.1),
          border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5,)
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              top: 12.h,
              right: 0,
              child: Image.asset(
                Images.helpHandImage,
                height: 88.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: pagePadding(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Did you know?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    width: 230.w,
                    child: Text(
                      didYouKnowController
                              .didYouKnowDetails?.details?.didYouKnow ??
                          "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.4.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
