// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/healing/disease_details/widgets/how_to_proceed.dart';
import 'package:aayu/view/healing/disease_details/widgets/program_details.dart';
import 'package:aayu/view/healing/programme_selection/program_selection.dart';
import 'package:aayu/view/healing/programme_selection/switch_program.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/deeplink/disease_details_deeplink_controller.dart';
import '../../../controller/healing/disease_details_controller.dart';
import '../../../data/deeplink_data.dart';
import '../../../model/deeplinks/deeplink.disease.details.model.dart';
import '../../../theme/app_theme.dart';
import '../../shared/constants.dart';
import '../../shared/network_image.dart';
import '../../shared/ui_helper/ui_helper.dart';
import '../consultant/doctor_list.dart';

class DiseaseDetails extends StatefulWidget {
  final String pageSource;
  final bool fromThankYou;
  final bool fromDoctorRecommended;

  const DiseaseDetails(
      {Key? key,
      this.pageSource = "",
      required this.fromThankYou,
      this.fromDoctorRecommended = false})
      : super(key: key);

  @override
  State<DiseaseDetails> createState() => _DiseaseDetailsState();
}

class _DiseaseDetailsState extends State<DiseaseDetails>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;
  late InAppWebViewController webViewController;
  TabController? tabController;
  DeeplinkDiseaseDetailModel deeplinkDiseaseDetailModel =
      DeeplinkDiseaseDetailModel();

  double top = 0.0;
  int tabIndex = 0;
  double programDetailsContentHeight = 100;
  List<String> listTabs = [
    'Program Details',
    'How to Proceed',
  ];

  DiseaseDetailsController diseaseDetailsController = Get.find();
  HealingListController healingListController = Get.find();
  ProgramRecommendationController programRecommendationController = Get.find();

  @override
  void initState() {
    super.initState();

    Get.put(DiseaseDetailsDeeplinkController());
    Future.delayed(Duration.zero, () {
      diseaseDetailsController.getDiseaseDetails();
    });

    deeplinkDiseaseDetailModel =
        DeeplinkDiseaseDetailModel.fromJson(deepLinksdata['data']);
    tabController = TabController(length: listTabs.length, vsync: this);
    diseaseDetailsController.initScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (widget.fromThankYou) {
        Future.delayed(const Duration(milliseconds: 500), () {
          selectProgramPreferences();
        });
      }
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (diseaseDetailsController.isLoading.value == true) {
        return showPageLoading();
      } else if (diseaseDetailsController.diseaseDetails.value == null) {
        return showPageLoading();
      } else if (diseaseDetailsController.diseaseDetails.value!.details ==
          null) {
        return showPageLoading();
      }
      return DefaultTabController(
        length: listTabs.length,
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F5FC),
          body: Stack(alignment: Alignment.bottomCenter, children: [
            NestedScrollView(
              controller: diseaseDetailsController.scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  GetBuilder<DiseaseDetailsController>(
                    builder: (titleController) {
                      return SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: false,
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        titleSpacing: 0,
                        elevation: 0,
                        titleTextStyle: AppTheme.bigTextStyle,
                        flexibleSpace:
                            LayoutBuilder(builder: (context, constraints) {
                          top = constraints.biggest.height;

                          return FlexibleSpaceBar(
                            title: top.floor() ==
                                    (MediaQuery.of(context).padding.top +
                                            kToolbarHeight)
                                        .floor()
                                ? AppBar(
                                    elevation: 0,
                                    centerTitle: true,
                                    iconTheme: const IconThemeData(
                                        color: AppColors.blackLabelColor),
                                    backgroundColor: const Color(0xFFF1F5FC),
                                    title: Text(
                                      titleController.diseaseDetails.value!
                                          .details!.silverAppBar!.title!,
                                      style: TextStyle(
                                        color: AppColors.blackLabelColor,
                                        fontFamily: 'Circular Std',
                                        fontSize: 16.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ))
                                : const Offstage(),
                            background: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.topCenter,
                                  children: [
                                    ShowNetworkImage(
                                      imgPath: titleController
                                              .diseaseDetails
                                              .value!
                                              .details!
                                              .silverAppBar!
                                              .backgroundImage ??
                                          "",
                                      imgWidth: double.infinity,
                                      imgHeight: (340).h,
                                      boxFit: BoxFit.cover,
                                    ),
                                    Positioned(
                                        top: 30.h,
                                        left: 7.w,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ))),
                                    Positioned(
                                      top: (294).h,
                                      child: CircleAvatar(
                                        radius: 40.5,
                                        backgroundColor:
                                            const Color(0xFFF1F5FC),
                                        child: Padding(
                                          padding: EdgeInsets.all(15.w),
                                          child: ShowNetworkImage(
                                            imgPath: titleController
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
                                  ],
                                ),
                              ],
                            ),
                            collapseMode: CollapseMode.parallax,
                            centerTitle: true,
                          );
                        }),
                        expandedHeight: (340 + 16).h,
                        backgroundColor: const Color(0xFFF1F5FC),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12.h,
                        ),
                        SizedBox(
                          width: 220.w,
                          child: Text(
                            diseaseDetailsController.diseaseDetails.value!
                                    .details!.silverAppBar!.title ??
                                "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Baskerville',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 322.w,
                          child: Text(
                            diseaseDetailsController.diseaseDetails.value!
                                    .details!.description ??
                                "Accelerate your healing with a scientific yoga program designed to centre the mind and help your body relax.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              height: 1.5.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (diseaseDetailsController.diseaseDetails.value !=
                                null &&
                            diseaseDetailsController.diseaseDetails.value!
                                    .details!.silverAppBar!.title!
                                    .toUpperCase() !=
                                "PERSONALIZED CARE")
                          InkWell(
                            onTap: () {
                              openKnowMoreWebView(
                                  diseaseDetailsController.diseaseDetails.value!
                                          .details!.knowMoreLink ??
                                      "https://www.aayu.live/",
                                  diseaseDetailsController.diseaseDetails.value!
                                      .details!.silverAppBar!.title!,
                                  diseaseDetailsController.diseaseDetails.value!
                                      .details!.silverAppBar!.image!.imageUrl!);
                            },
                            child: Text(
                              'Know more about ${diseaseDetailsController.diseaseDetails.value!.details!.disease ?? ""}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.secondaryLabelColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        TabBar(
                          indicatorColor: AppColors.primaryColor,
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0.h),
                          indicatorWeight: 3,
                          controller: tabController,
                          labelColor: AppColors.secondaryLabelColor,
                          unselectedLabelColor:
                              AppColors.secondaryLabelColor.withOpacity(0.5),
                          labelStyle: selectedTabTextStyle(),
                          unselectedLabelStyle: unSelectedTabTextStyle(),
                          onTap: (int index) {
                            setState(() {
                              tabIndex = index;
                            });
                          },
                          tabs: List.generate(
                            listTabs.length,
                            (index) => Tab(
                              text: listTabs[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if (tabIndex == 0)
                      ProgramDetails(
                          programName: diseaseDetailsController.diseaseDetails
                                  .value!.details!.silverAppBar!.title ??
                              "",
                          deeplinkDiseaseDetailModel:
                              deeplinkDiseaseDetailModel),
                    if (tabIndex == 1) const HowToProceed(),
                    // if (tabIndex == 2)
                    //   FreeDoctorConsultTab(
                    //     function: handleDoctorConsultation,
                    //   ),
                    if (tabIndex == 0)
                      SizedBox(
                        height: (healingListController
                                    .diseaseDetailsRequest.disease!.length >
                                1)
                            ? 200.h
                            : 40.h,
                      ),
                  ],
                ),
              ),
            ),
            showBottomNavaigationBar()
          ]),
        ),
      );
    });
  }

  showPageLoading() {
    return Scaffold(
      body: showLoading(),
    );
  }

  selectProgramPreferences() async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({
        "screenName": "DISEASE_DETAILS",
        "diseaseId":
            diseaseDetailsController.diseaseDetails.value?.details?.diseaseId
      });
      return;
    }
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null) {
      SubscriptionController subscriptionController = Get.find();
      buildShowDialog(context);
      bool blockHealingAccess =
          await subscriptionController.checkHealingAccess();
      if (blockHealingAccess == true) {
        Navigator.pop(context);
        showCustomSnackBar(context,
            "Soon you'll find out which healing program is perfect for you. Wait just a little longer and take the right step forward with the doctor's recommendation.");
      } else if (subscriptionCheckResponse!
          .subscriptionDetails!.programId!.isEmpty) {
        diseaseDetailsController.setSelectedHealthProblem();
        PostAssessmentController postAssessmentController =
            Get.put(PostAssessmentController());
        bool isDataAvailable =
            await postAssessmentController.getProgramDurationDetails();
        Navigator.pop(context);
        if (isDataAvailable == true) {
          Get.bottomSheet(
            ProgramSelection(
              isProgramSwitch: widget.pageSource == "SWITCH_PROGRAM",
              isRecommendedProgramSwitch: widget.fromDoctorRecommended,
            ),
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: false,
          );
        } else {
          showCustomSnackBar(context, "PERFERENCES_DETAILS_NOT_AVAILABLE".tr);
        }
      } else {
        Navigator.pop(context);
        showCustomSnackBar(context, "YOU_HAVE_ALREADY_SUBSCRIBED".tr);
      }
    } else {
      bool isAllowed = await checkIsPaymentAllowed("HEALING");
      if (isAllowed == true) {
        EventsService()
            .sendClickNextEvent("DiseaseDetails", "Next", "SubscribeToAayu");
        Get.bottomSheet(
          SubscribeToAayu(
            subscribeVia: widget.fromDoctorRecommended
                ? "RECOMMENDED_PROGRAM"
                : "HEALING",
            content: null,
          ),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
        );
      }
    }
  }

  openKnowMoreWebView(String link, String title, String icon) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 135.h,
              padding: EdgeInsets.only(left: 30.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5FC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.network(
                    icon,
                    height: 60.h,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontFamily: 'Baskerville',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.blackLabelColor,
                      size: 17,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(link)),
                  onEnterFullscreen: (controller) async {
                    await SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.landscapeLeft,
                    ]);
                  },
                  onExitFullscreen: (controller) async {
                    await SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  },
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      useOnDownloadStart: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                    ),
                  ),
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    return null;
                  },
                  onWebViewCreated: (InAppWebViewController controller) {
                    webViewController = controller;
                  },
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                  onDownloadStartRequest: (controller, downloadRequest) async {
                    print("onDownloadStart ${downloadRequest.url.toString()}");
                  },
                  onUpdateVisitedHistory:
                      (controller, url, androidIsReload) async {}),
            ),
          ],
        ),
      ),
    );
  }

  showBottomNavaigationBar() {
    if (healingListController.diseaseDetailsRequest.disease!.length > 1) {
      return showPersonlizedBookDoctorConsultation();
    } else {
      return Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          width: double.infinity,
          height: 146.h,
          decoration: const BoxDecoration(
              color: Color(0xFFEFEFEF),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 255, 255, 0),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 13.h, left: 26.w, right: 26.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  if (widget.pageSource == "SWITCH_PROGRAM") {
                    handleSwitchProgram();
                  } else if (widget.pageSource == "EXPLORE_PROGRAM") {
                    buildShowDialog(context);
                    if (diseaseDetailsController.diseaseDetails.value!.details!
                            .deepLinkDetails!.deepLink ==
                        null) {
                      ShareService().shareApp();
                    } else {
                      ShareService().shareHealingProgram(
                          diseaseDetailsController.diseaseDetails.value!
                                  .details!.deepLinkDetails!.shareMessage ??
                              "",
                          diseaseDetailsController.diseaseDetails.value!
                                  .details!.deepLinkDetails!.deepLink ??
                              "",
                          diseaseDetailsController.diseaseDetails.value!
                                  .details!.silverAppBar!.backgroundImage ??
                              "");
                    }

                    Navigator.pop(context);
                  } else {
                    selectProgramPreferences();
                  }
                },
                child: mainButton(widget.pageSource == "SWITCH_PROGRAM"
                    ? "Switch to ${diseaseDetailsController.diseaseDetails.value!.details!.silverAppBar!.title ?? ""}"
                    : widget.pageSource == "EXPLORE_PROGRAM"
                        ? "Share Program"
                        : (programRecommendationController
                                        .recommendation.value !=
                                    null &&
                                programRecommendationController
                                        .recommendation.value!.recommendation !=
                                    null &&
                                programRecommendationController.recommendation.value!
                                        .recommendation!.disease !=
                                    null &&
                                programRecommendationController
                                        .recommendation
                                        .value!
                                        .recommendation!
                                        .disease!
                                        .length ==
                                    1 &&
                                programRecommendationController
                                        .recommendation
                                        .value!
                                        .recommendation!
                                        .disease![0]!
                                        .diseaseId ==
                                    diseaseDetailsController.diseaseDetails
                                        .value!.details!.diseaseId)
                            ? "Subscribe Now"
                            : "Select Plan"),
              ),
              SizedBox(
                height: 15.h,
              ),
              widget.pageSource == "SWITCH_PROGRAM"
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "No, I will continue with my current Program",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.blueGreyAssessmentColor,
                          fontSize: 14.sp,
                          fontFamily: "Circular Std",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : (programRecommendationController.recommendation.value !=
                              null &&
                          programRecommendationController
                                  .recommendation.value!.recommendation !=
                              null &&
                          programRecommendationController
                                  .recommendation.value!.recommendation!.disease !=
                              null &&
                          programRecommendationController.recommendation.value!
                                  .recommendation!.programType ==
                              "SINGLE DISEASE" &&
                          programRecommendationController.recommendation.value!
                                  .recommendation!.disease![0]!.diseaseId ==
                              diseaseDetailsController
                                  .diseaseDetails.value!.details!.diseaseId)
                      ? const Offstage()
                      : InkWell(
                          onTap: () {
                            handleDoctorConsultation();
                          },
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: TextStyle(
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 14.sp,
                                fontFamily: "Circular Std",
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'For Personal Care ',
                                ),
                                TextSpan(
                                  text: "Consult our Doctors",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColors.blueGreyAssessmentColor,
                                    fontSize: 14.sp,
                                    fontFamily: "Circular Std",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
            ],
          ),
        )
      ]);
    }
  }

  showPersonlizedBookDoctorConsultation() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: pagePadding(),
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
            offset: Offset(-5, 10),
            blurRadius: 20,
          )
        ],
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "CONSULT_FOR_MORE_THAN_ONE_ILLNESS_MSG".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  height: 1.5.h,
                ),
              ),
              SizedBox(
                height: 17.h,
              ),
              InkWell(
                onTap: () async {
                  diseaseDetailsController.sendDiseaseInterestedEvent();
                  handleDoctorConsultation();
                },
                child: mainButton(
                  "Book a Doctor Consultation",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  handleDoctorConsultation() async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({
        "screenName": "DISEASE_DETAILS",
        "diseaseId":
            diseaseDetailsController.diseaseDetails.value?.details?.diseaseId
      });
      return;
    }
    try {
      if (appProperties.consultation!.doctor!.enabled == false) {
        EventsService().sendEvent("Doctor_Session_Free_Notify", {
          "date_time": DateTime.now().toString(),
        });
        showCustomSnackBar(
          context,
          "Thank you for showing interest.\nFeature is coming soon.",
        );
      } else if (appProperties.consultation!.doctor!.underMaintainance ==
          true) {
        showCustomSnackBar(
          context,
          "UNDER_SCHEDULED_MAINTENANCE_MSG".tr,
        );
      } else {
        bool isAlreadyBooked = await CoachService()
            .checkIsBooked(globalUserIdDetails!.userId!, "Doctor");

        if (isAlreadyBooked == false) {
          EventsService().sendClickNextEvent("DoctorConsultationInfo",
              "Select Your Doctor", "BookDoctorSession");

          DoctorSessionController doctorSessionController = Get.find();
          bool isSessionAvailable = false;
          if (doctorSessionController.upcomingSessionsList.value != null &&
              doctorSessionController
                      .upcomingSessionsList.value!.upcomingSessions !=
                  null) {
            CoachUpcomingSessionsModelUpcomingSessions? sessionDetails =
                doctorSessionController
                    .upcomingSessionsList.value!.upcomingSessions!
                    .firstWhereOrNull(
                        (element) => element!.status == "PENDING");

            if (sessionDetails != null) {
              isSessionAvailable = true;
            }
          }

          if (isSessionAvailable == true) {
            Get.to(
              DoctorList(
                pageSource: "PROGRAM_DETAILS",
                consultType: "ADD-ON",
                bookType: "PAID",
              ),
            )!
                .then((value) {
              EventsService().sendClickBackEvent(
                  "BookDoctorSession", "Back", "DoctorList");
            });
          } else {
            EventsService().sendClickNextEvent(
                "Disease Details", "Got Query", "DoctorList");
            Get.to(
              DoctorList(
                pageSource: "PROGRAM_DETAILS",
                consultType: "GOT QUERY",
                bookType: "PAID",
              ),
            )!
                .then((value) {
              EventsService().sendClickBackEvent(
                  "BookDoctorSession", "Back", "DoctorList");
            });
          }
        } else {
          showCustomSnackBar(context, "COMPLETE_DOCTOR_CALL_BOOKED".tr);
        }
      }
    } catch (e) {}
  }

  handleSwitchProgram() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        )),
        builder: (context) {
          return SwitchProgram(
            fromDoctorRecommended: widget.fromDoctorRecommended,
          );
        });
  }
}
