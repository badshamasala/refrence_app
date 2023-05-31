// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/loyalty/loyalty_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class UserCoupons extends StatelessWidget {
  const UserCoupons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyController>(builder: (loyaltyController) {
      if (loyaltyController.isLoading.value == true) {
        return showLoading();
      } else if (loyaltyController.couponList.value == null) {
        return const Offstage();
      } else if (loyaltyController.couponList.value!.userCoupons == null) {
        return const Offstage();
      } else if (loyaltyController.couponList.value!.userCoupons!.isEmpty) {
        return const Offstage();
      }
      return ListView.separated(
        shrinkWrap: true,
        padding: pagePadding(),
        itemCount: loyaltyController.couponList.value!.userCoupons!.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 26.h);
        },
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: HexColor(loyaltyController
                          .couponList.value!.userCoupons?[index]?.theme ??
                      "#FCAFAF")
                  .withOpacity(0.3),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: AppColors.blackLabelColor.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loyaltyController
                          .couponList.value!.userCoupons?[index]?.displayText ??
                      "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Baskerville",
                    fontSize: 20.sp,
                    color: AppColors.blackLabelColor,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 30.h,
                  child: Text(
                    loyaltyController.couponList.value!.userCoupons?[index]
                            ?.description ??
                        "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.blackLabelColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                showDate(loyaltyController, index),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      width: 20.w,
                      image: const AssetImage(Images.aayuPointsImage),
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(
                      width: 10.sp,
                    ),
                    Text(
                      "${loyaltyController.couponList.value!.userCoupons?[index]?.vPoints} atoms",
                      style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100.w, 25.h),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          disabledBackgroundColor: const Color(0xFFF5F5F5),
                          disabledForegroundColor: const Color(0xFFD1D5DA),
                        ),
                        onPressed: loyaltyController.couponList.value!
                                    .userCoupons?[index]?.status ==
                                "ACTIVE"
                            ? () async {}
                            : null,
                        child: Text(
                          loyaltyController.couponList.value!
                                      .userCoupons?[index]?.status ==
                                  "ACTIVE"
                              ? "APPLY"
                              : loyaltyController.couponList.value!
                                      .userCoupons?[index]?.status ??
                                  "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ))
                  ],
                )
              ],
            ),
          );
        },
      );
    });
  }

  showDate(LoyaltyController loyaltyController, int index) {
    String status =
        loyaltyController.couponList.value!.userCoupons?[index]?.status ?? "";
    if (status == "ACTIVE" &&
        loyaltyController.couponList.value!.userCoupons?[index]?.expiresOn !=
            null) {
      return buildDateWidget(
          "Expires on: ",
          DateFormat("dd MMM yyyy").format(dateFromTimestamp(loyaltyController
                  .couponList.value!.userCoupons?[index]?.expiresOn ??
              0)));
    } else if (status == "EXPIRED" &&
        loyaltyController.couponList.value!.userCoupons?[index]?.expiresOn !=
            null) {
      return buildDateWidget(
          "Expired on: ",
          DateFormat("dd MMM yyyy").format(dateFromTimestamp(loyaltyController
                  .couponList.value!.userCoupons?[index]?.expiresOn ??
              0)));
    } else if (status == "USED" &&
        loyaltyController
                .couponList.value!.userCoupons?[index]?.usageDetails?.usedOn !=
            null) {
      return buildDateWidget(
          "Used on: ",
          DateFormat("dd MMM yyyy, hh:mm a").format(dateFromTimestamp(loyaltyController
                  .couponList
                  .value!
                  .userCoupons?[index]
                  ?.usageDetails
                  ?.usedOn ??
              0)));
    }
    return const Offstage();
  }

  buildDateWidget(String title, String value) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          color: AppColors.secondaryLabelColor,
          fontSize: 12.sp,
          letterSpacing: 0,
          fontWeight: FontWeight.w500,
        ),
        text: title,
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontSize: 12.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
