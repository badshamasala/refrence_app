import 'dart:convert';

import 'package:aayu/data/mood_tracking_data.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/view/shared/shared.dart';

import 'http.service.dart';
import 'request.id.service.dart';

const String moodTrackerServiceName = "tracker-service";

class MoodTrackingService {
  Future<MoodListModel?> getMoodList() async {
    dynamic response = await httpGet(
        moodTrackerServiceName, 'v1/mood/list?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      MoodListModel moodListResponse = MoodListModel();
      moodListResponse = MoodListModel.fromJson(response["data"]);
      return moodListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<MoodIdentifyModel?> getMoodIdentifications() async {
    dynamic response = await httpGet(moodTrackerServiceName,
        'v1/mood/identifications?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      MoodIdentifyModel moodIdentifyModel = MoodIdentifyModel();
      moodIdentifyModel = MoodIdentifyModel.fromJson(response["data"]);
      return moodIdentifyModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postMoodCheckIn(dynamic postData) async {
    dynamic response = await httpPost(moodTrackerServiceName,
        'v1/mood/checkIn?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<TodaysMoodSummaryModel?> getTodaysMoodSummary() async {
    dynamic response = await httpGet(moodTrackerServiceName,
        'v1/mood/todaysLastCheckIn?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      TodaysMoodSummaryModel todaysMoodSummaryModel = TodaysMoodSummaryModel();
      todaysMoodSummaryModel =
          TodaysMoodSummaryModel.fromJson(response["data"]);
      return todaysMoodSummaryModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<WeeklyMoodCheckInModel?> getWeeklyMoodSummary(
      String fromDate, String toDate) async {
    dynamic response = await httpGet(moodTrackerServiceName,
        'v1/mood/insight/$fromDate/$toDate?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      WeeklyMoodCheckInModel weeklyMoodCheckInModel = WeeklyMoodCheckInModel();
      weeklyMoodCheckInModel =
          WeeklyMoodCheckInModel.fromJson(response["data"]);
      return weeklyMoodCheckInModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<DateWiseMoodCheckInModel?> getDateWiseCheckIns() async {
    return await Future.delayed(const Duration(seconds: 2), () {
      DateWiseMoodCheckInModel dateWiseMoodCheckIns =
          DateWiseMoodCheckInModel();
      dateWiseMoodCheckIns = DateWiseMoodCheckInModel.fromJson(
          jsonDecode(jsonEncode(dateWiseMoodCheckInsData)));
      return dateWiseMoodCheckIns;
    });
  }

  Future<DateWiseMoodCheckInDetailsModel?> getDateWiseCheckInsDetails(
      String date) async {
    dynamic response = await httpGet(moodTrackerServiceName,
        'v1/mood/checkIn/$date?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      DateWiseMoodCheckInDetailsModel dateWiseMoodCheckInDetailsModel =
          DateWiseMoodCheckInDetailsModel();
      dateWiseMoodCheckInDetailsModel =
          DateWiseMoodCheckInDetailsModel.fromJson(response["data"]);
      return dateWiseMoodCheckInDetailsModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<List<DateTime>> getMoodCheckInDates() async {
    dynamic response = await httpGet(moodTrackerServiceName,
        'v1/mood/checkInDates?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null &&
        response["success"] == true &&
        response["data"] != null &&
        response["data"]["checkInDates"] != null) {
      List<DateTime> list = [];

      List<dynamic> dates = response["data"]["checkInDates"];
      for (var element in dates) {
        list.add(DateTime.fromMillisecondsSinceEpoch(element as int));
      }
      return list;
    } else {
      showError(response["error"]);
      return [];
    }
  }

  Future<bool> putReminderTime(dynamic postData) async {
    dynamic response = await httpPut(moodTrackerServiceName,
        'v1/mood/reminder?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }
}
