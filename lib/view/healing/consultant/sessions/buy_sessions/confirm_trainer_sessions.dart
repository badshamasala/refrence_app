import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmTrainerSessions extends StatelessWidget {
  final PageController pageController;
  const ConfirmTrainerSessions({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostAssessmentController postAssessmentController = Get.find();
    ConsultingPackagesModelConsultingPackagesTherapistPackages?
        selectedPackage = postAssessmentController.consultingPackageResponse
            .value!.consultingPackages!.therapistPackages!
            .firstWhereOrNull((element) => element!.isSelected == true);

    if (selectedPackage == null) {
      return const Offstage();
    }

    double finalPurchaseAmount = selectedPackage.purchaseAmount!;
    if (selectedPackage.offerAmount != null &&
        selectedPackage.offerAmount! > 0) {
      finalPurchaseAmount = finalPurchaseAmount - selectedPackage.offerAmount!;
      if (selectedPackage.country == "IN") {
        finalPurchaseAmount = finalPurchaseAmount.floorToDouble();
      }
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.pageBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.w),
              topRight: Radius.circular(30.w),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 56.h,
                ),
                SizedBox(
                  width: 265.w,
                  child: Text(
                    "Confirm your therapist consultation session bookings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.16.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 32.w, right: 32.w),
                  margin: EdgeInsets.only(bottom: 18.h),
                  height: 63.h,
                  width: 290.w,
                  decoration: BoxDecoration(
                    color: AppColors.lightSecondaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.w),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 103.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedPackage.displayText!.split("/")[0],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontFamily: 'Circular Std',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.5.h,
                              ),
                            ),
                            Text(
                              selectedPackage.displayText!.split("/")[1],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontFamily: 'Circular Std',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                                height: 1.5.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 31.h,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1.0,
                              color: const Color(0xFFB7BFC7).withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: finalPurchaseAmount !=
                                selectedPackage.purchaseAmount,
                            child: Text(
                              selectedPackage.purchaseAmount! > 0
                                  ? "${selectedPackage.currency!.display} ${getFormattedNumber(selectedPackage.purchaseAmount!)}"
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
                          Text(
                            finalPurchaseAmount > 0
                                ? "${selectedPackage.currency!.display} ${getFormattedNumber(finalPurchaseAmount)}"
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
                InkWell(
                  onTap: () async {
                    double finalPurchaseAmount =
                        selectedPackage.purchaseAmount!;
                    if (selectedPackage.offerAmount != null &&
                        selectedPackage.offerAmount! > 0) {
                      finalPurchaseAmount =
                          finalPurchaseAmount - selectedPackage.offerAmount!;
                      if (selectedPackage.country == "IN") {
                        finalPurchaseAmount =
                            finalPurchaseAmount.floorToDouble();
                      }
                    }
                    EventsService().sendEvent("Therapist_Payment_Selected", {
                      "package_name": selectedPackage.packageName,
                      "consult_type": selectedPackage.consultType,
                      "purchase_type": selectedPackage.purchaseType,
                      "sessions": selectedPackage.sessions,
                      "consulting_charges": selectedPackage.consultingCharges,
                      "is_percentage": selectedPackage.isPercentage,
                      "discount": selectedPackage.discount,
                      "purchase_amount": selectedPackage.purchaseAmount,
                      "currency": selectedPackage.currency!.billing ?? "",
                      "recommended": selectedPackage.recommended,
                      "consulting_package_id":
                          selectedPackage.consultingPackageId
                    });

                    Navigator.pop(context);

                    Get.to(JuspayPayment(
                      pageSource: "CONSULTATION_PAYMENT",
                      totalPayment: finalPurchaseAmount,
                      currency: selectedPackage.currency!.billing ?? "",
                      paymentEvent: "THERAPIST_CONSULTATION",
                      customData: {
                        "consultationType": "Therapist",
                        "consultingPackageId":
                            selectedPackage.consultingPackageId,
                        "sessions": selectedPackage.sessions,
                        "selectedConsultingPackage": selectedPackage.toJson(),
                        "promoCodeDetails": {
                          "isApplied":
                              postAssessmentController.isPromoCodeApplied.value,
                          "promoCode": {
                            "promoCodeId": postAssessmentController
                                .appliedPromoCode?.promoCodeId,
                            "promoCode": postAssessmentController
                                .appliedPromoCode?.promoCode,
                            "promoCodeName": postAssessmentController
                                .appliedPromoCode?.promoCodeName,
                            "accessType": postAssessmentController
                                .appliedPromoCode?.accessType,
                            "appUserCouponId": postAssessmentController
                                .appliedPromoCode?.appUserCouponId,
                          },
                        }
                      },
                    ));
                  },
                  child: SizedBox(
                    width: 320.w,
                    child: mainButton("Pay Now"),
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 22.h,
          left: 22.w,
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                pageController.previousPage(
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeOut);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
