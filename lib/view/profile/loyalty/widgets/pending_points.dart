// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/loyalty/loyalty_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class PendingPoints extends StatelessWidget {
  const PendingPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyController>(builder: (loyaltyController) {
      if (loyaltyController.isLoading.value == true) {
        return showLoading();
      } else if (loyaltyController.pendingPointList.value == null) {
        return const Offstage();
      } else if (loyaltyController.pendingPointList.value!.result == null) {
        return const Offstage();
      } else if (loyaltyController.pendingPointList.value!.result!.isEmpty) {
        return const Offstage();
      }
      return ListView.separated(
        shrinkWrap: true,
        padding: pagePadding(),
        itemCount: loyaltyController.pendingPointList.value!.result!.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 26.h);
        },
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                color: AppColors.blackLabelColor.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loyaltyController.pendingPointList.value
                                    ?.result?[index]?.displayText ??
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
                              loyaltyController.pendingPointList.value
                                      ?.result?[index]?.description ??
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
                          loyaltyController.pendingPointList.value
                                      ?.result?[index]?.expiresOn !=
                                  null
                              ? RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: AppColors.secondaryLabelColor,
                                      fontSize: 12.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    text: "Expires on: ",
                                    children: [
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy").format(
                                            dateFromTimestamp(loyaltyController
                                                    .pendingPointList
                                                    .value
                                                    ?.result?[index]
                                                    ?.expiresOn ??
                                                0)),
                                        style: TextStyle(
                                          color: AppColors.blackLabelColor,
                                          fontSize: 12.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Offstage(),
                        ],
                      ),
                      const Spacer(),
                      ShowNetworkImage(
                        imgPath: loyaltyController
                                .pendingPointList.value?.result?[index]?.icon ??
                            "",
                        imgWidth: 42.w,
                        imgHeight: 50.h,
                        boxFit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor(loyaltyController.pendingPointList.value
                                ?.result?[index]?.theme ??
                            "#FCAFAF")
                        .withOpacity(0.3),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                    child: Row(
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
                          "${loyaltyController.pendingPointList.value?.result?[index]?.transactionType == "DEBIT" ? "-" : "+"}${loyaltyController.pendingPointList.value?.result?[index]?.vPoints} atoms",
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
                              minimumSize: Size(100.sp, 25.sp),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              elevation: 0,
                              backgroundColor: const Color(0xffAAFDB4),
                              foregroundColor: AppColors.secondaryLabelColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () async {
                              buildShowDialog(context);
                              bool isClaimed = await loyaltyController
                                  .claimPoints(loyaltyController
                                          .pendingPointList
                                          .value
                                          ?.result?[index]
                                          ?.transactionId ??
                                      "");
                              if (isClaimed == true) {
                                await Future.wait([
                                  loyaltyController.getUserPoints(),
                                  loyaltyController.getPendingPointsList(),
                                ]);
                                Navigator.pop(context);
                                showSnackBar(
                                    context,
                                    "You have successfully claimed Aayu Atoms!",
                                    SnackBarMessageTypes.Success);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Claim atoms",
                              style: TextStyle(
                                fontSize: 11.sp,
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
