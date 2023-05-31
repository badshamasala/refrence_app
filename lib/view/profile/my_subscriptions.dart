import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/healing/programme/switch_disease.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/upgrade_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/payment/subscription_package_controller.dart';
import '../../controller/program/programme_controller.dart';
import '../../model/grow/grow.page.content.model.dart';
import '../player/video_player.dart';
import '../subscription/previous_subscription.dart';
import '../subscription/renew_subscription.dart';
import '../subscription/subscribe_to_aayu.dart';

class MySubscriptions extends StatelessWidget {
  final bool showUpgradeSnackBar;
  final bool showRenewAuto;
  final String? promoCode;
  const MySubscriptions(
      {Key? key,
      this.showUpgradeSnackBar = false,
      this.showRenewAuto = false,
      this.promoCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showPrevSubscription = false;
    SubscriptionController subscriptionController =
        Get.put(SubscriptionController());

    Future.delayed(Duration.zero, () {
      subscriptionController.getSubscriptionDetails().then((value) async {
        if (subscriptionController
                .subscriptionDetailsResponse.value?.subscriptionDetails ==
            null) {
          subscriptionController.isLoading(true);
          await subscriptionController.getPreviousSubscriptionDetails();
          if (subscriptionController
                  .previousSubscriptionDetails.value?.subscriptionDetails !=
              null) {
            showPrevSubscription = true;
          }
        }
      });
    });
    if (showUpgradeSnackBar) {
      Future.delayed(const Duration(seconds: 1), () {
        print('Great decision! Your program is successfully upgraded.');
        showGreenSnackBar(
            context, 'Great decision! Your program is successfully upgraded.');
      });
    }
    if (showRenewAuto &&
        subscriptionController.subscriptionDetailsResponse.value!
                .subscriptionDetails!.enableRenew ==
            true) {
      Get.bottomSheet(
        RenewSubscription(
          renewalVia: "MY_SUBSCRIPTIONS",
          promoCode: promoCode,
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() {
        if (subscriptionController.isLoading.value == true) {
          return const Offstage();
        }
        if (subscriptionController.subscriptionDetailsResponse.value != null &&
            subscriptionController
                    .subscriptionDetailsResponse.value!.subscriptionDetails !=
                null) {
          if (subscriptionController.subscriptionDetailsResponse.value!
                  .subscriptionDetails!.enableRenew ==
              true) {
            return InkWell(
              onTap: () {
                Get.bottomSheet(
                  const RenewSubscription(renewalVia: "MY_SUBSCRIPTIONS"),
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
                            "Your ${toTitleCase((subscriptionController.subscriptionDetailsResponse.value!.subscriptionDetails!.packageType ?? "").toLowerCase())} subscription is up for renewal soon.",
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
                height: 101.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 26.w, bottom: 26.h, right: 26.w),
                child: Text(
                  'MY_SUBSCRIPTION'.tr,
                  style: AppTheme.secondarySmallFontTitleTextStyle,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: subscriptionController
                                .subscriptionDetailsResponse.value !=
                            null &&
                        subscriptionController.subscriptionDetailsResponse
                                .value!.subscriptionDetails !=
                            null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            buildActivePlanDetails(
                                subscriptionController, context),
                          ],
                        ),
                      )
                    : showPrevSubscription
                        ? const PreviousSubscription(allowBackPress: false)
                        : Center(
                            child: SizedBox(
                              width: 307.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.renewSubscriptionDiamondSVG,
                                    color: const Color(0xFF929DA7),
                                    height: 96.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    "YOU_HAVE_NO_SUBSCRIPTIONS".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.blackLabelColor
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Text(
                                    "Enjoy uninterrupted access to thousands of minutes of healing, growth and mindfulness content updated weekly",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.blackLabelColor
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 26.h,
                                  ),
                                  SizedBox(
                                    width: 193.w,
                                    child: InkWell(
                                      onTap: () async {
                                        bool isAllowed =
                                            await checkIsPaymentAllowed(
                                                "MY_SUBSCRIPTION");
                                        if (isAllowed == true) {
                                          EventsService().sendClickNextEvent(
                                              "Content",
                                              "Play",
                                              "SubscribeToAayu");
                                          Get.bottomSheet(
                                            const SubscribeToAayu(
                                                subscribeVia: "MY_SUBSCRIPTION",
                                                content: null),
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            enableDrag: false,
                                          );
                                        }
                                      },
                                      child: mainButton("Subscribe Now"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              )
            ],
          ),
          Positioned(
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
        ]);
      }),
    );
  }

  Widget buildActivePlanDetails(
      SubscriptionController subscriptionController, BuildContext context) {
    HealingListController healingListController = Get.find();
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(left: 26.w, right: 26.w, bottom: 26.h),
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
                      toTitleCase((subscriptionController
                                  .subscriptionDetailsResponse
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
                    if (subscriptionController.subscriptionDetailsResponse
                            .value!.subscriptionDetails!.allowUpgrade ??
                        true)
                      TextButton(
                        onPressed: () async {
                          buildShowDialog(context);
                          SubscriptionPackageController
                              subscriptionPackageController = Get.find();

                          await subscriptionPackageController
                              .getUpgradeSubscriptionPackages();
                          Navigator.of(context).pop();

                          Get.bottomSheet(
                              UpgradeSubscription(
                                  subscriptionController:
                                      subscriptionController,
                                  subscribeVia: "MY_SUBSCRIPTION"),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              )));
                        },
                        child: Text(
                          "Upgrade Plan",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp),
                        ),
                      )
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
                                  .subscriptionDetailsResponse
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
                                  .subscriptionDetailsResponse
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
                            color: AppColors.secondaryLabelColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        Visibility(
                          visible: subscriptionController
                                  .subscriptionDetailsResponse
                                  .value!
                                  .subscriptionDetails!
                                  .canSwitchProgram ==
                              true,
                          child: InkWell(
                            onTap: () {
                              Get.put(DiseaseDetailsController());
                              changeHealingProgram(context);
                            },
                            child: Text(
                              "Change",
                              style: TextStyle(
                                color: const Color(0xFFFCAFAF),
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    subscriptionController.subscriptionDetailsResponse.value!
                            .subscriptionDetails!.programId!.isNotEmpty
                        ? showSubscribedHealingProgram(
                            subscriptionController, context)
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Your subscription gives you access to one healing program of your choice.',
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: ShowNetworkImage(
                                            boxFit: BoxFit.fitWidth,
                                            imgPath: healingListController
                                                    .healingListResponse
                                                    .value!
                                                    .pageContent!
                                                    .backgroundImage ??
                                                "",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25.h,
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          SingularDeepLinkController
                                              singularDeepLinkController =
                                              Get.find();
                                          Get.close(1);
                                          singularDeepLinkController
                                              .diseaseDetailAlreadySubscribed!();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(0, 44.h),
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100))),
                                        child: Text(
                                          'View Healing Programs',
                                          textAlign: TextAlign.center,
                                          style: mainButtonTextStyle(),
                                        ),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 55.h,
                              )
                            ],
                          ),
                  ],
                ),
              ),
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
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                height: 24.h,
                width: 112.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFAAFDB4),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Active Plan',
                  style: TextStyle(
                      color: const Color(0xFF597393),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp),
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
    ProgrammeController programmeController = Get.find();
    HealingListController healingListController = Get.find();
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (subscriptionController.subscriptionDetailsResponse.value!
                    .subscriptionDetails!.canStartProgram ==
                false) {
              if (programmeController
                      .dayZeroContent.value!.content!.contentType ==
                  "Video") {
                if (programmeController
                            .dayZeroContent.value!.content!.contentPath !=
                        null &&
                    programmeController.dayZeroContent.value!.content!
                        .contentPath!.isNotEmpty) {
                  EventsService().sendClickNextEvent(
                      "MySubscription", "Play", "VideoPlayer");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(
                        source: "Healing Program",
                        content: Content.fromJson(programmeController
                            .dayZeroContent.value!.content!
                            .toJson()),
                        day: 0,
                      ),
                    ),
                  );
                } else {
                  showGetSnackBar(
                      "Content not avaialble!", SnackBarMessageTypes.Info);
                }
              }
            } else {
              if (programmeController
                      .todaysContent.value!.content!.metaData!.multiSeries ==
                  false) {
                if (programmeController
                        .todaysContent.value!.content!.contentType ==
                    "Video") {
                  if (programmeController
                              .todaysContent.value!.content!.contentPath !=
                          null &&
                      programmeController.todaysContent.value!.content!
                          .contentPath!.isNotEmpty) {
                    EventsService().sendClickNextEvent(
                        "MySubscription", "Play", "VideoPlayer");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayer(
                          source: "Healing Program",
                          content: Content.fromJson(programmeController
                              .todaysContent.value!.content!
                              .toJson()),
                          day: programmeController.todaysContent.value?.day,
                        ),
                      ),
                    );
                  } else {
                    showGetSnackBar(
                        "Content not avaialble!", SnackBarMessageTypes.Info);
                  }
                }
              }
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(alignment: Alignment.center, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ShowNetworkImage(
                    boxFit: BoxFit.fitWidth,
                    imgPath: subscriptionController
                            .subscriptionDetailsResponse
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
                          ])),
                ),
              ),
              SvgPicture.asset(
                AppIcons.playSVG,
                width: 39.w,
                height: 39.h,
                color: const Color(0xFFFCAFAF),
              ),
              Positioned(
                  bottom: 16.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Day ${!subscriptionController.subscriptionDetailsResponse.value!.subscriptionDetails!.canStartProgram! ? 0 : programmeController.todaysContent.value?.day ?? 0}",
                        style: TextStyle(
                            fontFamily: 'Baskerville',
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 24.sp),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      Text(
                        (subscriptionController
                                    .subscriptionDetailsResponse
                                    .value!
                                    .subscriptionDetails!
                                    .silverAppBar!
                                    .title ??
                                "")
                            .toUpperCase(),
                        style: TextStyle(
                            color: const Color(0xFFD6D6D6),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp),
                      )
                    ],
                  ))
            ]),
          ),
        ),
        if (subscriptionController.subscriptionDetailsResponse.value!
                    .subscriptionDetails!.disease !=
                null &&
            subscriptionController.subscriptionDetailsResponse.value!
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
                      itemCount: subscriptionCheckResponse!
                          .subscriptionDetails!.disease!.length,
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
                                                .subscriptionDetailsResponse
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
                                      .subscriptionDetailsResponse
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
                  .subscriptionDetailsResponse
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

  changeHealingProgram(BuildContext context) {
    Get.bottomSheet(
        Stack(alignment: Alignment.topLeft, children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 41.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 65.w),
                  child: Text(
                    "Change Your Healing Program",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Baskerville",
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 43.w),
                  child: Text(
                    "Find a different healing program that will work better for you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SwitchDisease(
                  fromMySubscription: true,
                )
              ],
            ),
          ),
          Positioned(
            top: 30.h,
            left: 20.w,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.blueGreyAssessmentColor,
                )),
          )
        ]),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))));
  }
}
