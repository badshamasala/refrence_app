import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';

import 'package:get/get.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/navigation_action.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/properties.dart';

const String moengageAppId = '619QTZ4M9JW1G47R3R1XH0HG';
final MoEngageFlutter _moengagePlugin = MoEngageFlutter(moengageAppId);

class MoengageService {
  initialize() {
    try {
      //dynamic moEngage =  MoEngage.Builder(this, moengageAppId);
      _moengagePlugin.setInAppClickHandler(_onInAppClick);
      _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
      _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
      _moengagePlugin.setSelfHandledInAppHandler((message) {
        print(
            "This is a callback on inapp self handle from native to flutter. Payload $message");
      });

      _moengagePlugin.initialise();
      _moengagePlugin.enableAdIdTracking();

      _moengagePlugin.showInApp();
      // _moengagePlugin.enableSdk();

      // _moengagePlugin.enableSDKLogs();
      // _moengagePlugin.registerForPushNotification();

      _moengagePlugin.setPushClickCallbackHandler(_onPushClick);
      print("-------MoengageService | initialize | Success-------");
    } catch (e) {
      print("-------MoengageService | initialize | Failed-------");
      print(e);
    } finally {}
  }

  void registerForNotification() {
    _moengagePlugin.registerForPushNotification();
  }

  showInApp() {
    _moengagePlugin.showInApp();
  }

  void _onPushClick(PushCampaignData message) {
    // print("++++++++++++++++++MOEANGAGE CLICK HANDLER++++++++++++++++++");

    // print('==================PRINTING KVPAIR================');
    // print(message.data.payload['moengage']['screenData']);
    if (message.data.payload['moengage']['screenData'] != null) {
      SingularDeepLinkController singularDeepLinkController = Get.find();
      singularDeepLinkController
          .storeData(message.data.payload['moengage']['screenData']);
    }
  }

  setUserId(String userId) {
    try {
      _moengagePlugin.setUniqueId(userId);
      print("-------MoengageService | setUserId | $userId | Success-------");
    } catch (e) {
      print("-------MoengageService | setUserId | Failed-------");
      print(e);
    }
  }

  setPhoneNumber(String phoneNumber) {
    try {
      _moengagePlugin.setPhoneNumber(phoneNumber);
      print(
          "-------MoengageService | phoneNumber | $phoneNumber | Success-------");
    } catch (e) {
      print("-------MoengageService | phoneNumber | Failed-------");
      print(e);
    }
  }

  setUserName(String userName) {
    try {
      String firstName = "";
      String lastName = "";

      userName = userName.trim();

      if (userName.contains(" ")) {
        if (userName.split(" ")[0].isNotEmpty) {
          firstName = userName.split(" ")[0];
          _moengagePlugin.setFirstName(firstName);
        }
        if (userName.split(" ")[1].isNotEmpty) {
          lastName = userName.split(" ")[1];
          _moengagePlugin.setLastName(lastName);
        }
      } else {
        _moengagePlugin.setFirstName(userName);
      }

      _moengagePlugin.setUserName(userName);
      print(
          "-------MoengageService | setUserName | $userName | Success-------");
    } catch (e) {
      print("-------MoengageService | setUserName | Failed-------");
      print(e);
    }
  }

  setGender(String gender) {
    try {
      switch (gender.toUpperCase()) {
        case "MALE":
          _moengagePlugin.setGender(MoEGender.male);
          break;
        case "FEMALE":
          _moengagePlugin.setGender(MoEGender.female);
          break;
        case "NON-BINARY":
          _moengagePlugin.setGender(MoEGender.other);
          break;
      }

      if (gender.isNotEmpty) {
        print("-------MoengageService | setGender | $gender | Success-------");
      } else {
        print("-------MoengageService | setGender | $gender | Empty-------");
      }
    } catch (e) {
      print("-------MoengageService | setGender | Failed-------");
      print(e);
    }
  }

  sendLoginTypeEvent(String loginType) {
    var details = MoEProperties();
    try {
      switch (loginType.toUpperCase()) {
        case "MOBILE":
          details.addAttribute("mobile", "Yes");
          details.addAttribute("gmail", "No");
          details.addAttribute("facebook", "No");
          details.addAttribute("apple", "No");
          break;
        case "GMAIL":
          details.addAttribute("mobile", "No");
          details.addAttribute("gmail", "Yes");
          details.addAttribute("facebook", "No");
          details.addAttribute("apple", "No");
          break;
        case "FACEBOOK":
          details.addAttribute("mobile", "No");
          details.addAttribute("gmail", "No");
          details.addAttribute("facebook", "Yes");
          details.addAttribute("apple", "No");
          break;
        case "APPLE":
          details.addAttribute("mobile", "No");
          details.addAttribute("gmail", "No");
          details.addAttribute("facebook", "No");
          details.addAttribute("apple", "Yes");
          break;
      }

      _moengagePlugin.trackEvent("login_type", details);

      print(
          "-------MoengageService | sendLoginTypeEvent | $loginType | Success-------");
    } catch (e) {
      print(
          "-------MoengageService | sendLoginTypeEvent | $loginType | Failed-------");
      print(e);
    }
  }

  sendEvent(String eventName, Map<String, dynamic> eventDetails) {
    var details = MoEProperties();
    try {
      eventDetails.forEach((key, value) => details.addAttribute(key, value));
      _moengagePlugin.trackEvent(eventName, details);
      print("-------MoengageService | sendEvent | $eventName | Success-------");
    } catch (e) {
      print("-------MoengageService | sendEvent | $eventName | Failed-------");
    }
  }

  setUserSourceAndCampaign(String utmSource, String utmCampaign) {
    try {
      _moengagePlugin.setUserAttribute('utm_source', utmSource);
      _moengagePlugin.setUserAttribute('utm_campaign', utmCampaign);
      print(
          "-------MoengageService | utm_source | $utmSource | Success-------");
      print(
          "-------MoengageService | utm_campaign | $utmCampaign | Success-------");
    } catch (e) {
      print("-------MoengageService | utm_source | Failed-------");
      print("-------MoengageService | utm_campaign | Failed-------");
      print(e);
    }
  }

  void _onInAppClick(ClickData message) {
    print(
        "This is a inapp click callback from native to flutter. Payload $message");

    print("========");

    Map<String, dynamic> mapData =
        (message.action as NavigationAction).keyValuePairs;
    print(mapData);

    SingularDeepLinkController singularDeepLinkController = Get.find();
    singularDeepLinkController.storeData(mapData);
    singularDeepLinkController.handleNavigation();
  }

  void _onInAppShown(InAppData message) {
    print(
        "This is a callback on inapp shown from native to flutter. Payload $message");
  }

  void _onInAppDismiss(InAppData message) {
    print(
        "This is a callback on inapp dismiss from native to flutter. Payload $message");
  }
}
