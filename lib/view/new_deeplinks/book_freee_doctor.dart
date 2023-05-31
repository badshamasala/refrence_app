import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import '../onboarding/onboarding_bottom_sheet.dart';

class BookFreeDoctor extends StatelessWidget {
  final Map<String, dynamic>? deeplinkData;
  final Function? bookFunction;
  final bool allowBack;
  const BookFreeDoctor(
      {Key? key, this.deeplinkData, this.allowBack = true, this.bookFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingularDeepLinkController singularDeepLinkController = Get.find();
    Get.put(OnboardingBottomSheetController(true));

    return WillPopScope(
        onWillPop: () async {
          if (allowBack == true) {
            return true;
          }
          return false;
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: false,
                pinned: true,
                floating: true,
                titleSpacing: 0,
                elevation: 0,
                centerTitle: true,
                leading: null,
                flexibleSpace: Stack(
                  children: [
                    Image(
                      image: const AssetImage(Images.planSummaryBGImage),
                      fit: BoxFit.cover,
                      height: 151.h,
                    ),
                    allowBack == true
                        ? Positioned(
                            top: 26.h,
                            left: 10.w,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.blackLabelColor,
                              ),
                            ),
                          )
                        : const Offstage()
                  ],
                ),
                expandedHeight: 256.h,
                backgroundColor: AppColors.whiteColor,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: Size(256.w, 256.h),
                  child: Image(
                    width: 256.w,
                    height: 256.h,
                    fit: BoxFit.contain,
                    image: const AssetImage(Images.doctorImageDeeplinkImsge),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 26.w, right: 26.w, bottom: 26.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Doctor Consultation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Baskerville",
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      SizedBox(
                        width: 320.w,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                            ),
                            text: "Get access to certified doctors from ",
                            children: <TextSpan>[
                              TextSpan(
                                text: "S-VYASA",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.secondaryLabelColor,
                                  fontSize: 14.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    EventsService().sendEvent(
                                        "DL_DOC_LP", {"click": "S-VYASA"});
                                    Get.bottomSheet(
                                      Container(
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
                                          padding: const EdgeInsets.only(
                                              left: 36, right: 29),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 35.25.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "About S-VYASA",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "Circular Std",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors
                                                          .secondaryLabelColor,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      icon: const Icon(
                                                          Icons.close)),
                                                ],
                                              ),
                                              DropCapText(
                                                "\nS-VYASA is a globally\n reputed institution known\n for its rigorous, 4 decades\n long research on the\n science of yoga and healing. S-VYASA is\n affiliated with renowned universities such as\n Harvard and Stanford. Its published clinical\n research papers on yoga - science based healing\n for chronic diseases are cited internationally.",
                                                style: TextStyle(
                                                  height: 1.5,
                                                  fontSize: 14.sp,
                                                  color: const Color.fromRGBO(
                                                      91, 112, 129, 0.8),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                dropCapPosition:
                                                    DropCapPosition.start,
                                                dropCap: DropCap(
                                                  width: 132.w,
                                                  height: 100.h,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 12.0.h,
                                                        right: 16.h),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 24.h),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFF7F7F7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: ", trained in integrated yoga therapy.",
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontSize: 14.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 40.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9EEF3).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24.w),
                        ),
                        width: 322.w,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Text(
                                "HOW IT WORKS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.blackLabelColor
                                      .withOpacity(0.6),
                                  fontFamily: 'Circular Std',
                                  fontSize: 12.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                  height: 1.h,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(24.w),
                                  bottomLeft: Radius.circular(24.w),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildHeader("PRE CALL:"),
                                  buildPreCall(),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  buildHeader("POST CALL:"),
                                  buildPostCall(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Visibility(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 26.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                      offset: Offset(-5, 10),
                      blurRadius: 20)
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (deeplinkData != null) {
                    EventsService()
                        .sendEvent("DL_DOC_LP", {"click": "Get Started"});

                    singularDeepLinkController
                        .setDeepLinkDataContinued(deeplinkData!);
                    singularDeepLinkController.nullDeepLinkData();

                    Get.to(
                      const OnboardingBottomSheet(),
                    );
                  }

                  if (bookFunction != null) {
                    bookFunction!();
                  }
                },
                style: AppTheme.mainButtonStyle,
                child: const Text(
                  "Get Started",
                ),
              ),
            ),
          ),
        ));
  }
}

buildHeader(String header) {
  return Text(
    header,
    textAlign: TextAlign.left,
    style: TextStyle(
        color: AppColors.secondaryLabelColor,
        fontFamily: 'Circular Std',
        fontSize: 13.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
        height: 1.5384615384615385.h),
  );
}

buildPreCall() {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPreCall1(),
        buildPreCall2("Select expert doctors instantly"),
        buildPreCall2("Schedule an appointment as per your convenience"),
        buildPreCall2("Get focused care and personalised health service"),
      ]);
}

buildPostCall() {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.0.h),
          child: SvgPicture.asset(
            AppIcons.tickSVG,
            width: 11.w,
            height: 9.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                color: AppColors.secondaryLabelColor.withOpacity(0.8),
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
              ),
              children: [
                const TextSpan(
                  text:
                      'Get health management program curated by your doctor in ',
                ),
                TextSpan(
                  text: '48 hrs',
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.8),
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

buildPreCall1() {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.0.h),
          child: SvgPicture.asset(
            AppIcons.tickSVG,
            width: 11.w,
            height: 9.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                color: AppColors.secondaryLabelColor.withOpacity(0.8),
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
              ),
              children: [
                const TextSpan(
                  text: 'Book an online ',
                ),
                TextSpan(
                  text: 'doctor consultation ',
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.8),
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: 'to discuss your health concerns.',
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.8),
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

buildPreCall2(String postText) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.0.h),
          child: SvgPicture.asset(
            AppIcons.tickSVG,
            width: 11.w,
            height: 9.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Expanded(
          child: Text(
            postText,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.secondaryLabelColor.withOpacity(0.8),
              fontFamily: 'Circular Std',
              fontSize: 14.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
            ),
          ),
        )
      ],
    ),
  );
}

buildOptions(List<String> texts) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(
      texts.length,
      (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.0.h),
                child: SvgPicture.asset(
                  AppIcons.tickSVG,
                  width: 11.w,
                  height: 9.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 11.w,
              ),
              Expanded(
                child: Text(
                  texts[index],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.8),
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
