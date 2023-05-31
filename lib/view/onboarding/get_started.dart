import 'package:aayu/controller/onboarding/get_started_controller.dart';
import 'package:aayu/controller/onboarding/login/login_controller.dart';
import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/onboarding/login/login_bottom_sheet.dart';
import 'package:aayu/view/onboarding/onboarding_bottom_sheet.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lottie/lottie.dart';

import '../../controller/grow/grow_controller.dart';
import '../../controller/healing/healing_list_controller.dart';
import '../../controller/subscription/subscription_controller.dart';
import '../../controller/you/you_controller.dart';
import '../main_page.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetStartedController getStartedController = Get.put(GetStartedController());
    return WillPopScope(
      onWillPop: () => _willPopScope(context),
      child: Scaffold(
        body: Obx(
          () {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.0.h,
                    ),
                    SvgPicture.asset(
                      AppIcons.aayuOnboardingIconSVG,
                      width: 27.w,
                      height: 36.h,
                    ),
                    SizedBox(
                      height: 30.0.h,
                    ),
                    CarouselSlider.builder(
                      itemCount: getStartedController
                              .getStartedScreenData.value.screens!.length +
                          1,
                      itemBuilder:
                          (BuildContext context, int index, int value) {
                        if (index == 0) {
                          return onBoardHealingSlider();
                        }
                        return onBoardSlider(getStartedController
                            .getStartedScreenData.value.screens![index - 1]!);
                      },
                      options: CarouselOptions(
                        initialPage: 0,
                        height: 488.h,
                        enlargeCenterPage: false,
                        autoPlayCurve: Curves.easeOutSine,
                        viewportFraction: 1,
                        autoPlay: true,
                        reverse: false,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          getStartedController.currentIndex.value = index;
                        },
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 2000),
                        pauseAutoPlayOnTouch: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          getStartedController
                                  .getStartedScreenData.value.screens!.length +
                              1,
                          (index) => Container(
                            width: 8.h,
                            height: 8.h,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: getStartedController.currentIndex.value ==
                                      index
                                  ? AppColors.primaryColor
                                  : const Color(0xFFC4C4C4).withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    getStartedButton(),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (remoteConfigData != null &&
                        remoteConfigData!.getString('SKIP_REGISTRATION') ==
                            'SHOW_SKIP')
                      InkWell(
                        onTap: () async {
                          fetchBackgroundDataAndPush(context);
                        },
                        child: Text(
                          "Do it Later",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: "Circular Std",
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryLabelColor,
                            height: 1.14.h,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          color: AppColors.lightPrimaryColor,
          width: double.infinity,
          height: 45.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ALREADY_MEMBER'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Circular Std",
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryLabelColor,
                  height: 1.14.h,
                  fontSize: 14.sp,
                ),
              ),
              InkWell(
                onTap: () async {
                  LoginController loginController = Get.put(LoginController());
                  loginController.isRegistered.value = true;
                  loginController.userPhoneNumber.value = PhoneNumber(
                      countryISOCode: "IN", countryCode: "IN", number: "");
                  loginController.phoneNumberController.text = "";
                  loginController.update();
                  EventsService().sendClickNextEvent(
                      "GetStarted", "Already Member", "Login Bottom Sheet");
                  Get.to(const LoginBottomSheet())!.then((value) =>
                      EventsService().sendClickBackEvent(
                          "Login_EnterNumber", "Back", "GetStarted"));
                },
                child: Text(
                  "LOGIN".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Circular Std",
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryLabelColor,
                    decoration: TextDecoration.underline,
                    height: 1.14.h,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fetchBackgroundDataAndPush(BuildContext context) async {
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
        subscriptionController.checkSubscription(),
      ]);
    } catch (e) {
      print(e);
    } finally {
      EventsService()
          .sendClickNextEvent("SplashScreen", "ExistingUser", "Home");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(
            selectedTab: 0,
          ),
        ),
      );
    }
  }

  Widget onBoardSlider(GetStartedScreenModelScreens screenData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          screenData.heading ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Baskerville",
            fontWeight: FontWeight.w400,
            fontSize: 34.0,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          width: 300.w,
          child: Text(
            screenData.subTitle ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Circular Std",
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: AppColors.secondaryLabelColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 26.h),
          child: Container(
            margin: EdgeInsets.zero,
            height: 280.h,
            width: double.infinity,
            alignment: Alignment.center,
            child: Image(
              image: AssetImage(screenData.image!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget onBoardHealingSlider() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Health Management\nPrograms",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Baskerville",
            fontWeight: FontWeight.w400,
            fontSize: 34.0,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          width: 300.w,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 14.sp,
                fontFamily: "Circular Std",
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
              ),
              text:
                  "All programs are designed based on 4 decades of scientific research by ",
              children: <TextSpan>[
                TextSpan(
                    text: "S-VYASA",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: AppColors.secondaryLabelColor,
                      fontFamily: "Circular Std",
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.bottomSheet(Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.w),
                              topRight: Radius.circular(30.w),
                            ),
                          ),
                          height: 320.h,
                          width: 375.w,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 36, right: 29),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 35.25.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "About S-VYASA",
                                      style: TextStyle(
                                        fontFamily: "Circular Std",
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.secondaryLabelColor,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.close)),
                                  ],
                                ),
                                DropCapText(
                                  "\nS-VYASA is a globally\n reputed institution known\n for its rigorous, 4 decades\n long research on the science of yoga and healing. S-VYASA is affiliated with renowned universities such as Harvard and Stanford. Its published clinical research papers on yoga - science based healing for chronic diseases are cited internationally.",
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 14.sp,
                                    fontFamily: "Circular Std",
                                    color: AppColors.secondaryLabelColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  dropCapPosition: DropCapPosition.start,
                                  dropCap: DropCap(
                                    width: 132.w,
                                    height: 100.h,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 12.0.h, right: 16.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 24.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F7F7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.asset(
                                        Images.svyasaImage,
                                        width: 90.5.w,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                      }),
                TextSpan(
                  text:
                      ", a world leader in yoga research. Get the results you can measure.",
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: "Circular Std",
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 26.h),
          child: Container(
            margin: EdgeInsets.zero,
            height: 280.h,
            width: double.infinity,
            alignment: Alignment.center,
            child: Lottie.asset(
              Images.healingProgramLottie,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              repeat: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget getStartedButton() {
    return InkWell(
      onTap: () {
        EventsService()
            .sendEvent("Appwalkthrough_Register_Signup", {"type": "Signup"});

        Get.put(OnboardingBottomSheetController(true));
        Get.to(
          const OnboardingBottomSheet(),
        );
      },
      child: Container(
        height: 54.h,
        width: 222.h,
        decoration: AppTheme.mainButtonDecoration,
        child: Center(
          child: Text(
            "Register",
            textAlign: TextAlign.center,
            style: mainButtonTextStyle(),
          ),
        ),
      ),
    );
  }

  _willPopScope(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EXIT_AAYU'.tr,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                'ARE_YOU_SURE_YOU_WANT_TO_LEAVE'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromRGBO(86, 103, 137, 0.26),
                                  width: 1),
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'NO'.tr,
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          padding: EdgeInsets.symmetric(vertical: 9.h)),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text(
                        'YES'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ).then((exit) {
      if (exit) {
        return Future<bool>.value(true);
      }

      return Future<bool>.value(false);
    });
  }
}
