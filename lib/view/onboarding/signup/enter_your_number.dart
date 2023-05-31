import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/onboarding/login/login_controller.dart';
import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/login/login_bottom_sheet.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class EnterYourNumber extends StatelessWidget {
  final PageController pageController;
  const EnterYourNumber({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnboardingBottomSheetController controller = Get.find();
    SingularDeepLinkController singularDeepLinkController = Get.find();
    HealingListController healingListController = Get.find();
    String description =
        "Having your phone number will help us to send you personalised healing solutions and timely offers as well as program updates.\nYour phone number is secure with us";
    if (singularDeepLinkController.deepLinkDataContinued != null) {
      switch (singularDeepLinkController.deepLinkDataContinued!["screenName"]
          .toString()
          .toUpperCase()) {
        case "DISEASE_DETAILS":
          String diseaseName = healingListController
              .getDiseaseNameFromDiseaseId(singularDeepLinkController
                  .deepLinkDataContinued!['diseaseId']);

          description =
              "To get started with your $diseaseName Program, enter your phone number. Your number will be secure with us. ";

          break;
        case "BOOK_DOCTOR_CONSULT":
          description =
              "To book your free doctor consultation session, start with entering your phone number. Your number will be secure with us. ";

          break;
        case "CONTENT_DETAILS":
          break;
        default:
      }
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
                onboardingTitleMessage(
                  controller.isSocialSignUp == true
                      ? "LINK_YOUR_MOBILE".tr
                      : "SIGN_UP".tr,
                ),
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  height: 36.h,
                  child: Text(
                    "ENTER_MOBILE_NO".tr,
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
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4.h,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
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
                          color:
                              Color.fromRGBO(64, 117, 205, 0.07999999821186066),
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
                      height: 1.16,
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.isRegistered.value == true,
                  child: InkWell(
                    onTap: () {
                      LoginController loginController =
                          Get.put(LoginController());
                      loginController.isRegistered.value = true;
                      loginController.userPhoneNumber.value =
                          controller.userPhoneNumber.value;
                      loginController.phoneNumberController.text =
                          controller.phoneNumberController.text.trim();
                      loginController.isValidPhoneNumber.value =
                          controller.isValidPhoneNumber.value;
                      loginController.update();
                      EventsService().sendClickNextEvent("SignUp_EnterNumber",
                          "Accont already exist", "Login Bottom Sheet");
                      Get.to(const LoginBottomSheet())!.then((value) =>
                          EventsService().sendClickBackEvent(
                              "Login Bottom Sheet",
                              "Back",
                              "SignUp_EnterNumber"));
                    },
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "ACCOUNT_ALREADY_EXIST_WITH_THIS_MOBILE_NUMBER_TXT"
                              .tr,
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
                          "LOGIN".tr,
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
                          print("NUMBER");
                          print(controller.userPhoneNumber.value.number);
                          FocusScope.of(context).unfocus();
                          if (controller.userPhoneNumber.value.number.isEmpty) {
                            showGetSnackBar(
                                "MOBILE_NUMBER_CANT_BE_EMPTY_TXT".tr,
                                SnackBarMessageTypes.Info);
                          } else if (!controller.isValidPhoneNumber.value) {
                            showGetSnackBar("ENTER_A_VALID_MOBILE_NUMBER".tr,
                                SnackBarMessageTypes.Info);
                          } else {
                            EventsService().sendEvent("signup_type", {
                              "mobile": "Yes",
                              "gmail": "No",
                              "facebook": "No",
                              "apple": "No",
                            });
                            EventsService().sendEvent("SignUp_EnterNumber", {
                              "mobile": "Yes",
                            });

                            EventsService().sendClickNextEvent(
                                "SignUp_EnterNumber",
                                "NextButton",
                                "VerifyOTP");
                            buildShowDialog(context);
                            bool? isRegistered =
                                await controller.checkIfRegistered();
                            Navigator.pop(context);
                            if (isRegistered == false) {
                              pageController.animateToPage(1,
                                  duration: Duration(
                                      milliseconds:
                                          defaultAnimateToPageDuration),
                                  curve: Curves.easeIn);
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
      bottomNavigationBar: SizedBox(
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: const Color(0xFF5B7081),
                ),
                children: [
                  TextSpan(text: 'YOU_AGREE_TO_AAYU_TXT'.tr),
                  TextSpan(
                    text: 'TERMS'.tr,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        launchCustomUrl(
                            "https://www.resettech.in/terms-of-use.html");
                      },
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' & '),
                  TextSpan(
                    text: 'PRIVACY_POLICY'.tr,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        launchCustomUrl(
                            "https://www.resettech.in/privacy-policy.html");
                      },
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Container(
              color: AppColors.lightPrimaryColor,
              width: double.infinity,
              height: 45.h,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "ALREADY_MEMBER".tr,
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
                      LoginController loginController =
                          Get.put(LoginController());
                      loginController.isRegistered.value = true;
                      loginController.userPhoneNumber.value = PhoneNumber(
                          countryISOCode: "IN", countryCode: "IN", number: "");
                      loginController.phoneNumberController.text = "";
                      loginController.update();
                      EventsService().sendClickNextEvent("SignUp_EnterNumber",
                          "Already Member", "Login Bottom Sheet");
                      Get.to(const LoginBottomSheet())!.then((value) =>
                          EventsService().sendClickBackEvent(
                              "Login Bottom Sheet",
                              "Back",
                              "SignUp_EnterNumber"));
                    },
                    child: Text(
                      "LOGIN".tr,
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
          ],
        ),
      ),
    );
  }

  buildSocialIcons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text("OR_CONTINUE_WITH".tr),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4384E9),
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(AppIcons.googleSVG,
                        width: 8.w, height: 8.h, color: AppColors.whiteColor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D66BB),
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(AppIcons.facebookSVG,
                        width: 16.w, height: 16.h, color: AppColors.whiteColor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    border: Border.all(color: Colors.white),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(AppIcons.appleSVG,
                        width: 8.w, height: 8.h, color: AppColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
