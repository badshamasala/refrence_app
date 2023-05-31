import 'dart:async';
import 'dart:convert';
import 'package:aayu/config.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/shared/ui_helper/loaclization_string.dart';
import 'package:aayu/view/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'controller/payment/juspay_controller.dart';
import 'services/services.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print("notificationTapBackground =========>");
  //LocalNotificationService().handleNavigation(notificationResponse.payload!);
}

void initializeApp() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    statusBarBrightness: Brightness.dark, //status bar brigtness
    statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  remoteConfigData = remoteConfig;
  if (Config.environment == "PROD") {
    //FirebaseCrashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  initDynamicLink();
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    String passData = dynamicLinkData.link.queryParameters['data'] ?? "";
    Map<String, dynamic> data = jsonDecode(passData);
    SingularDeepLinkController singularDeepLinkController =
        Get.put(SingularDeepLinkController());
    singularDeepLinkController.storeData(data);
    singularDeepLinkController.setUtmParams(
        dynamicLinkData.utmParameters['utm_source'],
        dynamicLinkData.utmParameters['utm_campaign']);
    if (globalUserIdDetails != null && globalUserIdDetails!.userId != null) {
      singularDeepLinkController.handleNavigation();
    }
  }).onError((error) {
    // Handle errors
  });
  await initializeLocalNotifications();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const AayuApp());
  });
}

Future<void> initDynamicLink() async {
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  if (initialLink != null) {
    String passData = initialLink.link.queryParameters['data'] ?? "";
    Map<String, dynamic> data = jsonDecode(passData);
    SingularDeepLinkController singularDeepLinkController =
        Get.put(SingularDeepLinkController());
    singularDeepLinkController.storeData(data);
    singularDeepLinkController.setUtmParams(
        initialLink.utmParameters['utm_source'],
        initialLink.utmParameters['utm_campaign']);
    if (globalUserIdDetails != null && globalUserIdDetails!.userId != null) {
      singularDeepLinkController.handleNavigation();
    } else {
      singularDeepLinkController.handleNavigationBeforeRegistration();
    }
  }
}

Future<void> initializeLocalNotifications() async {
  tz.initializeTimeZones();
  try {
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    print('Could not get the local timezone');
  }

  try {
    // Initialization  setting for android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // Initialization  setting for iOS
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedLocalNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // to handle event when we receive notification
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        default:
          // LocalNotificationService()
          //     .handleNavigation(notificationResponse.payload);
          break;
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    LocalNotificationService().listenSelectNotificationStream();
  } catch (e) {
    print("--------------InitializeLocalNotifications | Exception--------------");
    print(e);
  }
}

class AayuApp extends StatefulWidget {
  const AayuApp({Key? key}) : super(key: key);

  @override
  State<AayuApp> createState() => _AayuAppState();
}

class _AayuAppState extends State<AayuApp> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  @override
  void initState() {
    super.initState();
    Get.put(SingularDeepLinkController());
    FirebaseMessagingService().initializeMessaging(context);
    BranchService().initialize();
    MoengageService().initialize();
    getConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  getConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && !isAlertSet) {
        showNetworkDialogFunction();
        setState(() {
          isAlertSet = true;
        });
      }
    });
  }

  showNetworkDialogFunction() {
    showNetworkDialog(
      () async {
        Get.close(1);
        setState(() {
          isAlertSet = false;
        });
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          showNetworkDialogFunction();
          setState(() {
            isAlertSet = true;
          });
        }
      },
      () async {
        Get.close(1);
        JuspayController juspayController = Get.find();
        await juspayController.terminateHyperSDK();
        SystemNavigator.pop().then((value) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const SplashScreen(
                callWhenAppResumed: true,
              ),
            ));
          });
        });
      },
      "Network Error!",
      'This app requires active network connection to work.\nPlease check your network settings and relaunch.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        navigatorKey: navState,
        title: 'Aayu',
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.pageBackgroundColor,
          highlightColor: AppColors.pageBackgroundColor,
          fontFamily: "Circular Std",
          colorScheme: ColorScheme.fromSwatch(
            accentColor: AppColors.lightPrimaryColor,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
