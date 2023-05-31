///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CoachUpcomingSessionsModelUpcomingSessionsCoach {
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

  CoachUpcomingSessionsModelUpcomingSessionsCoach({
    this.coachId,
    this.coachName,
    this.profilePic,
  });
  CoachUpcomingSessionsModelUpcomingSessionsCoach.fromJson(
      Map<String, dynamic> json) {
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

class CoachUpcomingSessionsModelUpcomingSessions {
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

  CoachUpcomingSessionsModelUpcomingSessionsCoach? coach;
  String? sessionId;
  String? consultType;
  String? bookType;
  String? status;
  int? fromTime;
  int? toTime;
  int? expiresOn;
  int? secondsRemaining;
  bool? allowReschedule;

  CoachUpcomingSessionsModelUpcomingSessions({
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
  CoachUpcomingSessionsModelUpcomingSessions.fromJson(
      Map<String, dynamic> json) {
    coach = (json['coach'] != null)
        ? CoachUpcomingSessionsModelUpcomingSessionsCoach.fromJson(
            json['coach'])
        : null;
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

class CoachUpcomingSessionsModel {
/*
{
  "upcomingSessions": [
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

  List<CoachUpcomingSessionsModelUpcomingSessions?>? upcomingSessions;

  CoachUpcomingSessionsModel({
    this.upcomingSessions,
  });
  CoachUpcomingSessionsModel.fromJson(Map<String, dynamic> json) {
    if (json['upcomingSessions'] != null) {
      final v = json['upcomingSessions'];
      final arr0 = <CoachUpcomingSessionsModelUpcomingSessions>[];
      v.forEach((v) {
        arr0.add(CoachUpcomingSessionsModelUpcomingSessions.fromJson(v));
      });
      upcomingSessions = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (upcomingSessions != null) {
      final v = upcomingSessions;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['upcomingSessions'] = arr0;
    }
    return data;
  }
}
