import 'dart:convert';

import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';

class BranchService {
  initialize() {
    try {
      FlutterBranchSdk.initSession().listen((data) {
        // print("BRANCH DATA");
        // print(data);
        // print(data['~channel']);
        // print(data['~feature']);
        // print(data['~tags']);
        // print(data['~campaign']);

        // print(data["\$deeplink_path"]);
        SingularDeepLinkController singularDeepLinkController = Get.find();
        if (data["\$deeplink_path"] != null) {
          singularDeepLinkController
              .storeData(jsonDecode(data["\$deeplink_path"]));
        } else if (data["deeplin"] != null) {
          singularDeepLinkController.storeData(jsonDecode(data["deeplin"]));
        }

        singularDeepLinkController.setUtmParams(
            data['~channel'], data['~campaign']);

        // FlutterBranchSdk.validateSDKIntegration();
      });
      // print("-------BranchService | initialize | Success-------");
    } catch (e) {
      // print("-------BranchService | initialize | Failed-------");
      print(e);
    } finally {}
  }

  sendEvent(String eventName, Map<String, dynamic> eventDetails) {
    try {
      var event = BranchEvent.customEvent(eventName);
      eventDetails.forEach((key, value) {
        if (value != null) {
          event.addCustomData(key, value.toString());
        }
      });
      FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
      print("-------BranchService | sendEvent | $eventName | Success-------");
    } catch (e) {
      print("-------BranchService | sendEvent | $eventName | Failed-------");
      print(e);
    }
  }

  trackCustomRevenue(String eventName, String currency, double amount,
      Map<String, dynamic> attributes) {
    try {
      BranchEvent event =
          BranchEvent.standardEvent(BranchStandardEvent.PURCHASE);
      event.eventDescription = eventName;
      event.addCustomData('eventName', eventName);
      event.addCustomData('Custom_Event_Property_Key1', attributes['order_id']);

      event.revenue = amount;
      event.currency = BranchCurrencyType.values.firstWhere((element) =>
          getCurrencyTypeString(element) == currency.toUpperCase());
      attributes.forEach((key, value) {
        if (value != null) {
          event.addCustomData(key, value.toString());
        }
      });
      FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
    } catch (e) {
      print(
          "-------BranchService | trackCustomRevenue | $eventName | Failed-------");
      print(e);
    }
  }

  sendSubscribeEvent(
      String package, String eventName, Map<String, dynamic> attributes) {
    try {
      BranchEvent event =
          BranchEvent.standardEvent(BranchStandardEvent.SUBSCRIBE);
      event.eventDescription = package;

      event.addCustomData('Custom_Event_Property_Key1', eventName);

      event.addCustomData('event_name', eventName);

      attributes.forEach((key, value) {
        if (value != null) {
          event.addCustomData(key, value.toString());
        }
      });
      FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
    } catch (e) {
      print(
          "-------BranchService | trackSubscribeEvent | $eventName | Failed-------");
      print(e);
    }
  }

  sendCompleteRegistration() {
    try {
      BranchEvent event =
          BranchEvent.standardEvent(BranchStandardEvent.COMPLETE_REGISTRATION);

      FlutterBranchSdk.trackContentWithoutBuo(branchEvent: event);
    } catch (e) {
      print(
          "-------BranchService | trackSubscribeEvent | COMPLETE_REGISTRATION | Failed-------");
      print(e);
    }
  }
}
