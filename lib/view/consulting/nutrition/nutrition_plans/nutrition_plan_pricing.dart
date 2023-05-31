import 'package:aayu/controller/consultant/nutrition/nutrition_plan_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NutritionPlanPricing extends StatelessWidget {
  final NutritionPlanController nutritionPlanController;
  final String coachId;
  final bool extendPlan;
  const NutritionPlanPricing(
      {Key? key,
      required this.nutritionPlanController,
      required this.coachId,
      required this.extendPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: pagePadding(),
      physics: const BouncingScrollPhysics(),
      itemCount: nutritionPlanController
          .nutritionPlansResponse.value!.packages!.length,
      itemBuilder: (context, index) {
        double purchaseAmount = nutritionPlanController
            .nutritionPlansResponse.value!.packages![index]!.purchaseAmount!;

        double finalPurchaseAmount = purchaseAmount;

        double? offerAmount = nutritionPlanController
            .nutritionPlansResponse.value!.packages![index]!.offerAmount;

        if (offerAmount != null && offerAmount != 0) {
          finalPurchaseAmount = finalPurchaseAmount - offerAmount;
          if (nutritionPlanController
                  .nutritionPlansResponse.value!.packages![index]!.country ==
              "IN") {
            finalPurchaseAmount = finalPurchaseAmount.floorToDouble();
          }
        }

        return InkWell(
          onTap: (() {
            EventsService().sendEvent(
                extendPlan == true
                    ? "Extend_Nutrition_Plan_Selected"
                    : "Nutrition_Plan_Selected",
                {
                  "package_name": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.packageName,
                  "package_type": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.packageType,
                  "purchase_type": nutritionPlanController
                      .nutritionPlansResponse
                      .value!
                      .packages![index]!
                      .purchaseType,
                  "consulting_charges": nutritionPlanController
                      .nutritionPlansResponse
                      .value!
                      .packages![index]!
                      .consultingCharges,
                  "is_percentage": nutritionPlanController
                      .nutritionPlansResponse
                      .value!
                      .packages![index]!
                      .isPercentage,
                  "discount": nutritionPlanController
                      .nutritionPlansResponse.value!.packages![index]!.discount,
                  "purchase_amount": nutritionPlanController
                      .nutritionPlansResponse
                      .value!
                      .packages![index]!
                      .purchaseAmount,
                  "currency": nutritionPlanController.nutritionPlansResponse
                          .value!.packages![index]!.currency!.billing ??
                      "",
                  "package_id": nutritionPlanController
                      .nutritionPlansResponse.value!.packages![index]!.packageId
                });
            Get.to(JuspayPayment(
              pageSource: "NUTRITION_CONSULTATION",
              totalPayment: finalPurchaseAmount,
              currency: nutritionPlanController.nutritionPlansResponse.value!
                      .packages![index]!.currency!.billing ??
                  "",
              paymentEvent: "NUTRITION_CONSULTATION",
              customData: {
                "coachId": coachId,
                "extendPlan": extendPlan,
                "selectedPackage": {
                  "packageId": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.packageId,
                  "packageName": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.packageName,
                  "packageType": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.packageType,
                  "purchaseType": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.purchaseType,
                  "consultingCharges": nutritionPlanController
                      .nutritionPlansResponse
                      .value!
                      .packages![index]!
                      .consultingCharges,
                  "isPercentage": nutritionPlanController.nutritionPlansResponse
                      .value!.packages![index]!.isPercentage,
                  "discount": nutritionPlanController
                      .nutritionPlansResponse.value!.packages![index]!.discount,
                  "purchaseAmount": nutritionPlanController
                      .nutritionPlansResponse
                      .value!
                      .packages![index]!
                      .purchaseAmount,
                  "sessions": nutritionPlanController
                      .nutritionPlansResponse.value!.packages![index]!.sessions,
                  "dietPlans": nutritionPlanController
                      .nutritionPlansResponse.value!.packages![index]!.dietPlans,
                  "duration": nutritionPlanController
                      .nutritionPlansResponse.value!.packages![index]!.duration,
                },
                "promoCodeDetails": {
                  "isApplied": nutritionPlanController.isPromoCodeApplied.value,
                  "promoCode": {
                    "promoCodeId":
                        nutritionPlanController.appliedPromoCode?.promoCodeId,
                    "promoCode":
                        nutritionPlanController.appliedPromoCode?.promoCode,
                    "promoCodeName":
                        nutritionPlanController.appliedPromoCode?.promoCodeName,
                    "accessType":
                        nutritionPlanController.appliedPromoCode?.accessType,
                    "appUserCouponId": nutritionPlanController
                        .appliedPromoCode?.appUserCouponId,
                  },
                }
              },
            ));
          }),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (nutritionPlanController.nutritionPlansResponse.value
                      ?.packages?[index]?.recommended ??
                  false)
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFAAFDB4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      )),
                  padding: EdgeInsets.only(top: 6.h, left: 6.h, right: 6.h),
                  child: Text(
                    "RECOMMENDED",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 8.sp,
                        color: AppColors.blueGreyAssessmentColor),
                  ),
                ),
              Container(
                width: 322.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16.w),
                  border: (nutritionPlanController.nutritionPlansResponse.value
                              ?.packages?[index]?.recommended ??
                          false)
                      ? Border.all(color: const Color(0xFFAAFDB4), width: 2.h)
                      : null,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(89, 115, 147, 0.32),
                      offset: Offset(0, 12),
                      blurRadius: 28,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
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
                          Text(
                            "${nutritionPlanController.nutritionPlansResponse.value!.packages![index]!.displayText}",
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 16.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: finalPurchaseAmount != purchaseAmount,
                                child: Text(
                                  purchaseAmount > 0
                                      ? "${nutritionPlanController.nutritionPlansResponse.value!.packages![index]!.currency!.display} ${getFormattedNumber(purchaseAmount)}"
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
                                    ? "${nutritionPlanController.nutritionPlansResponse.value!.packages![index]!.currency!.display} ${getFormattedNumber(finalPurchaseAmount)}"
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
                    SizedBox(
                      height: 16.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            nutritionPlanController
                                .nutritionPlansResponse
                                .value!
                                .packages![index]!
                                .whatYouGet!
                                .length, (descIndex) {
                          return Text(
                            "- ${nutritionPlanController.nutritionPlansResponse.value!.packages![index]!.whatYouGet![descIndex]}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor
                                  .withOpacity(0.7),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.5.h,
                            ),
                          );
                        }),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Pay now",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
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
            ],
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
