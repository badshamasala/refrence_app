import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/psychologist/psychology_plan_controller.dart';

class PsychologyPlanPricing extends StatelessWidget {
  final PsychologyPlanController psychologyPlanController;
  final bool extendPlan;
  const PsychologyPlanPricing(
      {Key? key,
      required this.psychologyPlanController,
      required this.extendPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: psychologyPlanController
          .psychologyPlansResponse.value!.packages!.length,
      itemBuilder: (context, index) {
        double purchaseAmount = psychologyPlanController
            .psychologyPlansResponse.value!.packages![index]!.purchaseAmount!;

        double finalPurchaseAmount = purchaseAmount;

        double? offerAmount = psychologyPlanController
            .psychologyPlansResponse.value!.packages![index]!.offerAmount;

        if (offerAmount != null && offerAmount != 0) {
          finalPurchaseAmount = finalPurchaseAmount - offerAmount;
          if (psychologyPlanController
                  .psychologyPlansResponse.value!.packages![index]!.country ==
              "IN") {
            finalPurchaseAmount = finalPurchaseAmount.floorToDouble();
          }
        }

        return ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            hasIcon: false,
          ),
          collapsed: const Offstage(),
          header: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFCAFAF).withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                topRight: Radius.circular(16.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${psychologyPlanController.psychologyPlansResponse.value!.packages![index]!.sessions} Sessions",
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${psychologyPlanController.psychologyPlansResponse.value!.packages![index]!.displayText}",
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 12.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: finalPurchaseAmount != purchaseAmount,
                      child: Text(
                        purchaseAmount > 0
                            ? "${psychologyPlanController.psychologyPlansResponse.value!.packages![index]!.currency!.display} ${getFormattedNumber(purchaseAmount)}"
                            : "FREE".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      finalPurchaseAmount > 0
                          ? "${psychologyPlanController.psychologyPlansResponse.value!.packages![index]!.currency!.display} ${getFormattedNumber(finalPurchaseAmount)}"
                          : "FREE".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                        height: 1.h,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          expanded: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.w),
                bottomRight: Radius.circular(16.w),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(91, 112, 129, 0.07),
                  offset: Offset(0, 12),
                  blurRadius: 28,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What You Get",
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      psychologyPlanController.psychologyPlansResponse.value!
                          .packages![index]!.whatYouGet!.length, (descIndex) {
                    return Text(
                      "- ${psychologyPlanController.psychologyPlansResponse.value!.packages![index]!.whatYouGet![descIndex]}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor.withOpacity(0.7),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5.h,
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (() {
                      EventsService().sendEvent("Psychology_Plan_Selected", {
                        "package_name": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .packageName,
                        "package_type": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .packageType,
                        "purchase_type": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .purchaseType,
                        "consulting_charges": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .consultingCharges,
                        "is_percentage": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .isPercentage,
                        "discount": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .discount,
                        "purchase_amount": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .purchaseAmount,
                        "currency": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .currency!
                                .billing ??
                            "",
                        "package_id": psychologyPlanController
                            .psychologyPlansResponse
                            .value!
                            .packages![index]!
                            .packageId
                      });
                      Get.to(JuspayPayment(
                        pageSource: "MENTAL_WELLBEING",
                        totalPayment: finalPurchaseAmount,
                        currency: psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .currency!
                                .billing ??
                            "",
                        paymentEvent: "MENTAL_WELLBEING",
                        customData: {
                          "extendPlan": extendPlan,
                          "selectedPackage": {
                            "packageId": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .packageId,
                            "packageName": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .packageName,
                            "packageType": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .packageType,
                            "purchaseType": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .purchaseType,
                            "consultingCharges": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .consultingCharges,
                            "isPercentage": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .isPercentage,
                            "discount": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .discount,
                            "purchaseAmount": psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!
                                .purchaseAmount,
                            "sessions":psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!.sessions,
                            "duration":psychologyPlanController
                                .psychologyPlansResponse
                                .value!
                                .packages![index]!.duration,
                          },
                          "promoCodeDetails": {
                            "isApplied": psychologyPlanController
                                .isPromoCodeApplied.value,
                            "promoCode": {
                              "promoCodeId": psychologyPlanController
                                  .appliedPromoCode?.promoCodeId,
                              "promoCode": psychologyPlanController
                                  .appliedPromoCode?.promoCode,
                              "promoCodeName": psychologyPlanController
                                  .appliedPromoCode?.promoCodeName,
                              "accessType": psychologyPlanController
                                  .appliedPromoCode?.accessType,
                              "appUserCouponId": psychologyPlanController
                                  .appliedPromoCode?.appUserCouponId,
                            },
                          }
                        },
                      ));
                    }),
                    child: Text(
                      "Pay now",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 26.h,
        );
      },
    );
  }
}
