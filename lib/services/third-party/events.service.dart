import 'dart:io';

import 'package:aayu/services/third-party/branch.service.dart';
import 'package:aayu/services/third-party/moengage.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/services.dart';

import '../../config.dart';
import 'analytics.service.dart';

final facebookAppEvents = FacebookAppEvents();

class EventsService {
  sendEvent(String eventName, Map<String, dynamic>? eventDetails) async {
    if (Config.environment != "PROD") {
      return;
    }
    bool allowTracking = true;
    if (Platform.isIOS) {
      final TrackingStatus trackingStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      if (trackingStatus == TrackingStatus.authorized) {
        allowTracking = true;
      } else {
        allowTracking = false;
      }
    }

    if (allowTracking == false) {
      return;
    }

    eventDetails?.forEach((key, value) {
      value ??= "";
    });

    //FIRE BASE EVENTS
    try {
      if (appProperties.services!.analytics!.firebase == true) {
        Map<String, dynamic> firebaseEventParam = {};
        eventDetails?.forEach((key, value) {
          if (value is bool) {
            firebaseEventParam[key] = value.toString();
          } else {
            firebaseEventParam[key] = value;
          }
        });
        // print("-------------print(firebaseEventParam);-------------");
        // print(firebaseEventParam);
        FirebaseAnalyticsService().sendEvent(eventName, firebaseEventParam);
      }
    } catch (err) {
      print(err.toString());
    }

    // Branch
    switch (eventName.toUpperCase()) {
      case "AAYU_OTP_VERIFICATION_COMPLETE":
        try {
          if (eventDetails!["otp_type"] == "Sign Up" ||
              eventDetails["otp_type"] == "Link your Mobile") {
            BranchService().sendEvent(eventName, eventDetails);
          }
        } catch (err) {
          print(err.toString());
        }
        break;
      case "AAYU_LOGIN":
      case "AAYU_REGISTRATION_COMPLETE":
        try {
          BranchService().sendEvent(eventName, eventDetails ?? {});
        } catch (err) {
          print(err.toString());
        }
        break;
    }

    //Facebook Events
    switch (eventName.toUpperCase()) {
      case "SUBSCRIPTION_PAYMENT_SUCCESS":
      case "SUBS_PAYMENT_EVENT_SUCCESS":
      case "SUBS_PAYMENT_HEAL_SUCCESS":
      case "SUBS_PAYMENT_GROW_SUCCESS":
      case "RENEWAL_PAYMENT_SUCCESS":
      case "PERSONALCARE_PAYMENT_SUCCESS":
      case "SUBS_PAYMENT_PERSONALCARE_SUCCESS":
      case "SUBS_PAYMENT_RECMDPROGRAM_SUCCESS":
      case "AAYU_REGISTRATION_COMPLETE":
        try {
          if (appProperties.services!.analytics!.facebook == true) {
            if (eventName.toUpperCase() == "AAYU_REGISTRATION_COMPLETE") {
              Map<String, dynamic>? eventDet = eventDetails;
              if (eventDet != null) {
                eventDet.remove("mobile_number");
              }
              FacebookAppEvents()
                  .logCompletedRegistration(registrationMethod: "Mobile");
              facebookAppEvents.logEvent(
                name: eventName,
                parameters: eventDet,
              );
            } else {
              facebookAppEvents.logEvent(
                name: eventName,
                parameters: eventDetails,
              );
            }
          }
        } catch (err) {
          print(err.toString());
        }
    }

    try {
      if (appProperties.services!.analytics!.moengage == true) {
        if (eventDetails == null) {
          MoengageService().sendEvent(eventName, {"no_data": true});
        } else {
          MoengageService().sendEvent(eventName, eventDetails);
        }
      }
    } catch (err) {
      print(err.toString());
    }
  }

  sendClickNextEvent(String pageName, String actionSource, String nextPage) {
    if (Config.environment != "PROD") {
      return;
    }
    if (appProperties.services!.analytics!.moengage == true) {
      sendEvent("Click_Next", {
        "pageName": pageName,
        "actionSource": actionSource,
        "nextPage": nextPage,
      });
    }
  }

  sendClickBackEvent(String pageName, String actionSource, String backPage) {
    if (Config.environment != "PROD") {
      return;
    }
    if (appProperties.services!.analytics!.moengage == true) {
      sendEvent("Click_Back", {
        "pageName": pageName,
        "actionSource": actionSource,
        "backPage": backPage,
      });
    }
  }

  Future<void> initAppTrackingTransparency() async {
    print("+++++++++++++++++CALLING APP TRACKING ++++++++++++++++++++++");
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } on PlatformException {}

    await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}
