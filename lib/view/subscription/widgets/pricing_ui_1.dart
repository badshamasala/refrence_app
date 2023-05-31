import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/payment/subscription.packages.model.dart';
import '../../../theme/app_colors.dart';
import '../../shared/circle_check_box.dart';
import '../../shared/ui_helper/ui_helper.dart';

class PricingUI1 extends StatelessWidget {
  final int index;
  final SupcriptionPackagesModelSubscriptionPackages package;
  final SubscriptionPackageController subscriptionPackageController;

  final bool addShadow;
  const PricingUI1(
      {Key? key,
      required this.addShadow,
      required this.package,
      required this.index,
      required this.subscriptionPackageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showTherapist = false;
    bool showDoctor = false;
    bool showSubscriptionPrice =
        package.subscriptionCharges != package.purchaseAmount;

    double finalPurchaseAmount = package.purchaseAmount!;

    double? offerAmount = package.offerAmount;

    if (offerAmount != null && offerAmount > 0) {
      finalPurchaseAmount = finalPurchaseAmount - offerAmount;
    }
    package.finalPurchaseAmount = finalPurchaseAmount;

    if (package.sessions != null) {
      showTherapist = package.sessions!.therapist! >= 1;
      showDoctor = package.sessions!.doctor! >= 1;
    }
    return InkWell(
      onTap: () {
        subscriptionPackageController.setSelection(index);
      },
      child: Opacity(
        opacity: package.isSelected ?? false ? 1 : 0.6,
        child: Container(
          width: 322.w,
          height: package.isSelected ?? false
              ? 82.h +
                  ((showDoctor && showTherapist)
                      ? 40.h
                      : (showDoctor || showTherapist)
                          ? 30.h
                          : package.recommended ?? false
                              ? 20.h
                              : 0)
              : 64.h +
                  ((showDoctor && showTherapist)
                      ? 40.h
                      : (showDoctor || showTherapist)
                          ? 30.h
                          : package.recommended ?? false
                              ? 20.h
                              : 0),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
              boxShadow: addShadow
                  ? [
                      BoxShadow(
                          color: Color.fromRGBO(91, 112, 129, 0.16),
                          offset: Offset(1, 4),
                          blurRadius: 16)
                    ]
                  : null,
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.w)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  CircleCheckbox(
                    activeColor: AppColors.primaryColor,
                    inactiveColor: AppColors.whiteColor,
                    value: package.isSelected ?? false,
                    onChanged: (value) {
                      subscriptionPackageController.setSelection(index);
                    },
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    package.displayText ?? "",
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      height: 1.h,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: showSubscriptionPrice,
                              child: Text(
                                '${package.currency!.display}${getFormattedNumber(package.subscriptionCharges!)}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF9F9F9F),
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'Circular Std',
                                  fontSize: 16.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.h,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: showSubscriptionPrice == false &&
                                  subscriptionPackageController
                                          .isPromoCodeApplied ==
                                      true &&
                                  getFormattedNumber(finalPurchaseAmount) !=
                                      getFormattedNumber(
                                          package.purchaseAmount!),
                              child: Text(
                                '${package.currency!.display}${getFormattedNumber(package.purchaseAmount!)}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF9F9F9F),
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'Circular Std',
                                  fontSize: 16.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3.h,
                            ),
                            Text(
                              finalPurchaseAmount > 0
                                  ? "${package.currency!.display}${getFormattedNumber(finalPurchaseAmount)}"
                                  : "FREE".tr,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF2E2E2E),
                                fontFamily: 'Circular Std',
                                fontSize: 24.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w700,
                                height: 1.h,
                              ),
                            ),
                          ]),
                      if (package.recommended ?? false)
                        Positioned(
                            right: 0, bottom: -20.h, child: showRecommended())
                    ],
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
              if (showDoctor || showTherapist)
                Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDoctor)
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: '${package.sessions!.doctor} Free',
                                style: TextStyle(
                                  color: AppColors.blackLabelColor,
                                  fontSize: 13.sp,
                                  fontFamily: "Circular Std",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text: " Doctor Consultation",
                              ),
                            ],
                          ),
                        ),
                      if (showTherapist)
                        SizedBox(
                          height: 8.h,
                        ),
                      if (showTherapist)
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: '${package.sessions!.therapist} Free',
                                style: TextStyle(
                                  color: AppColors.blackLabelColor,
                                  fontSize: 13.sp,
                                  fontFamily: "Circular Std",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " Yoga Therapist ${package.sessions!.therapist! > 1 ? 'Sessions' : 'Session'}",
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

showRecommended() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFFAAFDB4),
      borderRadius: BorderRadius.circular(4.w),
    ),
    child: Center(
      child: Text(
        "RECOMMENDED".tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.secondaryLabelColor,
          fontFamily: 'Circular Std',
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          height: 1.4.h,
        ),
      ),
    ),
  );
}
