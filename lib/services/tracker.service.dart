import 'package:aayu/model/model.dart';
import 'package:aayu/model/trackers/steps_tracker/steps_summary_modal.dart';
import 'package:aayu/view/shared/shared.dart';
import 'http.service.dart';
import 'request.id.service.dart';

const String trackerServiceName = "tracker-service";

class TrackerService {
  Future<HealthTrackerUnitsModel?> getHealthTrackerUnits(
      String userId, String parameter) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/health/tracker/units/${parameter.toUpperCase()}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      HealthTrackerUnitsModel healthTrackerUnits = HealthTrackerUnitsModel();
      healthTrackerUnits = HealthTrackerUnitsModel.fromJson(response["data"]);
      return healthTrackerUnits;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<UserHealthTrackingModel?> getUserHealthTrackingDetails(
      String userId, String parameter) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/health/tracker/${parameter.toUpperCase()}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      UserHealthTrackingModel userHealthTracking = UserHealthTrackingModel();
      userHealthTracking = UserHealthTrackingModel.fromJson(response["data"]);
      return userHealthTracking;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> addHealthTracker(String userId, dynamic postData) async {
    dynamic response = await httpPost(trackerServiceName,
        'v1/health/tracker/?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": userId});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["added"] != null) {
        if (response["data"]["added"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  //Water-Intake
  Future<TodaysWaterIntakeDetailsModel?> getTodaysWaterIntake() async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/water/intake/todays?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      TodaysWaterIntakeDetailsModel todaysWaterIntakeDetails =
          TodaysWaterIntakeDetailsModel();
      todaysWaterIntakeDetails =
          TodaysWaterIntakeDetailsModel.fromJson(response["data"]);
      return todaysWaterIntakeDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> addWaterIntake(dynamic postData) async {
    dynamic response = await httpPost(trackerServiceName,
        'v1/water/intake/entry?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> updateWaterDailyTarget(dynamic postData) async {
    dynamic response = await httpPut(
        trackerServiceName,
        'v1/water/intake/dailyTarget?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> updateWaterReminder(dynamic postData) async {
    dynamic response = await httpPut(
        trackerServiceName,
        'v1/water/intake/reminder?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<int?> getWaterIntakeOfDate(String date) async {
    dynamic response = await httpGet(
        trackerServiceName, 'v1/water/intake/$date?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["totalIntake"] != null) {
        return response["data"]["totalIntake"];
      }
      return 0;
    } else {
      showError(response["error"]);
      return 0;
    }
  }

  Future<WaterIntakeSummaryModel?> getWaterIntakeSummary(
      String duration) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/water/intake/summary/${duration.toUpperCase()}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      WaterIntakeSummaryModel summaryDetails = WaterIntakeSummaryModel();
      summaryDetails = WaterIntakeSummaryModel.fromJson(response["data"]);
      return summaryDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<WaterIntakeSummaryModel?> getWaterIntakeDurationSummary(
      String duration, fromDate, toDate) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/water/intake/summary/${duration.toUpperCase()}/$fromDate/$toDate?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      WaterIntakeSummaryModel summaryDetails = WaterIntakeSummaryModel();
      summaryDetails = WaterIntakeSummaryModel.fromJson(response["data"]);
      return summaryDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  //Weight-Tracking

  Future<bool> submitFirstCheckInDetails(dynamic postData) async {
    dynamic response = await httpPost(
        trackerServiceName,
        'v1/weight/firstCheckIn?requestId=${getRequestId()}',
        {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<TodaysWeightDetailsModel?> getTodaysWeightDetails() async {
    dynamic response = await httpGet(
        trackerServiceName, 'v1/weight/todays?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      TodaysWeightDetailsModel todaysWeightDetails = TodaysWeightDetailsModel();
      todaysWeightDetails = TodaysWeightDetailsModel.fromJson(response["data"]);
      return todaysWeightDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<WeightDetailsModel?> getWeightOfDate(String date) async {
    dynamic response = await httpGet(
        trackerServiceName, 'v1/weight/$date?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      WeightDetailsModel weightDetails = WeightDetailsModel();
      weightDetails = WeightDetailsModel.fromJson(response["data"]);
      return weightDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<bool> updateWeightGoal(dynamic postData) async {
    dynamic response = await httpPut(trackerServiceName,
        'v1/weight/goal?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> addUpdateWeight(dynamic postData) async {
    dynamic response = await httpPost(trackerServiceName,
        'v1/weight/entry?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<bool> updateWeightReminder(dynamic postData) async {
    dynamic response = await httpPut(trackerServiceName,
        'v1/weight/reminder?requestId=${getRequestId()}', {"data": postData},
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      if (response["data"] != null && response["data"]["isUpdated"] != null) {
        if (response["data"]["isUpdated"] == true) {
          return true;
        }
      }
      return false;
    } else {
      showError(response["error"]);
      return false;
    }
  }

  Future<WeightSummaryModel?> getWeightSummary(
      String duration, fromDate, toDate) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/weight/summary/${duration.toUpperCase()}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      WeightSummaryModel summaryDetails = WeightSummaryModel();
      summaryDetails = WeightSummaryModel.fromJson(response["data"]);
      return summaryDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<WeightSummaryModel?> getWeightDurationSummary(
      String duration, fromDate, toDate) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/weight/summary/${duration.toUpperCase()}/$fromDate/$toDate?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      WeightSummaryModel summaryDetails = WeightSummaryModel();
      summaryDetails = WeightSummaryModel.fromJson(response["data"]);
      return summaryDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }
  Future<StepsSummaryModel?> getStepSummary(
      String duration) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/weight/summary/${duration.toUpperCase()}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      StepsSummaryModel summaryDetails = StepsSummaryModel();
      summaryDetails = StepsSummaryModel.fromJson(response["data"]);
      return summaryDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<StepsSummaryModel?> getStepDurationSummary(
      String duration, fromDate, toDate) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/weight/summary/${duration.toUpperCase()}/$fromDate/$toDate?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      StepsSummaryModel summaryDetails = StepsSummaryModel();
      summaryDetails = StepsSummaryModel.fromJson(response["data"]);
      return summaryDetails;
    } else {
      showError(response["error"]);
      return null;
    }
  }

  Future<DidYouKnowModel?> getDidYouKnow(String category) async {
    dynamic response = await httpGet(trackerServiceName,
        'v1/didYouKnow/${category.toUpperCase()}?requestId=${getRequestId()}',
        customHeaders: {"x-user-id": globalUserIdDetails?.userId ?? ""});
    if (response != null && response["success"] == true) {
      DidYouKnowModel didYouKnow = DidYouKnowModel();
      didYouKnow = DidYouKnowModel.fromJson(response["data"]);
      return didYouKnow;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
