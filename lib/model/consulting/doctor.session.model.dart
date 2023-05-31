import 'package:aayu/model/model.dart';

class DoctorSessionResponseSessionsEpochTime {
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

  DoctorSessionResponseSessionsEpochTime({
    this.slotTime,
    this.slotEndTime,
    this.expiresOn,
  });
  DoctorSessionResponseSessionsEpochTime.fromJson(Map<String, dynamic> json) {
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

class DoctorSessionResponseSessions {
/*
{
  "scheduledDate": "2022-06-09",
  "slotTime": "08:00 PM",
  "secondsRemaining":1120,
  "slotEndTime": "08:30 PM",
  "status": "BOOKED",
  "doctorId": "1ecf5890-cd22-11ec-aae7-f151822f89d2",
  "doctorName": "Dr. Shivaji",
  "profilePic": "https://resetcontent.s3.ap-south-1.amazonaws.com/trainerprofile/1ecf5890-cd22-11ec-aae7-f151822f89d2/image_cropper_1653312556809.jpg",
  "callJoinLink": "https://meet.toktown.tk/mspQvk",
  "consultType": "ADD-ON",
  "sessionId": "340cb440-e7fe-11ec-97c5-032f0b96fd74",
  "disease": [
    {
      "diseaseId": "9e162ea0-c20d-11ec-8195-fb3d9a5f7244"
    }
  ],
  "expiresOn": ""
} 
*/

  String? scheduledDate;
  String? slotTime;
  int? secondsRemaining;
  String? slotEndTime;
  String? status;
  String? doctorId;
  String? doctorName;
  String? profilePic;
  String? callJoinLink;
  String? consultType;
  String? bookType;
  String? sessionId;
  List<DiseaseDetailsRequestDisease?>? disease;
  String? expiresOn;
  bool? isReschedule;
  DoctorSessionResponseSessionsEpochTime? epochTime;

  DoctorSessionResponseSessions({
    this.scheduledDate,
    this.slotTime,
    this.slotEndTime,
    this.secondsRemaining,
    this.status,
    this.doctorId,
    this.doctorName,
    this.profilePic,
    this.callJoinLink,
    this.consultType,
    this.bookType,
    this.sessionId,
    this.disease,
    this.expiresOn,
    this.isReschedule,
    this.epochTime,
  });
  DoctorSessionResponseSessions.fromJson(Map<String, dynamic> json) {
    scheduledDate = json['scheduledDate']?.toString();
    slotTime = json['slotTime']?.toString();
    secondsRemaining = json['secondsRemaining'];
    slotEndTime = json['slotEndTime']?.toString();
    status = json['status']?.toString();
    doctorId = json['doctorId']?.toString();
    doctorName = json['doctorName']?.toString();
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
        ? DoctorSessionResponseSessionsEpochTime.fromJson(json['epochTime'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['scheduledDate'] = scheduledDate;
    data['slotTime'] = slotTime;
    data['secondsRemaining'] = secondsRemaining;
    data['slotEndTime'] = slotEndTime;
    data['status'] = status;
    data['doctorId'] = doctorId;
    data['doctorName'] = doctorName;
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

class DoctorSessionResponse {
/*
{
  "sessions": [
    {
      "scheduledDate": "2022-06-09",
      "slotTime": "08:00 PM",
      "secondsRemaining":1120,
      "slotEndTime": "08:30 PM",
      "status": "BOOKED",
      "doctorId": "1ecf5890-cd22-11ec-aae7-f151822f89d2",
      "doctorName": "Dr. Shivaji",
      "profilePic": "https://resetcontent.s3.ap-south-1.amazonaws.com/trainerprofile/1ecf5890-cd22-11ec-aae7-f151822f89d2/image_cropper_1653312556809.jpg",
      "callJoinLink": "https://meet.toktown.tk/mspQvk",
      "consultType": "ADD-ON",
      "sessionId": "340cb440-e7fe-11ec-97c5-032f0b96fd74",
      "disease": [
        {
          "diseaseId": "9e162ea0-c20d-11ec-8195-fb3d9a5f7244"
        }
      ],
      "expiresOn": ""
    }
  ]
} 
*/

  List<DoctorSessionResponseSessions?>? sessions;

  DoctorSessionResponse({
    this.sessions,
  });
  DoctorSessionResponse.fromJson(Map<String, dynamic> json) {
    if (json['sessions'] != null) {
      final v = json['sessions'];
      final arr0 = <DoctorSessionResponseSessions>[];
      v.forEach((v) {
        arr0.add(DoctorSessionResponseSessions.fromJson(v));
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
