import 'package:aayu/controller/onboarding/login/login_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/onboarding_bottom_sheet.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class LoginViaMobile extends StatelessWidget {
  final PageController pageController;
  final PhoneNumber? mobileNumber;
  const LoginViaMobile(
      {Key? key, required this.pageController, this.mobileNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    if (mobileNumber != null) {
      controller.updateMobileNumber(mobileNumber!);
    }

    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                onboardingTitleMessage("LOGIN".tr),
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  height: 36.h,
                  child: Text(
                    "ENTER_YOUR_NUMBER".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Baskerville',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    color: (controller.isValidPhoneNumber.value == false &&
                            controller.phoneNumberController.text.isNotEmpty)
                        ? AppColors.errorColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(64, 117, 205, 0.08),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IntlPhoneField(
                        disableLengthCheck: false,
                        decoration: InputDecoration(
                          helperStyle: const TextStyle(
                              color: Colors.transparent, fontSize: 0),
                          hintStyle: AppTheme.hintTextStyle,
                          errorStyle: const TextStyle(
                              color: AppColors.errorColor,
                              fontSize: 0,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Circular Std"),
                          hintText: 'MY_MOBILE_NUMBER'.tr,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.whiteColor,
                          focusColor: AppColors.whiteColor,
                          hoverColor: AppColors.whiteColor,
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.errorColor, width: 3),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                        ),
                        onCountryChanged: (value) {},
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          controller.updateMobileNumber(phone);
                        },
                        validateFunction: (bool val) {
                          controller.updateIsValidPhoneNumber(val);
                        },
                        onSubmitted: (s) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: controller.phoneNumberController,
                        style: AppTheme.inputTextStyle,
                        cursorColor: AppColors.blackColor),
                  ),
                ),
                SizedBox(
                  height: 9.h,
                ),
                Visibility(
                  visible: controller.isValidPhoneNumber.value == false &&
                      controller.phoneNumberController.text.isNotEmpty,
                  child: Text(
                    "ENTER_A_VALID_MOBILE_NUMBER".tr,
                    style: TextStyle(
                      color: const Color.fromRGBO(241, 99, 102, 1),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.1666666666666667,
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.isRegistered.value == false,
                  child: InkWell(
                    onTap: () {
                      EventsService().sendClickNextEvent(
                          "LoginViaMobile", "Sign up", "Onboarding");
                      Get.to(const OnboardingBottomSheet(
                        showPersonalisingYourSpace: true,
                      ));
                    },
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "ACCOUNT_NOT_EXIST_WITH_THIS_MOBILE_NUMBER".tr,
                          style: TextStyle(
                            color: const Color.fromRGBO(241, 99, 102, 1),
                            fontFamily: 'Circular Std',
                            fontSize: 12.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.1666666666666667,
                          ),
                        ),
                        Text(
                          "SIGN_UP".tr,
                          style: TextStyle(
                            color: const Color.fromRGBO(241, 99, 102, 1),
                            fontFamily: 'Circular Std',
                            fontSize: 12.sp,
                            letterSpacing: 0,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal,
                            height: 1.1666666666666667,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                InkWell(
                  onTap: (controller.isValidPhoneNumber.value == false)
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          if (controller
                              .userPhoneNumber.value.completeNumber.isEmpty) {
                            showGetSnackBar(
                                "MOBILE_NUMBER_CANT_BE_EMPTY_TXT".tr,
                                SnackBarMessageTypes.Info);
                          } else if (!controller.isValidPhoneNumber.value) {
                            showGetSnackBar("ENTER_A_VALID_MOBILE_NUMBER".tr,
                                SnackBarMessageTypes.Info);
                          } else {
                            buildShowDialog(context);

                            MoengageService().sendLoginTypeEvent("Mobile");

                            bool? isRegistered =
                                await controller.checkIfRegistered();
                            Navigator.pop(context);

                            if (isRegistered == true) {
                              pageController.nextPage(
                                duration: Duration(
                                    milliseconds: defaultAnimateToPageDuration),
                                curve: Curves.easeIn,
                              );
                            }
                          }
                        },
                  child: SizedBox(
                    width: 158.w,
                    child: (controller.isValidPhoneNumber.value == true)
                        ? mainButton("NEXT".tr)
                        : disabledMainButton("NEXT".tr),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        color: AppColors.lightPrimaryColor,
        width: double.infinity,
        height: 45.h,
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "DONT_HAVE_AN_ACCOUNT".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Circular Std",
                fontWeight: FontWeight.w400,
                color: AppColors.secondaryLabelColor,
                height: 1.14.sp,
                fontSize: 14.sp,
              ),
            ),
            InkWell(
              onTap: () {
                EventsService().sendClickNextEvent(
                    "Login Via Mobile", "Sign up", "Onboarding");
                Get.to(const OnboardingBottomSheet(
                  showPersonalisingYourSpace: true,
                ))?.then((value) {
                  EventsService().sendClickBackEvent(
                      "Onboarding", "Back", "Login Via Mobile");
                });
              },
              child: Text(
                "SIGN_UP".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Circular Std",
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryLabelColor,
                  height: 1.14.sp,
                  decoration: TextDecoration.underline,
                  fontSize: 14.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
