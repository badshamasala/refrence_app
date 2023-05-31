import 'sleep.check.in.model.dart';

class TodaysSleepSummaryModelReminder {
/*
{
  "isActive": false,
  "reminderTime": false
} 
*/

  bool? isActive;
  int? reminderTime;

  TodaysSleepSummaryModelReminder({
    this.isActive,
    this.reminderTime,
  });
  TodaysSleepSummaryModelReminder.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    reminderTime = int.tryParse(json['reminderTime']?.toString() ?? '');
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['reminderTime'] = reminderTime;
    return data;
  }
}

class TodaysSleepSummaryModel {
/*
{
  "reminder": {
    "isActive": false,
    "reminderTime": false
  },
  "checkInDetails": [
    {
      "checkInId": "9d8df6e0-e357-11ed-872d-11104341291a",
      "sleep": {
        "sleepId": "7dc5f962-d9ec-11ed-afa1-0242ac120002",
        "sleep": "Alright",
        "icon": "assets/images/sleep-tracker/alright-icon.png"
      },
      "bedTime": 1682357400000,
      "wakeupTime": 1682386200000,
      "sleepHours": 8,
      "identifications": [
        {
          "identificationId": "ad6efd44-d9ec-11ed-afa1-0242ac120002",
          "identification": "Medical Problems"
        }
      ],
      "checkInTime": 1682403480547
    }
  ]
} 
*/

  TodaysSleepSummaryModelReminder? reminder;
  List<SleepCheckInModel?>? checkInDetails;

  TodaysSleepSummaryModel({
    this.reminder,
    this.checkInDetails,
  });
  TodaysSleepSummaryModel.fromJson(Map<String, dynamic> json) {
    reminder = (json['reminder'] != null)
        ? TodaysSleepSummaryModelReminder.fromJson(json['reminder'])
        : null;
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
    if (reminder != null) {
      data['reminder'] = reminder!.toJson();
    }
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
