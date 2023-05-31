import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShowWebView extends StatefulWidget {
  final String pageUrl;
  const ShowWebView({Key? key, required this.pageUrl}) : super(key: key);

  @override
  State<ShowWebView> createState() => _ShowWebViewState();
}

class _ShowWebViewState extends State<ShowWebView> {
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
        /* appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () async {
              bool canGoBack = await webViewController.canGoBack();
              if (canGoBack == true) {
                webViewController.goBack();
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            )
          ],
        ), */
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: InAppWebView(
            initialUrlRequest:
                URLRequest(url: Uri.parse(widget.pageUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowFileAccessFromFileURLs: true,
                  allowUniversalAccessFromFileURLs: true,
                  useOnDownloadStart: true,
                  javaScriptCanOpenWindowsAutomatically: true),
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              // any code;
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
            onUpdateVisitedHistory: (controller, url, androidIsReload) async {
              /* String visitedUrl = url!.path.toLowerCase();
              if (visitedUrl.contains("1-samskriti-bhavan.html") ||
                  visitedUrl.contains("2-mangal-mandir.html") ||
                  visitedUrl.contains("3-santosha-hall.html") ||
                  visitedUrl.contains("4-tapas-hall.html")) {
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              } else {
                visitedUrl = url.host.toLowerCase();
                if (visitedUrl.contains("svyasa.aayu.live")) {
                  await SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                }
              } */
            }),
      ),
    );
  }
}
