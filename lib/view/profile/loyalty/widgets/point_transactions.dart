// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/loyalty/loyalty_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PointTransactions extends StatelessWidget {
  const PointTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoyaltyController loyaltyController = Get.find();
    Future.delayed(Duration.zero, () {
      loyaltyController.getTransactonList();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blackLabelColor,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Transaction History",
          style: TextStyle(
            fontSize: 25.sp,
            color: AppColors.blackLabelColor,
            fontFamily: "Baskerville",
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GetBuilder<LoyaltyController>(builder: (loyaltyController) {
        if (loyaltyController.isLoading.value == true) {
          return showLoading();
        } else if (loyaltyController.userPointTransactionList.value == null) {
          return const Offstage();
        } else if (loyaltyController.userPointTransactionList.value!.result ==
            null) {
          return const Offstage();
        } else if (loyaltyController
            .userPointTransactionList.value!.result!.isEmpty) {
          return const Offstage();
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount:
              loyaltyController.userPointTransactionList.value!.result!.length,
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: AppColors.secondaryLabelColor.withOpacity(0.4),
            );
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 /*  Image(
                    width: 30.w,
                    image: const AssetImage(Images.aayuPointsImage),
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    width: 12.w,
                  ), */
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loyaltyController.userPointTransactionList.value
                                ?.result?[index]?.displayText ??
                            "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.blackLabelColor,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        DateFormat("dd MMM yyyy, hh:mm a").format(
                            dateFromTimestamp(loyaltyController
                                    .userPointTransactionList
                                    .value
                                    ?.result?[index]
                                    ?.createdAt ??
                                0)),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.blackLabelColor,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${loyaltyController.userPointTransactionList.value?.result?[index]?.transactionType == "DEBIT" ? "" : "+"}${loyaltyController.userPointTransactionList.value?.result?[index]?.vPoints}",
                          style: TextStyle(
                            color: AppColors.blackLabelColor,
                            fontSize: 14.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        loyaltyController.userPointTransactionList.value
                                    ?.result?[index]?.expiresOn !=
                                null
                            ? Text(
                                "Expires on: ${DateFormat("dd MMM yyyy").format(dateFromTimestamp(loyaltyController.userPointTransactionList.value?.result?[index]?.expiresOn ?? 0))}",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : const Offstage(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
