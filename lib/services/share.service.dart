import 'dart:convert';
import 'dart:io';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ShareService {
  shareApp() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    Map<String, dynamic> shareRemoteConfig =
        json.decode(remoteConfig.getString('APP_SHARE'));
    String shareMsg = shareRemoteConfig["message"];
    String dynamicLink = shareRemoteConfig["dynamicLink"];
    shareMessage(
      shareMsg,
      dynamicLink,
    );
  }

  shareContent(String contentId, String contentImage) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    Map<String, dynamic> shareRemoteConfig =
        json.decode(remoteConfig.getString('CONTENT_SHARE'));
    String shareMsg = shareRemoteConfig["message"];
    String params = jsonEncode({
      "screenName": "CONTENT_DETAILS",
      "contentId": contentId,
    });
    String shortLink = '';
    shortLink = await getShortLinkFromParams(params);
    var response = await get(Uri.parse(contentImage));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        '${documentDirectory.path}/images/${contentImage.split("/").last}';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    shareMessage(
      shareMsg,
      shortLink,
      images: [
        filePathAndName,
      ],
    );
  }

  shareAffirmation(String contentId, String contentImage) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    Map<String, dynamic> shareRemoteConfig =
        json.decode(remoteConfig.getString('AFFIRMATION_SHARE'));
    String shareMsg = shareRemoteConfig["message"];
    String params = jsonEncode({
      "screenName": "AFFIRMATION",
      "contentId": contentId,
    });
    String shortLink = '';
    shortLink = await getShortLinkFromParams(params);
    var response = await get(Uri.parse(contentImage));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        '${documentDirectory.path}/images/${contentImage.split("/").last}';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    shareMessage(
      shareMsg,
      shortLink,
      images: [
        filePathAndName,
      ],
    );
  }

  shareTip(String tip) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    Map<String, dynamic> shareRemoteConfig =
        json.decode(remoteConfig.getString('APP_SHARE'));
    String shareMsg = "Aayu Tips:\n\n$tip\n\n${shareRemoteConfig["message"]}";
    String dynamicLink = shareRemoteConfig["dynamicLink"];
    shareMessage(
      shareMsg,
      dynamicLink,
    );
  }

  shareMessage(String message, String longDynamicLink,
      {List<String> images = const []}) async {
    if (images.isNotEmpty) {
      await Share.shareFiles(images, text: "$message $longDynamicLink");
    } else {
      await Share.share("$message $longDynamicLink");
    }
  }

  shareHealingProgram(String message, String deeplink, String image) async {
    var response = await get(Uri.parse(image));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        '${documentDirectory.path}/images/${image.split("/").last}';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    await Share.shareFiles([
      filePathAndName,
    ], text: "$message\n\n$deeplink");
  }

  shareLiveEvent(String liveEventId, String contentImage, String message,
      BuildContext context) async {
    buildShowDialog(context);
    String shareMsg = message;
    String params = jsonEncode({
      "screenName": "LIVE_EVENT",
      "liveEventId": liveEventId,
    });
    String shortLink = '';
    shortLink = await getShortLinkFromParams(params);
    var response = await get(Uri.parse(contentImage));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName =
        '${documentDirectory.path}/images/${contentImage.split("/").last}';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    Get.close(1);
    shareMessage(
      shareMsg,
      shortLink,
      images: [
        filePathAndName,
      ],
    );
  }

  Future<String> getShortLinkFromParams(String params) async {
    BranchLinkProperties lp = BranchLinkProperties();
    lp.addControlParam("deeplin", params);

    BranchUniversalObject buo = BranchUniversalObject(
      canonicalUrl: "https://www.aayu.live?data=$params",
      canonicalIdentifier: params,
    );
    // print("BRANCH LINK");

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );
    // print(response.result);

    // final dynamicLinkParams = DynamicLinkParameters(
    //   link: Uri.parse("https://www.aayu.live?data=$params"),
    //   uriPrefix: "https://aayuhealing.page.link",
    //   androidParameters: const AndroidParameters(
    //     packageName: "com.resettech.aayu",
    //   ),
    //   iosParameters: const IOSParameters(bundleId: "com.resettech.aayu"),
    // );

    // final dynamicLink =
    //     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    if (response.success) {
      return response.result;
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
      return "";
    }

    // return dynamicLink.shortUrl.toString();
  }
}
