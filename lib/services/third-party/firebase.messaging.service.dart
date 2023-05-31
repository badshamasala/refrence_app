import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/profile/my_subscriptions.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseMessagingService {
  void initializeMessaging(context) {
    iOSPermission();
    //removed this block for moengage inApp
    //Background Message Handling
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "----------------------firebaseMessaging onMessage-----------------------");
      print('data: ${message.data}');
      print('notification: ${message.notification}');
      if (message.notification != null) {
        print("notification title: ${message.notification!.title}");
        print("notification body: ${message.notification!.body}");
      }
      print(
          "----------------------firebaseMessaging onMessage-----------------------");
      // if (message.data['screenName'] != null &&
      //     (message.data['screenName'] as String).isNotEmpty) {
      //   SingularDeepLinkController singularDeepLinkController = Get.find();
      //   singularDeepLinkController.storeData(message.data);
      // }

      handleNotifcation(context, message, false);
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "----------------------firebaseMessaging onMessageOpenedApp-----------------------");
      print('data: ${message.data}');
      print('notification: ${message.notification}');
      print("notification title: ${message.notification!.title}");
      print("notification body: ${message.notification!.body}");
      print(
          "----------------------firebaseMessaging onMessageOpenedApp-----------------------");
      if (message.data['screenName'] != null) {
        SingularDeepLinkController singularDeepLinkController = Get.find();
        singularDeepLinkController.storeData(message.data);
        singularDeepLinkController.handleNavigation();
      }
      handleNotifcation(context, message, true);
    });
  }

  checkInitialMessage(context) async {
    print('==============CHECKING INITIAL MESSAG==============+##########');
    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print(
          "----------------------firebaseMessaging getInitialMessage-----------------------");
      print('data: ${message.data}');
      print('notification: ${message.notification}');
      if (message.data['screenName'] != null) {
        SingularDeepLinkController singularDeepLinkController = Get.find();
        singularDeepLinkController.storeData(message.data);
        singularDeepLinkController.handleNavigation();
      }

      if (message.notification != null) {
        print("notification title: ${message.notification!.title}");
        print("notification body: ${message.notification!.body}");
        handleNotifcation(context, message, true);
      }
      print(
          "----------------------firebaseMessaging getInitialMessage-----------------------");
    }
  }

  handleNotifcation(
      BuildContext context, RemoteMessage message, bool redirectOnPage) async {
    RemoteNotification? notification = message.notification;
    //AndroidNotification? android = message.notification?.android;

    if (notification != null && message.data["notificationType"] != null) {
      var data = message.data;
      var notificationType = data["notificationType"];
      EventsService().sendEvent("PUSH_$notificationType", data);

      switch (notificationType!.toUpperCase()) {
        case "DOCTOR_CALL_ALERT":
          showCustomSnackBar(
              navState.currentState!.context, message.notification!.body!);
          break;
        case "TRAINER_CALL_ALERT":
          showCustomSnackBar(
              navState.currentState!.context, message.notification!.body!);
          break;
        case "DOCTOR_CALL_JOIN":
          showCustomSnackBarWithAction(navState.currentState!.context,
              message.notification!.body!, "Start Now", () {
            DoctorSessionController controller =
                Get.put(DoctorSessionController());
            controller.handleCallJoin(navState.currentState!.context,
                data["doctorId"], data["sessionId"]);
          });
          break;
        case "TRAINER_CALL_JOIN":
          showCustomSnackBarWithAction(navState.currentState!.context,
              message.notification!.body!, "Start Now", () {
            /* Navigator.of(navState.currentState!.context).push(
              MaterialPageRoute(
                builder: (context) => const TrainerSessions(),
              ),
            ); */
            TrainerSessionController controller =
                Get.put(TrainerSessionController());
            controller.handleCallJoin(navState.currentState!.context,
                data["trainerId"], data["sessionId"]);
          });
          break;
        case "PROGRAM_REMINDER":
        case "DAYWISE_PROGRAM_REMINDER":
          if (redirectOnPage == true) {
            Navigator.of(navState.currentState!.context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const MainPage(
                          selectedTab: 1,
                        )),
                (Route<dynamic> route) => false);
          } else {
            showCustomSnackBarWithAction(navState.currentState!.context,
                message.notification!.body!, "Start Now", () {
              Navigator.pushReplacement(
                navState.currentState!.context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(
                    selectedTab: 1,
                  ),
                ),
              );
            });
          }
          break;
        case "SET_PROGRAM_REMINDER":
          if (redirectOnPage == true) {
            Navigator.of(navState.currentState!.context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const MainPage(
                          selectedTab: 1,
                        )),
                (Route<dynamic> route) => false);
          } else {
            showCustomSnackBarWithAction(navState.currentState!.context,
                message.notification!.body!, "Set Now", () {
              Navigator.pushReplacement(
                navState.currentState!.context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(
                    selectedTab: 1,
                  ),
                ),
              );
            });
          }
          break;
        case "RENEW_SUBSCRIPTION":
          if (redirectOnPage == true) {
            Navigator.push(
              navState.currentState!.context,
              MaterialPageRoute(
                builder: (context) => const MySubscriptions(),
              ),
            );
          } else {
            showCustomSnackBarWithAction(navState.currentState!.context,
                message.notification!.body!, "Renew Now", () {
              Navigator.push(
                navState.currentState!.context,
                MaterialPageRoute(
                  builder: (context) => const MySubscriptions(),
                ),
              );
            });
          }
          break;
      }
    }
  }

  void iOSPermission() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    /*  _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    }); */
  }
}

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message");
//   print(
//       "----------------------firebaseMessaging BackgroundHandler-----------------------");
//   print('data: ${message.data}');
//   print('notification: ${message.notification}');
//   print("notification title: ${message.notification?.title}");
//   print("notification body: ${message.notification?.body}");
//   print(
//       "----------------------firebaseMessaging BackgroundHandler-----------------------");
// }
