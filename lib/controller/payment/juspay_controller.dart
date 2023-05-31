// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/controller/consultant/personal_trainer_controller.dart';
import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/home/home_top_section_controller.dart';
import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/payment.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/consulting/nutrition/home/nutrition_home.dart';
import 'package:aayu/view/consulting/psychologist/home/psychology_home.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_assessment_start.dart';
import 'package:aayu/view/healing/consultant/check_slot/confirming_slot.dart';
import 'package:aayu/view/payment/payment_pop_ups/choose_another_slot.dart';
import 'package:aayu/view/payment/payment_pop_ups/consultation_addon_payment_success.dart';
import 'package:aayu/view/payment/payment_pop_ups/consultation_payment_success.dart';
import 'package:aayu/view/payment/payment_pop_ups/payment_failed.dart';
import 'package:aayu/view/payment/payment_pop_ups/renewal_payment_success.dart';
import 'package:aayu/view/payment/payment_pop_ups/subscription_payment_success.dart';
import 'package:aayu/view/payment/payment_pop_ups/wigets/nutrition_consultation_payment_success.dart';
import 'package:aayu/view/payment/payment_pop_ups/wigets/nutrition_extend_plan_payment_success.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/offers/special_discount.dart';
import 'package:aayu/view/subscription/offers/special_discount_coach.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../view/payment/payment_pop_ups/wigets/personal_care_subscription_payment_success.dart';
import '../../view/payment/payment_pop_ups/wigets/psychology_consultation_payment_success.dart';
import '../../view/payment/payment_pop_ups/wigets/psychology_extend_plan_payment_success.dart';
import '../consultant/program_recommendation_controller.dart';
import '../healing/post_assessment_controller.dart';
import '../../config.dart';

class JuspayController extends GetxController {
  bool allowCheatOnBackPress = true;
  RxBool paymentProcessStarted = false.obs;

  Future<void> initiateHyperSDK() async {
    try {
      // Check whether hyperSDK is already initialised
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
      bool isInitialised = await hyperSDK.isInitialised();
      print(
          "---------initiateHyperSDK | isInitialised => $isInitialised---------");
      if (!isInitialised) {
        print("---------initiateHyperSDK | initilization started---------");
        // Getting initiate payload
        // block:start:get-initiate-payload
        var initiatePayload = {
          "requestId": DateTime.now().millisecondsSinceEpoch.toString(),
          "service": "in.juspay.hyperpay",
          "payload": {
            "action": "initiate",
            "merchantId": "resettech",
            "clientId": "resettech",
            "environment": (Config.environment != "PROD")
                ? "sandbox"
                : "production" // "sandbox"|"production"
          }
        };
        print("---------initiateHyperSDK | initiatePayload---------");
        print(initiatePayload);
        // block:end:get-initiate-payload
        // Calling initiate on hyperSDK instance to boot up payment engine.
        // block:start:initiate-sdk
        await hyperSDK.initiate(initiatePayload, (MethodCall methodCall) {
          print(
              "-----------------initiateHyperSDK | methodCall.method----------------------");
          print(methodCall.method);
          if (methodCall.method == "initiate_result") {
            // check initiate result
            var args = {};
            try {
              args = json.decode(methodCall.arguments);
            } catch (e) {
              print(e);
            }
            print(
                "-----------------initiateHyperSDK | args----------------------");
            print(args);
          }
        });
        // block:end:initiate-sdk
      }
    } catch (e) {
      print(
          "-----------------initiateHyperSDK | Exception----------------------");
      print(e);
    } finally {
      print("---------initiateHyperSDK | initilization end---------");
    }
  }

  terminateHyperSDK() async {
    bool isInitialised = await hyperSDK.isInitialised();
    if (isInitialised) {
      await hyperSDK.terminate();
    }
  }

  startPaymentProcess(
      String pageSource,
      String paymentEvent,
      double totalPayment,
      String currency,
      dynamic juspaySessionData,
      dynamic customData) async {
    bool isInitialised = await hyperSDK.isInitialised();

    print('---------startPaymentProcess | isInitialised---------');
    print(isInitialised);

    if (isInitialised == true) {
      EventsService().sendEvent("Juspay_Process_Payment", {
        "page_source": pageSource,
        "payment_event": paymentEvent,
        "amount": totalPayment,
        "order_id": juspaySessionData["order_id"] ?? "",
        "juspay_id": juspaySessionData["id"] ?? "",
      });
      print("---------startPaymentProcess | sdk_payload---------");
      print(json.encode(juspaySessionData["sdk_payload"]));

      paymentProcessStarted.value = true;
      hyperSDK.process(juspaySessionData["sdk_payload"],
          (MethodCall methodCall) {
        hyperSDKCallbackHandler(methodCall, pageSource, paymentEvent,
            totalPayment, currency, juspaySessionData, customData);
      });
    } else {
      EventsService().sendEvent("Juspay_Process_Payment_Failed", {
        "page_source": pageSource,
        "payment_event": paymentEvent,
        "amount": totalPayment,
      });

      showCustomSnackBar(
          Get.context!, "Oops...Something went wrong. Please try again later.");
      Get.back();
    }
  }

  void hyperSDKCallbackHandler(
      MethodCall methodCall,
      String pageSource,
      String paymentEvent,
      double totalPayment,
      String currency,
      dynamic juspaySessionData,
      dynamic customData) async {
    print(
        "-----------------hyperSDKCallbackHandler | methodCall.method----------------------");
    print(methodCall.method);

    switch (methodCall.method) {
      case "hide_loader":
        Get.back();
        break;
      case "process_result":
        paymentProcessStarted.value = false;
        var args = {};
        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          print(e);
        }
        print(
            "-----------------hyperSDKCallbackHandler | args----------------------");
        print(args);

        var error = args["error"] ?? false;
        var innerPayload = args["payload"] ?? {};
        var status = innerPayload["status"] ?? "";
        // var paymentInstrument = innerPayload["paymentInstrument"] ?? "";
        // var paymentInstrumentGroup =
        //     innerPayload["paymentInstrumentGroup"] ?? " ";

        EventsService().sendEvent("Juspay_CallBack_Response", {
          "page_source": pageSource,
          "payment_event": paymentEvent,
          "amount": totalPayment,
          "order_id": juspaySessionData["order_id"] ?? "",
          "juspay_id": juspaySessionData["id"] ?? "",
          "status": status
        });

        if (!error) {
          switch (status) {
            case "charged":
              {
                // block:start:check-order-status
                // Successful Transaction
                // check order status via S2S API
                // block:end:check-order-status

                handleSuccessPaymentFlow(pageSource, paymentEvent, totalPayment,
                    currency, juspaySessionData, customData, args);
              }
              break;
            case "cod_initiated":
              {
                // User opted for cash on delivery option displayed on payment page
              }
              break;
          }
        } else {
          bool checkOrderStatus = false;
          // var errorCode = args["errorCode"] ?? " ";
          // var errorMessage = args["errorMessage"] ?? " ";
          switch (status) {
            case "backpressed":
              {
                if (allowCheatOnBackPress == true) {
                } else {
                  checkOrderStatus = true;
                  handleSuccessPaymentFlow(
                      pageSource,
                      paymentEvent,
                      totalPayment,
                      currency,
                      juspaySessionData,
                      customData,
                      args);
                }
                // user back-pressed from PP without initiating any txn
              }
              break;
            case "user_aborted":
              {
                // user initiated a txn and pressed back
                // check order status via S2S API
                checkOrderStatus = true;
                handleSuccessPaymentFlow(pageSource, paymentEvent, totalPayment,
                    currency, juspaySessionData, customData, args);
              }
              break;
            case "pending_vbv":
              {}
              break;
            case "authorizing":
              {
                // txn in pending state
                // check order status via S2S API
                checkOrderStatus = true;
                handleSuccessPaymentFlow(pageSource, paymentEvent, totalPayment,
                    currency, juspaySessionData, customData, args);
              }
              break;
            case "authorization_failed":
              {}
              break;
            case "authentication_failed":
              {}
              break;
            case "api_failure":
              {
                // txn failed
                // check order status via S2S API
                checkOrderStatus = true;
                handleSuccessPaymentFlow(pageSource, paymentEvent, totalPayment,
                    currency, juspaySessionData, customData, args);
              }
              break;
            case "new":
              {
                // order created but txn failed
                // check order status via S2S API
                checkOrderStatus = true;
                handleSuccessPaymentFlow(pageSource, paymentEvent, totalPayment,
                    currency, juspaySessionData, customData, args);
              }
              break;
          }

          if (checkOrderStatus == false) {
            if (allowCheatOnBackPress == true) {
              if (await checkIsWhiteListedNumber() == true) {
                handleSuccessPaymentFlow(pageSource, paymentEvent, totalPayment,
                    currency, juspaySessionData, customData, args,
                    doCheat: true);
              } else {
                dynamic postData = {
                  "orderId": juspaySessionData["order_id"],
                  "status": "Failed",
                  "response": args
                };
                PaymentService().postJuspayTransaction(postData);
                Get.bottomSheet(
                  PaymentFailed(
                    pageSource: pageSource,
                    totalPayment: totalPayment,
                    currency: currency,
                    paymentEvent: paymentEvent,
                    customData: customData,
                  ),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                );
              }
            } else {
              dynamic postData = {
                "orderId": juspaySessionData["order_id"],
                "status": "Failed",
                "response": args
              };
              PaymentService().postJuspayTransaction(postData);
              Get.bottomSheet(
                PaymentFailed(
                  pageSource: pageSource,
                  totalPayment: totalPayment,
                  currency: currency,
                  paymentEvent: paymentEvent,
                  customData: customData,
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            }
          }
        }
    }
  }

  Future<Map<String, dynamic>?> createSession(String event, double totalPayment,
      String currency, dynamic customData) async {
    Map<String, Object> juspaySessionData = {};
    try {
      UserDetailsResponse? userDetailsResponse =
          await HiveService().getUserDetails();
      dynamic postData = {
        "payment": {
          "event": event,
          "action": "paymentPage",
          "amount": totalPayment,
          "currency": currency
        },
        "user": {
          "firtName": userDetailsResponse!.userDetails!.firstName ?? "",
          "lastName": userDetailsResponse.userDetails!.lastName ?? "",
          "emailId": userDetailsResponse.userDetails!.emailId ?? "",
          "mobileNumber": userDetailsResponse.userDetails!.mobileNumber ?? "",
        },
        "customData": customData
      };

      print("--------------createJuspaySession|postData--------------");
      print(postData);

      juspaySessionData = await PaymentService().createJuspaySession(postData);
    } finally {
      print(
          "--------------createJuspaySession|juspaySessionData--------------");
      print(juspaySessionData);
    }
    return juspaySessionData;
  }

  Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
    Map<String, dynamic> juspayOrderData;
    try {
      juspayOrderData = await PaymentService().getJuspayOrderStatus(orderId);
      print("--------------createJuspaySession|juspayOrderData--------------");
      print(juspayOrderData);
    } finally {}
    return juspayOrderData;
  }

  handleSuccessPaymentFlow(
      String pageSource,
      String paymentEvent,
      double totalPayment,
      String currency,
      dynamic juspaySessionData,
      dynamic customData,
      dynamic transactionData,
      {bool doCheat = false}) async {
    try {
      Map<String, dynamic> juspayOrderData =
          await getOrderStatus(juspaySessionData["order_id"]);
      if ((doCheat == true ||
              juspayOrderData["status"].toString() == "CHARGED") &&
          (double.parse(juspayOrderData["amount"].toString()) ==
              double.parse(juspaySessionData["sdk_payload"]["payload"]["amount"]
                  .toString()))) {
        totalPayment = double.parse(juspayOrderData["amount"].toString());
        dynamic postData = {
          "orderId": juspaySessionData["order_id"],
          "status": "Success",
          "response": transactionData
        };
        PaymentService().postJuspayTransaction(postData);

        if (customData["promoCodeDetails"] != null &&
            customData["promoCodeDetails"]["isApplied"] == true &&
            customData["promoCodeDetails"]["promoCode"] != null &&
            customData["promoCodeDetails"]["promoCode"]["promoCodeId"] !=
                null) {
          EventsService().sendEvent("Promo_Code_Transaction", {
            "pageSource": pageSource,
            "promo_code_id": customData["promoCodeDetails"]["promoCode"]
                    ["promoCodeId"] ??
                "",
            "promo_code": customData["promoCodeDetails"]["promoCode"] ?? "",
            "order_id": juspaySessionData["order_id"],
            "currency": currency,
            "total_payment": totalPayment
          });
          dynamic postPromoCodeData = {
            "promoCodeId": customData["promoCodeDetails"]["promoCode"]
                ["promoCodeId"],
            "orderId": juspaySessionData["order_id"],
            "accessType": customData["promoCodeDetails"]["promoCode"]
                ["accessType"],
            "appUserCouponId": customData["promoCodeDetails"]["promoCode"]
                ["appUserCouponId"],
          };
          PaymentService().postPromoCodeTransaction(postPromoCodeData);
          SubscriptionPackageController subscriptionPackageController =
              Get.find();
          subscriptionPackageController.appliedPromoCode = null;
          subscriptionPackageController.isPromoCodeApplied.value = false;
        }
        if (customData["specialOffer"] != null &&
            customData["specialOfferId"] != null) {
          EventsService().sendEvent("Special_Offer_Transaction", {
            "pageSource": pageSource,
            "special_offer_id": customData["specialOffer"]["specialOfferId"],
            "special_offer_source": customData["specialOffer"]["source"],
            "special_offer_offerOn": customData["specialOffer"]["offerOn"],
            "special_offer_country": customData["specialOffer"]["country"],
            "special_offer_discount": customData["specialOffer"]["discount"],
            "order_id": juspaySessionData["order_id"],
            "currency": currency,
            "total_payment": totalPayment
          });
          dynamic postSpecialOfferData = {
            "specialOfferId": customData["specialOffer"]["specialOfferId"],
            "source": customData["specialOffer"]["source"],
            "offerOn": customData["specialOffer"]["offerOn"],
            "discount": customData["specialOffer"]["discount"],
            "referencePackageId": customData["specialOffer"]
                ["referencePackageId"],
            "purchaseAmount": juspayOrderData["amount"],
            "paymentOrderId": juspaySessionData["order_id"]
          };
          PaymentService().postSpecialOfferTransaction(postSpecialOfferData);
          SubscriptionPackageController subscriptionPackageController =
              Get.find();
          subscriptionPackageController.appliedPromoCode = null;
        }

        switch (pageSource) {
          case "CONSULTATION_PAYMENT":
            sendEvents("CONSULTATION_PAYMENT", juspaySessionData["order_id"],
                currency, totalPayment, customData);
            await Future.wait([
              addPaymentConsultingPackageEntry(
                  customData["selectedConsultingPackage"]),
              addConsultationSlots(
                  customData["consultationType"],
                  juspaySessionData["order_id"],
                  customData["sessions"],
                  customData["consultingPackageId"])
            ]);
            Get.bottomSheet(
              ConsultationAddOnPaymentSuccess(
                consultationType: customData["consultationType"] ?? "",
                sessions: customData["sessions"],
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
            break;
          case "CONFIRM_THERAPIST_CONSULTATION":
            PersonalTrainerController personalTrainerController = Get.find();
            sendEvents(
                "SINGLE_THERAPIST_PAYMENT_SUCCESS",
                juspaySessionData["order_id"],
                currency,
                totalPayment,
                customData);
            bool isConfirmed = await personalTrainerController.confirmSlot(
                customData["trainerId"],
                customData["consultName"],
                customData["consultType"],
                customData["bookType"],
                juspaySessionData["order_id"]);

            await addPaymentConsultingPackageEntry(
                customData["selectedConsultingPackage"]);

            if (isConfirmed == true) {
              sendEvents(
                  "SINGLE_THERAPIST_SESSION_SLOT_CONFIRMED",
                  juspaySessionData["order_id"],
                  currency,
                  totalPayment,
                  customData);
              Get.bottomSheet(
                ConsultationPaymentSuccess(
                  consultationType: customData["consultationType"],
                  okayFunction: () {
                    Get.to(
                      ConfirmingSlot(
                        isScheduled: false,
                        consultationType: "THERAPIST",
                        bookCall: () async {
                          Get.until((route) => route.isFirst);
                          MyRoutineController myRoutineController = Get.find();
                          HealingListController healingListController =
                              Get.find();
                          TrainerSessionController trainerSessionController =
                              Get.find();
                          healingListController.resetSelection();
                          await Future.wait([
                            myRoutineController.getData(),
                            trainerSessionController.getSessionSummary()
                          ]);
                          Future.delayed(Duration.zero, () {
                            showScheduledSessionPopup(
                                customData["consultationType"],
                                customData["trainerName"],
                                customData["profilePic"],
                                customData["scheduleDate"],
                                customData["scheduleTime"]);
                          });
                        },
                      ),
                    );
                  },
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            } else {
              sendEvents(
                  "SINGLE_THERAPIST_PAYMENT_ANOTHER_SLOT",
                  juspaySessionData["order_id"],
                  currency,
                  totalPayment,
                  customData);
              Get.bottomSheet(
                ChooseAnotherSlot(
                  isDoctor: false,
                  doctorId: customData["trainerId"],
                  consultName: customData["consultName"],
                  consultType: customData["consultType"],
                  bookType: customData["bookType"],
                  orderId: customData["order_id"],
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            }
            break;
          case "CONFIRM_DOCTOR_CONSULTATION":
            // DiseaseDetailsRequest diseaseDetailsRequest =
            //     DiseaseDetailsRequest.fromJson(customData["diseaseList"]);
            DoctorController doctorController = Get.find();
            sendEvents(
                "SINGLE_DOCTOR_PAYMENT_SUCCESS",
                juspaySessionData["order_id"],
                currency,
                totalPayment,
                customData);
            bool isConfirmed = await doctorController.confirmSlot(
                customData["doctorId"],
                customData["sessionId"],
                customData["consultType"],
                customData["bookType"],
                juspaySessionData["order_id"]);

            await addPaymentConsultingPackageEntry(
                customData["selectedConsultingPackage"]);

            if (isConfirmed == true) {
              sendEvents(
                  "SINGLE_DOCTOR_SESSION_SLOT_CONFIRMED",
                  juspaySessionData["order_id"],
                  currency,
                  totalPayment,
                  customData);
              Get.bottomSheet(
                ConsultationPaymentSuccess(
                  consultationType: customData["consultationType"],
                  okayFunction: () {
                    Get.to(
                      ConfirmingSlot(
                        isScheduled: false,
                        consultationType: "DOCTOR",
                        bookCall: () async {
                          if (customData["pageSource"] == "MY_ROUTINE") {
                            Get.close(3);
                          } else if (customData["pageSource"] ==
                              "DOCTOR_LIST") {
                            Get.close(2);
                          } else {
                            Get.close(4);
                          }
                          MyRoutineController myRoutineController = Get.find();
                          HealingListController healingListController =
                              Get.find();
                          DoctorSessionController doctorSessionController =
                              Get.find();
                          healingListController.resetSelection();
                          await Future.wait([
                            myRoutineController.getData(),
                            doctorSessionController.getSessionSummary()
                          ]);
                          Future.delayed(Duration.zero, () {
                            showScheduledSessionPopup(
                                customData["consultationType"],
                                customData["doctorName"],
                                customData["profilePic"],
                                customData["scheduleDate"],
                                customData["scheduleTime"]);
                          });
                        },
                      ),
                    );
                  },
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            } else {
              sendEvents(
                  "SINGLE_DOCTOR_PAYMENT_ANOTHER_SLOT",
                  juspaySessionData["order_id"],
                  currency,
                  totalPayment,
                  customData);
              Get.bottomSheet(
                ChooseAnotherSlot(
                  isDoctor: true,
                  doctorId: customData["doctorId"],
                  consultName: customData["consultName"],
                  consultType: customData["consultType"],
                  bookType: customData["bookType"],
                  orderId: customData["order_id"],
                ),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            }
            break;
          case "AAYU_SUBSCRIPTION":
            await startAayuSubscription(
                juspaySessionData["order_id"], customData);

            sendEvents("AAYU_SUBSCRIPTION", juspaySessionData["order_id"],
                currency, totalPayment, customData);
            Get.bottomSheet(
              SubscriptionPaymentSuccess(
                customData: customData,
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
            break;
          case "UPGRADE_SUBSCRIPTION":
            await startAayuUpgradePlan(
                juspaySessionData["order_id"], customData);
            showGreenSnackBar(Get.context,
                'Great decision! Your program is successfully upgraded.');
            sendEvents("UPGRADE_SUBSCRIPTION", juspaySessionData["order_id"],
                currency, totalPayment, customData);
            break;
          case "AAYU_RENEWAL":
            await startAayuRenewal(juspaySessionData["order_id"], customData);
            sendEvents("AAYU_RENEWAL", juspaySessionData["order_id"], currency,
                totalPayment, customData);
            Get.bottomSheet(
              RenewalPaymentSuccess(
                customData: customData,
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
            break;
          case "PERSONAL_CARE":
            String userType = customData["userType"];
            switch (userType) {
              case "AAYU_NOT_SUBSCRIBED|HEALING_NOT_ACCESSED":
                await startAayuSubscription(
                    juspaySessionData["order_id"], customData);
                sendEvents("AAYU_SUBSCRIPTION", juspaySessionData["order_id"],
                    currency, totalPayment, customData);
                SubscriptionController subscriptionController = Get.find();
                await subscriptionController.startRecommendedProgram();
                Get.to(const PersonalCareSubscriptionPaymentSuccess());
                break;
              case "AAYU_SUBSCRIBED|HEALING_NOT_ACCESSED":
                sendEvents(
                    "PERSONAL_CARE_PAYMENT",
                    juspaySessionData["order_id"],
                    currency,
                    totalPayment,
                    customData);
                await extendExpiryDate(
                    juspaySessionData["order_id"],
                    subscriptionCheckResponse!
                        .subscriptionDetails!.subscriptionId!,
                    customData["selectedPackage"]);
                break;
              case "AAYU_SUBSCRIBED|HEALING_ACCESSED":
                sendEvents(
                    "PERSONAL_CARE_PAYMENT",
                    juspaySessionData["order_id"],
                    currency,
                    totalPayment,
                    customData);
                await extendExpiryDate(
                    juspaySessionData["order_id"],
                    subscriptionCheckResponse!
                        .subscriptionDetails!.subscriptionId!,
                    customData["selectedPackage"]);
                break;
            }
            dynamic postPaymentDetails = {
              "orderId": juspaySessionData["order_id"],
              "subscriptionCharges": customData["selectedPackage"]
                  ["subscriptionCharges"],
              "isPercentage": customData["selectedPackage"]["isPercentage"],
              "discount": customData["selectedPackage"]["discount"],
              "purchaseAmount": customData["selectedPackage"]["purchaseAmount"]
            };
            await SubscriptionService().updatePersonalCarePayment(
                globalUserIdDetails!.userId!,
                subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
                postPaymentDetails);

            Get.to(SubscriptionPaymentSuccess(
              customData: customData,
            ));
            break;
          case "RECOMMENDED_PROGRAM":
            String userType = customData["userType"];
            switch (userType) {
              case "AAYU_NOT_SUBSCRIBED|HEALING_NOT_ACCESSED":
                await startAayuSubscription(
                    juspaySessionData["order_id"], customData);
                sendEvents("AAYU_SUBSCRIPTION", juspaySessionData["order_id"],
                    currency, totalPayment, customData);
                if (customData["multipleProgram"] != null &&
                    customData["multipleProgram"] == true) {
                  SubscriptionController subscriptionController = Get.find();
                  await subscriptionController.startRecommendedProgram();
                }
                Get.to(SubscriptionPaymentSuccess(
                  customData: customData,
                ));
                break;
              case "AAYU_SUBSCRIBED|HEALING_NOT_ACCESSED":
                sendEvents(
                    "RECOMMENDED_PROGRAM_PAYMENT",
                    juspaySessionData["order_id"],
                    currency,
                    totalPayment,
                    customData);
                await extendExpiryDate(
                    juspaySessionData["order_id"],
                    subscriptionCheckResponse!
                        .subscriptionDetails!.subscriptionId!,
                    customData["selectedPackage"]);
                SubscriptionController subscriptionController = Get.find();
                await subscriptionController.startRecommendedProgram();
                Get.to(SubscriptionPaymentSuccess(
                  customData: customData,
                ));
                break;
              case "AAYU_SUBSCRIBED|HEALING_ACCESSED":
                sendEvents(
                    "RECOMMENDED_PROGRAM_PAYMENT",
                    juspaySessionData["order_id"],
                    currency,
                    totalPayment,
                    customData);
                await switchRecommendedProgram(
                    customData["selectedPackage"]["packageType"]);
                Get.to(const PersonalCareSubscriptionPaymentSuccess());
                break;
            }
            break;
          case "NUTRITION_CONSULTATION":
            sendEvents("NUTRITION_CONSULTATION", juspaySessionData["order_id"],
                currency, totalPayment, customData);
            NutritionController nutritionController = Get.find();
            bool isStarted = false;
            if (customData["extendPlan"] == true) {
              isStarted = await nutritionController.extendNutritionPlan(
                  customData["coachId"],
                  customData["selectedPackage"]["packageId"],
                  juspaySessionData["order_id"]);
            } else {
              isStarted = await nutritionController.startUserNutrition(
                  customData["coachId"],
                  customData["selectedPackage"]["packageId"],
                  juspaySessionData["order_id"]);
            }
            if (isStarted == true) {
              //await nutritionController.getUserNutritionDetails();
              MyRoutineController myRoutineController = Get.find();
              await myRoutineController.checkNutritionStatus();
              myRoutineController.organize();
              myRoutineController.update();
              Navigator.of(Get.context!).popUntil((route) => route.isFirst);
              Get.to(const NutritionHome());
              Future.delayed(const Duration(seconds: 1), () {
                Get.bottomSheet(
                  customData["extendPlan"] == true
                      ? NutritionExtendPlanPaymentSuccess(
                          pageSource: pageSource,
                          totalPayment: totalPayment,
                          currency: currency,
                          paymentEvent: paymentEvent,
                          customData: customData,
                        )
                      : NutritionConsultationPaymentSuccess(
                          pageSource: pageSource,
                          totalPayment: totalPayment,
                          currency: currency,
                          paymentEvent: paymentEvent,
                          customData: customData,
                        ),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                );
              });
            }
            break;
          case "MENTAL_WELLBEING":
            sendEvents("MENTAL_WELLBEING", juspaySessionData["order_id"],
                currency, totalPayment, customData);
            PsychologyController psychologyController = Get.find();
            bool isStarted = false;
            if (customData["extendPlan"] == true) {
              isStarted = await psychologyController.extendPsychologyPlan(
                  customData["selectedPackage"]["packageId"],
                  juspaySessionData["order_id"]);
            } else {
              isStarted = await psychologyController.startUserPsychologyPlan(
                  customData["selectedPackage"]["packageId"],
                  juspaySessionData["order_id"]);
            }
            if (isStarted == true) {
              //await nutritionController.getUserNutritionDetails();
              MyRoutineController myRoutineController = Get.find();
              await myRoutineController.checkPsychologyStatus();
              myRoutineController.organize();
              myRoutineController.update();
              Navigator.of(Get.context!).popUntil((route) => route.isFirst);
              if (customData["extendPlan"] == true) {
                Get.to(const PsychologyHome());
              } else {
                Get.to(const PsychologistAssessmentStart());
              }
              Future.delayed(const Duration(seconds: 1), () {
                Get.bottomSheet(
                  customData["extendPlan"] == true
                      ? PsychologyExtendPlanPaymentSuccess(
                          pageSource: pageSource,
                          totalPayment: totalPayment,
                          currency: currency,
                          paymentEvent: paymentEvent,
                          customData: customData,
                        )
                      : PsychologyConsultationPaymentSuccess(
                          pageSource: pageSource,
                          totalPayment: totalPayment,
                          currency: currency,
                          paymentEvent: paymentEvent,
                          customData: customData,
                        ),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                );
              });
            }
            break;
        }
      } else {
        try {
          String offerOn = "";
          switch (pageSource) {
            case "AAYU_SUBSCRIPTION":
              offerOn = 'SUBSCRIPTION';
              break;
            case "UPGRADE_SUBSCRIPTION":
              offerOn = 'UPGRADE SUBSCRIPTION';
              break;
            case "AAYU_RENEWAL":
              offerOn = 'RENEWAL';
              break;
            case "CONFIRM_THERAPIST_CONSULTATION":
              offerOn = 'THERAPIST CONSULTATION';
              break;
            case "CONFIRM_DOCTOR_CONSULTATION":
              offerOn = 'DOCTOR CONSULTATION';
              break;
          }
          SpecialOfferModel? response;
          if ((customData["specialOffer"] == null ||
                  customData["specialOffer"]["specialOfferId"] == null) &&
              offerOn.isNotEmpty) {
            response = await PaymentService()
                .getSpecialOffer('PAYMENT FAILURE', offerOn);
          }

          bool showPaymentFailed = true;
          if (response != null) {
            String country = "";
            UserDetailsResponse? userDetailsResponse =
                await HiveService().getUserDetails();
            if (userDetailsResponse != null &&
                userDetailsResponse.userDetails != null) {
              if (userDetailsResponse.userDetails!.location != null &&
                  userDetailsResponse.userDetails!.location!.isNotEmpty) {
                country =
                    userDetailsResponse.userDetails!.location!.first!.country ??
                        "";
              }
            }
            int index = response.offerDetails!.countries!
                .indexWhere((element) => element!.country == country);
            double percent = 0;
            if (index != -1) {
              showPaymentFailed = false;
              percent = response.offerDetails!.countries?[index]?.discount ?? 0;
              switch (pageSource) {
                case "AAYU_SUBSCRIPTION":
                case "UPGRADE_SUBSCRIPTION":
                case "AAYU_RENEWAL":
                  SubscriptionPackageController subscriptionPackageController =
                      Get.find();
                  subscriptionPackageController.applyTemporaryDiscount(percent);
                  Get.to(SpecialDiscount(
                    pageSource: pageSource,
                    country: country,
                    specialOfferModel: response,
                    time: 30,
                    percent: percent,
                    customData: customData,
                  ));

                  break;
                case "CONFIRM_DOCTOR_CONSULTATION":
                  DoctorController doctorController = Get.find();
                  doctorController.applyTemporaryDiscount(percent);
                  await doctorController
                      .getDoctorProfile(customData["doctorId"]);
                  Get.to(SpecialDiscountCoach(
                    doctorController: doctorController,
                    pageSource: pageSource,
                    country: country,
                    specialOfferModel: response,
                    time: 30,
                    percent: percent,
                    customData: customData,
                  ));

                  break;
                case "CONFIRM_THERAPIST_CONSULTATION":
                  PersonalTrainerController personalTrainerController =
                      Get.find();
                  personalTrainerController.applyTemporaryDiscount(percent);
                  await personalTrainerController
                      .getTrainerProfile(customData["trainerId"]);
                  Get.to(SpecialDiscountCoach(
                    personalTrainerController: personalTrainerController,
                    pageSource: pageSource,
                    country: country,
                    specialOfferModel: response,
                    time: 30,
                    percent: percent,
                    customData: customData,
                  ));

                  break;
                default:
              }
            }
          }
          if (showPaymentFailed) {
            dynamic postData = {
              "orderId": juspaySessionData["order_id"],
              "status": "Failed",
              "response": transactionData
            };
            PaymentService().postJuspayTransaction(postData);
            Get.bottomSheet(
              PaymentFailed(
                pageSource: pageSource,
                totalPayment: totalPayment,
                currency: currency,
                paymentEvent: paymentEvent,
                customData: customData,
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
          }
        } catch (er) {}
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addConsultationSlots(String consultType, String orderId,
      int sessions, String consultingSessionId) async {
    try {
      String profession = "";
      if (consultType.toUpperCase() == "DOCTOR") {
        profession = "Doctor";
      } else if (consultType.toUpperCase() == "THERAPIST") {
        profession = "Trainer";
      }
      dynamic postData = {
        "profession": profession,
        "consultingPackageId": consultingSessionId,
        "sessions": sessions,
        "paymentOrderId": orderId
      };
      bool isAdded = await CoachService()
          .addSessions(globalUserIdDetails!.userId!, postData);
      if (isAdded == true) {
        if (consultType.toUpperCase() == "DOCTOR") {
          DoctorSessionController doctorSessionController = Get.find();
          doctorSessionController.getSessionSummary();
          doctorSessionController.getUpcomingSessions();
        } else if (consultType.toUpperCase() == "THERAPIST") {
          TrainerSessionController trainerSessionController =
              Get.put(TrainerSessionController());
          await Future.wait([
            trainerSessionController.getSessionSummary(),
            trainerSessionController.getUpcomingSessions(),
          ]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addPaymentConsultingPackageEntry(
      dynamic selectedConsultingPackage) async {
    dynamic postData = {
      "packageName": selectedConsultingPackage["packageName"],
      "consultType": selectedConsultingPackage["consultType"],
      "purchaseType": selectedConsultingPackage["purchaseType"],
      "sessions": selectedConsultingPackage["sessions"],
      "consultingCharges": selectedConsultingPackage["consultingCharges"],
      "isPercentage": selectedConsultingPackage["isPercentage"],
      "discount": selectedConsultingPackage["discount"],
      "consultingPackageId": selectedConsultingPackage["consultingPackageId"]
    };
    try {
      await PaymentService().postConsultingPackageEntry(postData);
    } catch (e) {
      print(e);
    }
  }

  checkIsWhiteListedNumber() async {
    bool doCheat = false;
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();
    if (userDetailsResponse != null &&
        userDetailsResponse.userDetails != null &&
        userDetailsResponse.userDetails!.mobileNumber != null) {
      doCheat = appProperties.whiteListNumbers!
          .contains(userDetailsResponse.userDetails!.mobileNumber);
    }
    print("------------checkIsWhiteListedNumber---------------");
    print(doCheat);
    return doCheat;
  }

  Future<bool> startAayuSubscription(
      String paymentOrderId, dynamic customData) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isSubscribed = await subscriptionController.postAayuSubscription(
      paymentOrderId,
      customData["subscribeVia"],
      customData["selectedPackage"],
    );
    Get.back();
    if (isSubscribed == true) {
      HomeTopSectionController homeTopSectionController =
          Get.put(HomeTopSectionController());
      homeTopSectionController.getHomePageTopSectionContent();
      if (customData["subscribeVia"] == "MY_SUBSCRIPTION") {
        await subscriptionController.getSubscriptionDetails();
      }
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isSubscribed;
  }

  Future<bool> startAayuRenewal(
      String paymentOrderId, dynamic customData) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isRenewed = await subscriptionController.postAayuRenewal(
        paymentOrderId,
        customData["subscriptionId"],
        customData["selectedPackage"],
        customData["renewalVia"]);
    Get.back();
    if (isRenewed == true) {
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());
      await subscriptionController.getSubscriptionDetails();
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isRenewed;
  }

  Future<bool> startAayuUpgradePlan(
      String paymentOrderId, dynamic customData) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isUpgraded = await subscriptionController.postAayuUpgradePlan(
      paymentOrderId,
      customData["subscriptionId"],
      customData["selectedPackage"],
    );
    Get.back();
    if (isUpgraded == true) {
      SubscriptionController subscriptionController =
          Get.put(SubscriptionController());
      await subscriptionController.getSubscriptionDetails();
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isUpgraded;
  }

  switchRecommendedProgram(String packageType) async {
    HealingListController healingListController = Get.find();
    ProgramRecommendationController programRecommendationController =
        Get.find();
    List<String> diseaseList = programRecommendationController
        .recommendation.value!.recommendation!.disease!
        .map((element) => element!.diseaseId!)
        .toList();

    healingListController.setSelectedDiseaseFromMultiDiseaseIds(diseaseList);
    PostAssessmentController postAssessmentController =
        Get.put(PostAssessmentController());

    String programId = programRecommendationController
            .recommendation.value!.recommendation!.programId ??
        "";
    bool isDataAvailable =
        await postAssessmentController.getProgramDetails(programId);
    if (isDataAvailable == true) {
      bool isSelected = false;
      for (var element
          in postAssessmentController.programDurationDetails.value!.duration!) {
        if (element!.isSelected == true) {
          isSelected = true;
          break;
        }
      }
      if (isSelected == false) {
        postAssessmentController
            .programDurationDetails.value!.duration![0]!.isSelected = true;
      }

      SubscriptionController subscriptionController = Get.find();
      await subscriptionController.switchRecommendedProgram(packageType);
    } else {
      showSnackBar(Get.context, "PERFERENCES_DETAILS_NOT_AVAILABLE".tr,
          SnackBarMessageTypes.Info);
    }
  }

  Future<bool> extendExpiryDate(String paymentOrderId, String subscriptionId,
      dynamic selectedPackage) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isUpdated = await subscriptionController.extendExpiryDate(
      paymentOrderId,
      subscriptionId,
      selectedPackage,
    );
    Get.back();
    if (isUpdated == true) {
      if (selectedPackage["sessions"]["doctor"] > 0) {
        DoctorSessionController doctorSessionController = Get.find();
        doctorSessionController.getUpcomingSessions();
        doctorSessionController.getSessionSummary();
      }
      if (selectedPackage["sessions"]["therapist"] > 0) {
        TrainerSessionController trainerSessionController = Get.find();
        trainerSessionController.getUpcomingSessions();
        trainerSessionController.getSessionSummary();
      }
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isUpdated;
  }

  sendEvents(String paymentType, String orderId, String currency,
      double totalPayment, dynamic customData) {
    switch (paymentType) {
      case "AAYU_SUBSCRIPTION":
        String eventName = "Subscription_Payment_Success";
        String subscribeVia = customData["subscribeVia"];
        if (subscribeVia == "CONTENT") {
          eventName = "Subs_Payment_Grow_Success";
        } else if (subscribeVia == "HEALING") {
          eventName = "Subs_Payment_Heal_Success";
        } else if (subscribeVia == "LIVE_EVENT") {
          eventName = "Subs_Payment_Event_Success";
        } else if (subscribeVia == "RECOMMENDED_PROGRAM") {
          eventName = "Subs_Payment_RecmdProgram_Success";
        } else if (subscribeVia == "PERSONAL_CARE") {
          eventName = "Subs_Payment_PersonalCare_Success";
        }
        Map<String, dynamic> eventData = {
          "subscribe_via": subscribeVia,
          "user_id": globalUserIdDetails!.userId!,
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "subscription_type": customData["selectedPackage"]
              ["subscriptionType"],
          "subscription_charges": customData["selectedPackage"]
              ["subscriptionCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,
          "subscription_package_id": customData["selectedPackage"]
              ["subscriptionPackageId"],
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        EventsService().sendEvent(eventName, eventData);

        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);

        sendSubscriptionPeriodEvents(
            paymentType, orderId, currency, totalPayment, customData);
        break;
      case "UPGRADE_SUBSCRIPTION":
        String eventName = "Subs_Payment_Upgrade_Success";
        String subscribeVia = customData["subscribeVia"];
        if (subscribeVia == "MY_SUBSCRIPTION") {
          eventName = "Subs_Payment_Upgrade_Success";
        } else if (subscribeVia == "PROMOTION") {
          eventName = "Subs_Payment_Upgrade_Success";
        }
        Map<String, dynamic> eventData = {
          "subscribe_via": subscribeVia,
          "user_id": globalUserIdDetails!.userId!,
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "subscription_type": customData["selectedPackage"]
              ["subscriptionType"],
          "subscription_charges": customData["selectedPackage"]
              ["subscriptionCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,
          "subscription_package_id": customData["selectedPackage"]
              ["subscriptionPackageId"],
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        EventsService().sendEvent(eventName, eventData);
        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);
        FacebookAppEvents().logSubscribe(
            price: totalPayment, currency: currency, orderId: orderId);

        break;
      case "AAYU_RENEWAL":
        Map<String, dynamic> eventData = {
          "renewal_via": customData["renewalVia"],
          "user_id": globalUserIdDetails!.userId!,
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "subscription_type": customData["selectedPackage"]
              ["subscriptionType"],
          "subscription_charges": customData["selectedPackage"]
              ["subscriptionCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,

          "subscription_package_id": customData["selectedPackage"]
              ["subscriptionPackageId"],
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        EventsService().sendEvent("Renewal_Payment_Success", eventData);

        BranchService().trackCustomRevenue(
            "Renewal_Payment_Success", currency, totalPayment, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);
        FacebookAppEvents().logSubscribe(
            price: totalPayment, currency: currency, orderId: orderId);

        break;
      case "SINGLE_DOCTOR_PAYMENT_SUCCESS":
        DoctorController doctorController = Get.find();
        Map<String, dynamic> eventData = {
          "doctor_id": customData["doctorId"],
          "user_id": globalUserIdDetails!.userId!,
          "consult_name": customData["doctorName"],
          "consult_type": customData["consultType"],
          "book_type": customData["bookType"],
          "session_id": doctorController.selectedSlot!.sessionId,
          "selected_date": DateFormat.yMMMd()
              .format(doctorController.selectedDate)
              .toString(),
          "from_time": doctorController.selectedSlot!.fromTime!,
          "to_time": doctorController.selectedSlot!.toTime!,
          "order_id": orderId,
          "purchase_amount": totalPayment,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        EventsService().sendEvent("Single_Doctor_Payment_Success", eventData);

        BranchService().trackCustomRevenue(
            "Single_Doctor_Payment_Success", currency, totalPayment, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);
        break;
      case "SINGLE_DOCTOR_SESSION_SLOT_CONFIRMED":
        DoctorController doctorController = Get.find();
        EventsService().sendEvent("Single_Doctor_Session_Slot_Confirmed", {
          "doctor_id": customData["doctorId"],
          "user_id": globalUserIdDetails!.userId!,
          "consult_name": customData["doctorName"],
          "consult_type": customData["consultType"],
          "book_type": customData["bookType"],
          "session_id": doctorController.selectedSlot!.sessionId,
          "selected_date": DateFormat.yMMMd()
              .format(doctorController.selectedDate)
              .toString(),
          "from_time": doctorController.selectedSlot!.fromTime!,
          "to_time": doctorController.selectedSlot!.toTime!,
          "order_id": orderId,
        });
        break;
      case "SINGLE_DOCTOR_PAYMENT_ANOTHER_SLOT":
        DoctorController doctorController = Get.find();
        EventsService().sendEvent("Single_Doctor_Payment_Another_Slot", {
          "doctor_id": customData["doctorId"],
          "user_id": globalUserIdDetails!.userId!,
          "consult_name": customData["doctorName"],
          "consult_type": customData["consultType"],
          "book_type": customData["bookType"],
          "session_id": doctorController.selectedSlot!.sessionId,
          "selected_date": DateFormat.yMMMd()
              .format(doctorController.selectedDate)
              .toString(),
          "from_time": doctorController.selectedSlot!.fromTime!,
          "to_time": doctorController.selectedSlot!.toTime!,
          "order_id": orderId,
        });
        break;
      case "SINGLE_THERAPIST_PAYMENT_SUCCESS":
        PersonalTrainerController personalTrainerController = Get.find();
        Map<String, dynamic> eventData = {
          "trainer_id": customData["trainerId"],
          "user_id": globalUserIdDetails!.userId!,
          "consult_name": customData["trainerName"],
          "consult_type": customData["consultType"],
          "book_type": customData["bookType"],
          "session_id": personalTrainerController.selectedSlot!.sessionId,
          "selected_date": DateFormat.yMMMd()
              .format(personalTrainerController.selectedDate)
              .toString(),
          "from_time": personalTrainerController.selectedSlot!.fromTime!,
          "to_time": personalTrainerController.selectedSlot!.toTime!,
          "order_id": orderId,
          "purchase_amount": totalPayment,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        EventsService()
            .sendEvent("Single_Therapist_Payment_Success", eventData);

        BranchService().trackCustomRevenue("Single_Therapist_Payment_Success",
            currency, totalPayment, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);

        break;
      case "CONSULTATION_PAYMENT":
        String eventName = "Consultation_Payment_Success";
        if (customData["consultationType"].toString().toUpperCase() ==
            "DOCTOR") {
          eventName = "Doctor_Payment_Success";
        } else if (customData["consultationType"].toString().toUpperCase() ==
            "THERAPIST") {
          eventName = "Therapist_Payment_Success";
        }
        Map<String, dynamic> eventData = {
          "consultation_type": customData["consultationType"].toString(),
          "user_id": globalUserIdDetails!.userId!,
          "package_name": customData["selectedConsultingPackage"]
              ["packageName"],
          "consult_type": customData["selectedConsultingPackage"]
              ["consultType"],
          "purchase_type": customData["selectedConsultingPackage"]
              ["purchaseType"],
          "consulting_charges": customData["selectedConsultingPackage"]
              ["consultingCharges"],
          "sessions": customData["selectedConsultingPackage"]["sessions"],
          "is_percentage": customData["selectedConsultingPackage"]
              ["isPercentage"],
          "discount": customData["selectedConsultingPackage"]["discount"],
          "purchase_amount": totalPayment,
          "recommended": customData["selectedConsultingPackage"]["recommended"],
          "consulting_package_id": customData["selectedConsultingPackage"]
              ["consultingPackageId"],
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };

        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        EventsService().sendEvent(eventName, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);
        break;
      case "PERSONAL_CARE_PAYMENT":
        String eventName = "PersonalCare_Payment_Success";
        Map<String, dynamic> eventData = {
          "user_type": customData["userType"],
          "user_id": globalUserIdDetails!.userId!,
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "subscription_type": customData["selectedPackage"]
              ["subscriptionType"],
          "subscription_charges": customData["selectedPackage"]
              ["subscriptionCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,

          "subscription_package_id": customData["selectedPackage"]
              ["subscriptionPackageId"],
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };

        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        EventsService().sendEvent(eventName, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);

        sendSubscriptionPeriodEvents(
            paymentType, orderId, currency, totalPayment, customData);
        break;
      case "RECOMMENDED_PROGRAM_PAYMENT":
        String eventName = "RecmdProgram_Payment_Success";
        Map<String, dynamic> eventData = {
          "user_type": customData["userType"],
          "user_id": globalUserIdDetails!.userId!,
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "subscription_type": customData["selectedPackage"]
              ["subscriptionType"],
          "subscription_charges": customData["selectedPackage"]
              ["subscriptionCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,

          "subscription_package_id": customData["selectedPackage"]
              ["subscriptionPackageId"],
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };

        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        EventsService().sendEvent(eventName, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);

        sendSubscriptionPeriodEvents(
            paymentType, orderId, currency, totalPayment, customData);
        break;
      case "NUTRITION_CONSULTATION":
        String eventName = "Nutrition_StartPlan_Payment_Success";
        if (customData["extendPlan"] == true) {
          eventName = "Nutrition_ExtendPlan_Payment_Success";
        }
        Map<String, dynamic> eventData = {
          "coach_id": customData["coachId"],
          "user_id": globalUserIdDetails!.userId!,
          "package_id": customData["selectedPackage"]["packageId"],
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "consulting_charges": customData["selectedPackage"]
              ["consultingCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        EventsService().sendEvent(eventName, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);
        break;
      case "MENTAL_WELLBEING":
        String eventName = "MentalWellBeing_StartPlan_Payment_Success";
        if (customData["extendPlan"] == true) {
          eventName = "MentalWellBeing_ExtendPlan_Payment_Success";
        }
        Map<String, dynamic> eventData = {
          "user_id": globalUserIdDetails!.userId!,
          "package_id": customData["selectedPackage"]["packageId"],
          "package_name": customData["selectedPackage"]["packageName"],
          "package_type": customData["selectedPackage"]["packageType"],
          "purchase_type": customData["selectedPackage"]["purchaseType"],
          "consulting_charges": customData["selectedPackage"]
              ["consultingCharges"],
          "is_percentage": customData["selectedPackage"]["isPercentage"],
          "discount": customData["selectedPackage"]["discount"],
          "purchase_amount": totalPayment,
          "order_id": orderId,
          // for firebase analytics start
          "currency": currency,
          "value": totalPayment,
          "transaction_id": orderId,
          "item_id": paymentType,
        };
        BranchService()
            .trackCustomRevenue(eventName, currency, totalPayment, eventData);
        EventsService().sendEvent(eventName, eventData);
        FirebaseAnalyticsService()
            .sendPurchaseEvent(orderId, paymentType, currency, totalPayment);
        break;
    }
  }

  sendSubscriptionPeriodEvents(String paymentType, String orderId,
      String currency, double totalPayment, dynamic customData) {
    String packageType = customData["selectedPackage"]["packageType"];
    String eventName = "";
    switch (packageType) {
      case "MONTHLY":
        eventName = "Subs_Month_Payment_Success";
        break;
      case "QUARTERLY":
        eventName = "Subs_Quarter_Payment_Success";
        break;
      case "HALF YEARLY":
        eventName = "Subs_HalfYear_Payment_Success";
        break;
      case "YEARLY":
        eventName = "Subs_Year_Payment_Success";
        break;
    }
    if (eventName.isNotEmpty) {
      Map<String, dynamic> eventData = {
        "user_id": globalUserIdDetails!.userId!,
        "package_name": customData["selectedPackage"]["packageName"],
        "package_type": customData["selectedPackage"]["packageType"],
        "purchase_type": customData["selectedPackage"]["purchaseType"],
        "subscription_type": customData["selectedPackage"]["subscriptionType"],
        "subscription_charges": customData["selectedPackage"]
            ["subscriptionCharges"],
        "is_percentage": customData["selectedPackage"]["isPercentage"],
        "discount": customData["selectedPackage"]["discount"],
        "purchase_amount": totalPayment,
        "subscription_package_id": customData["selectedPackage"]
            ["subscriptionPackageId"],
        "order_id": orderId,
        // for firebase analytics start
        "currency": currency,
        "value": totalPayment,
        "transaction_id": orderId,
        "item_id": paymentType,
      };
      EventsService().sendEvent(eventName, eventData);

      BranchService().sendSubscribeEvent(packageType, eventName, eventData);

      FacebookAppEvents().logSubscribe(
          price: totalPayment, currency: currency, orderId: orderId);
    }
  }

  Future<void> checkSpecialOfferAvailable(
      String source, String offerOn) async {}
}
