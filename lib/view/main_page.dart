import 'dart:async';
import 'dart:io';

import 'package:aayu/controller/casting/cast_controller.dart';
import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/controller/onboarding/login/post_login_controller.dart';
import 'package:aayu/controller/payment/juspay_controller.dart';
import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/grow/grow.dart';
import 'package:aayu/view/healing/healing.dart';
import 'package:aayu/view/healing/healing_list.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/recommended_program_ready.dart';
import 'package:aayu/view/home/home.dart';
import 'package:aayu/view/onboarding/onboarding_bottom_sheet.dart';
import 'package:aayu/view/profile/edit_profile.dart';
import 'package:aayu/view/profile/you.dart';
import 'package:aayu/view/search/search_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../controller/home/my_routine_controller.dart';
import '../controller/player/content_preview_controller.dart';

class MainPage extends StatefulWidget {
  final int selectedTab;
  const MainPage({Key? key, required this.selectedTab}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int currentIndex = 0;
  late Widget currentPage;
  late List<Widget> pages = [
    const HomePage(),
    const Healing(),
    GrowPage(
      selectedTab: "",
      key: GrowPage.globalKey,
    ),
    const YouPage(),
  ];
  ContentPreviewController contentPreviewController =
      Get.put(ContentPreviewController());
  List<String> tabs = ["Aayu", "Healing", "Grow", "Profile"];

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _healKey = GlobalKey();
  final GlobalKey _growKey = GlobalKey();
  final GlobalKey _youKey = GlobalKey();
  bool isInit = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      //Added This as Singular handle Navigation was not being called for case in which
      //App was opened with the link
      print("APP RESUMED ========================================");
      SingularDeepLinkController singularDeepLinkController = Get.find();
      Future.delayed(const Duration(seconds: 1), () {
        singularDeepLinkController.handleNavigation();
        singularDeepLinkController.handleNavigationContinued();
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit = true) {
      initTargets();
      isInit = false;
    }
  }

  @override
  void initState() {
    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      // checkInternet();
      dummySetState();

      Future.delayed(Duration.zero, () async {
        FirebaseMessagingService().checkInitialMessage(context);
        MoengageService().showInApp(); //for In app Notifications;
        SingularDeepLinkController singularDeepLinkController = Get.find();

        MyRoutineController myRoutineController =
            Get.put(MyRoutineController());

        Get.put(LiveEventsController());
        PostLoginController postLoginController =
            Get.isRegistered<PostLoginController>()
                ? Get.find<PostLoginController>()
                : Get.put(PostLoginController());
        myRoutineController
            .setGotoHealing(diseaseDetailsAlreadySubscribedDeepLink);
        postLoginController.getFunctions(changeMainPageTo, changePageToGrow);

        if (singularDeepLinkController.deepLinkData == null) {
          singularDeepLinkController.getDiseaseDetailsAlreadySubscribed(
              diseaseDetailsAlreadySubscribedDeepLink);

          singularDeepLinkController.getGotoHealing(
              changePageToHealing, changePageToGrow);
        }
        singularDeepLinkController.getDiseaseDetailsAlreadySubscribed(
            diseaseDetailsAlreadySubscribedDeepLink);

        singularDeepLinkController.getGotoHealing(
            changePageToHealing, changePageToGrow);
        singularDeepLinkController.handleNavigation();

        singularDeepLinkController.handleNavigationContinued();
        postLoginController.handleNavigation();

        checkProgramRecommendation();

        LocalNotificationService().handleAppLaunchedViaNotification();
      });

      SubscriptionPackageController subscriptionPackageController =
          Get.put(SubscriptionPackageController());
      subscriptionPackageController.getSubscriptionCarouselData();
    }
    super.initState();
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: _homeKey,
        shape: ShapeLightFocus.Circle,
        radius: 5,
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        tutorialCoachMark.skip();
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      )),
                ],
              )),
          TargetContent(
            padding: EdgeInsets.zero,
            align: ContentAlign.top,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Aayu Home",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackLabelColor,
                        fontSize: 24.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Discover a world of wellness, curated for you, just the way you need!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackLabelColor,
                        fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: _healKey,
        enableOverlayTab: true,
        shape: ShapeLightFocus.Circle,
        radius: 5,
        contents: [
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        changeMainPageTo(0);

                        tutorialCoachMark.previous();
                      },
                      child: Text(
                        'Back',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      )),
                  TextButton(
                      onPressed: () {
                        tutorialCoachMark.skip();
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      )),
                ],
              )),
          TargetContent(
            padding: EdgeInsets.zero,
            align: ContentAlign.top,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Healing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackLabelColor,
                        fontSize: 24.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "JOIN science backed health programs to RESET your lifestyle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackLabelColor,
                        fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: _growKey,
        enableOverlayTab: true,
        contents: [
          TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        changeMainPageTo(1);

                        tutorialCoachMark.previous();
                      },
                      child: Text(
                        'Back',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      )),
                  TextButton(
                      onPressed: () {
                        tutorialCoachMark.skip();
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      )),
                ],
              )),
          TargetContent(
            padding: EdgeInsets.zero,
            align: ContentAlign.top,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Grow",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.blackLabelColor,
                        fontSize: 24.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Unlock the transformative power of regenerative healing techniques.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackLabelColor,
                        fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
        shape: ShapeLightFocus.Circle,
        radius: 5,
      ),
    );

    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: _youKey,
      enableOverlayTab: true,
      contents: [
        TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(top: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      changeMainPageTo(2);

                      tutorialCoachMark.previous();
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    )),
              ],
            )),
        TargetContent(
          padding: EdgeInsets.zero,
          align: ContentAlign.top,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 20.h),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "You",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackLabelColor,
                      fontSize: 24.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Manage your healthcare profile and activities.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackLabelColor,
                      fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
  }

  @override
  dispose() {
    CastController castController = Get.put(CastController());
    WidgetsBinding.instance.removeObserver(this);
    castController.closeSession();

    super.dispose();
  }

  dummySetState() {
    setState(() {
      currentPage = pages[widget.selectedTab];
      currentIndex = widget.selectedTab;
    });
  }

  changePageToHealing() {
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null) {
      Get.to(const HealingList(
        pageSource: "DEEPLINK",
      ));
    } else {
      setState(() {
        currentIndex = 1;
        currentPage = pages[currentIndex];
      });
    }
  }

  changePageToGrow(String? tabName) {
    if (tabName != null) {
      setState(() {
        currentIndex = 2;
        currentPage = pages[currentIndex];
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        GrowPage.globalKey.currentState!.changeToTab(tabName);
      });
    } else {
      setState(() {
        currentIndex = 2;
        currentPage = pages[currentIndex];
      });
    }
  }

  diseaseDetailsAlreadySubscribedDeepLink() {
    setState(() {
      currentIndex = 1;
      currentPage = pages[currentIndex];
    });
  }

  changeMainPageTo(int index) {
    setState(() {
      currentIndex = index;
      currentPage = pages[currentIndex];
    });
  }

  checkProfileCompletion() async {
    UserDetailsResponse? userDetails = await HiveService().getUserDetails();
    if (userDetails != null && userDetails.userDetails != null) {
      if (userDetails.userDetails!.firstName!.isEmpty ||
          userDetails.userDetails!.gender!.isEmpty ||
          userDetails.userDetails!.dob!.isEmpty) {
        Future.delayed(const Duration(seconds: 3), () {
          Get.bottomSheet(
            const OnboardingBottomSheet(
              showPersonalisingYourSpace: false,
            ),
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
          );
        });
      }
    }
  }

  checkProgramRecommendation() async {
    ProgramRecommendationController recommendationController = Get.find();
    await recommendationController.getProgramRecommendation();
    if (recommendationController.recommendation.value != null &&
        recommendationController.recommendation.value!.recommendation != null) {
      Get.bottomSheet(
        const RecommendedProgramReady(),
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (remoteConfigData != null &&
        remoteConfigData!.getBool("SHOW_COACH_MARKS") == true) {
      HiveService().showCoachMark().then((value) {
        if (value) {
          Future.delayed(const Duration(seconds: 1), () {
            showDialog(
              context: context,
              barrierColor: AppColors.blackLabelColor.withOpacity(0.85),
              builder: (BuildContext context) {
                return AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.h)),
                    content: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 28.w),
                          padding: EdgeInsets.only(top: 72.h, bottom: 18.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome to\nAayu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                'Health, Wellness & You',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blueGreyAssessmentColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 17.h,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Let’s take a quick tour',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14.sp,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -103.h,
                          child: Image.asset(
                            Images.welcomeImage,
                            height: 170.h,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      ],
                    ));
              },
            ).then((value) {
              showTutorial();
            });
          }).then((value) {
            HiveService().seenCoachMarks();
          });
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        JuspayController juspayController = Get.find();
        if (juspayController.paymentProcessStarted.value == true) {
          if (Platform.isAndroid) {
            var backpressResult = await hyperSDK.onBackPress();
            if (backpressResult.toLowerCase() == "true") {
              return false;
            } else {
              return true;
            }
          } else {
            return true;
          }
        } else {
          return showExitConfirmation();
        }
      },
      child: Scaffold(
        appBar: showAppBar(),
        body: currentPage,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(215, 215, 215, 0.14),
                offset: const Offset(0, -10),
                blurRadius: 12.h,
              )
            ],
          ),
          child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: BottomNavigationIcons(
                    key: _homeKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.aayuIconSVG,
                    backgroundColor: AppColors.pageBackgroundColor,
                  ),
                  activeIcon: BottomNavigationIcons(
                    key: _homeKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.aayuIconSVG,
                    backgroundColor: const Color(0xFFAAFDB4),
                  ),
                  label: 'Home',
                  backgroundColor: AppColors.primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIcons(
                    key: _healKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.healingIconSVG,
                    backgroundColor: AppColors.pageBackgroundColor,
                  ),
                  activeIcon: BottomNavigationIcons(
                    key: _healKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.healingIconSVG,
                    backgroundColor: const Color(0xFFAAFDB4),
                  ),
                  label: 'Healing',
                  backgroundColor: AppColors.primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIcons(
                    key: _growKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.growIconSVG,
                    backgroundColor: AppColors.pageBackgroundColor,
                  ),
                  activeIcon: BottomNavigationIcons(
                    key: _growKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.growIconSVG,
                    backgroundColor: const Color(0xFFAAFDB4),
                  ),
                  label: 'Grow',
                  backgroundColor: AppColors.primaryColor,
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIcons(
                    key: _youKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.youIconSVG,
                    backgroundColor: AppColors.pageBackgroundColor,
                  ),
                  activeIcon: BottomNavigationIcons(
                    key: _youKey,
                    width: 30,
                    height: 30,
                    icon: AppIcons.youIconSVG,
                    backgroundColor: const Color(0xFFAAFDB4),
                  ),
                  label: 'You',
                  backgroundColor: AppColors.primaryColor,
                ),
              ],
              backgroundColor: AppColors.whiteColor,
              selectedItemColor: AppColors.bottomNavigationLabelColor,
              unselectedItemColor: AppColors.bottomNavigationLabelColor,
              unselectedLabelStyle: TextStyle(
                  color: AppColors.bottomNavigationLabelColor, fontSize: 12.sp),
              selectedLabelStyle: TextStyle(
                  color: AppColors.bottomNavigationLabelColor, fontSize: 12.sp),
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  currentPage = pages[index];
                });
              },
              elevation: 0),
        ),
      ),
    );
  }

  showExitConfirmation() {
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
                      onPressed: () async {
                        JuspayController juspayController = Get.find();
                        await juspayController.terminateHyperSDK();
                        SystemNavigator.pop().then((value) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const SplashScreen(
                                callWhenAppResumed: true,
                              ),
                            ));
                          });
                        });
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

  showAppBar() {
    if (currentIndex == 0) {
      return AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GetBuilder<YouController>(builder: (youController) {
          if (youController.userDetails.value?.userDetails == null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    changeMainPageTo(3);
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.w),
                        child: Image(
                          image: const AssetImage(Images.userImage),
                          width: 40.w,
                          height: 40.h,
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  "Hi User",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  changeMainPageTo(3);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.w),
                  child: youController
                                  .userDetails.value?.userDetails?.profilePic !=
                              null &&
                          youController.userDetails.value!.userDetails!
                              .profilePic!.isNotEmpty
                      ? ShowNetworkImage(
                          imgPath:
                              "${youController.userDetails.value!.userDetails!.profilePic}",
                          imgWidth: 40.w,
                          imgHeight: 40.h,
                          boxFit: BoxFit.cover,
                        )
                      : youController.userDetails.value!.userDetails!.gender!
                              .isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(40.w),
                              child: Image(
                                image: AssetImage(
                                  youController.userDetails.value!.userDetails!
                                              .gender!
                                              .toUpperCase() ==
                                          "MALE"
                                      ? Images.maleImage
                                      : youController.userDetails.value!
                                                  .userDetails!.gender!
                                                  .toUpperCase() ==
                                              "FEMALE"
                                          ? Images.femaleImage
                                          : Images.userImage,
                                ),
                                width: 40.w,
                                height: 40.h,
                                fit: BoxFit.contain,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(40.w),
                              child: Image(
                                image: const AssetImage(
                                  Images.userImage,
                                ),
                                width: 40.w,
                                height: 40.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              SizedBox(
                width: youController
                        .userDetails.value!.userDetails!.firstName!.isEmpty
                    ? null
                    : 200.w,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    youController
                            .userDetails.value!.userDetails!.firstName!.isEmpty
                        ? "Hi User"
                        : "Hi, ${youController.userDetails.value!.userDetails!.firstName ?? ""}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              if (youController
                  .userDetails.value!.userDetails!.firstName!.isEmpty)
                IconButton(
                  onPressed: () {
                    Get.to(const EditProfile());
                  },
                  padding: EdgeInsets.zero,
                  iconSize: 12.sp,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.blackLabelColor,
                  ),
                ),
            ],
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              SearchController searchController = Get.put(SearchController());
              searchController.nullSearchResults();
              searchController.clearSearchText();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ));
            },
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.search,
              color: AppColors.blueGreyAssessmentColor,
            ),
          ),
        ],
      );
    }
    return null;
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      hideSkip: true,
      textSkip: "Skip",
      colorShadow: AppColors.blackLabelColor,
      textStyleSkip: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          decoration: TextDecoration.underline),
      alignSkip: Alignment.topRight,
      paddingFocus: 10,
      opacityShadow: 0.85,
      onFinish: () {
        showDialog(
          context: context,
          barrierColor: AppColors.blackLabelColor.withOpacity(0.85),
          builder: (BuildContext context) {
            return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.h)),
                content: Container(
                  margin: EdgeInsets.symmetric(horizontal: 28.w),
                  padding: EdgeInsets.only(top: 28.h, bottom: 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Begin your transformation journey now!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Baskerville',
                            color: AppColors.blackLabelColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 31.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Explore',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14.sp,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ).then((value) {
          changeMainPageTo(0);
        });
      },
      onClickTarget: (target) {
        switch (target.identify) {
          case "Target 0":
            changeMainPageTo(1);
            break;
          case "Target 1":
            changeMainPageTo(2);
            break;
          case "Target 2":
            changeMainPageTo(3);
            break;
          case "Target 3":
            break;
          default:
            changeMainPageTo(0);
            break;
        }
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        switch (target.identify) {
          case "Target 0":
            changeMainPageTo(1);
            break;
          case "Target 1":
            changeMainPageTo(2);
            break;
          case "Target 2":
            changeMainPageTo(3);
            break;
          case "Target 3":
            break;
          default:
            changeMainPageTo(0);
            break;
        }
      },
    )..show(context: context);
  }
}

class BottomNavigationIcons extends StatelessWidget {
  final String icon;
  final double width;
  final double height;
  final Color backgroundColor;
  const BottomNavigationIcons(
      {Key? key,
      required this.icon,
      required this.width,
      required this.height,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: SvgPicture.asset(
        icon,
        width: (width).w,
        height: (height).h,
      ),
    );
  }
}
