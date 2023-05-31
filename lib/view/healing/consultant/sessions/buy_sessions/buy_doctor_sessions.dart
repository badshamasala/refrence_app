import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/widgets/apply_coupon.dart';
import 'package:aayu/view/subscription/offers/widgets/coupon_applied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BuyDoctorSessions extends StatelessWidget {
  final PageController pageController;
  const BuyDoctorSessions({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 43.h),
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
                  height: 96.h,
                ),
                Text(
                  "Doctor Consultation Sessions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    letterSpacing: 0.w,
                    fontWeight: FontWeight.normal,
                    height: 1.16.h,
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Padding(
                  padding: pageHorizontalPadding(),
                  child: Text(
                    "We recommend a monthly consultation to review your progress with a doctor specialising in Integrated Yoga Therapy.",
                    textAlign: TextAlign.center,
                    style: primaryFontSecondaryLabelSmallTextStyle(),
                  ),
                ),
                GetBuilder<PostAssessmentController>(
                    builder: (offerController) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    child: offerController.isPromoCodeApplied == false
                        ? ApplyCoupon(
                            offerOn: "DOCTOR SESSIONS",
                          )
                        : CouponApplied(
                            offerOn: "DOCTOR SESSIONS",
                            appliedPromoCode: offerController.appliedPromoCode!,
                            removeFunction: () {
                              offerController.removeCoupon("DOCTOR SESSIONS");
                            }),
                  );
                }),
                GetBuilder<PostAssessmentController>(
                    builder: (doctorPackageSelection) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          doctorPackageSelection
                              .consultingPackageResponse
                              .value!
                              .consultingPackages!
                              .doctorPackages!
                              .length, (index) {
                        if (doctorPackageSelection
                                .consultingPackageResponse
                                .value!
                                .consultingPackages!
                                .doctorPackages![index]!
                                .enabled ==
                            false) {
                          return const Offstage();
                        }
                        double purchaseAmount = doctorPackageSelection
                            .consultingPackageResponse
                            .value!
                            .consultingPackages!
                            .doctorPackages![index]!
                            .purchaseAmount!;

                        double finalPurchaseAmount = purchaseAmount;

                        double? offerAmount = doctorPackageSelection
                            .consultingPackageResponse
                            .value!
                            .consultingPackages!
                            .doctorPackages![index]!
                            .offerAmount;

                        if (offerAmount != null && offerAmount != 0) {
                          finalPurchaseAmount =
                              finalPurchaseAmount - offerAmount;
                          if (doctorPackageSelection
                                  .consultingPackageResponse
                                  .value!
                                  .consultingPackages!
                                  .doctorPackages![index]!
                                  .country ==
                              "IN") {
                            finalPurchaseAmount =
                                finalPurchaseAmount.floorToDouble();
                          }
                        }

                        bool isSelected = doctorPackageSelection
                            .consultingPackageResponse
                            .value!
                            .consultingPackages!
                            .doctorPackages![index]!
                            .isSelected!;

                        int sessions = doctorPackageSelection
                                .consultingPackageResponse
                                .value!
                                .consultingPackages!
                                .doctorPackages![index]!
                                .sessions ??
                            0;

                        return InkWell(
                          onTap: () {
                            doctorPackageSelection
                                .setDoctorTrainingOption(index);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 16.w, right: 32.w),
                            margin: EdgeInsets.only(bottom: 18.h),
                            height: 63.h,
                            width: 290.w,
                            decoration: BoxDecoration(
                              color: isSelected == true
                                  ? AppColors.whiteColor
                                  : AppColors.lightSecondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.w),
                              ),
                              boxShadow: (isSelected)
                                  ? const [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(89, 115, 147, 0.32),
                                        offset: Offset(0, 12),
                                        blurRadius: 28,
                                        spreadRadius: 0,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleCheckbox(
                                  activeColor: AppColors.primaryColor,
                                  inactiveColor: AppColors.whiteColor,
                                  value: isSelected,
                                  onChanged: (value) {
                                    doctorPackageSelection
                                        .setDoctorTrainingOption(index);
                                  },
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                SizedBox(
                                  width: 103.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$sessions ${sessions <= 1 ? "Session" : "Sessions"}",
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
                                        doctorPackageSelection
                                                .consultingPackageResponse
                                                .value!
                                                .consultingPackages!
                                                .doctorPackages![index]!
                                                .duration!
                                                .display ??
                                            "",
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
                                          color: const Color(0xFFB7BFC7)
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible:
                                          finalPurchaseAmount != purchaseAmount,
                                      child: Text(
                                        purchaseAmount > 0
                                            ? "${doctorPackageSelection.consultingPackageResponse.value!.consultingPackages!.doctorPackages![index]!.currency!.display} ${getFormattedNumber(purchaseAmount)}"
                                            : "FREE".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.secondaryLabelColor,
                                          fontFamily: 'Circular Std',
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 14.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.h,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      finalPurchaseAmount > 0
                                          ? "${doctorPackageSelection.consultingPackageResponse.value!.consultingPackages!.doctorPackages![index]!.currency!.display} ${getFormattedNumber(finalPurchaseAmount)}"
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
                        );
                      }),
                    ),
                  );
                }),
                GetBuilder<PostAssessmentController>(
                    builder: (buttonController) {
                  bool isSelected = false;
                  ConsultingPackagesModelConsultingPackagesDoctorPackages?
                      selectedPackage;
                  for (var element in buttonController.consultingPackageResponse
                      .value!.consultingPackages!.doctorPackages!) {
                    if (element!.isSelected == true) {
                      isSelected = true;
                      selectedPackage = element;
                      break;
                    }
                  }
                  return InkWell(
                    onTap: isSelected == true
                        ? () {
                            EventsService()
                                .sendEvent("Doctor_Payment_Selection", {
                              "package_name": selectedPackage!.packageName,
                              "consult_type": selectedPackage.consultType,
                              "purchase_type": selectedPackage.purchaseType,
                              "sessions": selectedPackage.sessions,
                              "consulting_charges":
                                  selectedPackage.consultingCharges,
                              "is_percentage": selectedPackage.isPercentage,
                              "discount": selectedPackage.discount,
                              "purchase_amount": selectedPackage.purchaseAmount,
                              "recommended": selectedPackage.recommended,
                              "consulting_package_id":
                                  selectedPackage.consultingPackageId
                            });
                            pageController.nextPage(
                                duration: Duration(
                                    milliseconds: defaultAnimateToPageDuration),
                                curve: Curves.easeIn);
                          }
                        : null,
                    child: SizedBox(
                      width: 320.w,
                      child: isSelected == true
                          ? mainButton("Proceed")
                          : disabledButton("Proceed"),
                    ),
                  );
                }),
                SizedBox(
                  height: 18.h,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0.h,
          left: 0.w,
          right: 0,
          child: Image(
            width: 180.w,
            height: 125.h,
            image: const AssetImage(Images.doctorConsultant3Image),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 58.h,
          right: 20.w,
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                EventsService().sendEvent(
                    "Doctor_Payment_Close", {"consult_type": "Doctor"});
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
