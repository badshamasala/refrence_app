import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  final String loginType;
  const SocialLoginButton({Key? key, required this.loginType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xFF7EE2BC);
    VerticalDivider firstDivider = VerticalDivider(
      width: 0.5.w,
    );
    VerticalDivider secondDivider = VerticalDivider(width: 0.5.w);
    SvgPicture svgPicture = SvgPicture.asset(AppIcons.googleSVG,
        width: 16, height: 16, color: AppColors.whiteColor);

    switch (loginType) {
      case "Google":
        color = const Color(0xFF4384E9);
        firstDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF2C74E5),
        );
        secondDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF5E97F1),
        );
        svgPicture = SvgPicture.asset(AppIcons.googleSVG,
            width: 16.w, height: 16.h, color: AppColors.whiteColor);
        break;
      case "Facebook":
        color = const Color(0xFF3D66BB);
        firstDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF2954AD),
        );
        secondDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF5A84D9),
        );
        svgPicture = SvgPicture.asset(AppIcons.facebookSVG,
            width: 16.w, height: 16.h, color: AppColors.whiteColor);
        break;
      case "Apple":
        color = const Color(0xFF000000);
        firstDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF000000),
        );
        secondDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF2D2D2D),
        );
        svgPicture = SvgPicture.asset(AppIcons.appleSVG,
            width: 16.w, height: 16.h, color: AppColors.whiteColor);
        break;
      case "Mobile Number":
        color = const Color(0xFF7EE2BC);
        firstDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFF47BF92),
        );
        secondDivider = VerticalDivider(
          width: 0.5.w,
          color: const Color(0xFFA4EED2),
        );
        svgPicture = SvgPicture.asset(AppIcons.mobileSVG,
            width: 16.w, height: 16.h, color: AppColors.whiteColor);
    }

    return Container(
      width: 292.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          32,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.w,
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: svgPicture,
              ),
              firstDivider,
              const SizedBox(
                width: 1,
              ),
              secondDivider,
            ],
          ),
          SizedBox(
            width: 292.w,
            child: Text(
              loginType,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.h,
              ),
            ),
          )
        ],
      ),
    );
  }
}
