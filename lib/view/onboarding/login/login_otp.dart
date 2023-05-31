import 'dart:async';

import 'package:aayu/controller/grow/grow_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';

import 'package:aayu/controller/onboarding/login/login_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../controller/deeplink/singular_deeplink_controller.dart';

class LoginOTP extends StatefulWidget {
  final PageController pageController;
  const LoginOTP({Key? key, required this.pageController}) : super(key: key);

  @override
  State<LoginOTP> createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  LoginController loginController = Get.find();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onboardingTitleMessage("LOGIN".tr),
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
              textAlign: TextAlign.center,
              text: TextSpan(
                style: primaryFontPrimaryLabelSmallTextStyle(),
                children: [
                  TextSpan(text: "OTP_SENT_ON".tr),
                  TextSpan(
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                      text:
                          loginController.userPhoneNumber.value.completeNumber)
                ],
              ),
            ),
            SizedBox(
              height: 33.h,
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
                  "otp_type": "Login",
                });
                if (checkIsTestNumber(code) == true) {
                  maintainState();
                } else {
                  signInWithPhoneNumber(code);
                }
              },
              onCompleted: (code) {
                FocusScope.of(context).unfocus();
                EventsService().sendEvent("Aayu_OTP_Entry_Manual", {
                  "otp_type": "Login",
                });
                if (checkIsTestNumber(code) == true) {
                  maintainState();
                } else {
                  signInWithPhoneNumber(code);
                }
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
                      "otp_type": "Login",
                      "status": "Success",
                      "mobile_number":
                          loginController.userPhoneNumber.value.completeNumber
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

  checkIsTestNumber(String code) {
    if (code == "123456") {
      switch (loginController.userPhoneNumber.value.completeNumber) {
        case "919967541071":
        case "+919967541071":
          return true;
      }
      return false;
    } else {
      return false;
    }
  }

  void verifyPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    try {
      await fireBaseAuth.verifyPhoneNumber(
        phoneNumber: loginController.userPhoneNumber.value.completeNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      EventsService().sendEvent("Aayu_OTP_Verification_Initiated", {
        "otp_type": "Login",
        "status": "Success",
        "mobile_number": loginController.userPhoneNumber.value.completeNumber
      });
    } catch (e) {
      EventsService().sendEvent("Aayu_OTP_Verification_Initiated", {
        "otp_type": "Login",
        "status": "Fail",
        "error_code": e.toString(),
        "mobile_number": loginController.userPhoneNumber.value.completeNumber
      });
      print(e);
    } finally {}
  }

  void verificationCompleted(AuthCredential phoneAuthCredential) async {
    try {
      final User? user =
          (await fireBaseAuth.signInWithCredential(phoneAuthCredential)).user;
      final User? currentUser = fireBaseAuth.currentUser;
      assert(user!.uid == currentUser!.uid);

      if (user != null) {
        EventsService().sendEvent("Aayu_OTP_Entry_Autodetect", {
          "otp_type": "Login",
        });
        EventsService().sendEvent("Aayu_Login_Verification_Complete", {
          "status": "Success",
        });

        EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
          "otp_type": "Login",
          "status": "Success",
          "mobile_number": loginController.userPhoneNumber.value.completeNumber,
        });

        print(
            "verificationCompleted => signInWithCredential | Success | UID => ${user.uid}");

        maintainState();
      } else {
        print("verificationCompleted => Invalid OTP!");
        EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
          "otp_type": "Login",
          "status": "Fail",
          "mobile_number": loginController.userPhoneNumber.value.completeNumber,
          "error_code": "Invalid OTP"
        });
        showGetSnackBar("Invalid OTP!", SnackBarMessageTypes.Error);
      }
    } catch (e) {
      EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
        "otp_type": "Login",
        "status": "Fail",
        "mobile_number": loginController.userPhoneNumber.value.completeNumber,
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
    print(authException);

    showGetSnackBar(
        'Phone number verification failed. Code: ${authException.code}',
        SnackBarMessageTypes.Error);
    EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
      "otp_type": "Login",
      "status": "Fail",
      "mobile_number": loginController.userPhoneNumber.value.completeNumber,
      "error_code": authException.code
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
        "otp_type": "Login",
        "status": "Success",
        "verificationId": verificationId,
        "mobile_number": loginController.userPhoneNumber.value.completeNumber
      });

      setState(() {
        otpVerificationId = verificationId;
      });
    } catch (exc) {
      print(exc);

      EventsService().sendEvent("Aayu_OTP_Verification_Code_Sent", {
        "otp_type": "Login",
        "status": "Fail",
        "verificationId": verificationId,
        "error_code": exc.toString(),
        "mobile_number": loginController.userPhoneNumber.value.completeNumber
      });
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
          "Invalid Verification Id/PIN!", SnackBarMessageTypes.Error);
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
          HiveService().seenCoachMarks();
          print(
              "signInWithCredential => signInWithPhoneNumber | Success | UID => ${user.uid}");
          EventsService().sendEvent("Aayu_Login_Verification_Complete", {
            "status": "Success",
          });

          EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
            "otp_type": "Login",
            "status": "Success",
            "mobile_number":
                loginController.userPhoneNumber.value.completeNumber
          });

          maintainState();
        } else {
          print("signInWithPhoneNumber => Invalid OTP!");

          EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
            "otp_type": "Login",
            "status": "Fail",
            "mobile_number": user!.phoneNumber,
            "error_code": "Invalid OTP"
          });

          showGetSnackBar("Invalid OTP!", SnackBarMessageTypes.Error);
        }
      } catch (excp) {
        EventsService().sendEvent("Aayu_OTP_Verification_Complete", {
          "otp_type": "Login",
          "status": "Fail",
          "mobile_number": loginController.userPhoneNumber.value.completeNumber,
          "error_code": excp.toString()
        });

        if (excp.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
          showGetSnackBar(
              "VERIFICATION_CODE_INVALID".tr, SnackBarMessageTypes.Error);
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

  maintainState() async {
    try {
      UserDetailsResponse? userDetailsResponse = await ProfileService()
          .getUserByMobileEmail(
              loginController.userPhoneNumber.value.completeNumber
                  .replaceAll("+", ""),
              FirebaseAuth.instance.currentUser?.email ?? "");
      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        EventsService().sendEvent("Aayu_Login", {
          "mobile_number": loginController.userPhoneNumber.value.completeNumber,
          "user_id": userDetailsResponse.userDetails!.userId!,
          "source": ""
        });
        await HiveService().saveDetails(
          "userIdDetails",
          OnboardingResponse.fromJson(userDetailsResponse.userDetails!.toJson())
              .toJson(),
        );

        await HiveService()
            .saveDetails("userDetails", userDetailsResponse.toJson());

        globalUserIdDetails = UserRegistrationResponse.fromJson(
            userDetailsResponse.userDetails!.toJson());

        FlurryService().setUserId(userDetailsResponse.userDetails!.userId!);
        MoengageService().setUserId(userDetailsResponse.userDetails!.userId!);

        MoengageService().setGender(userDetailsResponse.userDetails!.gender!);
        MoengageService().setUserName(
            "${userDetailsResponse.userDetails!.firstName ?? ""} ${userDetailsResponse.userDetails!.lastName ?? ""}");
        MoengageService().setPhoneNumber(
            loginController.userPhoneNumber.value.completeNumber);
        SingularDeepLinkController singularDeepLinkController = Get.find();
        MoengageService().setUserSourceAndCampaign(
            singularDeepLinkController.utmSource,
            singularDeepLinkController.utmCampaign);

        ProfileService()
            .updateLastLogin(userDetailsResponse.userDetails!.userId!);
        ProfileService().updateLatestVersionNumber(
            userDetailsResponse.userDetails!.userId!);

        FirebaseMessaging.instance.getToken().then((token) {
          OnboardingService().sendFirebaseToken(
              userDetailsResponse.userDetails!.userId!, token!);
        });
        fetchBackgroundDataAndPush();
      } else {
        showGetSnackBar(
            "State maintainance failed", SnackBarMessageTypes.Error);
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  fetchBackgroundDataAndPush() async {
    try {
      //Healing Diease List
      Get.put(HealingListController());

      //Grow Page Categories with 1st Category Content
      Get.put(GrowController());

      //You Page Minutes Summary
      YouController youController = Get.put(YouController(), permanent: true);
      //Subscription
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());

      await Future.wait([
        youController.getMinutesSummary(),
        subscriptionController.checkSubscription()
      ]);
    } finally {
      EventsService().sendClickNextEvent("LoginOTP", "Verify OTP", "Home");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const MainPage(
                    selectedTab: 0,
                  )),
          (Route<dynamic> route) => false);
    }
  }
}
