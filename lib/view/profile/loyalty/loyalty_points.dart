import 'package:aayu/controller/loyalty/loyalty_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/profile/loyalty/loyalty_points_details.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoyaltyPoints extends StatelessWidget {
  const LoyaltyPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoyaltyController loyaltyController = Get.put(LoyaltyController());
    loyaltyController.getUserPoints();
    return Obx(() {
      if (loyaltyController.isLoading.value == true) {
        return const Offstage();
      } else if (loyaltyController.userPoints.value == null) {
        return const Offstage();
      }
      return InkWell(
        onTap: () {
          Navigator.of(Get.context!).push(MaterialPageRoute(
            builder: (context) => const LoyaltyPointsDetails(),
          ));
        },
        child: Container(
          margin: pageHorizontalPadding(),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: 31.w,
                image: const AssetImage(Images.aayuPointsImage),
                fit: BoxFit.fitWidth,
              ),
              Text(
                "Your Aayu points",
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: AppColors.secondaryLabelColor,
                  height: 1.h,
                ),
              ),
              Text(
                "${(loyaltyController.userPoints.value?.points?.vPoints ?? 0).toString()} atoms",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: AppColors.secondaryLabelColor,
                  height: 1.h,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
