import 'dart:async';

import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../controller/consultant/program_recommendation_controller.dart';
import '../../../controller/healing/disease_details_controller.dart';
import '../../../controller/healing/healing_list_controller.dart';
import '../../../controller/healing/post_assessment_controller.dart';
import '../../../controller/home/home_top_section_controller.dart';
import '../../../controller/payment/subscription_package_controller.dart';
import '../../../controller/subscription/subscription_controller.dart';
import '../../../model/model.dart';
import '../../../services/payment.service.dart';
import '../../../services/services.dart';
import '../../healing/programme_selection/program_selection.dart';
import '../../payment/juspay_payment.dart';
import '../../payment/payment_pop_ups/renewal_payment_success.dart';
import '../../payment/payment_pop_ups/wigets/healing_payment_success.dart';
import '../../shared/shared.dart';
import '../widgets/subscription_pricing.dart';

class SpecialDiscount extends StatefulWidget {
  final String pageSource;
  final int time;
  final double percent;
  final SpecialOfferModel specialOfferModel;
  final dynamic customData;

  final String country;
  const SpecialDiscount(
      {Key? key,
      required this.time,
      required this.percent,
      required this.customData,
      required this.specialOfferModel,
      required this.country,
      required this.pageSource})
      : super(key: key);

  @override
  State<SpecialDiscount> createState() => _SpecialDiscountState();
}

class _SpecialDiscountState extends State<SpecialDiscount> {
  late SubscriptionPackageController subscriptionPackageController;
  Timer? timer;
  int time = 0;
  bool expired = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscriptionPackageController = Get.find();
    time = widget.time;
    timer = Timer.periodic(const Duration(seconds: 1), (ti) {
      setState(() {
        time--;
        if (time == 0) {
          expired = true;
          SubscriptionPackageController subscriptionPackageController =
              Get.find();
          subscriptionPackageController.removeCoupon();
          if (timer != null) {
            timer!.cancel();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
            ),
            Container(
              height: 165.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
              margin: EdgeInsets.symmetric(horizontal: 27.w),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          'assets/images/subscription/offer-tile-green.png'))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.specialOfferModel.offerDetails?.title ??
                                  "",
                              style: TextStyle(
                                  color: AppColors.blackLabelColor,
                                  fontFamily: 'Baskerville',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              widget.specialOfferModel.offerDetails?.desc ?? "",
                              style: TextStyle(
                                  color: const Color(0xFF768897),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Text(
                            '${widget.percent.toInt()}%',
                            style: TextStyle(
                                color: const Color(0xFF496074),
                                fontWeight: FontWeight.w700,
                                fontSize: 60.sp,
                                shadows: [
                                  Shadow(
                                      color: Colors.white,
                                      offset: Offset(0, 4.h),
                                      blurRadius: 2)
                                ]),
                          ),
                          Positioned(
                            bottom: -22,
                            child: Text(
                              'OFF',
                              style: TextStyle(
                                  color: const Color(0xFF496074),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30.sp,
                                  shadows: [
                                    Shadow(
                                        color: Colors.white,
                                        offset: Offset(0, 4.h),
                                        blurRadius: 2)
                                  ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Get it before it\'s gone',
                        style: TextStyle(
                            color: const Color(0xFF768897),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            '${time}s',
                            style: TextStyle(
                                color: time <= 10
                                    ? AppColors.errorColor
                                    : AppColors.blueGreyAssessmentColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          Positioned(
                            left: -35,
                            child: LottieBuilder.asset(
                              'assets/animations/timer-lottie.json',
                              height: 40.h,
                              fit: BoxFit.fill,
                              animate: !expired,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            const SubscriptionPricing(
              offerOn: 'SUBSCRIPTION',
              showApplyPromocode: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: returnBottomNaviationBar(),
    );
  }

  Widget? returnBottomNaviationBar() {
    switch (widget.pageSource) {
      case "AAYU_SUBSCRIPTION":
        return bottomNavigationBarsubscription(
            context, subscriptionPackageController);
      case "AAYU_RENEWAL":
        return bottomNavigationBarRenewal(
            context, subscriptionPackageController);
      case "UPGRADE_SUBSCRIPTION":
        return bottomNavigationBarUpgrade(
            context, subscriptionPackageController);

      default:
        return null;
    }
  }

  bottomNavigationBarsubscription(BuildContext context,
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

                  dynamic customData = widget.customData;
                  customData["promoCodeDetails"] = null;
                  customData["selectedPackage"] = selectedPackage.toJson();
                  customData["specialOffer"] = {
                    "referencePackageId": selectedPackage.subscriptionPackageId,
                    "specialOfferId":
                        widget.specialOfferModel.offerDetails?.specialOfferId,
                    "source": widget.specialOfferModel.offerDetails?.source,
                    "offerOn": widget.specialOfferModel.offerDetails?.offerOn,
                    "country": widget.country,
                    "discount": widget.percent
                  };

                  EventsService().sendClickNextEvent(
                      "SpecialDiscount", "Make Payment", "Payment");

                  String eventName = "Sub_Select";
                  if (customData["subscribeVia"] == "CONTENT") {
                    eventName = "Sub_Select_Grow";
                  } else if (customData["subscribeVia"] == "HEALING") {
                    eventName = "Sub_Select_Heal";
                  } else if (customData["subscribeVia"] == "LIVE_EVENT") {
                    eventName = "Sub_Select_Event";
                  } else if (customData["subscribeVia"] ==
                      "RECOMMENDED_PROGRAM") {
                    eventName = "Subs_Select_RecmdProgram";
                  }

                  EventsService().sendEvent(eventName, {
                    "subscribe_via": customData["subscribeVia"],
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
                    "special_offer_id":
                        widget.specialOfferModel.offerDetails?.specialOfferId,
                    "special_offer_source":
                        widget.specialOfferModel.offerDetails?.source,
                    "special_offer_offerOn":
                        widget.specialOfferModel.offerDetails?.offerOn,
                    "special_offer_country": widget.country,
                    "special_offer_discount": widget.percent
                  });

                  if (totalPayment == 0) {
                    freeSubscriptionToAaayu(
                        customData,
                        "FREE",
                        totalPayment,
                        selectedPackage.toJson(),
                        subscriptionPackageController);
                  } else {
                    if (customData["subscribeVia"] == "RECOMMENDED_PROGRAM") {
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
      dynamic customData,
      String orderId,
      double totalPayment,
      dynamic selectedPackage,
      SubscriptionPackageController subscriptionPackageController) async {
    String eventName = "Subscription_Payment_Success";
    if (customData["subscribeVia"] == "CONTENT") {
      eventName = "Subs_Payment_Grow_Success";
    } else if (customData["subscribeVia"] == "HEALING") {
      eventName = "Subs_Payment_Heal_Success";
    } else if (customData["subscribeVia"] == "LIVE_EVENT") {
      eventName = "Subs_Payment_Event_Success";
    } else if (customData["subscribeVia"] == "RECOMMENDED_PROGRAM") {
      eventName = "Subs_Select_RecmdProgram_Success";
    }

    switch (customData["subscribeVia"]) {
      case "CONTENT":
      case "HEALING":
      case "LIVE_EVENT":
      case "DEEPLINK":
      case "MY_SUBSCRIPTION":
        await startAayuSubscription(
            "FREE_SUBSCRIPTION", customData["subscribeVia"], selectedPackage);
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
              "FREE_SUBSCRIPTION", customData["subscribeVia"], selectedPackage);
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
      "subscribe_via": customData["subscribeVia"],
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

  bottomNavigationBarUpgrade(
    BuildContext context,
    SubscriptionPackageController subscriptionPackageController,
  ) {
    return InkWell(
      onTap: () {
        SupcriptionPackagesModelSubscriptionPackages? selectedPackage =
            subscriptionPackageController
                .subscriptionPackageData.value!.subscriptionPackages!
                .firstWhereOrNull((element) => element!.isSelected == true);

        if (selectedPackage != null) {
          double totalPayment =
              selectedPackage.purchaseAmount! - selectedPackage.offerAmount!;
          if (selectedPackage.country == "IN") {
            totalPayment = totalPayment.floorToDouble();
          }
          dynamic customData = widget.customData;
          customData["promoCodeDetails"] = null;
          customData["selectedPackage"] = selectedPackage.toJson();
          customData["specialOffer"] = {
            "referencePackageId": selectedPackage.subscriptionPackageId,
            "specialOfferId":
                widget.specialOfferModel.offerDetails?.specialOfferId,
            "source": widget.specialOfferModel.offerDetails?.source,
            "offerOn": widget.specialOfferModel.offerDetails?.offerOn,
            "country": widget.country,
            "discount": widget.percent
          };
          String eventName = "Sub_Select";
          if (customData["subscribeVia"] == "MY_SUBSCRIPTION") {
            eventName = "Sub_Sel_Upgd_Subscription";
          } else if (customData["subscribeVia"] == "PROMOTION") {
            eventName = "Sub_Sel_Upgd_Promotion";
          }

          EventsService().sendEvent(eventName, {
            "subscribe_via": customData["subscribeVia"],
            "package_name": selectedPackage.packageName,
            "package_type": selectedPackage.packageType,
            "purchase_type": selectedPackage.purchaseType,
            "subscription_type": selectedPackage.subscriptionType,
            "subscription_charges": selectedPackage.subscriptionCharges,
            "is_percentage": selectedPackage.isPercentage,
            "discount": selectedPackage.discount,
            "purchase_amount": selectedPackage.purchaseAmount,
            "currency": selectedPackage.currency!.billing ?? "",
            "subscription_package_id": selectedPackage.subscriptionPackageId,
            "promo_code_applied":
                subscriptionPackageController.isPromoCodeApplied.value,
            "promo_code_id":
                subscriptionPackageController.appliedPromoCode?.promoCodeId ??
                    "",
            "promo_code":
                subscriptionPackageController.appliedPromoCode?.promoCode ?? "",
            "promo_code_name":
                subscriptionPackageController.appliedPromoCode?.promoCodeName ??
                    "",
          });

          if (totalPayment == 0) {
            Navigator.pop(context);
            freeUpgradeSubscription(subscriptionPackageController, customData);
          } else {
            EventsService().sendClickNextEvent(
                "SpecialDiscount", "Make Payment", "Payment");

            Navigator.pop(context);
            Get.to(JuspayPayment(
              pageSource: "UPGRADE_SUBSCRIPTION",
              totalPayment: totalPayment,
              currency: selectedPackage.currency!.billing ?? "",
              paymentEvent: "UPGRADE_SUBSCRIPTION",
              customData: customData,
            ));
          }
        }
      },
      child: SizedBox(
        width: 320.w,
        child: mainButton("Pay Now"),
      ),
    );
  }

  bottomNavigationBarRenewal(
    BuildContext context,
    SubscriptionPackageController subscriptionPackageController,
  ) {
    SubscriptionController subscriptionController = Get.find();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            SupcriptionPackagesModelSubscriptionPackages? selectedPackage =
                subscriptionPackageController
                    .subscriptionPackageData.value!.subscriptionPackages!
                    .firstWhereOrNull((element) => element!.isSelected == true);

            if (selectedPackage != null) {
              double totalPayment = selectedPackage.purchaseAmount! -
                  selectedPackage.offerAmount!;
              if (selectedPackage.country == "IN") {
                totalPayment = totalPayment.floorToDouble();
              }
              dynamic customData = widget.customData;
              customData["promoCodeDetails"] = null;
              customData["selectedPackage"] = selectedPackage.toJson();
              customData["specialOffer"] = {
                "referencePackageId": selectedPackage.subscriptionPackageId,
                "specialOfferId":
                    widget.specialOfferModel.offerDetails?.specialOfferId,
                "source": widget.specialOfferModel.offerDetails?.source,
                "offerOn": widget.specialOfferModel.offerDetails?.offerOn,
                "country": widget.country,
                "discount": widget.percent
              };

              EventsService().sendEvent("Renewal_Option_Selected", {
                "renewal_via": customData["renewalVia"],
                "package_name": selectedPackage.packageName,
                "package_type": selectedPackage.packageType,
                "purchase_type": selectedPackage.purchaseType,
                "subscription_type": selectedPackage.subscriptionType,
                "renewal_charges": selectedPackage.subscriptionCharges,
                "is_percentage": selectedPackage.isPercentage,
                "discount": selectedPackage.discount,
                "purchase_amount": selectedPackage.purchaseAmount,
                "currency": selectedPackage.currency!.billing ?? "",
                "subscription_package_id":
                    selectedPackage.subscriptionPackageId,
                "subscription_id":
                    (customData["renewalVia"] == "PREVIOUS_SUBSCRIPTION")
                        ? subscriptionController.previousSubscriptionDetails
                            .value!.subscriptionDetails!.subscriptionId
                        : subscriptionCheckResponse!
                            .subscriptionDetails!.subscriptionId!,
                "promo_code_applied":
                    subscriptionPackageController.isPromoCodeApplied.value,
                "promo_code_id": subscriptionPackageController
                        .appliedPromoCode?.promoCodeId ??
                    "",
                "promo_code":
                    subscriptionPackageController.appliedPromoCode?.promoCode ??
                        "",
                "promo_code_name": subscriptionPackageController
                        .appliedPromoCode?.promoCodeName ??
                    "",
              });
              if (totalPayment == 0) {
                Navigator.pop(context);
                freeRenewal(subscriptionPackageController, customData);
              } else {
                EventsService().sendClickNextEvent(
                    "SpecialDiscount", "Make Payment", "Payment");

                Navigator.pop(context);

                Get.to(JuspayPayment(
                  pageSource: "AAYU_RENEWAL",
                  totalPayment: totalPayment,
                  currency: selectedPackage.currency!.billing ?? "",
                  paymentEvent: "AAYU_RENEWAL",
                  customData: customData,
                ));
              }
            }
          },
          child: SizedBox(
            width: 320.w,
            child: mainButton("Pay Now"),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        InkWell(
          onTap: () {
            launchCustomUrl("https://www.resettech.in/terms-of-use.html");
          },
          child: Text(
            'Terms and Privacy',
            style: TextStyle(
              color: const Color(0xFF717171),
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }

  Future<void> freeRenewal(
      SubscriptionPackageController subscriptionPackageController,
      dynamic customData) async {
    if (subscriptionPackageController.isPromoCodeApplied.value == true &&
        subscriptionPackageController.appliedPromoCode?.promoCodeId != null) {
      EventsService().sendEvent("Promo_Code_Transaction", {
        "pageSource": "AAYU_RENEWAL",
        "promo_code_id":
            subscriptionPackageController.appliedPromoCode?.promoCodeId ?? "",
        "promo_code":
            subscriptionPackageController.appliedPromoCode?.promoCode ?? "",
        "order_id": "FREE-PROMO-CODE",
        "currency": customData["selectedPackage"]["currency"],
        "total_payment": 0
      });
      dynamic postPromoCodeData = {
        "promoCodeId":
            subscriptionPackageController.appliedPromoCode?.promoCodeId,
        "orderId": "FREE-PROMO-CODE"
      };
      await PaymentService().postPromoCodeTransaction(postPromoCodeData);
      await startAayuRenewal("FREE_SUBSCRIPTION", customData);

      Get.bottomSheet(
        RenewalPaymentSuccess(
          customData: customData,
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );
    }
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

  Future<void> freeUpgradeSubscription(
      SubscriptionPackageController subscriptionPackageController,
      dynamic customData) async {
    await startAayuUpgradePlan("FREE_SUBSCRIPTION", customData).then((value) {
      if (value) {
        showGreenSnackBar(Get.context,
            'Great decision! Your program is successfully upgraded.');
      }
    });
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
}
