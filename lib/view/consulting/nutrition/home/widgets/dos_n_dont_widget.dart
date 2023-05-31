import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DosNDontWidget extends StatelessWidget {
  const DosNDontWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 322.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(16.sp),
        color: const Color(0xFFE0E7EE).withOpacity(0.3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Do’s & Don’t",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 16.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    height: 1.18.h,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Follow these essential nutritional guidelines",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 12.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    height: 1.3.h,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xff3E3A93),
                    elevation: 0,
                    padding: EdgeInsets.only(right: 10.w),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      navState.currentState!.context,
                      MaterialPageRoute(
                        builder: (context) => const DosNDontWebview(),
                      ),
                    );
                  },
                  child: Text(
                    "Read now",
                    style: TextStyle(
                      fontSize: 13.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.18.h,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image(
            image: const AssetImage(Images.dosDont),
            width: 70.w,
            height: 70.h,
          )
        ],
      ),
    );
  }
}

class DosNDontWebview extends StatelessWidget {
  const DosNDontWebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Do’s & Don’t", Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://www.aayu.live/other-pages/nutrition-guidelines.html")),
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
    );
  }
}
