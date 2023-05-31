import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../juspay_payment.dart';

class PaymentFailed extends StatelessWidget {
  final String pageSource;
  final String paymentEvent;
  final double totalPayment;
  final String currency;
  final dynamic customData;
  const PaymentFailed(
      {Key? key,
      required this.pageSource,
      required this.paymentEvent,
      required this.totalPayment,
      required this.currency,
      required this.customData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = "Don't worry, you can always try again.";
    if (pageSource == "CONSULTATION_PAYMENT") {
      message =
          "The payment for your ${customData["consultationType"] == "Doctor" ? "doctor consultation" : "yoga therapist's"} session couldn't be processed.";
    }

    sendPaymentFailedEvent();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Wrap(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 119.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.pageBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    SizedBox(
                      width: 265.w,
                      child: Text(
                        'Your payment didn’t go through.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Baskerville',
                          fontSize: 22.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2727272727272727.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
                      width: 286.w,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 16.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2727272727272727.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Padding(
                      padding: pageHorizontalPadding(),
                      child: Row(
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
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(100)),
                                padding: EdgeInsets.symmetric(
                                  vertical: 9.h,
                                ),
                              ),
                              onPressed: () {
                                sendDoItLaterEvent();
                                Navigator.of(context).pop();
                                switch (pageSource) {
                                  case "PROGRAM_PLAN_SUMMARY":
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    break;
                                  case "CONSULTATION_PAYMENT":
                                    break;
                                  case "CONFIRM_DOCTOR_CONSULTATION":
                                    HealingListController
                                        healingListController = Get.find();
                                    healingListController.resetSelection();
                                    break;
                                }
                              },
                              child: Text(
                                'Do it Later',
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Circular Std",
                                ),
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
                                  primary: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  padding: EdgeInsets.symmetric(vertical: 9.h)),
                              onPressed: () {
                                sendRetryPaymentEvent();
                                Navigator.pop(context);
                                Get.to(JuspayPayment(
                                  pageSource: pageSource,
                                  totalPayment: totalPayment,
                                  currency: currency,
                                  paymentEvent: paymentEvent,
                                  customData: customData,
                                ));
                              },
                              child: Text(
                                "Retry",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Circular Std",
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0.w,
                right: 0,
                child: Image(
                  width: 198.w,
                  height: 198.h,
                  image: const AssetImage(Images.paymentFailedImage),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  sendPaymentFailedEvent() {
    String eventName = "Payment_Failed";
    if (pageSource == "AAYU_SUBSCRIPTION") {
      String subscribeVia = customData["subscribe_via"];
      if (subscribeVia == "CONTENT") {
        eventName = "Subs_Payment_Grow_Failed";
      } else if (subscribeVia == "HEALING") {
        eventName = "Subs_Payment_Heal_Failed";
      } else if (subscribeVia == "LIVE_EVENT") {
        eventName = "Subs_Payment_Event_Failed";
      }
    } else if (pageSource == "AAYU_RENEWAL") {
      eventName = "Renewal_Payment_Failed";
    } else if (pageSource == "CONFIRM_DOCTOR_CONSULTATION") {
      eventName = "Single_Doctor_Payment_Failed";
    } else if (pageSource == "CONSULTATION_PAYMENT") {
      eventName = "Consultation_Payment_Failed";
      String consultationType = customData["consultationType"] ?? "";
      if (consultationType.toUpperCase() == "DOCTOR") {
        eventName = "Doctor_Payment_Failed";
      } else if (consultationType.toUpperCase() == "THERAPIST") {
        eventName = "Therapist_Payment_Failed";
      }
    } else if (pageSource == "UPGRADE_SUBSCRIPTION") {
      eventName = "Subs_Payment_Upgrade_Failed";
    }

    EventsService().sendEvent(eventName, {
      "page_source": pageSource,
      "payment_event": paymentEvent,
      "total_payment": totalPayment,
    });
  }

  sendDoItLaterEvent() {
    String eventName = "Payment_DoItLater";
    if (pageSource == "AAYU_SUBSCRIPTION") {
      String subscribeVia = customData["subscribe_via"];
      if (subscribeVia == "CONTENT") {
        eventName = "Subs_Payment_Grow_DoItLater";
      } else if (subscribeVia == "HEALING") {
        eventName = "Subs_Payment_Heal_DoItLater";
      } else if (subscribeVia == "LIVE_EVENT") {
        eventName = "Subs_Payment_Event_DoItLater";
      }
    } else if (pageSource == "AAYU_RENEWAL") {
      eventName = "Renewal_Payment_DoItLater";
    } else if (pageSource == "CONFIRM_DOCTOR_CONSULTATION") {
      eventName = "Single_Doctor_Payment_DoItLater";
    } else if (pageSource == "CONSULTATION_PAYMENT") {
      eventName = "Consultation_Payment_DoItLater";
      String consultationType = customData["consultationType"] ?? "";
      if (consultationType.toUpperCase() == "DOCTOR") {
        eventName = "Doctor_Payment_DoItLater";
      } else if (consultationType.toUpperCase() == "THERAPIST") {
        eventName = "Therapist_Payment_DoItLater";
      }
    } else if (pageSource == "UPGRADE_SUBSCRIPTION") {
      eventName = "Subs_Payment_Upgrade_DoItLater";
    }

    EventsService().sendEvent(eventName, {
      "page_source": pageSource,
      "payment_event": paymentEvent,
      "total_payment": totalPayment,
    });
  }

  sendRetryPaymentEvent() {
    String eventName = "Payment_Retry";
    if (pageSource == "AAYU_SUBSCRIPTION") {
      String subscribeVia = customData["subscribe_via"];
      if (subscribeVia == "CONTENT") {
        eventName = "Subs_Payment_Grow_Retry";
      } else if (subscribeVia == "HEALING") {
        eventName = "Subs_Payment_Heal_Retry";
      } else if (subscribeVia == "LIVE_EVENT") {
        eventName = "Subs_Payment_Event_Retry";
      }
    } else if (pageSource == "AAYU_RENEWAL") {
      eventName = "Renewal_Payment_Retry";
    } else if (pageSource == "CONFIRM_DOCTOR_CONSULTATION") {
      eventName = "Single_Doctor_Payment_Retry";
    } else if (pageSource == "CONSULTATION_PAYMENT") {
      eventName = "Consultation_Payment_Retry";
      String consultationType = customData["consultationType"] ?? "";
      if (consultationType.toUpperCase() == "DOCTOR") {
        eventName = "Doctor_Payment_Retry";
      } else if (consultationType.toUpperCase() == "THERAPIST") {
        eventName = "Therapist_Payment_Retry";
      }
    } else if (pageSource == "UPGRADE_SUBSCRIPTION") {
      eventName = "Subs_Payment_Upgrade_Retry";
    }

    EventsService().sendEvent(eventName, {
      "page_source": pageSource,
      "payment_event": paymentEvent,
      "total_payment": totalPayment,
    });
  }
}
