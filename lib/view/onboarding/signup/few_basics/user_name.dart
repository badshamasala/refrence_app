import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/onboarding.dart';
import 'package:aayu/view/onboarding/signup/personalising_your_space.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserName extends StatelessWidget {
  final PageController pageController;
  const UserName({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingBottomSheetController>(builder: (nameSelector) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onboardingTitleMessage(
              "YOU_ARE_UNIQUE".toUpperCase().tr,
            ),
            const SizedBox(
              height: 49.0,
            ),
            Image(
              width: 118.w,
              height: 87.h,
              image: const AssetImage(Images.cupImage),
            ),
            SizedBox(
              height: 42.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.h),
              child: Text(
                "HELP_US_MAKE_YOUR_JOURNEY_UNIQUE_TXT".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5.h,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "TELL_US_YOUR_NAME".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Baskerville',
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(64, 117, 205, 0.07999999821186066),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  )
                ],
              ),
              child: TextField(
                decoration: getInputDecoration("I am"),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
                textCapitalization: TextCapitalization.words,
                style: AppTheme.inputTextStyle,
                controller: nameSelector.userNameController,
                keyboardType: TextInputType.name,
                onChanged: (val) {
                  nameSelector.update();
                },
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(
              height: 45.h,
            ),
            InkWell(
              onTap: nameSelector.userNameController.text.trim().isNotEmpty
                  ? () async {
                      FocusScope.of(context).unfocus();
                      if (nameSelector.userNameController.text.isEmpty) {
                        showGetSnackBar(
                            "NAME_CANT_BE_EMPTY".tr, SnackBarMessageTypes.Info);
                      } else {
                        buildShowDialog(context);
                        bool isUpdated = await nameSelector.updateProfile();
                        Navigator.pop(context);

                        if (isUpdated == true) {
                          EventsService().sendClickNextEvent("SignUp_UserName",
                              "NextButton", "SignUp_UserGender");
                          pageController.nextPage(
                              duration: Duration(
                                  milliseconds: defaultAnimateToPageDuration),
                              curve: Curves.easeIn);
                        } else {
                          showCustomSnackBar(context,
                              "Failed to save details. Please try again");
                        }
                      }
                    }
                  : null,
              child: SizedBox(
                width: 158.w,
                child: nameSelector.userNameController.text.trim().isNotEmpty
                    ? mainButton("NEXT".tr)
                    : disabledMainButton("NEXT".tr),
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
            Center(
                child: InkWell(
              onTap: () async {
                buildShowDialog(context);
                EventsService().sendEvent(
                    "Aayu_Profile_Skiped", {"page_name": "SignUp_UserName"});
                EventsService().sendClickNextEvent(
                    "SignUp_UserName", "Skip", "PersonalisingYourSpace");
                OnboardingBottomSheetController
                    onboardingBottomSheetController = Get.find();
                await onboardingBottomSheetController.getAndSetUserProfile();
                Navigator.pop(context);
                Get.to(Onboarding(
                  showSkip: true,
                  personalisingYourSpace: true,
                ));
              },
              child: Text(
                "SKIP".tr,
                style: const TextStyle(
                  fontFamily: "Circular Std",
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  color: AppColors.secondaryLabelColor,
                ),
              ),
            )),
          ],
        ),
      );
    });
  }
}
