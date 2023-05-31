// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/new_deeplinks/book_freee_doctor.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class DFIWebView extends StatefulWidget {
  final String pageUrl;
  const DFIWebView({Key? key, required this.pageUrl}) : super(key: key);

  @override
  State<DFIWebView> createState() => _DFIWebViewState();
}

class _DFIWebViewState extends State<DFIWebView> {
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canGoBack = await webViewController.canGoBack();
        if (canGoBack == true) {
          webViewController.goBack();
        } else {
          Navigator.pop(context);
        }

        return false;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.pageUrl)),
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
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              Map<String, List<String>> queryParameters =
                  navigationAction.request.url!.queryParametersAll;

              if (queryParameters["type"] != null &&
                  queryParameters["type"]!.isNotEmpty) {
                switch (queryParameters["type"]![0].toString()) {
                  case "CLOSE":
                    Navigator.pop(context);
                    return NavigationActionPolicy.CANCEL;
                  case "FREE_DOCTOR_CONSULT":
                    Navigator.pop(context);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    /* Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(
                          selectedTab: 1,
                        ),
                      ),
                    ); */
                    HiveService().isFirstTimeDoctorConsultation().then((value) {
                      if (value == true) {
                        Get.bottomSheet(
                          BookFreeDoctor(
                            allowBack: true,
                            bookFunction: () {
                              Navigator.of(context).pop();
                              handleClick(context);
                            },
                          ),
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: false,
                        ).then((value) {
                          HiveService().initFirstTimeDoctorConsultation();
                        });
                      } else {
                        handleClick(context);
                      }
                    });
                    return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
            },
            androidOnPermissionRequest: (InAppWebViewController controller,
                String origin, List<String> resources) async {
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
    );
  }

  handleClick(BuildContext context) {
    DoctorSessionController doctorSessionController = Get.find();
    if (doctorSessionController.upcomingSessionsList.value != null &&
        doctorSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        doctorSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      CoachUpcomingSessionsModelUpcomingSessions? pendingSession =
          doctorSessionController.upcomingSessionsList.value!.upcomingSessions!
              .firstWhereOrNull((element) => element!.status == 'PENDING');
      if (pendingSession != null) {
        EventsService().sendClickNextEvent(
            "DoctorConsultationInfo", "Select Doctor", "DoctorSessions");
        Get.to(const DoctorSessions());
      } else {
        redirectToDoctorList(context);
      }
    } else {
      redirectToDoctorList(context);
    }
  }

  redirectToDoctorList(BuildContext context) async {
    bool isAllowed = await checkIsPaymentAllowed("DOCTOR_CONSULTATION");
    if (isAllowed == true) {
      buildShowDialog(context);
      Navigator.pop(context);
      EventsService().sendClickNextEvent(
          "DoctorConsultationInfo", "Select Doctor", "DoctorList");
      Get.to(const DoctorList(
        pageSource: "MY_ROUTINE",
        consultType: "GOT QUERY",
        bookType: "PAID",
      ));
    }
  }
}
