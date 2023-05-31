// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/nutrition/nutrition_plan_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/doctor_controller.dart';
import '../../../../controller/consultant/personal_trainer_controller.dart';
import '../../../../controller/payment/subscription_package_controller.dart';
import '../../../../model/subscription/promo.code.model.dart';
import '../../../../services/payment.service.dart';
import '../../../../theme/app_colors.dart';

class PriceAfterDiscountBottomSheet extends StatefulWidget {
  final PromoCodesModelPromoCodes? promoCode;
  final bool active;
  final String offerOn;
  const PriceAfterDiscountBottomSheet({
    Key? key,
    this.promoCode,
    required this.active,
    required this.offerOn,
  }) : super(key: key);

  @override
  State<PriceAfterDiscountBottomSheet> createState() =>
      _PriceAfterDiscountBottomSheetState();
}

class _PriceAfterDiscountBottomSheetState
    extends State<PriceAfterDiscountBottomSheet> {
  bool isApplyLoading = false;
  Future<void> applyCounCode() async {
    setState(() {
      isApplyLoading = true;
    });
    bool applyOffer = await PaymentService()
        .applyPromoCode(widget.promoCode?.promoCodeId ?? "");
    setState(() {
      isApplyLoading = false;
    });
    if (applyOffer) {
      EventsService().sendEvent("Promo_Code_Applied", {
        "offer_on": widget.offerOn,
        "promo_code_id": widget.promoCode!.promoCodeId ?? "",
        "promo_code": widget.promoCode!.promoCode ?? "",
        "title": widget.promoCode!.title ?? "",
      });
      switch (widget.offerOn) {
        case "DOCTOR CONSULTATION":
          DoctorController doctorController = Get.find();
          doctorController.applyCouponOffers(widget.promoCode);
          break;
        case "THERAPIST CONSULTATION":
          PersonalTrainerController personalTrainerController = Get.find();
          personalTrainerController.applyCouponOffers(widget.promoCode);
          break;
        case "DOCTOR SESSIONS":
          PostAssessmentController postAssessmentController = Get.find();
          postAssessmentController.applyCouponOffers(widget.promoCode);
          break;
        case "TRAINER SESSIONS":
          PostAssessmentController postAssessmentController = Get.find();
          postAssessmentController.applyCouponOffers(widget.promoCode);
          break;
        case "NUTRITION PLANS":
          NutritionPlanController nutritionPlanController = Get.find();
          nutritionPlanController.applyCouponOffers(widget.promoCode);
          break;
        default:
          SubscriptionPackageController subscriptionPackageController =
              Get.find();
          subscriptionPackageController.applyCouponOffers(widget.promoCode);
      }
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> listTextSpan = [];
    List<String>? list = (widget.promoCode!.subTitle ?? "").split('<b>');
    for (int i = 0; i < list.length; i++) {
      if (i % 2 == 0) {
        listTextSpan.add(TextSpan(text: list[i]));
      } else {
        listTextSpan.add(
          TextSpan(
              text: list[i],
              style: const TextStyle(fontWeight: FontWeight.w700)),
        );
      }
    }
    return Stack(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 39.h,
              ),
              Text(
                widget.promoCode!.title ?? "",
                style: TextStyle(
                  fontFamily: 'Baskerville',
                  fontWeight: FontWeight.w400,
                  fontSize: 24.sp,
                  color: AppColors.blackLabelColor,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    children: listTextSpan),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: List.generate(
                    50,
                    (index) => Expanded(
                          child: Container(
                            color: index % 2 == 0
                                ? Colors.transparent
                                : Colors.grey[350],
                            height: 1,
                          ),
                        )),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Coupon Code:',
                        style: TextStyle(
                          color: const Color(0xFF597393),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.promoCode!.promoCode ?? "",
                        style: TextStyle(
                          color: const Color(0xFF597393),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  widget.active == true
                      ? isApplyLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                applyCounCode();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 26.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 3.h,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.05),
                                    )
                                  ],
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'APPLY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                      : Text(
                          'Not Applicable',
                          style: TextStyle(
                              color: const Color(0xFFC3C5C7),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp),
                        )
                ],
              ),
              SizedBox(
                height: 26.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.promoCode?.desc != null &&
                      widget.promoCode!.desc!.isNotEmpty)
                    Text(
                      'How to avail?',
                      style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp),
                    ),
                  SizedBox(
                    height: 15.h,
                  ),
                  if (widget.promoCode?.desc != null &&
                      widget.promoCode!.desc!.isNotEmpty)
                    ...List.generate(
                      widget.promoCode!.desc!.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.done_rounded,
                              color: AppColors.primaryColor,
                              size: 15.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                widget.promoCode!.desc?[index] ?? "",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(
                                        91, 112, 129, 0.8)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 26.h,
                  ),
                  if (widget.promoCode?.tnc != null &&
                      widget.promoCode!.tnc!.isNotEmpty)
                    Text(
                      'Terms and Conditions',
                      style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp),
                    ),
                  SizedBox(
                    height: 15.h,
                  ),
                  if (widget.promoCode?.tnc != null &&
                      widget.promoCode!.tnc!.isNotEmpty)
                    ...List.generate(
                      widget.promoCode!.tnc!.length,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.done_rounded,
                              color: AppColors.primaryColor,
                              size: 15.h,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Text(
                                widget.promoCode!.tnc?[index] ?? "",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(
                                        91, 112, 129, 0.8)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 26.h,
                  ),
                ],
              ),
            ]),
      ),
      Positioned(
        top: 10.h,
        right: 10.h,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            color: AppColors.blackLabelColor,
          ),
        ),
      )
    ]);
  }
}
