import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/payment/subscription_package_controller.dart';
import '../../../controller/subscription/subscription_controller.dart';
import '../../../model/model.dart';
import '../../payment/juspay_payment.dart';
import '../../subscription/widgets/subscription_pricing.dart';

class PersonalisedCareSwitchProgram extends StatelessWidget {
  const PersonalisedCareSwitchProgram({
    Key? key,
  }) : super(key: key);
  format(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("d'$suffix' MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionPackageController subscriptionPackageController =
        Get.put(SubscriptionPackageController());
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());

    subscriptionPackageController.getSubscriptionPackages(
        "PERSONAL CARE", "SUBSCRIBE");
    HealingListController healingListController = Get.find();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'Switch Program',
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackLabelColor,
                  ))
            ]),
        body: Obx(() {
          if (subscriptionController.isLoading.value == true) {
            return const Offstage();
          }
          return Stack(alignment: Alignment.bottomCenter, children: [
            SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 33.h,
                  ),
                  Text(
                    'Are you sure you want to switch from your ${subscriptionCheckResponse!.subscriptionDetails!.diseaseName} to Personalised Care Program?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: AppColors.blueGreyAssessmentColor),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFEAF0F2), width: 1)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Current Plan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.blueGreyAssessmentColor),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: const Color(0xFFEAF0F2),
                                          width: 1)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 63.h,
                                      ),
                                      Text(
                                        '${subscriptionController.subscriptionDetailsResponse.value!.subscriptionDetails!.disease![0]!.diseaseName ?? ""} Care Program',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.sp,
                                            color: AppColors
                                                .blueGreyAssessmentColor),
                                      ),
                                      SizedBox(
                                        height: 26.h,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 25.w,
                                          ),
                                          returnTitltSubtitleBoxes(
                                              'Plan Type',
                                              toTitleCase((subscriptionController
                                                          .subscriptionDetailsResponse
                                                          .value!
                                                          .subscriptionDetails!
                                                          .packageType ??
                                                      "")
                                                  .toLowerCase())),
                                          returnTitltSubtitleBoxes(
                                              'Duration',
                                              subscriptionController
                                                      .subscriptionDetailsResponse
                                                      .value!
                                                      .subscriptionDetails!
                                                      .duration ??
                                                  ""),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 25.w,
                                          ),
                                          returnTitltSubtitleBoxes(
                                            'Start Date',
                                            format(returnDate(
                                                subscriptionController
                                                    .subscriptionDetailsResponse
                                                    .value!
                                                    .subscriptionDetails!
                                                    .startDate!
                                                    .split(" ")[0])),
                                          ),
                                          returnTitltSubtitleBoxes(
                                              'End Date',
                                              format(returnDate(
                                                  subscriptionController
                                                          .subscriptionDetailsResponse
                                                          .value!
                                                          .subscriptionDetails!
                                                          .expiryDate ??
                                                      ""))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 27.h,
                                      )
                                    ],
                                  )),
                              Positioned(
                                top: -5.h,
                                child: ShowNetworkImage(
                                  imgPath: healingListController
                                      .getImageFromDiseaseId(
                                          subscriptionController
                                                  .subscriptionDetailsResponse
                                                  .value!
                                                  .subscriptionDetails!
                                                  .disease![0]!
                                                  .diseaseId ??
                                              ""),
                                  imgHeight: 53.h,
                                  boxFit: BoxFit.fitHeight,
                                ),
                              ),
                              Positioned(
                                bottom: -30,
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Image.asset(
                                    Images.switchProgramArrowImage,
                                    width: 40,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                            ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 61.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFEAF0F2), width: 1)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'New Plan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.blueGreyAssessmentColor),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFC),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: const Color(0xFFEAF0F2),
                                          width: 1)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 63.h,
                                      ),
                                      Text(
                                        'Personalised Care Program',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.sp,
                                            color: AppColors
                                                .blueGreyAssessmentColor),
                                      ),
                                      SizedBox(
                                        height: 32.h,
                                      ),
                                      Text(
                                        'Choose Plan',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.sp,
                                            color: AppColors
                                                .blueGreyAssessmentColor),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      const SubscriptionPricing(
                                        offerOn: 'PERSONAL CARE',
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                    ],
                                  )),
                              Positioned(
                                  top: -15.h,
                                  child: Image.asset(
                                    Images.personalisedCareLogo,
                                    height: 53.h,
                                    fit: BoxFit.fitHeight,
                                  )),
                            ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                ],
              ),
            )),
            InkWell(
              onTap: () {
                SupcriptionPackagesModelSubscriptionPackages? selectedPackage =
                    subscriptionPackageController
                        .subscriptionPackageData.value!.subscriptionPackages!
                        .firstWhereOrNull(
                            (element) => element!.isSelected == true);
                if (selectedPackage != null) {
                  ProgramRecommendationController
                      programRecommendationController = Get.find();
                  List<String> diseaseList = programRecommendationController
                      .recommendation.value!.recommendation!.disease!
                      .map((element) => element!.diseaseId!)
                      .toList();
                  healingListController
                      .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);
                  double totalPayment = selectedPackage.purchaseAmount! -
                      selectedPackage.offerAmount!;
                  if (selectedPackage.country == "IN") {
                    totalPayment = totalPayment.floorToDouble();
                  }

                  dynamic customData = {
                    "subscribeVia": "RECOMMENDED_PROGRAM",
                    "userType": "AAYU_SUBSCRIBED|HEALING_ACCESSED",
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
                  Get.to(JuspayPayment(
                    pageSource: "RECOMMENDED_PROGRAM",
                    totalPayment: totalPayment,
                    currency: selectedPackage.currency!.billing ?? "",
                    paymentEvent: "AAYU_SUBSCRIPTION",
                    customData: customData,
                  ));
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 54.h,
                margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 25.h),
                decoration: AppTheme.mainButtonDecoration,
                child: Text(
                  'Switch',
                  textAlign: TextAlign.center,
                  style: mainButtonTextStyle(),
                ),
              ),
            )
          ]);
        }));
  }

  returnTitltSubtitleBoxes(String title, String subtitle) {
    return Expanded(
        child: Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
                color: AppColors.blueGreyAssessmentColor),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: AppColors.blueGreyAssessmentColor),
          ),
        ],
      ),
    ));
  }
}
