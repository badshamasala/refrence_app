import 'package:aayu/controller/onboarding/login/post_login_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/model/response.error.dart';
import 'package:aayu/services/hive.service.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase, DateFormat;
import 'package:intl_phone_field/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';

import '../../../controller/onboarding/login/login_controller.dart';
import '../../../controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import '../../onboarding/onboarding_bottom_sheet.dart';

appBar(title, iconData, onPressed) {
  return AppBar(
    backgroundColor: AppColors.pageBackgroundColor,
    elevation: 0,
    titleSpacing: 0,
    centerTitle: true,
    title: Text(
      title,
      style: appBarTextStyle(),
    ),
    leading: IconButton(
      onPressed: onPressed,
      iconSize: 20.w,
      icon: Icon(
        iconData,
        color: AppColors.blackLabelColor,
      ),
    ),
  );
}

appBarTransparent(title, iconData, onPressed) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleSpacing: 0,
    centerTitle: true,
    title: Text(
      title,
      style: appBarTextStyle(),
    ),
    leading: IconButton(
      onPressed: onPressed,
      iconSize: 20.w,
      icon: Icon(
        iconData,
        color: AppColors.blackLabelColor,
      ),
    ),
  );
}

appBarWithOnlyLeading(iconData, onPressed) {
  return AppBar(
    backgroundColor: AppColors.pageBackgroundColor,
    elevation: 0,
    leading: IconButton(
      padding: const EdgeInsets.all(12),
      onPressed: onPressed,
      iconSize: 20.w,
      icon: Icon(
        iconData,
        color: AppColors.blackLabelColor,
      ),
    ),
  );
}

appBarWithImage(String title, Function onBackPressed) {
  return Container(
    width: double.infinity,
    height: 100.h,
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fitWidth,
        image: AssetImage(Images.planSummaryBGImage),
      ),
    ),
    child: AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: Text(
        title,
        style: appBarTextStyle(),
      ),
      leading: IconButton(
        onPressed: () {
          onBackPressed();
        },
        iconSize: 20.w,
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.blackLabelColor,
        ),
      ),
    ),
  );
}

showGreenSnackBar(BuildContext? context, String message) {
  if (context == null) {
    Get.snackbar(
      '',
      message,
      margin: EdgeInsets.zero,
      snackPosition: SnackPosition.BOTTOM,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      barBlur: 0,
      messageText: SizedBox(
        height: 54.h,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //     offset: const Offset(0, 8),
                  //     blurRadius: 29,
                  //     color: AppColors.secondaryLabelColor.withOpacity(0.7),
                  //   )
                  // ],
                  ),
              width: double.infinity,
              height: 54.h,
              child: Image.asset(
                Images.greenToast,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Circular Std',
                color: AppColors.blackLabelColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),
        content: SizedBox(
          height: 54.h,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 29,
                      color: AppColors.secondaryLabelColor.withOpacity(0.7),
                    )
                  ],
                ),
                width: double.infinity,
                height: 54.h,
                child: Image.asset(
                  Images.greenToast,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Circular Std',
                  color: AppColors.blackLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showOTPResentSnackBar(context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.symmetric(horizontal: 26.w, vertical: 10.h),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 320.w,
              height: 34.h,
              child: Image.asset(
                Images.greenToast,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Circular Std',
              color: AppColors.blackLabelColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}

showSnackBar(context, message, messageType) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 1,
    /* backgroundColor: (messageType == "Error")
        ? primaryColor
        : const SnackBarThemeData().backgroundColor, */
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    content: Text(
      message,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white, height: 1),
    ),
  ));
}

showGetSnackBar(message, messageType) {
  Get.snackbar(
    '',
    '',
    titleText: const Offstage(),
    messageText: Text(
      message,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white, height: 1),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackColor,
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.all(16),
  );
}

showCustomSnackBar(BuildContext context, String message,
    {durationSeconds = 4}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: durationSeconds),
      content: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 56),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 29,
                    color: AppColors.secondaryLabelColor.withOpacity(0.7),
                  )
                ],
              ),
              width: double.infinity,
              child: Image.asset(
                Images.greenToast,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Circular Std',
                  color: AppColors.blackLabelColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showCustomSnackBarWithAction(
    BuildContext context, String message, String buttonText, Function action) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 60),
      content: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 8),
                    blurRadius: 29,
                    color: AppColors.secondaryLabelColor.withOpacity(0.7),
                  )
                ],
              ),
              width: double.infinity,
              child: Image.asset(
                Images.greenToast,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'Circular Std',
                        color: AppColors.blackLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  InkWell(
                    onTap: () {
                      action();
                      ScaffoldMessenger.of(context).clearSnackBars();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppColors.whiteColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 4),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF597393),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                            height: 1.h,
                            fontFamily: "Circular Std",
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showMaterialBanner(String message, String buttonText, Function action) {
  ScaffoldMessenger.of(navState.currentState!.context)
    ..removeCurrentMaterialBanner()
    ..showMaterialBanner(
      MaterialBanner(
        elevation: 0,
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            message,
            style: TextStyle(
              fontFamily: 'Circular Std',
              color: AppColors.blackLabelColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        leading: const Offstage(),
        padding: EdgeInsets.zero,
        leadingPadding: EdgeInsets.zero,
        backgroundColor: const Color(0xFFA0F4AA),
        actions: [
          InkWell(
            onTap: () {
              action();
              ScaffoldMessenger.of(navState.currentState!.context)
                  .removeCurrentMaterialBanner();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
              height: 30.h,
              constraints: BoxConstraints(minWidth: 100.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: AppColors.whiteColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF597393),
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                    height: 1.h,
                    fontFamily: "Circular Std",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
}

getInputDecoration(hintText) {
  return InputDecoration(
    errorStyle: const TextStyle(fontSize: 14.0, color: Colors.redAccent),
    fillColor: AppColors.whiteColor,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    hintText: hintText,
    hintStyle: AppTheme.hintTextStyle,
    prefixStyle: AppTheme.hintTextStyle,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

getDateInputDecoration(hintText) {
  return InputDecoration(
    errorStyle: const TextStyle(fontSize: 14.0, color: Colors.redAccent),
    fillColor: AppColors.lightPrimaryColor,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    hintText: hintText,
    hintStyle: AppTheme.hintTextStyle,
    suffixIcon: const Icon(Icons.calendar_today),
    border: OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
  );
}

mainButtonPadding() => EdgeInsets.symmetric(horizontal: 60.w, vertical: 27.h);
pagePadding() => EdgeInsets.symmetric(horizontal: 26.w, vertical: 26.h);
pageHorizontalPadding() => EdgeInsets.symmetric(horizontal: 26.w);
pageVerticalPadding() => EdgeInsets.symmetric(vertical: 26.h);

appBarTextStyle() => TextStyle(
      color: AppColors.blackLabelColor,
      fontSize: 24.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Baskerville',
    );

secondaryFontTitleTextStyle() => TextStyle(
      color: AppColors.blackColor,
      fontSize: 28.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Baskerville',
    );

primaryFontPrimaryLabelExtraSmallTextStyle() => TextStyle(
      color: const Color(0xFFF39D9D),
      fontFamily: 'Circular Std',
      fontSize: 12.sp,
      letterSpacing: 1.5.w,
      fontWeight: FontWeight.normal,
      height: 1.h,
    );
moodTrackerPinkTitle() => TextStyle(
      color: const Color(0xFFF39D9D),
      fontFamily: 'Circular Std',
      fontSize: 14.sp,
      letterSpacing: 1.5.w,
      fontWeight: FontWeight.normal,
      height: 1.5.h,
    );

growButtonTextStyle() => TextStyle(
      color: AppColors.blackLabelColor,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.h,
      fontFamily: "Circular Std",
    );

mainButtonTextStyle() => TextStyle(
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.h,
      fontFamily: "Circular Std",
    );

disabledButtonTextStyle() => TextStyle(
      color: const Color(0xFFD1D5DA),
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.h,
      fontFamily: "Circular Std",
    );

outlinedButtonStyle() => OutlinedButton.styleFrom(
      foregroundColor: AppColors.secondaryLabelColor,
      elevation: 0,
      textStyle: TextStyle(
          color: AppColors.secondaryLabelColor,
          fontWeight: FontWeight.normal,
          fontSize: 14.sp,
          fontFamily: "Circular Std"),
    );

skipButtonTextStyle() => TextStyle(
      color: AppColors.secondaryLabelColor,
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
      fontFamily: "Circular Std",
    );
skipButtonSleepCheckinTextStyle() => TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontSize: 14.sp,
      fontFamily: "Circular Std",
    );

primaryFontRegularTextStyle() => TextStyle(
      color: AppColors.blackColor,
      fontSize: 24.sp,
      fontWeight: FontWeight.normal,
      height: 1.25.h,
    );

primaryFontPrimaryLabelSmallTextStyle() => TextStyle(
      color: AppColors.primaryLabelColor,
      fontFamily: 'Circular Std',
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      height: 1.4285714285714286.h,
    );

primaryFontSecondaryLabelSmallTextStyle() => TextStyle(
      color: AppColors.secondaryLabelColor,
      fontFamily: 'Circular Std',
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      height: 1.5.h,
    );

selectedTabTextStyle() => TextStyle(
      color: AppColors.secondaryLabelColor,
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.h,
      fontFamily: "Circular Std",
    );

unSelectedTabTextStyle() => TextStyle(
      color: AppColors.secondaryLabelColor.withOpacity(0.5),
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      height: 1.h,
      fontFamily: "Circular Std",
    );

assesmentRulerValueTextStyle() => TextStyle(
      color: AppColors.blackLabelColor,
      fontSize: 50.sp,
      letterSpacing: 0.2.w,
      fontWeight: FontWeight.w700,
      fontFamily: "Circular Std",
    );

assesmentRulerUnitTextStyle() => TextStyle(
      color: AppColors.blackLabelColor,
      fontSize: 16.sp,
      letterSpacing: 0.2.w,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std",
    );

recommendedTextStyle() => TextStyle(
      color: const Color.fromRGBO(240, 158, 158, 1),
      fontFamily: 'Circular Std',
      fontSize: 10.sp,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
      height: 2.4.h,
    );

pageBottomHeight() => SizedBox(
      height: 30.h,
    );

growButton(String buttonText) => Container(
      height: 54.h,
      decoration: AppTheme.growButtonDecoration,
      child: Center(
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: growButtonTextStyle(),
        ),
      ),
    );

mainButton(String buttonText) => Container(
      height: 54.h,
      decoration: AppTheme.mainButtonDecoration,
      child: Center(
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: mainButtonTextStyle(),
        ),
      ),
    );

disabledMainButton(String buttonText) => Container(
      height: 54.h,
      decoration: AppTheme.disabledMainButtonDecoration,
      child: Center(
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: mainButtonTextStyle(),
        ),
      ),
    );

disabledButton(String buttonText) => Container(
      height: 54.h,
      decoration: AppTheme.disabledButtonDecoration,
      child: Center(
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: disabledButtonTextStyle(),
        ),
      ),
    );

signUpWithClose(BuildContext context, String title,
        {bool showBackButton = false,
        bool showCloseButton = false,
        required bool showUnderline,
        dynamic onBackPressed,
        dynamic onClosePressed}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 35.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onBackPressed,
              icon: Icon(
                Icons.arrow_back,
                color: (showBackButton == true)
                    ? AppColors.blackColor
                    : AppColors.whiteColor,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF39D9D),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 1.5.w,
                      fontWeight: FontWeight.w400,
                      height: 1.h,
                    ),
                  ),
                  if (showUnderline)
                    SizedBox(
                      height: 20.h,
                    ),
                  if (showUnderline)
                    Center(
                      child: Container(
                        width: 20,
                        height: 3,
                        decoration: BoxDecoration(
                          color: showUnderline
                              ? AppColors.secondaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: showCloseButton
                  ? () {
                      if (onClosePressed == null) {
                        Navigator.pop(context);
                      } else {
                        onBackPressed();
                      }
                    }
                  : null,
              icon: Icon(
                Icons.close,
                color: showCloseButton
                    ? AppColors.blackColor
                    : AppColors.whiteColor,
              ),
            )
          ],
        ),
      ],
    );

onboardingTitleMessage(String title) {
  return Column(
    children: [
      Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFF39D9D),
          fontFamily: 'Circular Std',
          fontSize: 12.sp,
          letterSpacing: 1.5.w,
          fontWeight: FontWeight.w400,
          height: 1.h,
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Center(
        child: Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    ],
  );
}

buildShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      );
    },
  );
}

showAssesmentPopup(
    BuildContext context, VoidCallback doItLater, VoidCallback startNow) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: SizedBox(
            height: 272.46.h,
            width: 328.w,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                  child: Text("START_YOUR_ASSESMENT".tr),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 103.0, right: 103, top: 9.0, bottom: 11.0),
                  child: Image.asset(
                    Images.healthCardImage,
                    width: 180.w,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ANSWER_QUESTIONS_ABOUT_HEALTH ".tr,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 42,
                        width: 126,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(
                                  color: AppColors.borderAssessmentColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          onPressed: doItLater,
                          child: Text(
                            'DO_IT_LATER'.tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        width: 126.0,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.primaryColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: startNow,
                            child: Text("START_NOW".tr,
                                style: const TextStyle(fontSize: 14))),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}

showAssesementDialog(VoidCallback doItLater, VoidCallback startNow) {
  return Get.defaultDialog(
    barrierDismissible: true,
    title: '',
    content: SizedBox(
      height: 283.46.h,
      width: 348.w,
      child: Column(
        children: [
          Text(
            "START_YOUR_ASSESMENT".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackColor,
              fontFamily: 'Circular Std',
              fontSize: 19.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 114.0,
              child: Image.asset(
                Images.healthCardImage,
                width: 160.w,
                height: 59.46,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ANSWER_QUESTIONS_ABOUT_HEALTH".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: doItLater,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderAssessmentColor,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: 42,
                    width: 126,
                    child: Center(
                      child: Text(
                        'DO_IT_LATER'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: startNow,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.whiteColor,
                        ),
                        color: AppColors.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: 42,
                    width: 126,
                    child: Center(
                      child: Text(
                        'START_NOW'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: 'Circular Std',
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

showSkipPopupScreen(BuildContext context, VoidCallback onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          width: 328.w,
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 328.w,
                child: Text(
                  "SURE_YOU_WANT_TO_SKIP".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 16.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 28.h,
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
                      onPressed: onPressed,
                      child: Text(
                        'ANSWER_LATER'.tr,
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
                        padding: EdgeInsets.symmetric(vertical: 9.h),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'ANSWER_NOW'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

showLoading() {
  return const Center(
    child: CircularProgressIndicator(
      color: AppColors.primaryColor,
    ),
  );
}

showError(dynamic errorDetails) {
  try {
    if (errorDetails != null && errorDetails["code"] != null) {
      ResponseError responseError = ResponseError.fromJson(errorDetails);
      EventsService().sendEvent("API_ERROR", {
        "code": "${responseError.code ?? ""}",
        "message": responseError.message,
      });
      // showGetSnackBar("${responseError.code}:${responseError.message}",
      //     SnackBarMessageTypes.Error);
      // }
    }
  } catch (e) {}
}

buildHealingTabRow(String imagePath, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShowNetworkImage(
          imgPath: imagePath,
          imgWidth: 20,
          imgHeight: 20,
        ),
        SizedBox(
          width: 13.w,
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              height: 1.2.h,
            ),
          ),
        )
      ],
    ),
  );
}

postAssessmentHeader(BuildContext context, String title,
        {bool showBackButton = false, dynamic onBackPressed}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: Icon(
            Icons.arrow_back,
            color: (showBackButton == true)
                ? AppColors.blackLabelColor
                : AppColors.whiteColor,
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              letterSpacing: 1.5.w,
              fontWeight: FontWeight.normal,
              height: 1.16.h,
            ),
          ),
        ),
      ],
    );

personalCareDurationHeader(BuildContext context, String title,
        {bool showBackButton = false, dynamic onBackPressed}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: Icon(
            Icons.arrow_back,
            color: (showBackButton == true)
                ? AppColors.blackLabelColor
                : AppColors.whiteColor,
          ),
        ),
        Expanded(
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              letterSpacing: 1.5.w,
              fontWeight: FontWeight.normal,
              height: 1.16.h,
            ),
          ),
        ),
      ],
    );

showAayuHealing() {
  return Center(
    child: Image(
      width: 183.w,
      fit: BoxFit.fitWidth,
      image: const AssetImage(Images.aayuHealingImage),
    ),
  );
}

String toTitleCase(String str) {
  /* return str
      .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
              "${m[0]![0].toUpperCase()}${m[0]!.substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-)+'), ' '); */

  return toBeginningOfSentenceCase(str)!;
}

DateTime returnDate(String date) {
  List<String> list = date.trim().split("-");
  return DateTime(int.parse(list[0]), int.parse(list[1]), int.parse(list[2]));
}

DateTime dateFromTimestamp(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(
    timestamp,
  );
}

String formatDatetoThForm(DateTime date) {
  var suffix = "th";
  var digit = date.day % 10;
  if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
    suffix = ["st", "nd", "rd"][digit - 1];
  }
  return DateFormat("d'$suffix' MMM, yyyy").format(date);
}

String formatDate({required String format, required String date}) {
  List<String> list = date.trim().split("-");
  DateTime dateTime =
      DateTime(int.parse(list[0]), int.parse(list[1]), int.parse(list[2]));
  return DateFormat(format).format(dateTime);
}

launchCustomUrl(String url) async {
  try {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showGetSnackBar("Can not launch URL", SnackBarMessageTypes.Info);
    }
  } catch (error) {
    rethrow;
  }
}

sendAssessmentEvent(String eventName) {
  if (subscriptionCheckResponse != null &&
      subscriptionCheckResponse!.subscriptionDetails != null) {
    String diseaseId = "";
    for (var element
        in subscriptionCheckResponse!.subscriptionDetails!.disease!) {
      if (diseaseId.isEmpty) {
        diseaseId = element!.diseaseId!;
      } else {
        diseaseId = "$diseaseId, ${element!.diseaseId!}";
      }
    }

    String diseaseNames = "";
    for (var element
        in subscriptionCheckResponse!.subscriptionDetails!.disease!) {
      if (diseaseNames.isEmpty) {
        diseaseNames = element!.diseaseName!;
      } else {
        diseaseNames = "$diseaseNames, ${element!.diseaseName!}";
      }
    }

    EventsService().sendEvent(eventName, {
      "program_id": subscriptionCheckResponse!.subscriptionDetails!.programId,
      "program_name":
          subscriptionCheckResponse!.subscriptionDetails!.programName,
      "disease_id": diseaseId,
      "disease_name": diseaseNames,
      "duration": subscriptionCheckResponse!.subscriptionDetails!.duration,
      "period": subscriptionCheckResponse!.subscriptionDetails!.period,
      "start_date": subscriptionCheckResponse!.subscriptionDetails!.startDate,
      "subscribe_date":
          subscriptionCheckResponse!.subscriptionDetails!.subscribeDate,
      "date_time": DateTime.now().toString()
    });
  }
}

circularConsultImage(
    String coachType, String? profilePic, double width, double height) {
  String consultantImage = "";

  if (coachType == "DOCTOR") {
    consultantImage = Images.doctorImage;
  } else if (coachType == "TRAINER") {
    consultantImage = Images.personalTraining2Image;
  } else if (coachType == "NUTRITIONIST") {
    consultantImage = Images.nutritionistImage;
  } else if (coachType == "PSYCHOLOGIST") {
    consultantImage = Images.doctorImage;
  } else {
    consultantImage = Images.doctorImage;
  }

  return (profilePic != null && profilePic.isNotEmpty)
      ? CircleAvatar(
          radius: width / 2.w,
          backgroundColor: AppColors.whiteColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width / 2.w),
            child: ShowNetworkImage(
              imgPath: profilePic,
              imgWidth: width,
              imgHeight: height,
              boxFit: BoxFit.fill,
            ),
          ),
        )
      : CircleAvatar(
          radius: width / 2.w,
          backgroundColor: AppColors.whiteColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width / 2.w),
            child: Image(
              image: AssetImage(consultantImage),
              fit: BoxFit.fill,
            ),
          ),
        );
}

imglib.Image convertJpeg(CameraImage image) {
  return imglib.Image.fromBytes(
      image.width, image.height, image.planes[0].bytes,
      format: imglib.Format.bgra);
}

showScheduledSessionPopup(String consultationType, String consultantName,
    String profilePic, String scheduleDate, String scheduleTime) {
  Get.defaultDialog(
      title: "",
      backgroundColor: Colors.transparent,
      radius: 0,
      content: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 58.h),
            padding: pagePadding(),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.w),
            ),
            width: 328.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 70.h,
                ),
                SizedBox(
                  width: 194.w,
                  child: Text(
                    "Your session with",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Circular Std",
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  consultantName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Baskerville",
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "is booked!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Circular Std",
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 17.h),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F5),
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Column(children: [
                    scheduleDetails("Date: ", scheduleDate),
                    Divider(
                      color: AppColors.secondaryLabelColor.withOpacity(0.1),
                    ),
                    scheduleDetails("Time: ", scheduleTime),
                  ]),
                ),
                SizedBox(
                  width: 232.w,
                  child: Text(
                    "You will receive a message with a link to join your call 15 minutes before it starts.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Circular Std",
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: mainButton("Okay"),
                )
              ],
            ),
          ),
          Positioned(
            top: 0.h,
            left: 0.w,
            right: 0,
            child: circularConsultImage(consultationType, profilePic, 134, 134),
          ),
        ],
      ));
}

scheduleDetails(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            fontFamily: "Circular Std",
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "Circular Std",
          ),
        ),
        const Spacer(),
        SvgPicture.asset(
          AppIcons.tickSVG,
          width: 14.w,
          height: 9.5.h,
          fit: BoxFit.contain,
          color: AppColors.secondaryLabelColor,
        ),
      ],
    ),
  );
}

String getFormattedNumber(double number) {
  dynamic result;
  if (number % 1 == 0) {
    result = number.toInt();
  } else {
    result = number.toStringAsFixed(2);
  }
  return result.toString();
}

checkIsPaymentAllowed(String source) async {
  if (globalUserIdDetails?.userId == null) {
    userLoginDialog({});
    return;
  }
  if (appProperties.payment!.global!.allowAll == true) {
    return true;
  } else {
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();
    if (userDetailsResponse != null &&
        userDetailsResponse.userDetails != null) {
      if (userDetailsResponse.userDetails!.location != null &&
          userDetailsResponse.userDetails!.location!.isNotEmpty) {
        String userCountry =
            userDetailsResponse.userDetails!.location!.first!.country!;
        if (userCountry.isNotEmpty) {
          bool isAllowed = appProperties.payment!.global!.allowedCountries!
              .contains(userCountry.trim());
          if (isAllowed == true) {
            return true;
          }
        }
      }
    }

    String communication = "";
    if (source == "DOCTOR_CONSULTATION") {
      communication = appProperties
          .payment!.global!.communications!.notAvailable!.consultation!.doctor!;
    } else if (source == "THERAPIST_CONSULTATION") {
      communication = appProperties.payment!.global!.communications!
          .notAvailable!.consultation!.therapist!;
    } else if (source == "HEALING") {
      communication =
          appProperties.payment!.global!.communications!.notAvailable!.healing!;
    } else if (source == "GROW") {
      communication =
          appProperties.payment!.global!.communications!.notAvailable!.grow!;
    } else if (source == "LIVE_EVENT") {
      communication = appProperties
          .payment!.global!.communications!.notAvailable!.liveEvent!;
    } else if (source == "PERSONAL_CARE") {
      communication = appProperties
          .payment!.global!.communications!.notAvailable!.personalCare!;
    } else {
      communication =
          appProperties.payment!.global!.communications!.notAvailable!.general!;
    }
    showCustomSnackBar(Get.context!, communication);
    return false;
  }
}

userLoginDialog(Map<String, dynamic> map) {
  LoginController loginController = Get.put(LoginController());
  PostLoginController postLoginController = Get.find();
  postLoginController.storeData(map);
  loginController.isRegistered.value = true;
  loginController.userPhoneNumber.value =
      PhoneNumber(countryISOCode: "IN", countryCode: "IN", number: "");
  loginController.phoneNumberController.text = "";
  loginController.update();
  EventsService()
      .sendClickNextEvent("GetStarted", "Already Member", "Login Bottom Sheet");
  Get.put(OnboardingBottomSheetController(true));

  Get.to(const OnboardingBottomSheet(), transition: Transition.native)!.then(
      (value) => EventsService()
          .sendClickBackEvent("Login_EnterNumber", "Back", "GetStarted"));
}

showNetworkDialog(
    Function? onRetry, Function onExit, String header, String description) {
  Get.dialog(
      AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Container(
          padding:
              EdgeInsets.only(top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.primaryColor,
                size: 50,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                header,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Circular Std"),
              ),
              SizedBox(
                height: 21.h,
              ),
              Text(
                description,
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
                        onExit();
                      },
                      child: Text(
                        'Exit',
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                  if (onRetry != null)
                    SizedBox(
                      width: 8.w,
                    ),
                  if (onRetry != null)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            padding: EdgeInsets.symmetric(vertical: 9.h)),
                        onPressed: () {
                          onRetry();
                        },
                        child: Text(
                          'Retry',
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
      barrierDismissible: false);
}
