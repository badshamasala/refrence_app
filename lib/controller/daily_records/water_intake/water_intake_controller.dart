import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WaterIntakesController extends GetxController {
  Rx<int> waterIntake = 0.obs;
  Rx<bool> enableDailyTarget = true.obs;
  Rx<int> dailyTarget = 3000.obs;
  Rx<DateTime> intakeDate = DateTime.now().obs;

  Rx<bool> enableWaterReminder = false.obs;
  Rx<DateTime> fromTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 7, 0, 0, 0)
      .obs;
  Rx<DateTime> toTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 22, 0, 0, 0)
      .obs;
  RxInt waterIntervalDuration = 1.obs;
  List<Map<String, Object>> waterIntervalDurationList = [
    {
      "text": "15 Minutes",
      "value": 15,
      "selected": false,
    },
    {
      "text": "30 Minutes",
      "value": 30,
      "selected": false,
    },
    {
      "text": "45 Minutes",
      "value": 45,
      "selected": false,
    },
    {
      "text": "1 Hour",
      "value": 60,
      "selected": true,
    },
    {
      "text": "2 Hours",
      "value": 120,
      "selected": false,
    },
    {
      "text": "3 Hours",
      "value": 180,
      "selected": false,
    },
    {
      "text": "4 Hours",
      "value": 240,
      "selected": false,
    }
  ];

  List<Map<String, Object>> summaryDurationList = [
    {
      "text": "Weekly",
      "selected": true,
    },
    {
      "text": "Monthly",
      "selected": false,
    },
    {
      "text": "Yearly",
      "selected": false,
    },
  ];
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  WaterIntakeSummaryModel? summarayDetails;

  Rx<ContentCategories?> recommendedContent = ContentCategories().obs;

  @override
  void onInit() async {
    for (var element in waterIntervalDurationList) {
      if (element["selected"] == true) {
        waterIntervalDuration.value = int.parse(element["value"].toString());
        break;
      }
    }
    super.onInit();
  }

  addUpdateWaterIntake(String action) async {
    if (action == "ADD") {
      waterIntake.value = waterIntake.value + 250;
      await TrackerService().addWaterIntake({
        "intakeDate": DateFormat('yyyy-MM-dd').format(intakeDate.value),
        "intake": 250,
      });
      update(["WaterIntakeDetails", "WaterIntakeIndicator"]);
      getDurationSummary();
    } else {
      if (waterIntake.value - 250 >= 0) {
        await TrackerService().addWaterIntake({
          "intakeDate": DateFormat('yyyy-MM-dd').format(intakeDate.value),
          "intake": -250,
        });
        waterIntake.value = waterIntake.value - 250;
        if (waterIntake.value <= 0) {
          waterIntake.value = 0;
        }
        update(["WaterIntakeDetails", "WaterIntakeIndicator"]);
        getDurationSummary();
      }
    }
    EventsService().sendEvent("Water_Intake_Added", {
      "intakeDate": DateFormat('yyyy-MM-dd').format(intakeDate.value),
      "action": action,
      "waterIntake": waterIntake.value
    });
  }

  setDailyTarget(String action, callApi) async {
    if (enableDailyTarget.value == true) {
      if (action == "ADD") {
        dailyTarget.value = dailyTarget.value + 250;
      } else {
        dailyTarget.value = dailyTarget.value - 250;
        if (dailyTarget.value <= 1000) {
          dailyTarget.value = 1000;
        }
      }
      if (callApi == true) {
        await postDailyTarget();
      }
      update(["DailyTarget", "DailyTargetDetails", "WaterIntakeTargetDetails"]);
    }
  }

  Future<bool> postDailyTarget() async {
    bool isUpdated = await TrackerService().updateWaterDailyTarget({
      "isActive": enableDailyTarget.value,
      "maxLimit": dailyTarget.value,
    });
    if (enableDailyTarget.value == true) {
      EventsService().sendEvent("Water_Intake_Daily_Target_Set", {
        "maxLimit": dailyTarget.value,
      });
    } else {
      EventsService().sendEvent("Water_Intake_Daily_Target_Off", {
        "maxLimit": dailyTarget.value,
      });
    }
    return isUpdated;
  }

  setIntakeDate(String action) async {
    if (action == "NEXT") {
      intakeDate.value = intakeDate.value.add(const Duration(days: 1));
    } else {
      intakeDate.value = intakeDate.value.add(const Duration(days: -1));
    }
    await getIntakeOfDate();
    update(["WaterIntakeDate"]);
  }

  Future<void> getTodaysIntake() async {
    try {
      TodaysWaterIntakeDetailsModel? todaysWaterIntakeDetails =
          await TrackerService().getTodaysWaterIntake();
      if (todaysWaterIntakeDetails != null &&
          todaysWaterIntakeDetails.details != null) {
        intakeDate.value = dateFromTimestamp(
            todaysWaterIntakeDetails.details?.todaysDate ?? 0);
        waterIntake.value = todaysWaterIntakeDetails.details?.todaysIntake ?? 0;

        enableDailyTarget.value =
            todaysWaterIntakeDetails.details?.dailyTarget?.isActive ?? true;
        dailyTarget.value =
            (todaysWaterIntakeDetails.details?.dailyTarget?.maxLimit ?? 0);

        enableWaterReminder.value =
            todaysWaterIntakeDetails.details?.reminder?.isActive ?? true;
        if (todaysWaterIntakeDetails.details?.reminder?.fromTime != null) {
          fromTime.value = dateFromTimestamp(
              todaysWaterIntakeDetails.details?.reminder?.fromTime ?? 0);
        }
        if (todaysWaterIntakeDetails.details?.reminder?.toTime != null) {
          toTime.value = dateFromTimestamp(
              todaysWaterIntakeDetails.details?.reminder?.toTime ?? 0);
        }
        if (todaysWaterIntakeDetails.details?.reminder?.interval != null) {
          waterIntervalDuration.value =
              todaysWaterIntakeDetails.details?.reminder?.interval ?? 15;
        } else {
          for (var element in waterIntervalDurationList) {
            if (element["selected"] == true) {
              waterIntervalDuration.value =
                  int.parse(element["value"].toString());
              break;
            }
          }
        }
        update([
          "WaterIntakeDetails",
          "WaterIntakeIndicator",
          "DailyTarget",
          "DailyTargetDetails",
          "DailyTargetSwitch",
          "WaterReminderSwitch",
          "WaterReminderValues"
        ]);
      }
    } catch (exception) {
      print(exception);
    }
  }

  getIntakeOfDate() async {
    try {
      int? totalIntake = await TrackerService().getWaterIntakeOfDate(
          DateFormat('yyyy-MM-dd').format(intakeDate.value));
      if (totalIntake != null) {
        waterIntake.value = totalIntake;
        update([
          "WaterIntakeDetails",
          "WaterIntakeIndicator",
        ]);
      } else {
        waterIntake.value = 0;
        update([
          "WaterIntakeDetails",
          "WaterIntakeIndicator",
        ]);
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<bool> saveReminder() async {
    bool isUpdated = false;
    try {
      isUpdated = await TrackerService().updateWaterReminder({
        "isActive": enableWaterReminder.value,
        "fromTime": fromTime.value.millisecondsSinceEpoch,
        "toTime": toTime.value.millisecondsSinceEpoch,
        "interval": waterIntervalDuration.value,
      });
      if (isUpdated == true) {
        if (enableWaterReminder.value == true) {
          LocalNotificationService().scheduleWaterReminder(fromTime.value,
              toTime.value, Duration(minutes: waterIntervalDuration.value));
        } else {
          LocalNotificationService().cancelReminder("WATER_INTAKE_TRACKER");
        }
        if (enableWaterReminder.value == true) {
          EventsService().sendEvent("Water_Intake_Reminder_Set", {
            "fromTime": DateFormat('hh:mm a').format(fromTime.value),
            "toTime": DateFormat('hh:mm a').format(toTime.value),
            "interval": waterIntervalDuration.value,
          });
        } else {
          EventsService().sendEvent("Water_Intake_Reminder_Off", {
            "fromTime": DateFormat('hh:mm a').format(fromTime.value),
            "toTime": DateFormat('hh:mm a').format(toTime.value),
            "interval": waterIntervalDuration.value,
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }

  getSummary() async {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    WaterIntakeSummaryModel? response =
        await TrackerService().getWaterIntakeSummary(duration);
    if (response != null) {
      fromDate.value = dateFromTimestamp(response.fromDate ?? 0);
      toDate.value = dateFromTimestamp(response.toDate ?? 0);
      summarayDetails = response;
      update(["WaterReminderSummaryList", "WaterReminderSummary"]);
    }
  }

  getDurationSummary() async {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    WaterIntakeSummaryModel? response = await TrackerService()
        .getWaterIntakeDurationSummary(
            duration,
            DateFormat('yyyy-MM-dd').format(fromDate.value),
            DateFormat('yyyy-MM-dd').format(toDate.value));
    if (response != null) {
      summarayDetails = response;
      update(["WaterReminderSummaryList", "WaterReminderSummary"]);
    }
  }

  setPreviousDate() {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    if (duration == "Weekly") {
      final DateTime sameWeekDayOfLastWeek =
          fromDate.value.subtract(const Duration(days: 7));
      fromDate.value = findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
      toDate.value = findLastDateOfTheWeek(sameWeekDayOfLastWeek);
    } else if (duration == "Monthly") {
      fromDate.value = DateTime(toDate.value.year, toDate.value.month - 1, 1);
      toDate.value = DateTime(fromDate.value.year, fromDate.value.month + 1, 0);
    } else if (duration == "Yearly") {
      fromDate.value = DateTime(fromDate.value.year - 1, 1, 1);
      toDate.value = DateTime(fromDate.value.year, 12, 31);
    }
    update(["WaterReminderSummaryList"]);
    getDurationSummary();
  }

  setNextDate() {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();

    DateTime maxDate = DateTime.now();
    bool doUpdate = false;
    if (duration == "Weekly") {
      maxDate = findLastDateOfTheWeek(maxDate);
      final DateTime sameWeekDayOfNextWeek =
          fromDate.value.add(const Duration(days: 7));
      if (sameWeekDayOfNextWeek.isBefore(maxDate)) {
        fromDate.value = findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
        toDate.value = findLastDateOfTheWeek(sameWeekDayOfNextWeek);
        doUpdate = true;
      }
    } else if (duration == "Monthly") {
      maxDate = DateTime(maxDate.year, maxDate.month + 1, 1);
      final DateTime nextMonthFirstDate =
          DateTime(fromDate.value.year, fromDate.value.month + 1, 1);
      if (nextMonthFirstDate.isBefore(maxDate)) {
        fromDate.value =
            DateTime(fromDate.value.year, fromDate.value.month + 1, 1);
        toDate.value =
            DateTime(fromDate.value.year, fromDate.value.month + 1, 0);
        doUpdate = true;
      }
    } else if (duration == "Yearly") {
      maxDate = DateTime(maxDate.year + 1, 1, 0);
      final DateTime nextYearFirstDate =
          DateTime(fromDate.value.year + 1, 1, 0);
      if (nextYearFirstDate.isBefore(maxDate)) {
        fromDate.value = DateTime(fromDate.value.year + 1, 1, 1);
        toDate.value = DateTime(fromDate.value.year, 12, 31);
        doUpdate = true;
      }
    }
    if (doUpdate == true) {
      getDurationSummary();
      update(["WaterReminderSummaryList"]);
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  Future<void> getRecommendedContent() async {
    try {
      ContentCategories? response = await GrowService()
          .getRecommendedContent(globalUserIdDetails?.userId!, "WATER");
      if (response != null &&
          response.content != null &&
          response.content!.isNotEmpty) {
        recommendedContent.value = response;
      } else {
        recommendedContent.value = null;
      }
    } finally {
      update(['recommendedContent']);
    }
  }
}
