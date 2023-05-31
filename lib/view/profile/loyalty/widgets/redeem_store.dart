// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/loyalty/loyalty_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class RedeemStore extends StatelessWidget {
  const RedeemStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyController>(builder: (loyaltyController) {
      if (loyaltyController.isLoading.value == true) {
        return showLoading();
      } else if (loyaltyController.redeemStoreList.value == null) {
        return const Offstage();
      } else if (loyaltyController.redeemStoreList.value!.redeemList == null) {
        return const Offstage();
      } else if (loyaltyController.redeemStoreList.value!.redeemList!.isEmpty) {
        return const Offstage();
      }
      return ListView.separated(
        shrinkWrap: true,
        padding: pagePadding(),
        itemCount: loyaltyController.redeemStoreList.value!.redeemList!.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 26.h);
        },
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: HexColor(loyaltyController
                          .redeemStoreList.value!.redeemList?[index]?.theme ??
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
                  loyaltyController.redeemStoreList.value!.redeemList?[index]
                          ?.displayText ??
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
                    loyaltyController.redeemStoreList.value!.redeemList?[index]
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
                  height: 26.h,
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
                      "${loyaltyController.redeemStoreList.value!.redeemList?[index]?.vPoints} atoms",
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
                            disabledForegroundColor:
                                const Color(0xFFD1D5DA),),
                        onPressed: (loyaltyController.redeemStoreList.value!
                                    .redeemList?[index]?.allowRedeem ==
                                true)
                            ? () async {
                                buildShowDialog(context);
                                bool isClaimed =
                                    await loyaltyController.redeemPoints(
                                        loyaltyController
                                                .redeemStoreList
                                                .value!
                                                .redeemList?[index]
                                                ?.appRedeemId ??
                                            "",
                                        loyaltyController.redeemStoreList.value!
                                                .redeemList?[index]?.redeemOn ??
                                            "");
                                if (isClaimed == true) {
                                  await Future.wait([
                                    loyaltyController.getUserPoints(),
                                    loyaltyController.getCouponList(),
                                  ]);
                                  Navigator.pop(context);
                                  showSnackBar(
                                      context,
                                      "You have successfully redeemed Aayu Atoms!",
                                      SnackBarMessageTypes.Success);
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                        child: Text(
                          "REDEEM",
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
}
