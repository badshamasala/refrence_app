import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PsychologyExtendPlanPaymentSuccess extends StatelessWidget {
  final String pageSource;
  final String paymentEvent;
  final double totalPayment;
  final String currency;
  final dynamic customData;
  const PsychologyExtendPlanPaymentSuccess(
      {Key? key,
      required this.pageSource,
      required this.paymentEvent,
      required this.totalPayment,
      required this.currency,
      required this.customData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Wrap(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 62.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.pageBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    SizedBox(
                      width: 265.w,
                      child: Text(
                        'Your payment is done!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Baskerville',
                          fontSize: 22.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2727272727272727.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      width: 286.w,
                      child: Text(
                        "Your payment for the mental wellbeing package was processed successfully.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2727272727272727.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      width: 230.w,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: mainButton("Okay"),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0.w,
                right: 0,
                child: Image(
                  width: 113.33.w,
                  height: 104.h,
                  image: const AssetImage(Images.paymentSuccessImage),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
