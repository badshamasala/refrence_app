import 'package:aayu/controller/onboarding/login/login_controller.dart';
import 'package:aayu/view/onboarding/login/login_otp.dart';
import 'package:aayu/view/onboarding/login/login_via_mobile.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginBottomSheet extends StatelessWidget {
  final PhoneNumber? mobileNumber;
  const LoginBottomSheet({Key? key, this.mobileNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    return WillPopScope(
      onWillPop: () async {
        if (loginController.selectedPage.value == 1) {
          loginController.pageController.previousPage(
              duration: Duration(milliseconds: defaultAnimateToPageDuration),
              curve: Curves.easeOut);
        } else if (loginController.selectedPage.value == 0) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
          leading: IconButton(
            onPressed: () {
              if (loginController.selectedPage.value == 1) {
                loginController.pageController.previousPage(
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeOut);
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.aayuOnboardingIconSVG,
                width: 32.59.w,
                height: 42.25.h,
              ),
              SizedBox(height: 75.76.h),
              Expanded(
                child: PageView.builder(
                  controller: loginController.pageController,
                  itemCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Future.delayed(const Duration(seconds: 0), () {
                      loginController.setSelectedPage(index);
                    });
                    switch (index) {
                      case 0:
                        return LoginViaMobile(
                            mobileNumber: mobileNumber,
                            pageController: loginController.pageController);
                      case 1:
                        return LoginOTP(
                            pageController: loginController.pageController);
                      default:
                        return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
