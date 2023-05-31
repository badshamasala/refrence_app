import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumContent extends StatelessWidget {
  final bool isPremiumContent;
  final bool showFull;
  final Color color;
  const PremiumContent(
      {Key? key,
      required this.isPremiumContent,
      required this.color,
      this.showFull = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool showPremium = false;
    // if (isPremiumContent == true) {
    //   if (subscriptionCheckResponse != null &&
    //       subscriptionCheckResponse!.subscriptionDetails != null &&
    //       subscriptionCheckResponse!
    //           .subscriptionDetails!.subscriptionId!.isNotEmpty) {
    //     showPremium = false;
    //   } else {
    //     showPremium = true;
    //   }
    // }
    if (showFull) {
      return isPremiumContent == true
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Color.fromRGBO(170, 253, 180, 0.8),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Premium",
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp),
                  ),
                  SizedBox(
                    width: 5.6.w,
                  ),
                  SvgPicture.asset(
                    AppIcons.premiumIconSVG,
                    height: 14.h,
                    fit: BoxFit.fitHeight,
                    color: color,
                  ),
                ],
              ))
          : const Offstage();
    }

    return isPremiumContent == true
        ? SvgPicture.asset(
            AppIcons.premiumIconSVG,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.fill,
            color: color,
          )
        : const Offstage();
  }
}
