import 'package:aayu/controller/deeplink/disease_details_deeplink_controller.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/onboarding/signup/onboarding_bottom_sheet_controller.dart';
import 'package:aayu/data/deeplink_data.dart';
import 'package:aayu/model/deeplinks/deeplink.disease.details.model.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/new_deeplinks/widgets/free_doctor_consult_tab.dart';
import 'package:aayu/view/new_deeplinks/widgets/how_to_proceed_deeplink.dart';
import 'package:aayu/view/new_deeplinks/widgets/program_details_deeplink.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../model/healing/disease.details.requset.model.dart';
import '../healing/disease_details/widgets/testimonial/testimonial.dart';
import '../onboarding/get_started.dart';
import '../onboarding/onboarding_bottom_sheet.dart';

class DiseaseDetailsTest extends StatefulWidget {
  final Map<String, dynamic> deepLinkData;
  const DiseaseDetailsTest({Key? key, required this.deepLinkData})
      : super(key: key);

  @override
  State<DiseaseDetailsTest> createState() => _DiseaseDetailsTestState();
}

class _DiseaseDetailsTestState extends State<DiseaseDetailsTest>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late InAppWebViewController webViewController;
  TabController? tabController;
  DeeplinkDiseaseDetailModel deeplinkDiseaseDetailModel =
      DeeplinkDiseaseDetailModel();
  DiseaseDetailsDeeplinkController diseaseDetailsDeeplinkController =
      Get.find();

  Color appBarTextColor = Colors.transparent;
  double top = 0.0;
  int tabIndex = 0;
  double programDetailsContentHeight = 100;
  List<String> listTabs = [
    'Program Details',
    'How to Proceed',
    'Doctor Consultation'
  ];
  @override
  void initState() {
    super.initState();
    if (appProperties.consultation!.doctor!.enabled == true &&
        appProperties.consultation!.doctor!.free == true) {
      listTabs = ['Program Details', 'How to Proceed', 'Doctor Consultation'];
    } else {
      listTabs = [
        'Program Details',
        'How to Proceed',
      ];
    }
    deeplinkDiseaseDetailModel =
        DeeplinkDiseaseDetailModel.fromJson(deepLinksdata['data']);
    tabController = TabController(length: listTabs.length, vsync: this);
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset < (340 - kToolbarHeight);
  }

  setDeepLinkContinuedFreeDoctor() {
    Map<String, dynamic> data = {
      "screenName": "BOOK_DOCTOR_CONSULT",
      "diseaseId": widget.deepLinkData['diseaseId'],
      "bookType": "FREE",
      "consultType": "ADD-ON",
    };

    SingularDeepLinkController singularDeepLinkController = Get.find();
    Get.put(OnboardingBottomSheetController(true));
    singularDeepLinkController.nullDeepLinkData();
    singularDeepLinkController.setDeepLinkDataContinued(data);
    Get.to(const OnboardingBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingBottomSheetController(true));
    SingularDeepLinkController singularDeepLinkController = Get.find();
    return DefaultTabController(
      length: listTabs.length,
      child: WillPopScope(
        onWillPop: () async {
          Get.close(2);
          Get.to(const GetStarted());
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F5FC),
          body: Stack(alignment: Alignment.bottomCenter, children: [
            NestedScrollView(
              controller: scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    pinned: true,
                    snap: false,
                    floating: false,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: isSliverAppBarExpanded == true
                        ? Text(
                            diseaseDetailsDeeplinkController
                                    .isPersonalizedCare.value
                                ? "Personalised Care"
                                : diseaseDetailsDeeplinkController
                                        .diseaseDetails
                                        .value!
                                        .details!
                                        .disease ??
                                    "",
                            style: TextStyle(
                              color: appBarTextColor,
                              fontFamily: 'Circular Std',
                              fontSize: 16.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : null,
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
                                  diseaseDetailsDeeplinkController
                                          .isPersonalizedCare.value
                                      ? "Personalised Care"
                                      : diseaseDetailsDeeplinkController
                                              .diseaseDetails
                                              .value!
                                              .details!
                                              .disease ??
                                          "",
                                  style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontFamily: 'Circular Std',
                                    fontSize: 16.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ))
                            : Container(),
                        background: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                ShowNetworkImage(
                                  imgPath: diseaseDetailsDeeplinkController
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
                                          Get.close(2);
                                          Get.to(const GetStarted());
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ))),
                                Positioned(
                                  top: (294).h,
                                  child: CircleAvatar(
                                    radius: 40.5,
                                    backgroundColor: const Color(0xFFF1F5FC),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: ShowNetworkImage(
                                        imgPath:
                                            diseaseDetailsDeeplinkController
                                                    .diseaseDetails
                                                    .value!
                                                    .details!
                                                    .silverAppBar!
                                                    .image!
                                                    .imageUrl ??
                                                "",
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
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 175.w,
                          child: Text(
                            diseaseDetailsDeeplinkController
                                    .isPersonalizedCare.value
                                ? "Personalised Care"
                                : diseaseDetailsDeeplinkController
                                        .diseaseDetails
                                        .value!
                                        .details!
                                        .disease ??
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
                            diseaseDetailsDeeplinkController.diseaseDetails
                                    .value!.details!.description ??
                                "Accelerate your healing from Anxiety with a scientific yoga program designed to centre the mind and help your body relax.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (!diseaseDetailsDeeplinkController
                            .isPersonalizedCare.value)
                          InkWell(
                            onTap: () {
                              EventsService().sendEvent("DL_Disease_LP", {
                                "click": "Know More",
                                "disease_name": diseaseDetailsDeeplinkController
                                        .diseaseDetails
                                        .value!
                                        .details!
                                        .disease ??
                                    ""
                              });
                              openKnowMoreWebView(
                                  diseaseDetailsDeeplinkController
                                          .diseaseDetails
                                          .value!
                                          .details!
                                          .knowMoreLink ??
                                      "https://www.aayu.live/disease/anxiety.html",
                                  diseaseDetailsDeeplinkController
                                      .diseaseDetails
                                      .value!
                                      .details!
                                      .silverAppBar!
                                      .title!,
                                  diseaseDetailsDeeplinkController
                                      .diseaseDetails
                                      .value!
                                      .details!
                                      .silverAppBar!
                                      .image!
                                      .imageUrl!);
                            },
                            child: Text(
                              'Know more about ${diseaseDetailsDeeplinkController.diseaseDetails.value!.details!.disease ?? ""}',
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
                          indicatorPadding: EdgeInsets.only(right: 20.w),
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 36.w, 0.h),
                          labelPadding: EdgeInsets.only(right: 20.w),
                          indicatorWeight: 3,
                          controller: tabController,
                          isScrollable: true,
                          labelColor: AppColors.secondaryLabelColor,
                          unselectedLabelColor:
                              AppColors.secondaryLabelColor.withOpacity(0.5),
                          labelStyle: selectedTabTextStyle(),
                          unselectedLabelStyle: unSelectedTabTextStyle(),
                          onTap: (int index) {
                            EventsService().sendEvent("DL_Disease_LP", {
                              "click": listTabs[index],
                              "disease_name": diseaseDetailsDeeplinkController
                                      .diseaseDetails.value!.details!.disease ??
                                  ""
                            });

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
                      ProgramDetailsDeeplink(
                          programName: diseaseDetailsDeeplinkController
                                  .diseaseDetails
                                  .value!
                                  .details!
                                  .silverAppBar!
                                  .title ??
                              "",
                          deeplinkDiseaseDetailModel:
                              deeplinkDiseaseDetailModel),
                    if (tabIndex == 1) const HowToProceedDeeplink(),
                    /* DiseaseBenefits(
                            deeplinkDiseaseDetailModel:
                                deeplinkDiseaseDetailModel), */
                    if (tabIndex == 2)
                      FreeDoctorConsultTab(
                        function: setDeepLinkContinuedFreeDoctor,
                      ),
                    Testimonial(
                      diseaseIds: DiseaseDetailsRequest(
                        disease: [
                          DiseaseDetailsRequestDisease(
                              diseaseId: diseaseDetailsDeeplinkController
                                      .diseaseDetails
                                      .value!
                                      .details!
                                      .diseaseId ??
                                  "")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(alignment: Alignment.bottomCenter, children: [
              Container(
                width: double.infinity,
                height: 146.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromRGBO(255, 255, 255, 0),
                  Color.fromRGBO(255, 255, 255, 1),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: EdgeInsets.only(right: 26.w, left: 26.w, top: 26.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () {
                      EventsService().sendEvent("DL_Disease_LP", {
                        "click": "Start Program",
                        "disease_name": diseaseDetailsDeeplinkController
                                .diseaseDetails.value!.details!.disease ??
                            ""
                      });
                      singularDeepLinkController.nullDeepLinkData();
                      singularDeepLinkController
                          .setDeepLinkDataContinued(widget.deepLinkData);
                      Get.to(const OnboardingBottomSheet());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 54.h,
                      width: double.infinity,
                      child: Text(
                        'Start Program',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Visibility(
                  visible:
                      (appProperties.consultation!.doctor!.enabled == true &&
                          appProperties.consultation!.doctor!.free == true),
                  child: InkWell(
                    onTap: () {
                      EventsService().sendEvent("DL_Disease_LP", {
                        "click": "Got queries",
                        "disease_name": diseaseDetailsDeeplinkController
                                .diseaseDetails.value!.details!.disease ??
                            ""
                      });

                      setDeepLinkContinuedFreeDoctor();
                    },
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 14.sp,
                            fontFamily: "Circular Std",
                            fontWeight: FontWeight.w400),
                        children: [
                          const TextSpan(
                            text: 'Got queries? ',
                          ),
                          TextSpan(
                            text: 'Book a Doctor Consultation',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.blueGreyAssessmentColor,
                                fontSize: 14.sp,
                                fontFamily: "Circular Std",
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.h,
                )
              ])
            ]),
          ]),
        ),
      ),
    );
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
                    width: 178.w,
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
}
