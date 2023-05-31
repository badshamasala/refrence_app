import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RenewalPaymentSuccess extends StatelessWidget {
  final dynamic customData;
  const RenewalPaymentSuccess({Key? key, required this.customData})
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
                      height: 68.h,
                    ),
                    Text(
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
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      width: 226.w,
                      child: Text(
                        'The payment for your ${toTitleCase((customData["selectedPackage"]["packageType"] as String).toLowerCase())} renewal is complete.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2727272727272727.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36.h,
                    ),
                    SizedBox(
                      width: 120.w,
                      child: InkWell(
                        onTap: () async {
                          if (customData["renewalVia"] ==
                              "PREVIOUS_SUBSCRIPTION") {
                            Navigator.pop(context);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(
                                  selectedTab: 0,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: mainButton("Okay"),
                      ),
                    ),
                    SizedBox(
                      height: 46.h,
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
