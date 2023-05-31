import 'package:aayu/model/model.dart';

class TrainerSessionResponseSessionsEpochTime {
/*
{
  "slotTime": 1670284800000,
  "slotEndTime": 1672876800000,
  "expiresOn": 1672876800000,
} 
*/

  int? slotTime;
  int? slotEndTime;
  int? expiresOn;

  TrainerSessionResponseSessionsEpochTime({
    this.slotTime,
    this.slotEndTime,
    this.expiresOn,
  });
  TrainerSessionResponseSessionsEpochTime.fromJson(Map<String, dynamic> json) {
    slotTime = json['slotTime'] ?? 0;
    slotEndTime = json['slotEndTime'] ?? 0;
    expiresOn = json['expiresOn'] ?? 0;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['slotTime'] = slotTime ?? 0;
    data['slotEndTime'] = slotEndTime ?? 0;
    data['expiresOn'] = expiresOn ?? 0;
    return data;
  }
}

class TrainerSessionResponseSessions {
/*
{
  "scheduledDate": null,
  "slotTime": null,
  "secondsRemaining":1120,
  "slotEndTime": null,
  "status": "PENDING",
  "trainerId": null,
  "trainerName": null,
  "profilePic": null,
  "callJoinLink": null,
  "expiresOn":"",
  "sessionId":"",
  "consultType":"",
} 
*/

  String? scheduledDate;
  String? slotTime;
  String? slotEndTime;
  int? secondsRemaining;
  String? status;
  String? trainerId;
  String? trainerName;
  String? profilePic;
  String? callJoinLink;
  String? consultType;
  String? bookType;
  String? sessionId;
  List<DiseaseDetailsRequestDisease?>? disease;
  String? expiresOn;
  bool? isReschedule;
  TrainerSessionResponseSessionsEpochTime? epochTime;

  TrainerSessionResponseSessions({
    this.scheduledDate,
    this.slotTime,
    this.slotEndTime,
    this.secondsRemaining,
    this.status,
    this.trainerId,
    this.trainerName,
    this.profilePic,
    this.callJoinLink,
    this.consultType,
    this.bookType,
    this.sessionId,
    this.disease,
    this.expiresOn,
    this.isReschedule,
    this.epochTime
  });
  TrainerSessionResponseSessions.fromJson(Map<String, dynamic> json) {
    scheduledDate = json['scheduledDate']?.toString();
    slotTime = json['slotTime']?.toString();
    secondsRemaining = json['secondsRemaining'];
    slotEndTime = json['slotEndTime']?.toString();
    status = json['status']?.toString();
    trainerId = json['trainerId']?.toString();
    trainerName = json['trainerName']?.toString();
    profilePic = json['profilePic']?.toString();
    callJoinLink = json['callJoinLink']?.toString();
    consultType = json['consultType']?.toString();
    bookType = json['bookType']?.toString();
    sessionId = json['sessionId']?.toString();
    if (json['disease'] != null) {
      final v = json['disease'];
      final arr0 = <DiseaseDetailsRequestDisease>[];
      v.forEach((v) {
        arr0.add(DiseaseDetailsRequestDisease.fromJson(v));
      });
      disease = arr0;
    }
    expiresOn = json['expiresOn']?.toString();
    isReschedule = json['isReschedule'] ?? false;
    epochTime = (json['epochTime'] != null)
        ? TrainerSessionResponseSessionsEpochTime.fromJson(json['epochTime'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['scheduledDate'] = scheduledDate;
    data['secondsRemaining'] = secondsRemaining;
    data['slotTime'] = slotTime;
    data['slotEndTime'] = slotEndTime;
    data['status'] = status;
    data['trainerId'] = trainerId;
    data['trainerName'] = trainerName;
    data['profilePic'] = profilePic;
    data['callJoinLink'] = callJoinLink;
    data['consultType'] = consultType;
    data['bookType'] = bookType;
    data['sessionId'] = sessionId;
    if (disease != null) {
      final v = disease;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['disease'] = arr0;
    }
    data['expiresOn'] = expiresOn;
    data['isReschedule'] = isReschedule;
    if (epochTime != null) {
      data['epochTime'] = epochTime!.toJson();
    }
    return data;
  }
}

class TrainerSessionResponse {
/*
{
  "sessions": [
    {
      "scheduledDate": null,
      "slotTime": null,
      "secondsRemaining":1120,
      "slotEndTime": null,
      "status": "PENDING",
      "trainerId": null,
      "trainerName": null,
      "profilePic": null,
      "callJoinLink": null
    }
  ]
} 
*/

  List<TrainerSessionResponseSessions?>? sessions;

  TrainerSessionResponse({
    this.sessions,
  });
  TrainerSessionResponse.fromJson(Map<String, dynamic> json) {
    if (json['sessions'] != null) {
      final v = json['sessions'];
      final arr0 = <TrainerSessionResponseSessions>[];
      v.forEach((v) {
        arr0.add(TrainerSessionResponseSessions.fromJson(v));
      });
      sessions = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sessions != null) {
      final v = sessions;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['sessions'] = arr0;
    }
    return data;
  }
}
