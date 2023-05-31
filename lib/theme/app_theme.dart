import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  /* AppTheme._(); */

  static const physics = BouncingScrollPhysics();

  static const splashScreenBoxShadow = [
    BoxShadow(
        color: AppColors.lightSecondaryColor,
        offset: Offset(0, 0),
        blurRadius: 10,
        spreadRadius: 5)
  ];

  static const imageBoxShadow = [
    BoxShadow(
        color: Colors.black45,
        offset: Offset(0, 0),
        blurRadius: 5,
        spreadRadius: 0)
  ];

  static const onboardingOptionDecoration = BoxDecoration(
    color: AppColors.lightPrimaryColor,
    boxShadow: [
      BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 0),
          blurRadius: 3,
          spreadRadius: 0)
    ],
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  );

  static const onboardingOptionSelectedDecoration = BoxDecoration(
    color: AppColors.secondaryColor,
    boxShadow: [
      BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 0),
          blurRadius: 3,
          spreadRadius: 0)
    ],
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  );
  static const pageAll = EdgeInsets.all(26);
  static const pagePadding = EdgeInsets.symmetric(horizontal: 26, vertical: 26);
  static const pageHorizontalPadding = EdgeInsets.symmetric(horizontal: 26);
  static const pageVerticalPadding = EdgeInsets.symmetric(vertical: 26);
  static const assessmentPadding =
      EdgeInsets.only(left: 26, right: 26, top: 8, bottom: 0);
  static const sessionsPadding = EdgeInsets.symmetric(vertical: 7);

  static const mainButtonPadding =
      EdgeInsets.symmetric(horizontal: 60, vertical: 15);

  static ButtonStyle loginOptionButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    onPrimary: AppColors.secondaryColor,
    primary: AppColors.lightPrimaryColor,
    textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    padding: const EdgeInsets.all(15),
  );

  static BoxDecoration disabledButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: const Color(0xFFF5F5F5),
    /* boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
        offset: Offset(-5, 10),
        blurRadius: 20,
      ),
    ], */
  );

  static BoxDecoration growButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: const Color(0xFFAAFDB4),
    boxShadow: const [
      BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
          offset: Offset(-5, 10),
          blurRadius: 20),
    ],
  );
  
  static BoxDecoration mainButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: AppColors.primaryColor,
    boxShadow: const [
      BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
          offset: Offset(-5, 10),
          blurRadius: 20),
    ],
  );

  static BoxDecoration disabledMainButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: AppColors.primaryColor.withOpacity(0.4),
    boxShadow: const [
      BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
          offset: Offset(-5, 10),
          blurRadius: 20),
    ],
  );

  static const TextStyle mainButtonTextStyle = TextStyle(
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      fontFamily: "Circular Std");

  static ButtonStyle mainButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    onPrimary: AppColors.whiteColor,
    primary: AppColors.primaryColor,
    textStyle: const TextStyle(
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        fontFamily: "Circular Std"),
    shadowColor: const Color.fromRGBO(0, 0, 0, 0.07000000029802322),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
    padding: const EdgeInsets.symmetric(vertical: 18),
  );
  static ButtonStyle disableMainButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    onPrimary: const Color(0xFFC4C4C4),
    primary: const Color(0xFFE5E5E5),
    textStyle: const TextStyle(
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        fontFamily: "Circular Std"),
    shadowColor: const Color.fromRGBO(0, 0, 0, 0.07000000029802322),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
    padding: const EdgeInsets.symmetric(vertical: 18),
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    elevation: 0,
    primary: AppColors.secondaryLabelColor,
    textStyle: const TextStyle(
        color: AppColors.secondaryLabelColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        fontFamily: "Circular Std"),
  );

  static const appBarTextStyle = TextStyle(
      color: AppColors.blackLabelColor,
      fontSize: 28,
      fontWeight: FontWeight.w600);

  static const secondarySmallFontTitleTextStyle = TextStyle(
    color: AppColors.blackLabelColor,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Baskerville',
  );

  static const secondaryFontTitleTextStyle = TextStyle(
    color: AppColors.blackColor,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    fontFamily: 'Baskerville',
  );
  static const secondaryFontBigTitleTextStyle = TextStyle(
    color: AppColors.blackLabelColor,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    fontFamily: 'Baskerville',
  );

  static const subTitleTextStyle = TextStyle(
    color: Color(0xFF496074),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Baskerville',
  );

  static const primaryFontRegularTextStyle = TextStyle(
      color: AppColors.blackColor,
      fontSize: 24,
      fontWeight: FontWeight.normal,
      height: 1.25);

  static const primaryFontPrimaryLabelExtraSmallTextStyle = TextStyle(
      color: Color(0xFFF39D9D),
      fontFamily: 'Circular Std',
      fontSize: 12,
      letterSpacing: 1.5,
      fontWeight: FontWeight.normal,
      height: 1.5);
  static const secondaryFontPrimaryLabelExtraSmallTextStyle = TextStyle(
      color: Color(0xFF8F9DA8),
      fontFamily: 'Circular Std',
      fontSize: 12,
      letterSpacing: 1.5,
      fontWeight: FontWeight.normal,
      height: 1.5);

  static const commanTextStyle = TextStyle(
      color: Color(0xFF768897),
      fontFamily: 'Circular Std',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5);

  static const primaryFontPrimaryLabelSmallTextStyle = TextStyle(
      color: AppColors.primaryLabelColor,
      fontFamily: 'Circular Std',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5);

  static const primaryFontSecondaryLabelSmallTextStyle = TextStyle(
      color: AppColors.secondaryLabelColor,
      fontFamily: 'Circular Std',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5);

  static const primaryFontSecondaryLabelBoldTextStyle = TextStyle(
      color: AppColors.secondaryLabelColor,
      fontFamily: 'Circular Std',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      height: 1.5);

  static const microTextStyle = TextStyle(
      color: AppColors.blackAssessmentColor,
      fontSize: 14,
      fontWeight: FontWeight.w400);
  static const microTextStyleAssessment = TextStyle(
      color: AppColors.whiteAssessmentColor,
      fontSize: 14,
      fontWeight: FontWeight.w400);

  static const extraSmallTextStyle = TextStyle(
      color: AppColors.blackColor, fontSize: 18, fontWeight: FontWeight.w400);
  static const smallTextStyle = TextStyle(
      color: AppColors.blackColor, fontSize: 21, fontWeight: FontWeight.w400);
  static const regularTextStyle = TextStyle(
      color: AppColors.blackColor, fontSize: 21, fontWeight: FontWeight.w500);
  static const bigTextStyle = TextStyle(
      color: AppColors.blackColor, fontSize: 24, fontWeight: FontWeight.w600);
  static const extraBigTextStyle = TextStyle(
      color: AppColors.blackColor, fontSize: 28, fontWeight: FontWeight.w600);

  static const bigItalicTextStyle = TextStyle(
      color: AppColors.blackColor,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic);

  static const optionSelectedTextStyle = TextStyle(
      color: AppColors.whiteColor,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontFamily: "Circular Std");
  static const optionNonSelectedTextStyle = TextStyle(
      color: AppColors.primaryLabelColor,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      fontFamily: "Circular Std");

  static const hintTextStyle = TextStyle(
      color: Color(0xFF8F9DA8),
      fontSize: 16,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std");
  static const hintTextStyleUnique = TextStyle(
      color: Color(0xFF8F9DA8),
      fontSize: 12,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std");

  static const tittleTextStyle = TextStyle(
      color: Color(0xFF5B7081),
      fontSize: 16,
      // letterSpacing: 0.4,
      fontWeight: FontWeight.w700,
      fontFamily: "Circular Std");

  static const errorTextStyle = TextStyle(
      color: AppColors.errorColor,
      fontSize: 12,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std");

  static const assesmentBigTextStyle = TextStyle(
      color: Color(0xFF344553),
      fontSize: 50,
      letterSpacing: 0.2,
      fontWeight: FontWeight.w700,
      fontFamily: "Circular Std");

  static const assesmentSmallTextStyle = TextStyle(
      color: Color(0xFF344553),
      fontSize: 16,
      letterSpacing: 0.32,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std");
  static const inputTextStyle = TextStyle(
      color: AppColors.blackLabelColor,
      fontSize: 21,
      fontWeight: FontWeight.w600);
  static const inputEditProfileTextStyle = TextStyle(
      color: AppColors.blackLabelColor,
      fontSize: 18,
      fontWeight: FontWeight.w400);

  static const durationBigTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 36,
      //letterSpacing: 0.2,
      fontWeight: FontWeight.w900,
      fontFamily: "Circular Std");

  static const periodBigTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      //letterSpacing: 0.2,
      fontWeight: FontWeight.w900,
      fontFamily: "Circular Std");

  static const durationSmallTextStyle = TextStyle(
      color: Color(0xFFF09E9E),
      fontFamily: 'Circular Std',
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1.5);
  static const priceTextStyle = TextStyle(
      color: Color(0xFF344553),
      fontFamily: 'Circular Std',
      fontSize: 20,
      fontWeight: FontWeight.w400,
      height: 1.5);

  static const contentTextStyle = TextStyle(
      color: Color(0xFF5B7081),
      fontSize: 12,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std");

  static const durationTextStyle = TextStyle(
      color: Color(0xFF5B7081),
      fontSize: 11,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w700,
      fontFamily: "Circular Std");
  static const secondarySmallFontTitleTextStyleSleeptracker = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: 'Baskerville',
  );
  static const pageViewSleepTrackerTitle = TextStyle(
    color: Color(0xFF54B0B3),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Circular Std',
  );
  static final sleepTrackerSubtitleTextStyle = TextStyle(
      color: const Color(0xFFBDB6FA),
      fontSize: 14.sp,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400,
      fontFamily: "Circular Std");
}
