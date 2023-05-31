import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_plan_controller.dart';
import 'package:aayu/controller/consultant/personal_trainer_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/subscription/offers/widgets/price_after_discount_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../model/subscription/promo.code.model.dart';
import '../../../../services/payment.service.dart';

class OffersTile extends StatefulWidget {
  final PromoCodesModelPromoCodes? promoCode;
  final String offerOn;
  final bool active;
  const OffersTile(
      {Key? key, this.promoCode, required this.active, required this.offerOn})
      : super(key: key);

  @override
  State<OffersTile> createState() => _OffersTileState();
}

class _OffersTileState extends State<OffersTile> {
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
        "promo_code_id": widget.promoCode?.promoCodeId ?? "",
        "promo_code": widget.promoCode?.promoCode ?? "",
        "title": widget.promoCode?.title ?? "",
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.promoCode == null) {
      return const Offstage();
    }
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
        widget.active
            ? 'assets/images/subscription/${widget.promoCode?.theme?.template ?? "offer-tile-pink"}.png'
            : 'assets/images/subscription/offer-tile-grey.png',
      ))),
      height: 240.h,
      padding:
          EdgeInsets.only(top: 27.h, bottom: 16.h, left: 26.w, right: 26.w),
      margin: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
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
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
          InkWell(
            onTap: () {
              EventsService().sendEvent(
                  widget.active
                      ? "Promo_Code_ViewPrice_Clicked"
                      : "Promo_Code_More_Clicked",
                  {
                    "offer_on": widget.offerOn,
                    "promo_code_id": widget.promoCode?.promoCodeId ?? "",
                    "promo_code": widget.promoCode?.promoCode ?? "",
                    "title": widget.promoCode?.title ?? "",
                    "coupon_type":
                        widget.active ? "Active Coupons" : "Other Coupons"
                  });
              Get.bottomSheet(
                PriceAfterDiscountBottomSheet(
                  active: widget.active,
                  promoCode: widget.promoCode,
                  offerOn: widget.offerOn,
                ),
                isScrollControlled: false,
              );
            },
            child: Text(
              'More',
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                decoration: TextDecoration.underline,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Spacer(),
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
              widget.active
                  ? isApplyLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : InkWell(
                          onTap: applyCounCode,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 3.h,
                                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                                )
                              ],
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'APPLY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
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
          )
        ],
      ),
    );
  }
}
