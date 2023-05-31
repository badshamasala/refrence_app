import 'package:aayu/model/trackers/sleep_tracker/sleep.check.in.model.dart';

class DateWiseSleepCheckInModel {
/*
{
  "checkInDetails": [
    {
      "checkInId": "96f85190-df74-11ed-b7c5-93fc8cac47a8",
      "sleep": {
        "sleepId": "7dc5f962-d9ec-11ed-afa1-0242ac120002",
        "sleep": "Alright",
        "icon": "assets/images/sleep-tracker/alright-icon.png"
      },
      "bedTime": 1682028000000,
      "wakeupTime": 1682060400000,
      "sleepHours": 9,
      "identifications": [
        {
          "identificationId": "ad6ef308-d9ec-11ed-afa1-0242ac120002",
          "identification": "Too much screen usage"
        }
      ],
      "checkInTime": 1681899144472
    }
  ]
} 
*/

  List<SleepCheckInModel?>? checkInDetails;

  DateWiseSleepCheckInModel({
    this.checkInDetails,
  });
  DateWiseSleepCheckInModel.fromJson(Map<String, dynamic> json) {
    if (json['checkInDetails'] != null) {
      final v = json['checkInDetails'];
      final arr0 = <SleepCheckInModel>[];
      v.forEach((v) {
        arr0.add(SleepCheckInModel.fromJson(v));
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
