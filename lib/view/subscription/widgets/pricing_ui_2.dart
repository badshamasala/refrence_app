import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/payment/subscription.packages.model.dart';
import '../../../theme/app_colors.dart';
import '../../shared/circle_check_box.dart';
import '../../shared/ui_helper/images.dart';
import '../../shared/ui_helper/ui_helper.dart';

class PricingUI2 extends StatelessWidget {
  final int index;
  final SupcriptionPackagesModelSubscriptionPackages package;
  final SubscriptionPackageController subscriptionPackageController;

  final bool addShadow;
  const PricingUI2(
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
    double finalPurchaseAmount = package.purchaseAmount!;
    double? offerAmount = package.offerAmount;

    if (offerAmount != null && offerAmount > 0) {
      finalPurchaseAmount = finalPurchaseAmount - offerAmount;
    }
    if (package.country == "IN") {
      finalPurchaseAmount = finalPurchaseAmount.floorToDouble();
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
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
              boxShadow: addShadow && (package.isSelected ?? false)
                  ? [
                      const BoxShadow(
                        color: Color.fromRGBO(91, 112, 129, 0.25),
                        offset: Offset(1, 4),
                        blurRadius: 16,
                      )
                    ]
                  : null,
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.w)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.w),
                    topRight: Radius.circular(16.w),
                  ),
                  color:
                      const Color.fromRGBO(252, 175, 175, 0.5).withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        package.packageName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    if (package.recommended ?? false)
                      showRecommended(package.recommendedText ?? "")
                  ],
                ),
              ),
              SizedBox(
                height: 19.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  if (package.description != null)
                                    SizedBox(
                                      height: 3.h,
                                    ),
                                  if (package.description != null)
                                    Text(
                                      package.description ?? "",
                                      style: TextStyle(
                                        color: const Color.fromRGBO(
                                            91, 112, 129, 0.6),
                                        fontFamily: 'Circular Std',
                                        fontSize: 11.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w400,
                                        height: 1.h,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 3.h,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: subscriptionPackageController
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
                                      fontSize: 12.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1.h,
                                    ),
                                  ),
                                ),
                                Text(
                                  finalPurchaseAmount > 0
                                      ? "${package.currency!.display}${getFormattedNumber(finalPurchaseAmount)}"
                                      : "FREE".tr,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: const Color(0xFF2E2E2E),
                                    fontFamily: 'Circular Std',
                                    fontSize: 18.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    height: 1.h,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              if (showDoctor || showTherapist)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(241, 241, 241, 0.3)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Free Add-ons:',
                        style: TextStyle(
                            color: const Color.fromRGBO(91, 112, 129, 0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                      ),
                      SizedBox(
                        width: 18.h,
                      ),
                      if (showDoctor)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Images.doctorConsultant3Image,
                              height: 25.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Text(
                              'x ${package.sessions!.doctor}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackAssessmentColor),
                            )
                          ],
                        ),
                      if (showTherapist && showDoctor)
                        Container(
                          height: 21.h,
                          width: 0.15.w,
                          color: AppColors.blueGreyAssessmentColor,
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                        ),
                      if (showTherapist)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Images.personalTrainingImageGrey,
                              height: 25.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Text(
                              'x ${package.sessions!.therapist}',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackAssessmentColor),
                            )
                          ],
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

showRecommended(String? recommendedText) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFFAAFDB4),
      borderRadius: BorderRadius.circular(4.w),
    ),
    child: Center(
      child: Text(
        (recommendedText != null && recommendedText.isNotEmpty)
            ? recommendedText.toUpperCase()
            : "RECOMMENDED".tr,
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
