///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CoachPendingSessionsModelPendingSessionsCoach {
/*
{
  "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
  "coachName": "Dr. Aayu Expert",
  "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg"
} 
*/

  String? coachId;
  String? coachName;
  String? profilePic;

  CoachPendingSessionsModelPendingSessionsCoach({
    this.coachId,
    this.coachName,
    this.profilePic,
  });
  CoachPendingSessionsModelPendingSessionsCoach.fromJson(Map<String, dynamic> json) {
    coachId = json['coachId']?.toString();
    coachName = json['coachName']?.toString();
    profilePic = json['profilePic']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coachId'] = coachId;
    data['coachName'] = coachName;
    data['profilePic'] = profilePic;
    return data;
  }
}

class CoachPendingSessionsModelPendingSessions {
/*
{
  "coach": {
    "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
    "coachName": "Dr. Aayu Expert",
    "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg"
  },
  "sessionId": "b377dbe0-b2a8-11ed-a6c6-03f59283dab5",
  "consultType": "GOT QUERY",
  "bookType": "PAID",
  "status": "BOOKED",
  "fromTime": 1677256200000,
  "toTime": 1677258000000,
  "expiresOn": 1677258000000,
  "secondsRemaining": 20586,
  "allowReschedule": true
} 
*/

  CoachPendingSessionsModelPendingSessionsCoach? coach;
  String? sessionId;
  String? consultType;
  String? bookType;
  String? status;
  int? fromTime;
  int? toTime;
  int? expiresOn;
  int? secondsRemaining;
  bool? allowReschedule;

  CoachPendingSessionsModelPendingSessions({
    this.coach,
    this.sessionId,
    this.consultType,
    this.bookType,
    this.status,
    this.fromTime,
    this.toTime,
    this.expiresOn,
    this.secondsRemaining,
    this.allowReschedule,
  });
  CoachPendingSessionsModelPendingSessions.fromJson(Map<String, dynamic> json) {
    coach = (json['coach'] != null) ? CoachPendingSessionsModelPendingSessionsCoach.fromJson(json['coach']) : null;
    sessionId = json['sessionId']?.toString();
    consultType = json['consultType']?.toString();
    bookType = json['bookType']?.toString();
    status = json['status']?.toString();
    fromTime = json['fromTime']?.toInt();
    toTime = json['toTime']?.toInt();
    expiresOn = json['expiresOn']?.toInt();
    secondsRemaining = json['secondsRemaining']?.toInt();
    allowReschedule = json['allowReschedule'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coach != null) {
      data['coach'] = coach!.toJson();
    }
    data['sessionId'] = sessionId;
    data['consultType'] = consultType;
    data['bookType'] = bookType;
    data['status'] = status;
    data['fromTime'] = fromTime;
    data['toTime'] = toTime;
    data['expiresOn'] = expiresOn;
    data['secondsRemaining'] = secondsRemaining;
    data['allowReschedule'] = allowReschedule;
    return data;
  }
}

class CoachPendingSessionsModel {
/*
{
  "pendingSessions": [
    {
      "coach": {
        "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
        "coachName": "Dr. Aayu Expert",
        "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg"
      },
      "sessionId": "b377dbe0-b2a8-11ed-a6c6-03f59283dab5",
      "consultType": "GOT QUERY",
      "bookType": "PAID",
      "status": "BOOKED",
      "fromTime": 1677256200000,
      "toTime": 1677258000000,
      "expiresOn": 1677258000000,
      "secondsRemaining": 20586,
      "allowReschedule": true
    }
  ]
} 
*/

  List<CoachPendingSessionsModelPendingSessions?>? pendingSessions;

  CoachPendingSessionsModel({
    this.pendingSessions,
  });
  CoachPendingSessionsModel.fromJson(Map<String, dynamic> json) {
  if (json['pendingSessions'] != null) {
  final v = json['pendingSessions'];
  final arr0 = <CoachPendingSessionsModelPendingSessions>[];
  v.forEach((v) {
  arr0.add(CoachPendingSessionsModelPendingSessions.fromJson(v));
  });
    pendingSessions = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (pendingSessions != null) {
      final v = pendingSessions;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['pendingSessions'] = arr0;
    }
    return data;
  }
}