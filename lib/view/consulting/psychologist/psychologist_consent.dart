// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/psychology_consent_controller.dart';
import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_list.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PsychologistConsent extends StatelessWidget {
  const PsychologistConsent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyConsentController psychologyConsentController =
        Get.put(PsychologyConsentController());
    return Scaffold(
      appBar: appBar("Consent Agreement", Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://www.aayu.live/other-pages/consent-form.html")),
        onEnterFullscreen: (controller) async {},
        onExitFullscreen: (controller) async {},
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
          return null;
        },
        onWebViewCreated: (InAppWebViewController controller) {},
        androidOnPermissionRequest: (InAppWebViewController controller,
            String origin, List<String> resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
        onDownloadStartRequest: (controller, downloadRequest) async {},
        onUpdateVisitedHistory: (controller, url, androidIsReload) async {},
      ),
      bottomNavigationBar: Padding(
        padding: pageHorizontalPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return Checkbox(
                    value: psychologyConsentController.isAccepted.value,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      psychologyConsentController.isAccepted.value = value!;
                      psychologyConsentController.update();
                    },
                  );
                }),
                Expanded(
                  child: Text(
                    "I accept this agreement and consent to counselling.",
                    style: TextStyle(
                      color: const Color(0xFF768897),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 26.h,
            ),
            SizedBox(
              height: 48.h,
              width: 216.w,
              child: Obx(() {
                if (psychologyConsentController.isAccepted.value == false) {
                  return disabledButton("Confirm");
                }
                return InkWell(
                  onTap: () async {
                    buildShowDialog(context);
                    PsychologyController psychologyController = Get.find();
                    bool isUpdated = await psychologyController.updateConsent();
                    Navigator.pop(context);
                    if (isUpdated == true) {
                      Navigator.pushReplacement(
                        navState.currentState!.context,
                        MaterialPageRoute(
                          builder: (context) => const PsychologistList(),
                        ),
                      );
                    }
                  },
                  child: mainButton("Confirm"),
                );
              }),
            ),
            SizedBox(
              height: 26.h,
            ),
          ],
        ),
      ),
    );
  }
}
