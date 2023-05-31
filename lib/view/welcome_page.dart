import 'package:aayu/controller/onboarding/welcomePageController.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WelComePage extends StatelessWidget {
  const WelComePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WelcomePageController welcomePageController =
        Get.put(WelcomePageController());
    // checkUserLoginStatus(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SvgPicture.asset(
                  AppIcons.aayuOnboardingIconSVG,
                  width: 32.59.w,
                  height: 42.24.h,
                ),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  (welcomePageController.userName.value.isEmpty)
                      ? "Welcome to Aayu"
                      : "Welcome Back\n${welcomePageController.userName.value}!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                    height: 1.2.h,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        welcomePageController.welcomeQuote.value.quote ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 18.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.2.h,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        welcomePageController.welcomeQuote.value.author ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Baskerville',
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                          height: 1.2.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
