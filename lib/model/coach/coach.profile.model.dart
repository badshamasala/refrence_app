///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CoachProfileModelCoachDetails {
/*
{
  "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
  "coachName": "Dr. Aayu Expert",
  "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg",
  "profession": [
    "Doctor"
  ],
  "experience": "2 Years",
  "bio": "Testing",
  "level": "1",
  "perSessionFee": 2,
  "speciality": [
    "Anxiety"
  ],
  "speaks": [
    "English"
  ],
  "rating": 4.5
} 
*/

  String? coachId;
  String? coachName;
  String? profilePic;
  List<String?>? profession;
  String? experience;
  String? bio;
  String? level;
  int? perSessionFee;
  List<String?>? speciality;
  List<String?>? speaks;
  double? rating;

  CoachProfileModelCoachDetails({
    this.coachId,
    this.coachName,
    this.profilePic,
    this.profession,
    this.experience,
    this.bio,
    this.level,
    this.perSessionFee,
    this.speciality,
    this.speaks,
    this.rating,
  });
  CoachProfileModelCoachDetails.fromJson(Map<String, dynamic> json) {
    coachId = json['coachId']?.toString();
    coachName = json['coachName']?.toString();
    profilePic = json['profilePic']?.toString();
  if (json['profession'] != null) {
  final v = json['profession'];
  final arr0 = <String>[];
  v.forEach((v) {
  arr0.add(v.toString());
  });
    profession = arr0;
    }
    experience = json['experience']?.toString();
    bio = json['bio']?.toString();
    level = json['level']?.toString();
    perSessionFee = json['perSessionFee']?.toInt();
  if (json['speciality'] != null) {
  final v = json['speciality'];
  final arr0 = <String>[];
  v.forEach((v) {
  arr0.add(v.toString());
  });
    speciality = arr0;
    }
  if (json['speaks'] != null) {
  final v = json['speaks'];
  final arr0 = <String>[];
  v.forEach((v) {
  arr0.add(v.toString());
  });
    speaks = arr0;
    }
    rating = json['rating']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coachId'] = coachId;
    data['coachName'] = coachName;
    data['profilePic'] = profilePic;
    if (profession != null) {
      final v = profession;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v);
  });
      data['profession'] = arr0;
    }
    data['experience'] = experience;
    data['bio'] = bio;
    data['level'] = level;
    data['perSessionFee'] = perSessionFee;
    if (speciality != null) {
      final v = speciality;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v);
  });
      data['speciality'] = arr0;
    }
    if (speaks != null) {
      final v = speaks;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v);
  });
      data['speaks'] = arr0;
    }
    data['rating'] = rating;
    return data;
  }
}

class CoachProfileModel {
/*
{
  "coachDetails": {
    "coachId": "8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e",
    "coachName": "Dr. Aayu Expert",
    "profilePic": "https://resetcontent.s3.amazonaws.com/trainerprofile/8ddc36d0-fd16-11ec-86fd-5bbfc80ca82e/image_cropper_1673427209776.jpg",
    "profession": [
      "Doctor"
    ],
    "experience": "2 Years",
    "bio": "Testing",
    "level": "1",
    "perSessionFee": 2,
    "speciality": [
      "Anxiety"
    ],
    "speaks": [
      "English"
    ],
    "rating": 4.5
  }
} 
*/

  CoachProfileModelCoachDetails? coachDetails;

  CoachProfileModel({
    this.coachDetails,
  });
  CoachProfileModel.fromJson(Map<String, dynamic> json) {
    coachDetails = (json['coachDetails'] != null) ? CoachProfileModelCoachDetails.fromJson(json['coachDetails']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (coachDetails != null) {
      data['coachDetails'] = coachDetails!.toJson();
    }
    return data;
  }
}