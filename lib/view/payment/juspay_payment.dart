// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:aayu/controller/payment/juspay_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JuspayPayment extends StatelessWidget {
  final String pageSource;
  final String paymentEvent;
  final String currency;
  final double totalPayment;
  final dynamic customData;

  const JuspayPayment(
      {Key? key,
      required this.pageSource,
      required this.paymentEvent,
      required this.currency,
      required this.totalPayment,
      required this.customData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    JuspayController juspayController = Get.find();
    checkIsInitialised(context, juspayController);
    return WillPopScope(
      onWillPop: () async {
        print("WillPopScope | JuspayPayment =====================>");
        if (Platform.isAndroid) {
          var backpressResult = await hyperSDK.onBackPress();
          print("backpressResult => $backpressResult");
          if (backpressResult.toLowerCase() == "true") {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      },
      child: Container(
        color: AppColors.pageBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 180.w,
              height: 360.h,
              image: const AssetImage(Images.ballGirlAnimationImage),
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: 265.w,
              child: Text(
                "You’re on your way to becoming a healthier you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Baskerville',
                  decoration: TextDecoration.none,
                  fontSize: 22.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.18.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkIsInitialised(
      BuildContext context, JuspayController juspayController) async {
    try {
      bool isInitialised = await hyperSDK.isInitialised();
      if (isInitialised == true) {
        createSession(context, juspayController);
      } else {
        await juspayController.initiateHyperSDK();
        isInitialised = await hyperSDK.isInitialised();
        if (isInitialised == true) {
          createSession(context, juspayController);
        } else {
          Navigator.pop(context);
          showCustomSnackBar(context, "Initilization failed...");
        }
      }
    } catch (e) {
      print(e);
      showCustomSnackBar(context, e.toString());
    }
  }

  createSession(BuildContext context, JuspayController juspayController) async {
    EventsService().sendEvent("Juspay_Create_Session_Started", {
      "page_source": pageSource,
      "payment_event": paymentEvent,
      "amount": totalPayment,
      "currency": currency,
    });
    Map<String, dynamic>? juspaySessionData = await juspayController
        .createSession(paymentEvent, totalPayment, currency, customData);
    if (juspaySessionData != null && juspaySessionData["sdk_payload"] != null) {
      EventsService().sendEvent("Juspay_Session_Created", {
        "page_source": pageSource,
        "payment_event": paymentEvent,
        "amount": totalPayment,
        "currency": currency,
        "order_id": juspaySessionData["order_id"] ?? "",
        "juspay_id": juspaySessionData["id"] ?? "",
      });
      startPaymentProcess(juspaySessionData, juspayController);
    } else {
      EventsService().sendEvent("Juspay_Create_Session_Failed", {
        "page_source": pageSource,
        "payment_event": paymentEvent,
        "amount": totalPayment,
        "currency": currency,
      });
      Navigator.pop(context);
      showCustomSnackBar(
          context, "Oops...Something went wrong. Please try again later.");
    }
  }

  startPaymentProcess(
      dynamic juspaySessionData, JuspayController juspayController) async {
    bool isInitialised = await hyperSDK.isInitialised();

    print('---------startPaymentProcess | isInitialised---------');
    print(isInitialised);

    if (isInitialised == true) {
      EventsService().sendEvent("Juspay_Process_Payment", {
        "page_source": pageSource,
        "payment_event": paymentEvent,
        "amount": totalPayment,
        "currency": currency,
        "order_id": juspaySessionData["order_id"] ?? "",
        "juspay_id": juspaySessionData["id"] ?? "",
      });
      print("---------startPaymentProcess | sdk_payload---------");
      print(json.encode(juspaySessionData["sdk_payload"]));

      juspayController.paymentProcessStarted.value = true;
      juspayController.update();
      hyperSDK.process(juspaySessionData["sdk_payload"],
          (MethodCall methodCall) {
        juspayController.hyperSDKCallbackHandler(
            methodCall,
            pageSource,
            paymentEvent,
            totalPayment,
            currency,
            juspaySessionData,
            customData);
      });
    } else {
      EventsService().sendEvent("Juspay_Process_Payment_Failed", {
        "page_source": pageSource,
        "payment_event": paymentEvent,
        "amount": totalPayment,
        "currency": currency,
      });

      showCustomSnackBar(
          Get.context!, "Oops...Something went wrong. Please try again later.");
      Get.back();
    }
  }
}
