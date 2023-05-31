import 'dart:async';

import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOTP extends StatefulWidget {
  final PageController pageController;
  const VerifyOTP({Key? key, required this.pageController}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  OnboardingBottomSheetController onboardingBottomSheetController = Get.find();
  final FirebaseAuth fireBaseAuth = FirebaseAuth.instance;
  late int resendOTPTimeRemaining = 60;
  String otpVerificationId = "";
  bool enableResendButton = false;
  bool isLoading = false;

  late Timer otpSendTimer;

  @override
  void initState() {
    isLoading = true;
    super.initState();
    if (mounted) {
      startTimer();
      verifyPhoneNumber();
    }
  }

  @override
  void dispose() {
    otpSendTimer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    otpSendTimer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          enableResendButton = false;
          if (resendOTPTimeRemaining < 1) {
            timer.cancel();
            enableResendButton = true;
          } else {
            resendOTPTimeRemaining = resendOTPTimeRemaining - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onboardingTitleMessage(
              onboardingBottomSheetController.isSocialSignUp == true
                  ? "LINK_YOUR_MOBILE".tr
                  : "SIGN_UP".tr,
            ),
            SizedBox(
              height: 67.h,
            ),
            Text(
              "VERIFY_OTP".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Baskerville',
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            RichText(
              text: TextSpan(
                style: primaryFontPrimaryLabelSmallTextStyle(),
                children: [
                  TextSpan(text: 'OTP_SENT_ON'.tr),
                  TextSpan(
                    text: onboardingBottomSheetController
                        .userPhoneNumber.value.completeNumber,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                EventsService().sendEvent("Aayu_OTP_Change_Number", {
                  "otp_type":
                      onboardingBottomSheetController.isSocialSignUp == true
                          ? "Link your Mobile"
                          : "Sign Up",
                });
                onboardingBottomSheetController.pageController.previousPage(
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeOut);
              },
              child: Text(
                "CHANGE_NUMBER".tr,
                style: TextStyle(
                  fontFamily: "Circular Std",
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryLabelColor,
                  height: 1.1428571428571428.h,
                  decoration: TextDecoration.underline,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            PinCodeTextField(
              enabled: (otpVerificationId.isNotEmpty) ? true : false,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              backgroundColor: Colors.transparent,
              showCursor: true,
              cursorColor: AppColors.blackLabelColor,
              cursorHeight: 20.h,
              appContext: context,
              enableActiveFill: true,
              textStyle: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 36.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
              ),
              /* boxShadows: const [
                BoxShadow(
                  color: Color.fromRGBO(125, 130, 138, 0.07999999821186066),
                  offset: Offset(0, 10),
                  blurRadius: 20,
                )
              ], */
              length: 6,
              autoDismissKeyboard: true,
              autoDisposeControllers: true,
              autoFocus: false,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldHeight: 46.w,
                fieldWidth: 46.h,
                fieldOuterPadding: const EdgeInsets.symmetric(vertical: 10),
                activeColor: Colors.white,
                errorBorderColor: Colors.red,
                activeFillColor: Colors.white,
                selectedColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveColor: const Color(0xFFF7F7F7),
                inactiveFillColor: const Color(0xFFF7F7F7),
                disabledColor: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(8.w),
              ),
              onChanged: (code) {},
              onSubmitted: (code) {
                FocusScope.of(context).unfocus();
                EventsService().sendEvent("Aayu_OTP_Entry_Manual", {
                  "otp_type":
                      onboardingBottomSheetController.isSocialSignUp == true
                          ? "Link your Mobile"
                          : "Sign Up",
                });
                signInWithPhoneNumber(code);
              },
              onCompleted: (code) {
                FocusScope.of(context).unfocus();
                EventsService().sendEvent("Aayu_OTP_Entry_Manual", {
                  "otp_type":
                      onboardingBottomSheetController.isSocialSignUp == true
                          ? "Link your Mobile"
                          : "Sign Up",
                });
                signInWithPhoneNumber(code);
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            Visibility(
              visible: isLoading == true,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: enableResendButton == true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: SizedBox(
            height: 72.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "DIDNT_RECEIVE_CODE".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Circular Std",
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryLabelColor,
                    height: 1.1428571428571428.h,
                    fontSize: 14.sp,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      resendOTPTimeRemaining = 60;
                      showOTPResentSnackBar(context, "OTP has been resent");
                    });
                    startTimer();
                    EventsService()
                        .sendEvent("Aayu_OTP_Verification_Retry_Initiated", {
                      "otp_type":
                          onboardingBottomSheetController.isSocialSignUp == true
                              ? "Link your Mobile"
                              : "Sign Up",
                      "status": "Success",
                      "mobile_number": onboardingBottomSheetController
                          .userPhoneNumber.value.completeNumber
                    });
                    verifyPhoneNumber();
                  },
                  child: Text(
                    "RESEND_OTP".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Circular Std",
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryLabelColor,
                      height: 1.1428571428571428.h,
                      decoration: TextDecoration.underline,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    try {
      await fireBaseAuth.verifyPhoneNumber(
          phoneNumber: onboardingBottomSheetController
              .userPhoneNumber.value.completeNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      EventsService().sendEvent("Aayu_OTP_Verification_Initiated", {
        "otp_type": onboardingBottomSheetController.isSocialSignUp == true
            ? "Link your Mobile"
            : "Sign Up",
        "status": "Success",
        "mobile_number":
            onboardingBottomSheetController.userPhoneNumber.value.completeNumber
      });
    } catch (e) {
      EventsService().sendEvent("Aayu_OTP_Verification_Initiated", {
        "otp_type": onboardingBottomSheetController.isSocialSignUp == true
            ? "Link your Mobile"
            : "Sign Up",
        "status": "Fail",
        "error_code": e.toString(),
        "mobile_number":
            onboardingBottomSheetController.userPhoneNumber.value.completeNumber
      });
      print(e);
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  void verificationCompleted(AuthCredential phoneAuthCredential) async {
    try {
      final User? user =
          (await fireBaseAuth.signInWithCredential(phoneAuthCredential)).user;
      final User? currentUser = fireBaseAuth.currentUser;
      assert(user!.uid == currentUser!.uid);

      if (user != null) {
        print(
            "verificationCompleted => signInWithCredential | Success | UID => ${user.uid}");
        EventsService().sendEvent("Aayu_OTP_Entry_Autodetect", {
          "otp_type": onboardingBottomSheetController.isSocialSignUp == true
              ? "Link your Mobile"
              : "Sign Up",
        });
        if (!onboardingBottomSheetController.isSocialSignUp) {
          EventsService().sendEvent("Aayu_Signup_Verification_Complete", {
            "status": "Success",
          });
        }

        EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
          "otp_type": onboardingBottomSheetController.isSocialSignUp == true
              ? "Link your Mobile"
              : "Sign Up",
          "status": "Success",
          "mobile_number": user.phoneNumber,
        });

        bool isRegistered = await registerUser();
        if (isRegistered == true) {
          BranchService().sendCompleteRegistration();
          MoengageService().setPhoneNumber(user.phoneNumber!);

          SingularDeepLinkController singularDeepLinkController = Get.find();
          MoengageService().setUserSourceAndCampaign(
              singularDeepLinkController.utmSource,
              singularDeepLinkController.utmCampaign);
        }
      } else {
        print("verificationCompleted => Invalid OTP!");
        EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
          "otp_type": onboardingBottomSheetController.isSocialSignUp == true
              ? "Link your Mobile"
              : "Sign Up",
          "status": "Fail",
          "mobile_number": user!.phoneNumber,
          "error_code": "Invalid OTP"
        });
        showGetSnackBar("INVALID_OTP".tr, SnackBarMessageTypes.Error);
      }
    } on FirebaseAuthException catch (error) {
      print("verificationCompleted => FirebaseAuthException =>");
      print(error.toString());
      EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
        "otp_type": onboardingBottomSheetController.isSocialSignUp == true
            ? "Link your Mobile"
            : "Sign Up",
        "status": "Fail",
        "mobile_number": onboardingBottomSheetController
            .userPhoneNumber.value.completeNumber,
        "error_code": error.toString()
      });
      showGetSnackBar(error.code, SnackBarMessageTypes.Error);
    } catch (e) {
      EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
        "otp_type": onboardingBottomSheetController.isSocialSignUp == true
            ? "Link your Mobile"
            : "Sign Up",
        "status": "Fail",
        "mobile_number": onboardingBottomSheetController
            .userPhoneNumber.value.completeNumber,
        "error_code": e.toString()
      });
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void verificationFailed(FirebaseAuthException authException) async {
    showGetSnackBar(
        'Phone number verification failed. Code: ${authException.code}',
        SnackBarMessageTypes.Error);
    EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
      "otp_type": onboardingBottomSheetController.isSocialSignUp == true
          ? "Link your Mobile"
          : "Sign Up",
      "status": "Fail",
      "mobile_number":
          onboardingBottomSheetController.userPhoneNumber.value.completeNumber,
      "error_code": authException.code.toString()
    });

    setState(() {
      isLoading = false;
    });
  }

  void codeSent(String verificationId, [int? forceResendingToken]) async {
    try {
      // showGetSnackBar('Please check your phone for the verification code.',
      //     SnackBarMessageTypes.Info);

      print("codeSent | verificationId => $verificationId");

      EventsService().sendEvent("Aayu_OTP_Verification_Code_Sent", {
        "otp_type": onboardingBottomSheetController.isSocialSignUp == true
            ? "Link your Mobile"
            : "Sign Up",
        "status": "Success",
        "verificationId": verificationId,
        "mobile_number":
            onboardingBottomSheetController.userPhoneNumber.value.completeNumber
      });

      setState(() {
        otpVerificationId = verificationId;
      });
    } catch (e) {
      EventsService().sendEvent("Aayu_OTP_Verification_Code_Sent", {
        "otp_type": onboardingBottomSheetController.isSocialSignUp == true
            ? "Link your Mobile"
            : "Sign Up",
        "status": "Fail",
        "verificationId": verificationId,
        "error_code": e.toString(),
        "mobile_number":
            onboardingBottomSheetController.userPhoneNumber.value.completeNumber
      });
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    if (mounted) {
      setState(() {
        otpVerificationId = verificationId;
      });
    }
    print('codeAutoRetrievalTimeout|otpVerificationId - $otpVerificationId');
  }

  void signInWithPhoneNumber(String smsCode) async {
    if (otpVerificationId == "") {
      showGetSnackBar(
          "INVALID_VERIFICATION_PIN".tr, SnackBarMessageTypes.Error);
    } else {
      setState(() {
        isLoading = true;
      });

      try {
        print('otpVerificationId - $otpVerificationId');
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: otpVerificationId,
          smsCode: smsCode,
        );

        final User? user =
            (await fireBaseAuth.signInWithCredential(credential)).user;
        final User? currentUser = fireBaseAuth.currentUser;
        assert(user!.uid == currentUser!.uid);

        if (user != null) {
          print(
              "signInWithCredential => signInWithPhoneNumber | Success | UID => ${user.uid}");
          if (!onboardingBottomSheetController.isSocialSignUp) {
            EventsService().sendEvent("Aayu_Signup_Verification_Complete", {
              "status": "Success",
            });
          }

          EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
            "otp_type": onboardingBottomSheetController.isSocialSignUp == true
                ? "Link your Mobile"
                : "Sign Up",
            "status": "Success",
            "mobile_number": user.phoneNumber,
          });

          registerUser();
        } else {
          print("signInWithPhoneNumber => Invalid OTP!");

          EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
            "otp_type": onboardingBottomSheetController.isSocialSignUp == true
                ? "Link your Mobile"
                : "Sign Up",
            "status": "Fail",
            "mobile_number": user!.phoneNumber,
            "error_code": "Invalid OTP"
          });

          showGetSnackBar("Invalid OTP!", SnackBarMessageTypes.Error);
        }
      } catch (excp) {
        EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
          "otp_type": onboardingBottomSheetController.isSocialSignUp == true
              ? "Link your Mobile"
              : "Sign Up",
          "status": "Fail",
          "mobile_number": onboardingBottomSheetController
              .userPhoneNumber.value.completeNumber,
          "error_code": excp.toString()
        });

        if (excp.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
          showGetSnackBar("THE_SMS_VERIFICATION_CODE_USED_IS_INVALID".tr,
              SnackBarMessageTypes.Error);
        } else {
          showGetSnackBar(excp.toString(), SnackBarMessageTypes.Error);
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  registerUser() async {
    buildShowDialog(context);
    bool isRegistered = await onboardingBottomSheetController.registerUser();
    Navigator.pop(context);
    if (isRegistered == true) {
      EventsService().sendClickNextEvent(
          "SignUp_VerifyOTP", "NextButton", "SignUp_UserName");
      widget.pageController.nextPage(
          duration: Duration(milliseconds: defaultAnimateToPageDuration),
          curve: Curves.easeIn);
    }

    return isRegistered;
  }
}
