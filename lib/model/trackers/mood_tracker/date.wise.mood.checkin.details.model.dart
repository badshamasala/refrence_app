import 'mood.check.in.model.dart';

class DateWiseMoodCheckInDetailsModel {
/*
{
  "checkInDetails": [
    {
      "checkInId": "b7de9d40-dd2d-11ed-8b0b-97babcaceaa8",
      "moodId": "253a08da-fc50-11ec-b939-0242ac120002",
      "mood": "Amazing",
      "icon": "assets/images/mood-tracker/amazing-icon.png",
      "feelings": [
        {
          "feelingId": "0f7d781a-fb92-11ec-b939-0242ac120002",
          "feeling": "Lonely"
        }
      ],
      "identifications": [
        {
          "identificationId": "f8113600-fc2a-11ec-b939-0242ac120002",
          "identification": "Family"
        }
      ],
      "note": "Hello",
      "checkInTime": 1681398171310
    }
  ]
} 
*/

  List<MoodCheckInModel?>? checkInDetails;

  DateWiseMoodCheckInDetailsModel({
    this.checkInDetails,
  });
  DateWiseMoodCheckInDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['checkInDetails'] != null) {
      final v = json['checkInDetails'];
      final arr0 = <MoodCheckInModel>[];
      v.forEach((v) {
        arr0.add(MoodCheckInModel.fromJson(v));
      });
      checkInDetails = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (checkInDetails != null) {
      final v = checkInDetails;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['checkInDetails'] = arr0;
    }
    return data;
  }
}
