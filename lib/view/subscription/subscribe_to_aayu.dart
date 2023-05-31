import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/controller/home/home_top_section_controller.dart';
import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/programme_selection/program_selection.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/payment/payment_pop_ups/wigets/healing_payment_success.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/widgets/heres_what_you_get_subscription.dart';
import 'package:aayu/view/subscription/widgets/subscription_pricing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../services/payment.service.dart';

class SubscribeToAayu extends StatelessWidget {
  final String subscribeVia;
  final Content? content;
  final String? packageType;
  final String? promoCode;
  const SubscribeToAayu({
    Key? key,
    required this.subscribeVia,
    required this.content,
    this.packageType,
    this.promoCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionPackageController subscriptionPackageController = Get.find();
    String title = "Aayu\nPremium Subscription";

    subscriptionPackageController.getSubscriptionPackages(
      "SINGLE DISEASE",
      "SUBSCRIBE",
      packageType,
      promoCode,
      'SUBSCRIPTION',
    );
    subscriptionPackageController.getCommunicationAndTestimonialData();

    return WillPopScope(
      onWillPop: () async {
        String eventName = "Subs_Select_Back";
        if (subscribeVia == "CONTENT") {
          eventName = "Subs_Select_Grow_Back";
        } else if (subscribeVia == "HEALING") {
          eventName = "Subs_Select_Heal_Back";
        } else if (subscribeVia == "LIVE_EVENT") {
          eventName = "Subs_Select_Event_Back";
        } else if (subscribeVia == "RECOMMENDED_PROGRAM") {
          eventName = "Subs_Select_RecmdProgram_Back";
        }

        EventsService().sendEvent(eventName, {"subscribe_via": subscribeVia});
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5FC),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              Images.subscribeTaAayuBackgroundImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 56.h,
                    ),
                    SizedBox(
                      width: 322.w,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Baskerville',
                          fontSize: 24.sp,
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      '"Start your transformation journey"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                        height: 1.2.h,
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      'SELECT YOUR PLAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Circular Std',
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        height: 1.2.h,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const SubscriptionPricing(
                      offerOn: 'SUBSCRIPTION',
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    const HeresWhatYouGetSubscription(),
                    SizedBox(
                      height: 26.h,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 15,
              child: IconButton(
                  onPressed: () {
                    String eventName = "Sub_Select_Close";
                    if (subscribeVia == "CONTENT") {
                      eventName = "Sub_Select_Grow_Close";
                    } else if (subscribeVia == "HEALING") {
                      eventName = "Sub_Select_Heal_Close";
                    } else if (subscribeVia == "LIVE_EVENT") {
                      eventName = "Sub_Select_Event_Close";
                    } else if (subscribeVia == "RECOMMENDED_PROGRAM") {
                      eventName = "Subs_Select_RecmdProgram_Close";
                    }

                    EventsService()
                        .sendEvent(eventName, {"subscribe_via": subscribeVia});
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                    size: 25,
                  )),
            ),
          ],
        ),
        bottomNavigationBar:
            bottomNavigationBar(context, subscriptionPackageController),
      ),
    );
  }

  bottomNavigationBar(BuildContext context,
      SubscriptionPackageController subscriptionPackageController) {
    return GetBuilder<SubscriptionPackageController>(
        builder: (subscriptionPackageController) {
      if (subscriptionPackageController.isLoading.value == true) {
        return const Offstage();
      } else if (subscriptionPackageController.subscriptionPackageData.value ==
          null) {
        return const Offstage();
      } else if (subscriptionPackageController
              .subscriptionPackageData.value!.subscriptionPackages ==
          null) {
        return const Offstage();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 13.h,
          ),
          InkWell(
              onTap: () {
                SupcriptionPackagesModelSubscriptionPackages? selectedPackage =
                    subscriptionPackageController
                        .subscriptionPackageData.value!.subscriptionPackages!
                        .firstWhereOrNull(
                            (element) => element!.isSelected == true);

                if (selectedPackage != null) {
                  double totalPayment = selectedPackage.purchaseAmount! -
                      selectedPackage.offerAmount!;
                  if (selectedPackage.country == "IN") {
                    totalPayment = totalPayment.floorToDouble();
                  }

                  dynamic customData = {};
                  if (subscribeVia == "CONTENT") {
                    customData = {
                      "subscribeVia": subscribeVia,
                      "contentSelected": {
                        "contentId": content!.contentId,
                        "contentName": content!.contentName,
                        "contentType": content!.contentType,
                        "artistId": content!.artist!.artistId,
                        "artistName": content!.artist!.artistName,
                      },
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  } else if (subscribeVia == "HEALING") {
                    DiseaseDetailsController diseaseDetailsController =
                        Get.put(DiseaseDetailsController());
                    customData = {
                      "subscribeVia": subscribeVia,
                      "diseaseSelected": {
                        "diseaseId": diseaseDetailsController
                            .diseaseDetails.value!.details!.diseaseId!,
                        "disease": diseaseDetailsController
                            .diseaseDetails.value!.details!.disease!,
                      },
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  } else if (subscribeVia == "LIVE_EVENT") {
                    LiveEventsController liveEventsController = Get.find();
                    customData = {
                      "subscribeVia": subscribeVia,
                      "eventSelected": {
                        "liveEventId":
                            liveEventsController.selectedLiveEvent!.liveEventId,
                        "eventType":
                            liveEventsController.selectedLiveEvent!.eventType,
                        "eventTitle":
                            liveEventsController.selectedLiveEvent!.eventTitle,
                      },
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  } else if (subscribeVia == "RECOMMENDED_PROGRAM") {
                    String userType = "AAYU_NOT_SUBSCRIBED";
                    if (subscriptionCheckResponse != null &&
                        subscriptionCheckResponse!.subscriptionDetails !=
                            null) {
                      userType = "AAYU_SUBSCRIBED";
                      if (subscriptionCheckResponse!
                          .subscriptionDetails!.programId!.isNotEmpty) {
                        userType = "$userType|HEALING_ACCESSED";
                      } else {
                        userType = "$userType|HEALING_NOT_ACCESSED";
                      }
                    } else {
                      userType = "$userType|HEALING_NOT_ACCESSED";
                    }
                    customData = {
                      "subscribeVia": "RECOMMENDED_PROGRAM",
                      "userType": userType,
                      "multipleProgram": false,
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  } else {
                    customData = {
                      "subscribeVia": subscribeVia,
                      "selectedPackage": selectedPackage.toJson(),
                      "promoCodeDetails": {
                        "isApplied": subscriptionPackageController
                            .isPromoCodeApplied.value,
                        "promoCode": {
                          "promoCodeId": subscriptionPackageController
                              .appliedPromoCode?.promoCodeId,
                          "promoCode": subscriptionPackageController
                              .appliedPromoCode?.promoCode,
                          "promoCodeName": subscriptionPackageController
                              .appliedPromoCode?.promoCodeName,
                          "accessType": subscriptionPackageController
                              .appliedPromoCode?.accessType,
                          "appUserCouponId": subscriptionPackageController
                              .appliedPromoCode?.appUserCouponId,
                        },
                      }
                    };
                  }

                  EventsService().sendClickNextEvent(
                      "SubscribeToAayu", "Make Payment", "Payment");

                  String eventName = "Sub_Select";
                  if (subscribeVia == "CONTENT") {
                    eventName = "Sub_Select_Grow";
                  } else if (subscribeVia == "HEALING") {
                    eventName = "Sub_Select_Heal";
                  } else if (subscribeVia == "LIVE_EVENT") {
                    eventName = "Sub_Select_Event";
                  } else if (subscribeVia == "RECOMMENDED_PROGRAM") {
                    eventName = "Subs_Select_RecmdProgram";
                  }

                  EventsService().sendEvent(eventName, {
                    "subscribe_via": subscribeVia,
                    "package_name": selectedPackage.packageName,
                    "package_type": selectedPackage.packageType,
                    "purchase_type": selectedPackage.purchaseType,
                    "subscription_type": selectedPackage.subscriptionType,
                    "subscription_charges": selectedPackage.subscriptionCharges,
                    "is_percentage": selectedPackage.isPercentage,
                    "discount": selectedPackage.discount,
                    "purchase_amount": selectedPackage.purchaseAmount,
                    "currency": selectedPackage.currency!.billing ?? "",
                    "subscription_package_id":
                        selectedPackage.subscriptionPackageId,
                    "promo_code_applied":
                        subscriptionPackageController.isPromoCodeApplied.value,
                    "promo_code_id": subscriptionPackageController
                            .appliedPromoCode?.promoCodeId ??
                        "",
                    "promo_code": subscriptionPackageController
                            .appliedPromoCode?.promoCode ??
                        "",
                    "promo_code_name": subscriptionPackageController
                            .appliedPromoCode?.promoCodeName ??
                        "",
                  });

                  if (totalPayment == 0) {
                    freeSubscriptionToAaayu(
                        "FREE",
                        totalPayment,
                        selectedPackage.toJson(),
                        subscriptionPackageController);
                  } else {
                    if (subscribeVia == "RECOMMENDED_PROGRAM") {
                      Navigator.pop(context);
                      Get.to(JuspayPayment(
                        pageSource: "RECOMMENDED_PROGRAM",
                        totalPayment: totalPayment,
                        currency: selectedPackage.currency!.billing ?? "",
                        paymentEvent: "AAYU_SUBSCRIPTION",
                        customData: customData,
                      ));
                    } else {
                      Navigator.pop(context);
                      Get.to(JuspayPayment(
                        pageSource: "AAYU_SUBSCRIPTION",
                        totalPayment: totalPayment,
                        currency: selectedPackage.currency!.billing ?? "",
                        paymentEvent: "AAYU_SUBSCRIPTION",
                        customData: customData,
                      ));
                    }
                  }
                }
              },
              child: SizedBox(
                width: 320.w,
                child: mainButton("Pay Now"),
              )),
          SizedBox(
            height: 18.h,
          ),
          InkWell(
            onTap: () {
              launchCustomUrl("https://www.resettech.in/terms-of-use.html");
            },
            child: Text(
              'Terms and Conditions',
              style: TextStyle(
                color: const Color.fromRGBO(113, 113, 113, 1),
                fontSize: 14.sp,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 23.h,
          ),
        ],
      );
    });
  }

  freeSubscriptionToAaayu(
      String orderId,
      double totalPayment,
      dynamic selectedPackage,
      SubscriptionPackageController subscriptionPackageController) async {
    String eventName = "Subscription_Payment_Success";
    if (subscribeVia == "CONTENT") {
      eventName = "Subs_Payment_Grow_Success";
    } else if (subscribeVia == "HEALING") {
      eventName = "Subs_Payment_Heal_Success";
    } else if (subscribeVia == "LIVE_EVENT") {
      eventName = "Subs_Payment_Event_Success";
    } else if (subscribeVia == "RECOMMENDED_PROGRAM") {
      eventName = "Subs_Select_RecmdProgram_Success";
    }
    if (subscriptionPackageController.isPromoCodeApplied.value == true &&
        subscriptionPackageController.appliedPromoCode?.promoCodeId != null) {
      EventsService().sendEvent("Promo_Code_Transaction", {
        "pageSource": subscribeVia == "RECOMMENDED_PROGRAM"
            ? "RECOMMENDED_PROGRAM"
            : "AAYU_SUBSCRIPTION",
        "promo_code_id":
            subscriptionPackageController.appliedPromoCode?.promoCodeId ?? "",
        "promo_code":
            subscriptionPackageController.appliedPromoCode?.promoCode ?? "",
        "order_id": "FREE-PROMO-CODE",
        "currency": selectedPackage.currency!.billing ??
            ""
                "",
        "total_payment": 0
      });
      dynamic postPromoCodeData = {
        "promoCodeId":
            subscriptionPackageController.appliedPromoCode?.promoCodeId,
        "orderId": "FREE-PROMO-CODE"
      };
      await PaymentService().postPromoCodeTransaction(postPromoCodeData);
    }

    switch (subscribeVia) {
      case "CONTENT":
      case "HEALING":
      case "LIVE_EVENT":
      case "DEEPLINK":
      case "MY_SUBSCRIPTION":
        await startAayuSubscription(
            "FREE_SUBSCRIPTION", subscribeVia, selectedPackage);
        SubscriptionController subscriptionController =
            Get.put(SubscriptionController());

        await subscriptionController.getSubscriptionDetails();

        break;
      case "RECOMMENDED_PROGRAM":
        if (subscriptionCheckResponse != null &&
            subscriptionCheckResponse!.subscriptionDetails != null &&
            subscriptionCheckResponse!
                .subscriptionDetails!.subscriptionId!.isNotEmpty) {
        } else {
          await startAayuSubscription(
              "FREE_SUBSCRIPTION", subscribeVia, selectedPackage);
          ProgramRecommendationController programRecommendationController =
              Get.find();
          if (programRecommendationController
                  .recommendation.value!.recommendation!.programType ==
              "SINGLE DISEASE") {
            singleDiseaseProgramSelection();
          } else {
            multiDieaseProgramSelection();
          }
        }
        break;
    }

    Map<String, dynamic> eventData = {
      "subscribe_via": subscribeVia,
      "package_name": selectedPackage["packageName"],
      "package_type": selectedPackage["packageType"],
      "purchase_type": selectedPackage["purchaseType"],
      "subscription_type": selectedPackage["subscriptionType"],
      "subscription_charges": selectedPackage["subscriptionCharges"],
      "is_percentage": selectedPackage["isPercentage"],
      "discount": selectedPackage["discount"],
      "purchase_amount": selectedPackage["purchaseAmount"],
      "subscription_package_id": selectedPackage["subscriptionPackageId"],
      "order_id": orderId
    };
    EventsService().sendEvent(eventName, eventData);

    BranchService()
        .trackCustomRevenue(eventName, "INR", totalPayment, eventData);
  }

  Future<bool> startAayuSubscription(String paymentOrderId, String subscribeVia,
      dynamic selectedPackage) async {
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());
    buildShowDialog(Get.context!);
    bool isSubscribed = await subscriptionController.postAayuSubscription(
      paymentOrderId,
      subscribeVia,
      selectedPackage,
    );
    Get.back();
    if (isSubscribed == true) {
      HomeTopSectionController homeTopSectionController =
          Get.put(HomeTopSectionController());
      homeTopSectionController.getHomePageTopSectionContent();
      Get.back();
      switch (subscribeVia) {
        case "HEALING":
          Get.to(const HealingPaymentSuccess(
            isFreeSubscription: true,
          ));
          break;
        default:
          showGreenSnackBar(Get.context, 'Aayu Subscription Done!');
      }
    } else {
      showGetSnackBar(
          "FAILED_TO_UPDATE_SUBSCRIPTION".tr, SnackBarMessageTypes.Error);
    }
    return isSubscribed;
  }

  singleDiseaseProgramSelection() async {
    buildShowDialog(Get.context!);
    HealingListController healingListController = Get.find();
    ProgramRecommendationController programRecommendationController =
        Get.find();
    healingListController.setDiseaseFromDeepLink(programRecommendationController
            .recommendation.value!.recommendation!.disease![0]!.diseaseId ??
        "");
    DiseaseDetailsController diseaseDetailsController =
        Get.put(DiseaseDetailsController());
    diseaseDetailsController.setSelectedHealthProblem();
    PostAssessmentController postAssessmentController =
        Get.put(PostAssessmentController());
    bool isDataAvailable =
        await postAssessmentController.getProgramDurationDetails();
    Navigator.pop(Get.context!);
    if (isDataAvailable == true) {
      bool isSubscribed = false;
      bool isHealingSubscribed = false;
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        isSubscribed = true;
        if (subscriptionCheckResponse!
            .subscriptionDetails!.programId!.isNotEmpty) {
          isHealingSubscribed = true;
        }
      }

      if (isSubscribed == true && isHealingSubscribed == true) {
        Get.bottomSheet(
          const ProgramSelection(
            isRecommendedProgramSwitch: true,
            isProgramSwitch: true,
          ),
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: false,
        );
      } else if (isSubscribed == true && isHealingSubscribed == false) {
        Get.bottomSheet(
          const ProgramSelection(
            isRecommendedProgramSwitch: false,
            isProgramSwitch: false,
          ),
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: false,
        );
      }
    } else {
      showCustomSnackBar(Get.context!, "PERFERENCES_DETAILS_NOT_AVAILABLE".tr);
    }
  }

  multiDieaseProgramSelection() async {
    buildShowDialog(Get.context!);
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
    Navigator.pop(Get.context!);
    if (isDataAvailable == true) {
      Navigator.pop(Get.context!);
      Get.bottomSheet(
        const ProgramSelection(
            isProgramSwitch: true, isRecommendedProgramSwitch: true),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
      );
    } else {
      showSnackBar(Get.context!, "PERFERENCES_DETAILS_NOT_AVAILABLE".tr,
          SnackBarMessageTypes.Info);
    }
  }
}
