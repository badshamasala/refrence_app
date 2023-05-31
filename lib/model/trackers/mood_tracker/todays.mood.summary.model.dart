
import 'package:aayu/model/trackers/mood_tracker/mood.check.in.model.dart';

class TodaysMoodSummaryModelReminder {
/*
{
  "isActive": false,
  "reminderTime": false
} 
*/

  bool? isActive;
  int? reminderTime;

  TodaysMoodSummaryModelReminder({
    this.isActive,
    this.reminderTime,
  });
  TodaysMoodSummaryModelReminder.fromJson(Map<String, dynamic> json) {
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

class TodaysMoodSummaryModel {
/*
{
  "reminder": {
    "isActive": false,
    "reminderTime": false
  },
  "checkInDetails": {
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
} 
*/

  TodaysMoodSummaryModelReminder? reminder;
  MoodCheckInModel? checkInDetails;

  TodaysMoodSummaryModel({
    this.reminder,
    this.checkInDetails,
  });
  TodaysMoodSummaryModel.fromJson(Map<String, dynamic> json) {
    reminder = (json['reminder'] != null)
        ? TodaysMoodSummaryModelReminder.fromJson(json['reminder'])
        : null;
    checkInDetails = (json['checkInDetails'] != null)
        ? MoodCheckInModel.fromJson(json['checkInDetails'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (reminder != null) {
      data['reminder'] = reminder!.toJson();
    }
    if (checkInDetails != null) {
      data['checkInDetails'] = checkInDetails!.toJson();
    }
    return data;
  }
}
