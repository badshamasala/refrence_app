import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/signup/enter_your_number.dart';
import 'package:aayu/view/onboarding/signup/few_basics/user_birth_date.dart';
import 'package:aayu/view/onboarding/signup/few_basics/user_gender.dart';
import 'package:aayu/view/onboarding/signup/few_basics/user_name.dart';
import 'package:aayu/view/onboarding/signup/verify_otp.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OnboardingBottomSheet extends StatelessWidget {
  final bool showPersonalisingYourSpace;
  const OnboardingBottomSheet(
      {Key? key,
      this.showPersonalisingYourSpace = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnboardingBottomSheetController onboardingBottomSheetController =
        Get.put(OnboardingBottomSheetController(showPersonalisingYourSpace));

    return WillPopScope(
      onWillPop: () async {
        if (onboardingBottomSheetController.selectedPage.value == 3 ||
            onboardingBottomSheetController.selectedPage.value == 4) {
          onboardingBottomSheetController.pageController.previousPage(
              duration: Duration(milliseconds: defaultAnimateToPageDuration),
              curve: Curves.easeOut);
        } else if (onboardingBottomSheetController.selectedPage.value == 0) {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
          leading: Obx(
            () {
              return (onboardingBottomSheetController.selectedPage.value == 0 ||
                      onboardingBottomSheetController.selectedPage.value == 3 ||
                      onboardingBottomSheetController.selectedPage.value == 4)
                  ? IconButton(
                      onPressed: () {
                        if (onboardingBottomSheetController
                                .selectedPage.value ==
                            0) {
                          Navigator.of(context).pop();
                        } else {
                          onboardingBottomSheetController.pageController
                              .previousPage(
                                  duration: Duration(
                                      milliseconds:
                                          defaultAnimateToPageDuration),
                                  curve: Curves.easeOut);
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                    )
                  : const Offstage();
            },
          ),
        ),
        body: Column(
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
                  controller: onboardingBottomSheetController.pageController,
                  itemCount: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Future.delayed(const Duration(seconds: 0), () {
                      onboardingBottomSheetController.setSelectedPage(index);
                    });
                    switch (index) {
                      case 0:
                        return EnterYourNumber(
                            pageController:
                                onboardingBottomSheetController.pageController);
                      case 1:
                        return VerifyOTP(
                            pageController:
                                onboardingBottomSheetController.pageController);
                      case 2:
                        return UserName(
                            pageController:
                                onboardingBottomSheetController.pageController);
                      case 3:
                        return UserGender(
                            pageController:
                                onboardingBottomSheetController.pageController);
                      case 4:
                        return UserBirthDate(
                            pageController:
                                onboardingBottomSheetController.pageController,
                            showPersonalisingYourSpace:
                                showPersonalisingYourSpace);
                      default:
                        return Container();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
