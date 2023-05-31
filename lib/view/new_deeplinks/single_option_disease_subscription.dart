import 'package:aayu/controller/payment/subscription_package_controller.dart';
import 'package:aayu/data/single_option_disease-subscription_data.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/healing/disease_details_controller.dart';
import '../../model/payment/subscription.packages.model.dart';
import '../../model/subscription/personalised.care.subscription.model.dart';
import '../../theme/theme.dart';
import '../payment/juspay_payment.dart';

class SingleOptionDiseaseSubscription extends StatelessWidget {
  final String packageType;
  const SingleOptionDiseaseSubscription({Key? key, required this.packageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DiseaseDetailsController diseaseDetailsController = Get.find();
    SubscriptionPackageController subscriptionPackageController = Get.find();
    int index = subscriptionPackageController
        .subscriptionPackageData.value!.subscriptionPackages!
        .indexWhere((element) =>
            element!.packageType!.toUpperCase() == packageType.toUpperCase());
    if (index == -1) {
      index = subscriptionPackageController
              .subscriptionPackageData.value!.subscriptionPackages!.length -
          1;
    }
    subscriptionPackageController.setSelection(index);
    String displaySubscriptionPlan = '';
    String bottomText = '';
    switch (subscriptionPackageController.subscriptionPackageData.value!
        .subscriptionPackages![index]!.packageType!
        .toUpperCase()) {
      case "MONTHLY":
        displaySubscriptionPlan = '1-Month Subscription Plan';
        bottomText =
            "Give the ${diseaseDetailsController.diseaseDetails.value!.details!.silverAppBar!.title} Program a try with a 1-month subscription plan.\n\nWhen you see a visible difference in your health, commit to a longer program.";

        break;
      case "HALF YEARLY":
        displaySubscriptionPlan = '6-Month Subscription Plan';
        bottomText =
            "To keep up the improvements you see in your health conditions, subscribe to a 6-month ${diseaseDetailsController.diseaseDetails.value!.details!.silverAppBar!.title} Program.";

        break;
      case "YEARLY":
        displaySubscriptionPlan = 'Annual Subscription Plan';
        bottomText =
            "To see the best healing results, commit to a year-long subscription of the ${diseaseDetailsController.diseaseDetails.value!.details!.silverAppBar!.title} Program.";

        break;
      case "QUARTERLY":
        displaySubscriptionPlan = '3-Month Subscription Plan';
        bottomText =
            "To keep up the improvements you see in your health conditions, subscribe to a 3-month ${diseaseDetailsController.diseaseDetails.value!.details!.silverAppBar!.title} Program.";

        break;

      default:
    }

    PersonalisedCareSubscriptionModel personalisedCareSubscriptionModel =
        PersonalisedCareSubscriptionModel.fromJson(
            singleOptionDisesaeSubscriptionData);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FC),
      body: Stack(alignment: Alignment.topCenter, children: [
        Image.asset(
          Images.personalisedCareSubscriptionBackgroundImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 27.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ShowNetworkImage(
                            imgPath: diseaseDetailsController
                                    .diseaseDetails
                                    .value!
                                    .details!
                                    .silverAppBar!
                                    .backgroundImage ??
                                "",
                            boxFit: BoxFit.fitWidth,
                            imgWidth: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: -45.h,
                          child: CircleAvatar(
                            radius: 40.5,
                            backgroundColor: const Color(0xFFF1F5FC),
                            child: Padding(
                              padding: EdgeInsets.all(15.w),
                              child: ShowNetworkImage(
                                imgPath: diseaseDetailsController
                                        .diseaseDetails
                                        .value!
                                        .details!
                                        .silverAppBar!
                                        .image!
                                        .imageUrl ??
                                    "",
                                boxFit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  diseaseDetailsController
                          .diseaseDetails.value!.details!.silverAppBar!.title ??
                      "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baskerville',
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  diseaseDetailsController
                          .diseaseDetails.value!.details!.description ??
                      "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                Container(
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
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.w, vertical: 29.h),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(252, 175, 175, 0.2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              displaySubscriptionPlan,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFF7979),
                                  fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${subscriptionPackageController.subscriptionPackageData.value!.subscriptionPackages![index]!.currency!.display}${getFormattedNumber(subscriptionPackageController.subscriptionPackageData.value!.subscriptionPackages![index]!.subscriptionCharges!)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.blueGreyAssessmentColor,
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: 'Circular Std',
                                    fontSize: 16.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.h,
                                ),
                                Text(
                                  subscriptionPackageController
                                              .subscriptionPackageData
                                              .value!
                                              .subscriptionPackages![index]!
                                              .purchaseAmount! >
                                          0
                                      ? "${subscriptionPackageController.subscriptionPackageData.value!.subscriptionPackages![index]!.currency!.display}${getFormattedNumber(subscriptionPackageController.subscriptionPackageData.value!.subscriptionPackages![index]!.purchaseAmount!)}"
                                      : "FREE".tr,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.blueGreyAssessmentColor,
                                    fontFamily: 'Circular Std',
                                    fontSize: 32.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    height: 1.h,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            InkWell(
                              onTap: () {
                                handleSubscription(
                                    context,
                                    diseaseDetailsController,
                                    subscriptionPackageController);
                              },
                              child: mainButton('Get Started'),
                            )
                          ],
                        ),
                      ),
                      whatYouGetSection(personalisedCareSubscriptionModel),
                      SizedBox(
                        height: 30.h,
                      ),
                      youAlsoGetSection(personalisedCareSubscriptionModel),
                    ],
                  ),
                ),
                SizedBox(
                  height: 27.h,
                ),
                Text(
                  bottomText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                    onTap: () async {
                      handleSubscription(context, diseaseDetailsController,
                          subscriptionPackageController);
                    },
                    child: mainButton("Subscribe Now")),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
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
      ]),
    );
  }

  Future<void> handleSubscription(
      BuildContext context,
      DiseaseDetailsController diseaseDetailsController,
      SubscriptionPackageController subscriptionPackageController) async {
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
      dynamic customData = {
        "subscribeVia": "HEALING",
        "diseaseSelected": {
          "diseaseId": diseaseDetailsController
              .diseaseDetails.value!.details!.diseaseId!,
          "disease":
              diseaseDetailsController.diseaseDetails.value!.details!.disease!,
        },
        "selectedPackage": selectedPackage.toJson(),
        "promoCodeDetails": {
          "isApplied": subscriptionPackageController.isPromoCodeApplied.value,
          "promoCode": {
            "promoCodeId":
                subscriptionPackageController.appliedPromoCode?.promoCodeId,
            "promoCode":
                subscriptionPackageController.appliedPromoCode?.promoCode,
            "promoCodeName":
                subscriptionPackageController.appliedPromoCode?.promoCodeName,
            "accessType":
                subscriptionPackageController.appliedPromoCode?.accessType,
            "appUserCouponId":
                subscriptionPackageController.appliedPromoCode?.appUserCouponId,
          },
        }
      };
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
    return SizedBox(
      width: double.infinity,
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
          ...personalisedCareSubscriptionModel.youAlsoGetList!
              .map((e) => buildtAlsoGetRow(e ?? ""))
              .toList(),
          SizedBox(
            height: 50.h,
          )
        ],
      ),
    );
  }
}
