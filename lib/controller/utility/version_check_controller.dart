import 'dart:convert';
import 'dart:io';

import 'package:aayu/config.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/onboarding.service.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheckController extends GetxController {
  Future<CheckAppVersionResponse?> checkAppVersion(
      String currentVersion, String currentBuildNumber) async {
    CheckAppVersionResponse? response =
        await OnboardingService().checkAppVersion(
            Platform.isAndroid
                ? "Android"
                : Platform.isIOS
                    ? "iOS"
                    : "Other",
            Config.environment,
            currentVersion,
            currentBuildNumber);

    return response;
  }

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    String currentBuildNumber =
        info.buildNumber.replaceAll("-dev", "").replaceAll("-prod", "");
    double currentVersion = double.parse(info.version
            .trim()
            .replaceAll(".", "")
            .replaceAll("-dev", "")
            .replaceAll("-prod", "") +
        currentBuildNumber);

    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetchAndActivate();
      Map<String, dynamic> appUpdateRemoteConfig =
          json.decode(remoteConfig.getString('NEW_UPDATE'));

      double newVersion = double.parse(
          appUpdateRemoteConfig["new_version"].trim().replaceAll(".", "") +
              appUpdateRemoteConfig["new_build_number"].trim());

      if (newVersion > currentVersion) {
        EventsService().sendEvent("App_Update_Available", {
          "current_build_version": info.version.trim(),
          "current_build_number": info.buildNumber,
          "update_build_version": appUpdateRemoteConfig["new_version"],
          "update_build_number": appUpdateRemoteConfig["new_build_number"],
          "platform": Platform.isAndroid
              ? "Android"
              : Platform.isIOS
                  ? "iOS"
                  : "Other"
        });

        _showVersionDialog(context, appUpdateRemoteConfig);
      } else {
        const Offstage();
      }
    } catch (exception) {
      print(exception);
    }
  }

//Show Dialog to force user to update
  _showVersionDialog(context, updateDetails) async {
    showDialog(
        context: context,
        builder: (context) {
          String title = (updateDetails["title"] != null)
              ? updateDetails["title"]
              : "New Version";
          String message = (updateDetails["message"] != null)
              ? updateDetails["message"]
              : "There is a newer version available for download! Please update the app.";
          String btnLabel = "Update Now";
          String btnLabelCancel =
              updateDetails["force_update"] == true ? "Quit" : "Do it Later";
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Container(
              padding: EdgeInsets.only(
                  top: 32.h, bottom: 24.h, left: 24.w, right: 24.w),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Circular Std"),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Circular Std"),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromRGBO(86, 103, 137, 0.26),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(100)),
                              padding: EdgeInsets.symmetric(vertical: 9.h)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (updateDetails["force_update"] == true) {
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            }
                          },
                          child: Text(
                            btnLabelCancel,
                            style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Circular Std"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              padding: EdgeInsets.symmetric(vertical: 9.h)),
                          onPressed: () async {
                            Navigator.pop(context);
                            if (Platform.isAndroid == true) {
                              _launchURL(
                                  updateDetails["android_update_url"]
                                      .toString(),
                                  updateDetails["force_update"],
                                  context);
                            } else {
                              _launchURL(
                                  updateDetails["ios_update_url"].toString(),
                                  updateDetails["force_update"],
                                  context);
                            }
                          },
                          child: Text(
                            btnLabel,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Circular Std"),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  _launchURL(String url, bool forceUpdate, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      if (forceUpdate == true) {
        versionCheck(context);
      }
    } else {
      showGetSnackBar(
          "Can not launch App Update URL", SnackBarMessageTypes.Info);
    }
  }
}
