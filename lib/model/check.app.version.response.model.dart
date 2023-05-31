import 'module.live.status.dart';

class CheckAppVersionResponseVersionDetails {
/*
{
  "newVersion": "1.0.5",
  "newBbuildNumber": "5",
  "androidUpdateUrl": "https://play.google.com/store/apps/details?id=com.resettech.aayu",
  "iosUpdateUrl": "",
  "forceUpdate": false,
  "title": "New Update Available",
  "message": "New features added.\n\n- UI Changes.\n- Bug Fixing."
} 
*/

  String? newVersion;
  String? newBuildNumber;
  String? androidUpdateUrl;
  String? iosUpdateUrl;
  bool? forceUpdate;
  String? title;
  String? message;

  CheckAppVersionResponseVersionDetails({
    this.newVersion,
    this.newBuildNumber,
    this.androidUpdateUrl,
    this.iosUpdateUrl,
    this.forceUpdate,
    this.title,
    this.message,
  });
  CheckAppVersionResponseVersionDetails.fromJson(Map<String, dynamic> json) {
    newVersion = json['newVersion']?.toString();
    newBuildNumber = json['newBuildNumber']?.toString();
    androidUpdateUrl = json['androidUpdateUrl']?.toString();
    iosUpdateUrl = json['iosUpdateUrl']?.toString();
    forceUpdate = json['forceUpdate'];
    title = json['title']?.toString();
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['newVersion'] = newVersion;
    data['newBuildNumber'] = newBuildNumber;
    data['androidUpdateUrl'] = androidUpdateUrl;
    data['iosUpdateUrl'] = iosUpdateUrl;
    data['forceUpdate'] = forceUpdate;
    data['title'] = title;
    data['message'] = message;
    return data;
  }
}

class CheckAppVersionResponse {
/*
{
  "doUpdate": true,
  "updateDetails": {
    "newVersion": "1.0.5",
    "newBbuildNumber": "5",
    "androidUpdateUrl": "https://play.google.com/store/apps/details?id=com.resettech.aayu",
    "iosUpdateUrl": "",
    "forceUpdate": false,
    "title": "New Update Available",
    "message": "New features added.\n\n- UI Changes.\n- Bug Fixing."
  },
  "liveStatus": {
    "isLive": true,
    "isUnderManintainance": "false"
  }
} 
*/

  bool? doUpdate;
  CheckAppVersionResponseVersionDetails? versionDetails;
  ModuleLiveStatus? liveStatus;

  CheckAppVersionResponse({
    this.doUpdate,
    this.versionDetails,
    this.liveStatus,
  });
  CheckAppVersionResponse.fromJson(Map<String, dynamic> json) {
    doUpdate = json['doUpdate'];
    versionDetails = (json['versionDetails'] != null) ? CheckAppVersionResponseVersionDetails.fromJson(json['versionDetails']) : null;
    liveStatus = (json['liveStatus'] != null) ? ModuleLiveStatus.fromJson(json['liveStatus']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['doUpdate'] = doUpdate;
    if (versionDetails != null) {
      data['versionDetails'] = versionDetails!.toJson();
    }
    if (liveStatus != null) {
      data['liveStatus'] = liveStatus!.toJson();
    }
    return data;
  }
}

