///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CoachPendingReviewsModelPendingReviewsCoach {
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

  CoachPendingReviewsModelPendingReviewsCoach({
    this.coachId,
    this.coachName,
    this.profilePic,
  });
  CoachPendingReviewsModelPendingReviewsCoach.fromJson(
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

class CoachPendingReviewsModelPendingReviews {
/*
{
  "coach": {
    "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
    "coachName": "Dr. Aayu Expert",
    "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg"
  },
  "consultType": "GOT QUERY",
  "bookType": "PAID",
  "fromTime": 1677256200000,
  "toTime": 1677258000000
} 
*/

  CoachPendingReviewsModelPendingReviewsCoach? coach;
  String? consultType;
  String? bookType;
  String? sessionId;
  int? fromTime;
  int? toTime;

  CoachPendingReviewsModelPendingReviews({
    this.coach,
    this.consultType,
    this.bookType,
    this.sessionId,
    this.fromTime,
    this.toTime,
  });
  CoachPendingReviewsModelPendingReviews.fromJson(Map<String, dynamic> json) {
    coach = (json['coach'] != null)
        ? CoachPendingReviewsModelPendingReviewsCoach.fromJson(json['coach'])
        : null;
    consultType = json['consultType']?.toString();
    bookType = json['bookType']?.toString();
    sessionId = json['sessionId']?.toString();
    fromTime = json['fromTime']?.toInt();
    toTime = json['toTime']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coach != null) {
      data['coach'] = coach!.toJson();
    }
    data['consultType'] = consultType;
    data['bookType'] = bookType;
    data['sessionId'] = sessionId;
    data['fromTime'] = fromTime;
    data['toTime'] = toTime;
    return data;
  }
}

class CoachPendingReviewsModel {
/*
{
  "pendingReviews": [
    {
      "coach": {
        "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
        "coachName": "Dr. Aayu Expert",
        "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg"
      },
      "consultType": "GOT QUERY",
      "bookType": "PAID",
      "fromTime": 1677256200000,
      "toTime": 1677258000000
    }
  ]
} 
*/

  List<CoachPendingReviewsModelPendingReviews?>? pendingReviews;

  CoachPendingReviewsModel({
    this.pendingReviews,
  });
  CoachPendingReviewsModel.fromJson(Map<String, dynamic> json) {
    if (json['pendingReviews'] != null) {
      final v = json['pendingReviews'];
      final arr0 = <CoachPendingReviewsModelPendingReviews>[];
      v.forEach((v) {
        arr0.add(CoachPendingReviewsModelPendingReviews.fromJson(v));
      });
      pendingReviews = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (pendingReviews != null) {
      final v = pendingReviews;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['pendingReviews'] = arr0;
    }
    return data;
  }
}