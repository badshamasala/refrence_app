///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class MoodCheckInModelIdentifications {
/*
{
  "identificationId": "f8113600-fc2a-11ec-b939-0242ac120002",
  "identification": "Family"
} 
*/

  String? identificationId;
  String? identification;

  MoodCheckInModelIdentifications({
    this.identificationId,
    this.identification,
  });
  MoodCheckInModelIdentifications.fromJson(Map<String, dynamic> json) {
    identificationId = json['identificationId']?.toString();
    identification = json['identification']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['identificationId'] = identificationId;
    data['identification'] = identification;
    return data;
  }
}

class MoodCheckInModelFeelings {
/*
{
  "feelingId": "12c8e19a-de85-11ed-b5ea-0242ac120002",
  "feeling": "Productive"
} 
*/

  String? feelingId;
  String? feeling;

  MoodCheckInModelFeelings({
    this.feelingId,
    this.feeling,
  });
  MoodCheckInModelFeelings.fromJson(Map<String, dynamic> json) {
    feelingId = json['feelingId']?.toString();
    feeling = json['feeling']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['feelingId'] = feelingId;
    data['feeling'] = feeling;
    return data;
  }
}

class MoodCheckInModelMood {
/*
{
  "moodId": "253a08da-fc50-11ec-b939-0242ac120002",
  "mood": "Amazing",
  "icon": "assets/images/mood-tracker/amazing-icon.png"
} 
*/

  String? moodId;
  String? mood;
  String? icon;

  MoodCheckInModelMood({
    this.moodId,
    this.mood,
    this.icon,
  });
  MoodCheckInModelMood.fromJson(Map<String, dynamic> json) {
    moodId = json['moodId']?.toString();
    mood = json['mood']?.toString();
    icon = json['icon']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['moodId'] = moodId;
    data['mood'] = mood;
    data['icon'] = icon;
    return data;
  }
}

class MoodCheckInModel {
/*
{
  "checkInId": "b6160890-dea9-11ed-b7c5-93fc8cac47a8",
  "mood": {
    "moodId": "253a08da-fc50-11ec-b939-0242ac120002",
    "mood": "Amazing",
    "icon": "assets/images/mood-tracker/amazing-icon.png"
  },
  "feelings": [
    {
      "feelingId": "12c8e19a-de85-11ed-b5ea-0242ac120002",
      "feeling": "Productive"
    }
  ],
  "identifications": [
    {
      "identificationId": "f8113600-fc2a-11ec-b939-0242ac120002",
      "identification": "Family"
    }
  ],
  "note": "Hello",
  "checkInTime": 1681905600000
} 
*/

  String? checkInId;
  MoodCheckInModelMood? mood;
  List<MoodCheckInModelFeelings?>? feelings;
  List<MoodCheckInModelIdentifications?>? identifications;
  String? note;
  int? checkInTime;

  MoodCheckInModel({
    this.checkInId,
    this.mood,
    this.feelings,
    this.identifications,
    this.note,
    this.checkInTime,
  });
  MoodCheckInModel.fromJson(Map<String, dynamic> json) {
    checkInId = json['checkInId']?.toString();
    mood = (json['mood'] != null)
        ? MoodCheckInModelMood.fromJson(json['mood'])
        : null;
    if (json['feelings'] != null) {
      final v = json['feelings'];
      final arr0 = <MoodCheckInModelFeelings>[];
      v.forEach((v) {
        arr0.add(MoodCheckInModelFeelings.fromJson(v));
      });
      feelings = arr0;
    }
    if (json['identifications'] != null) {
      final v = json['identifications'];
      final arr0 = <MoodCheckInModelIdentifications>[];
      v.forEach((v) {
        arr0.add(MoodCheckInModelIdentifications.fromJson(v));
      });
      identifications = arr0;
    }
    note = json['note']?.toString();
    checkInTime = json['checkInTime']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['checkInId'] = checkInId;
    if (mood != null) {
      data['mood'] = mood!.toJson();
    }
    if (feelings != null) {
      final v = feelings;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['feelings'] = arr0;
    }
    if (identifications != null) {
      final v = identifications;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['identifications'] = arr0;
    }
    data['note'] = note;
    data['checkInTime'] = checkInTime;
    return data;
  }
}