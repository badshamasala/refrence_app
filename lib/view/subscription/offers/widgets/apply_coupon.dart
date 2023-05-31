import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/aayu_offers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplyCoupon extends StatelessWidget {
  final String offerOn;
  const ApplyCoupon({Key? key, required this.offerOn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EventsService().sendEvent("Apply_Coupon_Clicked", {
          "offer_on": offerOn,
        });
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AayuOffers(
            offerOn: offerOn,
          ),
        ));
      },
      child: Container(
        height: 54.h,
        width: 322.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.w)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(64, 117, 205, 0.07999999821186066),
              offset: Offset(0, 10),
              blurRadius: 20,
            )
          ],
          color: const Color.fromRGBO(222, 226, 235, 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              Images.applyOfferPercentImage,
              width: 29.w,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              "Apply Coupon",
              style: TextStyle(
                color: const Color(0xFF496074),
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_right,
              size: 26.w,
              color: const Color(0xFF5C6979),
            ),
          ],
        ),
      ),
    );
  }
}
