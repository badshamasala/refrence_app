// ignore_for_file: use_build_context_synchronously

import 'package:aayu/model/subscription/personalised.care.subscription.model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/icons.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/view/subscription/widgets/subscription_pricing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/payment/subscription_package_controller.dart';
import '../../data/personalised_care_subscription_data.dart';
import '../../model/payment/subscription.packages.model.dart';
import '../../services/third-party/events.service.dart';
import '../payment/juspay_payment.dart';
import '../shared/constants.dart';
import '../shared/ui_helper/images.dart';

class PersonalisedCareSubscription extends StatelessWidget {
  final String subscribeVia;
  final bool isProgramRecommended;
  const PersonalisedCareSubscription(
      {Key? key,
      required this.subscribeVia,
      required this.isProgramRecommended})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersonalisedCareSubscriptionModel personalisedCareSubscriptionModel =
        getData();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(alignment: Alignment.topCenter, children: [
        Image.asset(
          Images.personalisedCareSubscriptionBackgroundImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 55.h,
              ),
              Image.asset(
                Images.personalisedCareSubscriptionIconsImage,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 23.h,
              ),
              Text(
                personalisedCareSubscriptionModel.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Baskerville',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                width: 285.w,
                child: Text(
                  personalisedCareSubscriptionModel.subtitle ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 26.w),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(235, 235, 235, 0.4),
                        offset: Offset(4, 2),
                        blurRadius: 16,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.25),
                        offset: Offset(-4, -2),
                        blurRadius: 16,
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    whatYouGetSection(personalisedCareSubscriptionModel),
                    SizedBox(
                      height: 50.h,
                    ),
                    youAlsoGetSection(personalisedCareSubscriptionModel),
                  ],
                ),
              ),
              SizedBox(
                height: 100.h,
              )
            ],
          ),
        ),
        Positioned(
            top: 30.h,
            right: 20.w,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.blackLabelColor,
              ),
            )),
        Positioned(
            bottom: 25.h,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: InkWell(
                  onTap: () async {
                    bool isAllowed =
                        await checkIsPaymentAllowed("PERSONAL_CARE");
                    if (isAllowed == true) {
                      buildShowDialog(context);
                      SubscriptionPackageController
                          subscriptionPackageController = Get.find();
                      await subscriptionPackageController
                          .getSubscriptionPackages(
                              "PERSONAL CARE", "SUBSCRIBE");
                      Navigator.pop(context);
                      Get.bottomSheet(
                        PersonalisedCareSubscriptionBottomSheet(
                          subscribeVia: subscribeVia,
                          subscriptionPackageController:
                              subscriptionPackageController,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        isScrollControlled: true,
                      );
                    }
                  },
                  child: mainButton("Select Plan")),
            )),
      ]),
    );
  }

  getData() {
    bool isSubscribed = false;
    bool isHealingSubscribed = false;
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null) {
      isSubscribed = true;
      if (subscriptionCheckResponse!.subscriptionDetails!.programId != null &&
          subscriptionCheckResponse!
              .subscriptionDetails!.programId!.isNotEmpty) {
        isHealingSubscribed = true;
      }
    }

    if (isProgramRecommended == true) {
      if (isSubscribed == true && isHealingSubscribed == true) {
        PersonalisedCareSubscriptionModel temp =
            PersonalisedCareSubscriptionModel.fromJson(
                aayuSubscribedHealingAccessedSwitch);
        temp.subtitle = temp.subtitle!.replaceAll('[PROGRAM_NAME]',
            '${subscriptionCheckResponse!.subscriptionDetails!.diseaseName ?? ""} Care Program');
        print('=====================PRINT SUBTTILE=====================');
        print(temp.subtitle);
        return temp;
      }
      return PersonalisedCareSubscriptionModel.fromJson(programRecommendedData);
    } else {
      if (isSubscribed == true && isHealingSubscribed == false) {
        return PersonalisedCareSubscriptionModel.fromJson(
            aayuSubscribedHealingNotAccessed);
      } else if (isSubscribed == true && isHealingSubscribed == true) {
        return PersonalisedCareSubscriptionModel.fromJson(
            aayuSubscribedHealingAccessed);
      }

      return PersonalisedCareSubscriptionModel.fromJson(
          aayuNotSubscribedHealingNotAccessed);
    }
  }

  Widget buildWhatYouGetRow(String image, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 25.w, right: 25.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            image,
            width: 40.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
              child: Text(
            text,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ))
        ],
      ),
    );
  }

  Widget buildtAlsoGetRow(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 25.w, right: 25.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppIcons.circleTickSVG,
            width: 21.w,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            width: 10.5.w,
          ),
          Expanded(
              child: Text(
            text,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ))
        ],
      ),
    );
  }

  Widget whatYouGetSection(
      PersonalisedCareSubscriptionModel personalisedCareSubscriptionModel) {
    if (personalisedCareSubscriptionModel.whatYouGetList == null ||
        personalisedCareSubscriptionModel.whatYouGetList!.isEmpty) {
      return const Offstage();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 25.w,
            ),
            Text(
              "Here’s what you get".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFFF7979),
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        ...personalisedCareSubscriptionModel.whatYouGetList!
            .map((e) => buildWhatYouGetRow(e!.image ?? "", e.text ?? ""))
            .toList()
      ],
    );
  }

  Widget youAlsoGetSection(
      PersonalisedCareSubscriptionModel personalisedCareSubscriptionModel) {
    if (personalisedCareSubscriptionModel.youAlsoGetList == null ||
        personalisedCareSubscriptionModel.youAlsoGetList!.isEmpty) {
      return const Offstage();
    }
    return Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFF5D8D8).withOpacity(0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 23.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                    ),
                    Text(
                      "You also get".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFFF7979),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                    ),
                    Text(
                      "Aayu Subscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF496074),
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
                ...personalisedCareSubscriptionModel.youAlsoGetList!
                    .map((e) => buildtAlsoGetRow(e ?? ""))
                    .toList(),
                SizedBox(
                  height: 50.h,
                )
              ],
            ),
          ),
          Positioned(
            top: -13.h,
            right: 39.w,
            child: Image.asset(
              Images.growLotusMedia,
              height: 76.h,
              fit: BoxFit.fitHeight,
            ),
          )
        ]);
  }
}

class PersonalisedCareSubscriptionBottomSheet extends StatelessWidget {
  final String subscribeVia;
  final SubscriptionPackageController subscriptionPackageController;
  const PersonalisedCareSubscriptionBottomSheet(
      {Key? key,
      required this.subscribeVia,
      required this.subscriptionPackageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEAEDF2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 25.h,
          ),
          AppBar(
            shadowColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            iconTheme:
                const IconThemeData(color: AppColors.blueGreyAssessmentColor),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SELECT YOUR PLAN',
                  style: TextStyle(
                      color: const Color(0xFFFF7979),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  height: 3.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                      color: const Color(0xFFB7C0CB),
                      borderRadius: BorderRadius.circular(2.h)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 7.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Your program requires long term commitment to help you see the desired healing outcomes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color.fromRGBO(91, 112, 129, 0.7),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          const SubscriptionPricing(
            offerOn: 'PERSONAL CARE',
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: InkWell(
                onTap: () {
                  SupcriptionPackagesModelSubscriptionPackages?
                      selectedPackage = subscriptionPackageController
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
                    String userType = "AAYU_NOT_SUBSCRIBED";
                    String eventName = "Sub_Select_PersonalCare";
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

                    EventsService().sendClickNextEvent(
                        "PersonalCare", "Make Payment", "Payment");
                    EventsService().sendEvent(eventName, {
                      "subscribe_via": subscribeVia,
                      "user_type": userType,
                      "package_name": selectedPackage.packageName,
                      "package_type": selectedPackage.packageType,
                      "purchase_type": selectedPackage.purchaseType,
                      "subscription_type": selectedPackage.subscriptionType,
                      "subscription_charges":
                          selectedPackage.subscriptionCharges,
                      "is_percentage": selectedPackage.isPercentage,
                      "discount": selectedPackage.discount,
                      "purchase_amount": selectedPackage.purchaseAmount,
                      "currency": selectedPackage.currency!.billing ?? "",
                      "subscription_package_id":
                          selectedPackage.subscriptionPackageId,
                      "promo_code_applied": subscriptionPackageController
                          .isPromoCodeApplied.value,
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

                    switch (subscribeVia) {
                      case "PERSONAL_CARE_CARD":
                        customData = {
                          "subscribeVia": "PERSONAL_CARE",
                          "userType": userType,
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
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Get.to(JuspayPayment(
                          pageSource: "PERSONAL_CARE",
                          totalPayment: totalPayment,
                          currency: selectedPackage.currency!.billing ?? "",
                          paymentEvent: "AAYU_SUBSCRIPTION",
                          customData: customData,
                        ));
                        break;
                      case "RECOMMENDED_PROGRAM":
                        customData = {
                          "subscribeVia": "RECOMMENDED_PROGRAM",
                          "userType": userType,
                          "multipleProgram": true,
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
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Get.to(JuspayPayment(
                          pageSource: "RECOMMENDED_PROGRAM",
                          totalPayment: totalPayment,
                          currency: selectedPackage.currency!.billing ?? "",
                          paymentEvent: "AAYU_SUBSCRIPTION",
                          customData: customData,
                        ));
                        break;
                    }
                  }
                },
                child: mainButton("Pay Now")),
          ),
          SizedBox(
            height: 25.h,
          ),
        ],
      ),
    );
  }
}
