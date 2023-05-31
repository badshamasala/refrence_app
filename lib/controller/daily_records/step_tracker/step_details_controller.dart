import 'package:aayu/services/tracker.service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/trackers/steps_tracker/steps_summary_modal.dart';

class StepsDetailsController extends GetxController {
  double targetWeight = 72.0;

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
  Rx<dynamic> selectedIndex = "Weekly".obs;

  changeIndex(index) {
    selectedIndex.value = summaryDurationList[index]["text"];
    print(selectedIndex);
    update();
  }

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  StepsSummaryModel? summarayDetails;

  DateTime dateFromTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp,
    );
  }

  getStepSummary() async {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    StepsSummaryModel? response =
        await TrackerService().getStepSummary(duration);
    if (response != null) {
      summarayDetails = response;
      fromDate = dateFromTimestamp(response.fromDate ?? 0);
      toDate = dateFromTimestamp(response.toDate ?? 0);
      update(["StepSummaryDurationList", "StepSummary"]);
    }
  }

  getStepDurationSummary() async {
    String duration = summaryDurationList
        .firstWhere((element) => element["selected"] == true)["text"]
        .toString();
    StepsSummaryModel? response = await TrackerService().getStepDurationSummary(
        duration,
        DateFormat('yyyy-MM-dd').format(fromDate),
        DateFormat('yyyy-MM-dd').format(toDate));
    if (response != null) {
      summarayDetails = response;
      update(["StepSummaryDurationList", "StepSummary"]);
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
    update(["StepSummaryDurationList"]);
    getStepDurationSummary();
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
      getStepDurationSummary();
      update(["StepSummaryDurationList"]);
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
}
