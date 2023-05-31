import 'package:aayu/model/model.dart';
import 'package:aayu/view/shared/shared.dart';

import 'http.service.dart';
import 'request.id.service.dart';

const String sleepTrackerServiceName = "tracker-service";

class SleepTrackingService {
  Future<SleepTrackerListModel?> getSleepList() async {
    dynamic response = await httpGet(
        sleepTrackerServiceName, 'v1/sleep/list?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      SleepTrackerListModel sleepListResponse = SleepTrackerListModel();
      sleepListResponse = SleepTrackerListModel.fromJson(response["data"]);
      return sleepListResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> postSleepCheckIn(dynamic postData) async {
    dynamic response = await httpPost(sleepTrackerServiceName,
        'v1/sleep/checkIn?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<DateWiseSleepCheckInModel?> getDateWiseSleepSummary(
      String date) async {
    dynamic response = await httpGet(sleepTrackerServiceName,
        'v1/sleep/checkIn/$date?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      DateWiseSleepCheckInModel dateWiseSleepCheckInModel =
          DateWiseSleepCheckInModel();
      dateWiseSleepCheckInModel =
          DateWiseSleepCheckInModel.fromJson(response["data"]);

      return dateWiseSleepCheckInModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<TodaysSleepSummaryModel?> getTodaysSleepSummary() async {
    dynamic response = await httpGet(sleepTrackerServiceName,
        'v1/sleep/todaysCheckIn?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      TodaysSleepSummaryModel todaysSleepSummaryModel =
          TodaysSleepSummaryModel();
      todaysSleepSummaryModel =
          TodaysSleepSummaryModel.fromJson(response["data"]);
      return todaysSleepSummaryModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<WeeklySleepCheckInModel?> getWeeklySleepSummary(
      String fromDate, String toDate) async {
    dynamic response = await httpGet(sleepTrackerServiceName,
        'v1/sleep/insight/$fromDate/$toDate?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      WeeklySleepCheckInModel weeklySleepCheckInModel =
          WeeklySleepCheckInModel();
      weeklySleepCheckInModel =
          WeeklySleepCheckInModel.fromJson(response["data"]);
      return weeklySleepCheckInModel;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<List<DateTime>> getSleepCheckInDates() async {
    dynamic response = await httpGet(sleepTrackerServiceName,
        'v1/sleep/checkInDates?requestId=${getRequestId()}',
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
    dynamic response = await httpPut(sleepTrackerServiceName,
        'v1/sleep/reminder?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId});
    if (response != null && response["success"] == true) {
      return true;
    } else {
      showError(response["error"]);
      return false;
    }
  }
}
