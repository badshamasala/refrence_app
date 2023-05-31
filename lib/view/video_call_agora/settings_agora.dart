import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

const appIdAgora = '2ae0887f11d64ca7b775782488589042';

class AgoraController extends GetxController {
  String agoraToken = '';
  String agoraAppId = '';
  RxBool isLoading = false.obs;

  Future<void> getAgoraDetails() async {
    isLoading(true);
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();
    Map<String, dynamic> shareRemoteConfig =
        json.decode(remoteConfig.getString('APP_SHARE'));
    agoraToken = shareRemoteConfig["agoraToken"];

    agoraAppId = shareRemoteConfig["agoraAppId"];
    print("AGOOOOOOOOOORA DETAILS ********");
    print(agoraAppId);
    print(agoraToken);
    isLoading(false);
  }
}
