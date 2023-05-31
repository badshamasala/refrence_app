import '../module.live.status.dart';

class CheckFreeSessionResponseSession {
/*
{
  "allowBooking": false,
  "sessionCount": 0
} 
*/

  bool? allowBooking;
  int? sessionCount;

  CheckFreeSessionResponseSession({
    this.allowBooking,
    this.sessionCount,
  });
  CheckFreeSessionResponseSession.fromJson(Map<String, dynamic> json) {
    allowBooking = json['allowBooking'];
    sessionCount = json['sessionCount']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['allowBooking'] = allowBooking;
    data['sessionCount'] = sessionCount;
    return data;
  }
}

class CheckFreeSessionResponse {
/*
{
  "session": {
    "allowBooking": false,
    "sessionCount": 0
  },
  "liveStatus": {
    "isLive": true,
    "isUnderMaintenance": false,
    "message": ""
  }
} 
*/

  CheckFreeSessionResponseSession? session;
  ModuleLiveStatus? liveStatus;

  CheckFreeSessionResponse({
    this.session,
    this.liveStatus,
  });
  CheckFreeSessionResponse.fromJson(Map<String, dynamic> json) {
    session = (json['session'] != null) ? CheckFreeSessionResponseSession.fromJson(json['session']) : null;
    liveStatus = (json['liveStatus'] != null) ? ModuleLiveStatus.fromJson(json['liveStatus']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (session != null) {
      data['session'] = session!.toJson();
    }
    if (liveStatus != null) {
      data['liveStatus'] = liveStatus!.toJson();
    }
    return data;
  }
}

