import 'package:aayu/model/subscription/promo.code.model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponApplied extends StatelessWidget {
  final PromoCodesModelPromoCodes appliedPromoCode;
  final Function removeFunction;
  final String offerOn;
  const CouponApplied(
      {Key? key,
      required this.appliedPromoCode,
      required this.removeFunction,
      required this.offerOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: 322.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.w)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(64, 117, 205, 0.07999999821186066),
            offset: Offset(0, 10),
            blurRadius: 20,
          )
        ],
        color: Color.fromRGBO(222, 226, 235, 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            Images.offerAppliedImage,
            width: 29.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: 12.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appliedPromoCode.promoCode ?? "",
                style: TextStyle(
                  color: Color(0xFF496074),
                  fontFamily: 'Circular Std',
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Coupon applied",
                style: TextStyle(
                  color: Color(0xFF496074),
                  fontFamily: 'Circular Std',
                  fontSize: 12.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              removeFunction();
              EventsService().sendEvent("Coupon_Applied_Removed", {
                "offer_on": offerOn,
                "promo_code_id": appliedPromoCode.promoCodeId ?? "",
                "promo_code": appliedPromoCode.promoCode ?? "",
                "title": appliedPromoCode.title ?? "",
              });
            },
            child: Text(
              "REMOVE",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
