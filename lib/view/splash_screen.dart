import 'dart:async';
import 'dart:io';

import 'package:aayu/config.dart';
import 'package:aayu/controller/payment/juspay_controller.dart';
import 'package:aayu/controller/utility/version_check_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/app.properties.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/grow/grow_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/view/main_page.dart';
import '../controller/consultant/program_recommendation_controller.dart';
import 'shared/under_maintaiance.dart';

class SplashScreen extends StatefulWidget {
  final bool callWhenAppResumed;
  final bool fromLogout;
  const SplashScreen(
      {Key? key, this.callWhenAppResumed = false, this.fromLogout = false})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController animationController;
  late Animation sizeAnimation;
  bool showAayuLogo = true;
  String buildNumber = "";

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        widget.callWhenAppResumed == true) {
      initServices();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    print("--------initServices | Splash Screen--------");
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    );
    animationController.repeat();
    if (widget.callWhenAppResumed == false) {
      if (Platform.isIOS) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => initAppTrackingTransparency().then((value) {
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    MoengageService().registerForNotification();
                  });
                }));
      }

      initServices();
    }

    super.initState();
  }

  Future<void> initServices() async {
    try {
      JuspayController juspayController = Get.put(JuspayController());
      Get.put(ProgramRecommendationController());
      getVersionDetails();
      await HiveService().initialize();
      FlurryService().initialize();

      juspayController.initiateHyperSDK();
      if (Config.environment == "PROD") {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
      await AppPropertiesService().fetchProperties();
      if (Platform.isAndroid) {
        await checkForUpdate();
      }
    } catch (exp) {
      print("--------initServices | Exception--------");
      print(exp);
      rethrow;
    } finally {
      checkUserLoginStatus();
    }
  }

  getVersionDetails() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    print("====================BUNDLE ID=========================");
    print(info.packageName);

    setState(() {
      buildNumber = "${info.version}+${info.buildNumber}";
    });
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();
      print("================***** APP UPDATE INFO *****=================");
      print(appUpdateInfo.toString());
      print('------UpdateAvailability.updateAvailable-----');
      print(UpdateAvailability.updateAvailable);

      if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        checkAppVersion();
      }
    } catch (exp) {
      print("--------checkForUpdate | Exception--------");
      print(exp);
    }
  }

  Future<void> initAppTrackingTransparency() async {
    await Future.delayed(const Duration(milliseconds: 1000), () async {
      print("+++++++++++++++++CALLING APP TRACKING ++++++++++++++++++++++");
      try {
        final TrackingStatus status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } on PlatformException {}

      await AppTrackingTransparency.getAdvertisingIdentifier();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(alignment: Alignment.bottomCenter, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0)
                        .animate(animationController),
                    child: Image(
                      width: 256.w,
                      height: 256.h,
                      fit: BoxFit.contain,
                      image: const AssetImage(
                        Images.pingCircleImage,
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 800),
                    alignment: Alignment.center,
                    crossFadeState: showAayuLogo
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Center(
                      child: SvgPicture.asset(Images.aayuLogoSVGImage,
                          width: 68.25.w,
                          height: 126.3.h,
                          color: AppColors.secondaryLabelColor),
                    ),
                    secondChild: Container(
                      alignment: Alignment.center,
                      height: 126.3.h,
                      child: Text(
                        "Healing,\nwellness & you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Baskerville",
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF495F74),
                            height: 1.083.h,
                            fontSize: 24.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              width: 300.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "POWERED_BY".tr,
                    style: TextStyle(
                      color: const Color.fromRGBO(91, 112, 128, 0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Image.asset(
                    Images.svyasaImage,
                    height: 40.h,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text(
                    buildNumber,
                    style: TextStyle(
                      color: const Color.fromRGBO(91, 112, 128, 0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                  ),
                  pageBottomHeight()
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  checkUserLoginStatus() async {
    try {
      //DELAY ADDED FOR SINGULAR DEEP LINK; DONT REMOVE THIS DELAY
      // Future.delayed(const Duration(seconds: 1), () async {
      UserRegistrationResponse? userIdDetails =
          await HiveService().getUserIdDetails();

      if (userIdDetails != null &&
          userIdDetails.userId != null &&
          userIdDetails.userId!.isNotEmpty) {
        UserDetailsResponse? userDetailsResponse =
            await ProfileService().getUserDetails(userIdDetails.userId!);

        if (userDetailsResponse != null &&
            userDetailsResponse.userDetails != null &&
            userDetailsResponse.userDetails!.userId!.isNotEmpty) {
          await HiveService()
              .saveDetails("userDetails", userDetailsResponse.toJson());

          globalUserIdDetails = userIdDetails;

          ProfileService().updateLastLogin(userIdDetails.userId!);
          ProfileService().updateLatestVersionNumber(userIdDetails.userId!);

          //Send Firebase Notification Token to Backend
          FirebaseMessaging.instance.getToken().then((token) {
            OnboardingService()
                .sendFirebaseToken(userIdDetails.userId!, token!);
          });

          MoengageService()
              .setPhoneNumber(userDetailsResponse.userDetails!.mobileNumber!);
          SingularDeepLinkController singularDeepLinkController = Get.find();
          MoengageService().setUserSourceAndCampaign(
              singularDeepLinkController.utmSource,
              singularDeepLinkController.utmCampaign);

          // Load Default Controllers
          fetchBackgroundDataAndPush();
        } else {
          // await HiveService().saveDetails("userIdDetails", null);
          Get.put(HealingListController());
          SingularDeepLinkController singularDeepLinkController = Get.find();
          singularDeepLinkController.handleNavigationBeforeRegistration();
        }
      } else {
        if (remoteConfigData != null &&
            remoteConfigData!.getString('SKIP_REGISTRATION') == 'DIRECTLY_IN') {
          fetchBackgroundDataAndPush();
        } else {
          Get.put(HealingListController());
          Get.put(SubscriptionController());
          if (!widget.fromLogout) {
            SingularDeepLinkController singularDeepLinkController = Get.find();
            singularDeepLinkController.handleNavigationBeforeRegistration();
          } else {
            SingularDeepLinkController singularDeepLinkController =
                Get.put(SingularDeepLinkController());
            singularDeepLinkController.handleNavigationBeforeRegistration();
          }
        }
      }
      // });
    } catch (exp) {
      print(
          "-----------------checkUserLoginStatus | Exception-----------------");
      print(exp);
    }
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

  checkAppVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    String currentBuildNumber =
        info.buildNumber.replaceAll("-dev", "").replaceAll("-prod", "");
    String currentVersion =
        info.version.trim().replaceAll("-dev", "").replaceAll("-prod", "");

    VersionCheckController versionCheckController =
        Get.put(VersionCheckController());
    CheckAppVersionResponse? response = await versionCheckController
        .checkAppVersion(currentVersion, currentBuildNumber);

    if (response != null) {
      if (appProperties.liveStatus!.underMaintenance == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UnderManintainance(),
          ),
        );
      } else if (response.doUpdate == true && response.versionDetails != null) {
        EventsService().sendEvent("App_Update_Available", {
          "environment": Config.environment,
          "current_build_version": currentVersion,
          "current_build_number": currentBuildNumber,
          "update_build_version": response.versionDetails!.newVersion!,
          "update_build_number": response.versionDetails!.newBuildNumber!,
          "force_update": response.versionDetails!.forceUpdate,
          "platform": Platform.isAndroid
              ? "Android"
              : Platform.isIOS
                  ? "iOS"
                  : "Other"
        });

        if (response.versionDetails!.forceUpdate == true) {
          print(
              "----------------------InAppUpdate.performImmediateUpdate()-------------------");
          InAppUpdate.performImmediateUpdate().then((value) {
            if (value == AppUpdateResult.userDeniedUpdate) {
              SystemNavigator.pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SplashScreen(
                  callWhenAppResumed: true,
                ),
              ));
            }
          });
          return;
        } else {
          InAppUpdate.startFlexibleUpdate().then((value) {
            if (value == AppUpdateResult.success) {
              InAppUpdate.completeFlexibleUpdate().then((value) {
                print(
                    "------------------InAppUpdate.completeFlexibleUpdate()-----------------------");
              });
            }
          });
          return;
        }
      }
    }
  }
}
