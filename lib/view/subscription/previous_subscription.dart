import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'renew_subscription.dart';

class PreviousSubscription extends StatelessWidget {
  final bool allowBackPress;
  const PreviousSubscription({Key? key, this.allowBackPress = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubscriptionController subscriptionController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() {
        if (subscriptionController.isLoading.value == true) {
          return const Offstage();
        }
        if (subscriptionController.previousSubscriptionDetails.value != null &&
            subscriptionController
                    .previousSubscriptionDetails.value!.subscriptionDetails !=
                null &&
            subscriptionController.previousSubscriptionDetails.value!
                    .subscriptionDetails!.enableRenew ==
                true) {
          return InkWell(
            onTap: () {
              Get.bottomSheet(
                const RenewSubscription(renewalVia: "PREVIOUS_SUBSCRIPTION"),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            },
            child: Container(
                padding: EdgeInsets.zero,
                child: Stack(alignment: Alignment.center, children: [
                  Image.asset(Images.greenToast),
                  Row(
                    children: [
                      SizedBox(
                        width: 27.w,
                      ),
                      Expanded(
                        child: Text(
                          "Your ${toTitleCase((subscriptionController.previousSubscriptionDetails.value!.subscriptionDetails!.packageType ?? "").toLowerCase())} subscription is expired. Renew it to continue your subscription.",
                          style: TextStyle(
                              color: AppColors.blackLabelColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.5.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 14,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                              )
                            ]),
                        child: Text(
                          'RENEW NOW',
                          style: TextStyle(
                              color: const Color(0xFF597393),
                              fontWeight: FontWeight.w700,
                              fontSize: 11.sp),
                        ),
                      ),
                      SizedBox(
                        width: 27.w,
                      )
                    ],
                  ),
                ])),
          );
        } else {
          return const Offstage();
        }
      }),
      body: Obx(() {
        if (subscriptionController.isLoading.value == true) {
          return showLoading();
        }

        return Stack(children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              Images.subscriptionBackground,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: allowBackPress == true ? 101.h : 56.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 26.w, bottom: 26.h, right: 26.w),
                child: const Text(
                  'Your Previous Subscription',
                  style: AppTheme.secondarySmallFontTitleTextStyle,
                ),
              ),
              Expanded(
                child:
                    subscriptionController.previousSubscriptionDetails.value !=
                                null &&
                            subscriptionController.previousSubscriptionDetails
                                    .value!.subscriptionDetails !=
                                null
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 26.h,
                                ),
                                buildActivePlanDetails(
                                    subscriptionController, context),
                                SizedBox(
                                  height: 60.h,
                                ),
                              ],
                            ),
                          )
                        : const Offstage(),
              )
            ],
          ),
          allowBackPress == true
              ? Positioned(
                  top: 40.h,
                  left: 14.w,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_sharp,
                      color: AppColors.blackLabelColor,
                      size: 25,
                    ),
                  ),
                )
              : const Offstage()
        ]);
      }),
    );
  }

  Widget buildActivePlanDetails(
      SubscriptionController subscriptionController, BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 27.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBFE),
            border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 23.h, bottom: 17.h, left: 27.w, right: 22.w),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Plan",
                      style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp),
                    ),
                    Text(
                      toTitleCase((subscriptionController
                                  .previousSubscriptionDetails
                                  .value!
                                  .subscriptionDetails!
                                  .packageType ??
                              "")
                          .toLowerCase()),
                      style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                color: Color(0xFFEBEBEB),
                thickness: 1,
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Start Date:',
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 16.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatDatetoThForm(dateFromTimestamp(
                              subscriptionController
                                  .previousSubscriptionDetails
                                  .value!
                                  .subscriptionDetails!
                                  .epochTimes!
                                  .subscribeDate!)),
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 16.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      color: Color(0xFFD1D9E5),
                      thickness: 1.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'End Date:',
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 16.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatDatetoThForm(dateFromTimestamp(
                              subscriptionController
                                  .previousSubscriptionDetails
                                  .value!
                                  .subscriptionDetails!
                                  .epochTimes!
                                  .expiryDate!)),
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 16.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 38.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Healing Program",
                          style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    subscriptionController.previousSubscriptionDetails.value!
                            .subscriptionDetails!.programId!.isNotEmpty
                        ? showSubscribedHealingProgram(
                            subscriptionController, context)
                        : const Offstage()
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: -17.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 40.h,
                width: 128.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBFE),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Container(
                height: 24.h,
                width: 112.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Previous Plan',
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget showSubscribedHealingProgram(
      SubscriptionController subscriptionController, BuildContext context) {
    HealingListController healingListController = Get.find();
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ShowNetworkImage(
                    boxFit: BoxFit.fitWidth,
                    imgPath: subscriptionController
                            .previousSubscriptionDetails
                            .value!
                            .subscriptionDetails!
                            .silverAppBar!
                            .backgroundImage ??
                        ""),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 129.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 1),
                        Color.fromRGBO(0, 0, 0, 0)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.h,
                child: Text(
                  (subscriptionController.previousSubscriptionDetails.value!
                              .subscriptionDetails!.silverAppBar!.title ??
                          "")
                      .toUpperCase(),
                  style: TextStyle(
                    color: const Color(0xFFD6D6D6),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (subscriptionController.previousSubscriptionDetails.value!
                    .subscriptionDetails!.disease !=
                null &&
            subscriptionController.previousSubscriptionDetails.value!
                    .subscriptionDetails!.disease!.length >
                1)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32.h,
              ),
              Text(
                'Chronic Health Conditions Covered',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 130.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: subscriptionController
                          .previousSubscriptionDetails
                          .value!
                          .subscriptionDetails!
                          .disease!
                          .length,
                      itemBuilder: (context, index) => Container(
                        width: 70.h,
                        margin: EdgeInsets.symmetric(horizontal: 10.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShowNetworkImage(
                                imgHeight: 50.h,
                                boxFit: BoxFit.fitHeight,
                                imgPath:
                                    healingListController.getImageFromDiseaseId(
                                        subscriptionController
                                                .previousSubscriptionDetails
                                                .value!
                                                .subscriptionDetails!
                                                .disease![index]!
                                                .diseaseId ??
                                            "")),
                            SizedBox(
                              height: 13.h,
                            ),
                            Text(
                              subscriptionController
                                      .previousSubscriptionDetails
                                      .value!
                                      .subscriptionDetails!
                                      .disease![index]!
                                      .diseaseName ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.blueGreyAssessmentColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 15.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        SizedBox(
          height: 18.h,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Start Date:',
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Text(
              formatDatetoThForm(dateFromTimestamp(subscriptionController
                  .previousSubscriptionDetails
                  .value!
                  .subscriptionDetails!
                  .epochTimes!
                  .startDate!)),
              style: TextStyle(
                color: AppColors.blueGreyAssessmentColor,
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        SizedBox(
          height: 29.h,
        )
      ],
    );
  }
}
