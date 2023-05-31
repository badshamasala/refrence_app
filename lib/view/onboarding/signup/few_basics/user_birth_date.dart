import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/onboarding.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/shared/ui_helper/date_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserBirthDate extends StatelessWidget {
  final PageController pageController;
  final bool showPersonalisingYourSpace;
  const UserBirthDate(
      {Key? key,
      required this.pageController,
      required this.showPersonalisingYourSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingBottomSheetController>(
        builder: (birthDateSelector) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onboardingTitleMessage(
              "YOU_ARE_UNIQUE".toUpperCase().tr,
            ),
            SizedBox(
              height: 32.h,
            ),
            Image(
              width: 27.w,
              height: 104.h,
              image: const AssetImage(Images.birthdayCandleImage),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "WE_ARE_ALMOST_THERE_TXT".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.5.h,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 272.w,
              height: 36.h,
              child: Text(
                "TELL_US_YOUR_BIRTHDATE".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Baskerville',
                ),
              ),
            ),
            Text(
              "BIRTH_DATE_TEXT".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.4.h,
              ),
            ),
            SizedBox(
              height: 36.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16.w),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(64, 117, 205, 0.07999999821186066),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  )
                ],
              ),
              child: CupertinoDateTextBox(
                hintText: "I_WAS_BORN_ON".tr,
                onDateChange: (DateTime? dateTime) {
                  if (dateTime != null) {
                    final formatter = DateFormat('dd-MM-yyyy');
                    String fieldText = formatter.format(dateTime);
                    birthDateSelector.initialDate = dateTime;
                    birthDateSelector.userBirthDateController.text = fieldText;
                  } else {
                    birthDateSelector.userBirthDateController.text = "";
                  }
                  birthDateSelector.update();
                },
                minimumDate: birthDateSelector.firstDate,
                initialValue: birthDateSelector.initialDate,
                maximumDate: birthDateSelector.lastDate,
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            InkWell(
              onTap: birthDateSelector.userBirthDateController.text
                      .trim()
                      .isNotEmpty
                  ? () async {
                      if (birthDateSelector
                          .userBirthDateController.text.isEmpty) {
                        showGetSnackBar("PROVIDE_YOUR_BIRTH_DATE".tr,
                            SnackBarMessageTypes.Info);
                      } else {
                        buildShowDialog(context);
                        bool isRegistered =
                            await birthDateSelector.updateProfile();
                        Navigator.pop(context);

                        if (isRegistered == true) {
                          if (showPersonalisingYourSpace == true) {
                            EventsService()
                                .sendEvent("Aayu_Profile_Completed", {
                              "mobile_number": birthDateSelector
                                  .userPhoneNumber.value.number,
                              "user_id": globalUserIdDetails!.userId,
                              "source": ""
                            });
                            EventsService().sendClickNextEvent(
                                "SignUp_UserBirthDate",
                                "Submit",
                                "PersonalisingYourSpace");
                            Get.to(const Onboarding(
                              showSkip: true,
                              personalisingYourSpace: true,
                            ));
                          } else {
                            Navigator.pop(context);
                            showCustomSnackBar(
                                context, "PROFILE_UPDATED_SUCCESSFULLY".tr);
                          }
                        }
                      }
                    }
                  : null,
              child: SizedBox(
                width: 158.w,
                child: birthDateSelector.userBirthDateController.text
                        .trim()
                        .isNotEmpty
                    ? mainButton("SUBMIT".tr)
                    : disabledMainButton("SUBMIT".tr),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            InkWell(
              onTap: () async {
                buildShowDialog(context);
                EventsService().sendEvent("Aayu_Profile_Skiped",
                    {"page_name": "SignUp_UserBirthDate"});
                EventsService().sendClickNextEvent(
                    "SignUp_UserBirthDate", "Skip", "PersonalisingYourSpace");
                OnboardingBottomSheetController
                    onboardingBottomSheetController = Get.find();
                await onboardingBottomSheetController.getAndSetUserProfile();
                Navigator.pop(context);
                Get.to(const Onboarding(
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
            ),
          ],
        ),
      );
    });
  }
}
