import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeightDetailsController extends GetxController {
  double weightOfDate = 0;
  DateTime checkInDate = DateTime.now();
  String defaultWeightUnit = "KG";
  String defaultHeightUnit = "FT";
  String? height = "";

  bool enableWeightGoal = true;
  double targetWeight = 72.0;
  String weightGoalUnit = "KG";

  bool enableReminder = false;
  DateTime reminderTime = DateTime.now();
  bool reminderDetailsChanged = false;
  List<Map<String, Object>> reminderDaysList = [
    {
      "text": "M",
      "value": "MON",
      "selected": false,
    },
    {
      "text": "T",
      "value": "TUE",
      "selected": false,
    },
    {
      "text": "W",
      "value": "WED",
      "selected": false,
    },
    {
      "text": "T",
      "value": "THU",
      "selected": false,
    },
    {
      "text": "F",
      "value": "FRI",
      "selected": false,
    },
    {
      "text": "S",
      "value": "SAT",
      "selected": false,
    },
    {
      "text": "S",
      "value": "SUN",
      "selected": false,
    },
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
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  WeightSummaryModel? summarayDetails;
  DidYouKnowModel? didYouKnowDetails;

  double bmiValue = 0;
  String weightRange = "";
  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;

  List bmiList = [
    {"range": "<18.5", "value": "Under Weight", "color": "#75C8E1"},
    {"range": "18.5-24.9", "value": "Normal Weight", "color": "#D5ECA5"},
    {"range": "25-29.9", "value": "Over Weight", "color": "#FDE47E"},
    {"range": "30-39.9", "value": "Obesity", "color": "#FAB789"},
    {"range": ">40", "value": "Extreme Obese", "color": "#DFBEEB"},
  ];

  Rx<ContentCategories?> recommendedContent = ContentCategories().obs;

  @override
  void onInit() async {
    fromDate = toDate.subtract(const Duration(days: 7));
    toDate = DateTime.now();
    reminderTime = DateTime(toDate.year, toDate.month, toDate.day, 10, 0, 0);
    super.onInit();
  }

  Future<void> getUserDetails() async {
    userDetails.value = await HiveService().getUserDetails();
  }

  addUpdateWeight(double weight, String unit) async {
    weightOfDate = weight;
    await TrackerService().addUpdateWeight({
      "checkInDate": DateFormat('yyyy-MM-dd').format(checkInDate),
      "unit": unit.toUpperCase(),
      "weight": weightOfDate,
    });
    update(["WeightInputDetails"]);
    EventsService().sendEvent("Weight_Tracker_Added", {
      "checkInDate": DateFormat('yyyy-MM-dd').format(checkInDate),
      "unit": unit.toUpperCase(),
      "weight": weightOfDate
    });
    getWeightSummary();
  }

  setWeightGoal(double weight, String unit, bool callApi) async {
    targetWeight = weight;
    weightGoalUnit = unit;
    if (enableWeightGoal == true && callApi == true) {
      await postWeightGoal();
    }
    update(["WeightGoalInputDetails", "WeightGoalDetails"]);
  }

  Future<bool> postWeightGoal() async {
    bool isUpdated = await TrackerService().updateWeightGoal({
      "isActive": enableWeightGoal,
      "targetWeight": targetWeight,
      "unit": weightGoalUnit.toUpperCase(),
    });
    if (enableWeightGoal == true) {
      EventsService().sendEvent("Weight_Tracker_Goal_Set",
          {"targetWeight": targetWeight, "unit": weightGoalUnit.toUpperCase()});
    } else {
      EventsService().sendEvent("Weight_Tracker_Goal_Off",
          {"targetWeight": targetWeight, "unit": weightGoalUnit.toUpperCase()});
    }
    return isUpdated;
  }

  setCheckInDate(String action) async {
    if (action == "NEXT") {
      checkInDate = checkInDate.add(const Duration(days: 1));
    } else {
      checkInDate = checkInDate.add(const Duration(days: -1));
    }
    await getWeightOfDate();
    update(["WeightCheckInDate"]);
  }

  Future<void> getTodaysWeightDetails() async {
    try {
      TodaysWeightDetailsModel? response =
          await TrackerService().getTodaysWeightDetails();
      if (response != null && response.details != null) {
        double latestWeight = response.details?.latestWeight?.weight ?? 0;
        checkInDate = dateFromTimestamp(response.details?.todaysDate ?? 0);
        if (response.details?.todaysWeight != null &&
            response.details!.todaysWeight! > 0) {
          weightOfDate = response.details?.todaysWeight ?? 0;
        } else {
          weightOfDate = response.details?.latestWeight?.weight ?? 0;
        }
        defaultWeightUnit = response.details?.defaultUnit ?? "KG";
        defaultHeightUnit = response.details?.height?.unit ?? "FEET";
        height = response.details?.height?.value ?? "";
        enableWeightGoal = response.details?.weightGoal?.isActive ?? true;
        targetWeight = (response.details?.weightGoal?.targetWeight ?? 0);
        enableReminder = response.details?.reminder?.isActive ?? true;
        if (response.details?.reminder?.repeat != null &&
            response.details!.reminder!.repeat!.isNotEmpty) {
          for (var element in reminderDaysList) {
            if (response.details?.reminder?.repeat!
                    .contains(element["value"].toString()) ==
                true) {
              element["selected"] = true;
            }
          }
        }
        reminderTime =
            dateFromTimestamp(response.details?.reminder?.reminderTime ?? 0);

        calculateBMI(latestWeight,
            (height != null && height!.isNotEmpty) ? height! : "");
      }

      update([
        "WeightReminderValues",
        "WeightInputDetails",
        "WeightCheckInDate",
        "WeightGoalSwitch",
        "WeightGoalInputDetails",
        "WeightGoalDetails",
        "WeightReminderSwitch",
        "WeightReminderValues"
            "WeightReminderTime"
      ]);
    } catch (exception) {
      print(exception);
    }
  }

  getWeightOfDate() async {
    try {
      WeightDetailsModel? weightDetails = await TrackerService()
          .getWeightOfDate(DateFormat('yyyy-MM-dd').format(checkInDate));
      if (weightDetails != null) {
        weightOfDate = weightDetails.weight ?? 0;
        defaultWeightUnit = weightDetails.defaultUnit ?? "KG";
        update([
          "WeightInputDetails",
        ]);
      } else {
        weightOfDate = 0;
        update([
          "WeightInputDetails",
        ]);
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<bool> saveReminder() async {
    bool isUpdated = false;
    reminderDetailsChanged = false;
    update(["WeightReminderValues"]);
    try {
      List<String> repeatList = [];
      for (var element in reminderDaysList) {
        if (element["selected"] == true) {
          repeatList.add(element["value"].toString());
        }
      }
      if (repeatList.isEmpty && enableReminder == true) {
        showGetSnackBar(
            "Please select repeat days!", SnackBarMessageTypes.Success);
        return false;
      }
      isUpdated = await TrackerService().updateWeightReminder({
        "isActive": enableReminder,
        "repeat": repeatList,
        "reminderTime": reminderTime.millisecondsSinceEpoch,
      });

      if (isUpdated == true) {
        if (repeatList.isNotEmpty && enableReminder == true) {
          LocalNotificationService().scheduleWeightTracker(
              repeatList, reminderTime.hour, reminderTime.minute);
        } else if (enableReminder == false) {
          LocalNotificationService().cancelReminder("WEIGHT_TRACKER");
        }
        if (enableWeightGoal == true) {
          EventsService().sendEvent("Weight_Tracker_Reminder_Set", {
            "repeat": repeatList,
            "reminderTime": DateFormat('hh:mm a').format(reminderTime)
          });
        } else {
          EventsService().sendEvent("Weight_Tracker_Reminder_Off", {
            "repeat": repeatList,
            "reminderTime": DateFormat('hh:mm a').format(reminderTime)
          });
        }
      }
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }

  Future<void> getWeightSummary() async {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    WeightSummaryModel? response = await TrackerService().getWeightSummary(
        duration,
        DateFormat('yyyy-MM-dd').format(fromDate),
        DateFormat('yyyy-MM-dd').format(toDate));
    if (response != null) {
      summarayDetails = response;
      fromDate = dateFromTimestamp(response.fromDate ?? 0);
      toDate = dateFromTimestamp(response.toDate ?? 0);
      update(["WeightSummaryDurationList", "WeightSummary"]);
    }
  }

  getWeightDurationSummary() async {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    WeightSummaryModel? response = await TrackerService()
        .getWeightDurationSummary(
            duration,
            DateFormat('yyyy-MM-dd').format(fromDate),
            DateFormat('yyyy-MM-dd').format(toDate));
    if (response != null) {
      summarayDetails = response;
      update(["WeightSummaryDurationList", "WeightSummary"]);
    }
  }

  setPreviousDate() {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    if (duration == "Weekly") {
      final DateTime sameWeekDayOfLastWeek =
          fromDate.subtract(const Duration(days: 7));
      fromDate = findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
      toDate = findLastDateOfTheWeek(sameWeekDayOfLastWeek);
    } else if (duration == "Monthly") {
      fromDate = DateTime(toDate.year, toDate.month - 1, 1);
      toDate = DateTime(fromDate.year, fromDate.month + 1, 0);
    } else if (duration == "Yearly") {
      fromDate = DateTime(fromDate.year - 1, 1, 1);
      toDate = DateTime(fromDate.year, 12, 31);
    }
    update(["WeightSummaryDurationList"]);
    getWeightDurationSummary();
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
          fromDate.add(const Duration(days: 7));
      if (sameWeekDayOfNextWeek.isBefore(maxDate)) {
        fromDate = findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
        toDate = findLastDateOfTheWeek(sameWeekDayOfNextWeek);
        doUpdate = true;
      }
    } else if (duration == "Monthly") {
      maxDate = DateTime(maxDate.year, maxDate.month + 1, 1);
      final DateTime nextMonthFirstDate =
          DateTime(fromDate.year, fromDate.month + 1, 1);
      if (nextMonthFirstDate.isBefore(maxDate)) {
        fromDate = DateTime(fromDate.year, fromDate.month + 1, 1);
        toDate = DateTime(fromDate.year, fromDate.month + 1, 0);
        doUpdate = true;
      }
    } else if (duration == "Yearly") {
      maxDate = DateTime(maxDate.year + 1, 1, 0);
      final DateTime nextYearFirstDate = DateTime(fromDate.year + 1, 1, 0);
      if (nextYearFirstDate.isBefore(maxDate)) {
        fromDate = DateTime(fromDate.year + 1, 1, 1);
        toDate = DateTime(fromDate.year, 12, 31);
        doUpdate = true;
      }
    }
    if (doUpdate == true) {
      getWeightDurationSummary();
      update(["WeightSummaryDurationList"]);
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  calculateBMI(double latestWeight, String height) {
    bmiValue = 0;
    if (height.isNotEmpty) {
      double weightInKG = latestWeight;
      if (defaultWeightUnit.toUpperCase() == "LBS") {
        weightInKG = weightInKG / 2.205;
      }
      double heightInMeter = 0;
      if (defaultHeightUnit.toUpperCase() == "FT") {
        List<String> list = height.split(".");
        int inches = int.parse(list[0]) * 12;
        inches += int.parse(list[1]);
        heightInMeter = inches / 39.37;
      } else if (defaultHeightUnit.toUpperCase() == "CM") {
        heightInMeter = double.parse(height) / 100;
      }
      if (heightInMeter > 0) {
        bmiValue = weightInKG / (heightInMeter * heightInMeter);
      }
    }

    if (bmiValue < 18.5) {
      weightRange = "Under weight";
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      weightRange = "Normal";
    } else if (bmiValue >= 25 && bmiValue < 30) {
      weightRange = "Over weight";
    } else if (bmiValue >= 30 && bmiValue < 40) {
      weightRange = "Obese";
    } else {
      weightRange = "Extreme Obese";
    }

    update(["BMIDetails"]);
  }

  getDidYouKnow() async {
    DidYouKnowModel? response = await TrackerService().getDidYouKnow("WEIGHT");
    if (response != null && response.details != null) {
      didYouKnowDetails = response;
      update(["WeightDidYouKnow"]);
    }
  }

  Future<void> getRecommendedContent() async {
    try {
      ContentCategories? response = await GrowService()
          .getRecommendedContent(globalUserIdDetails?.userId!, "WEIGHT");
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
