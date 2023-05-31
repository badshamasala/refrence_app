import 'package:aayu/model/model.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HealthTrackerController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<HealthTrackerUnitsModel?> healthTrackerUnitsData =
      HealthTrackerUnitsModel().obs;
  Rx<UserHealthTrackingModel?> userHealthTrackingDetails =
      UserHealthTrackingModel().obs;

  DateTime selectedDate = DateTime.now();
  DateTime initialSelectedDate = DateTime.now();
  DateTime minSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DatePickerController datePickerController = DatePickerController();

  String? userAnswer = "";
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController fractionExtentScrollController =
      FixedExtentScrollController(initialItem: 0);
  bool dateChanged = false;

  Future<void> getHealthTrackerUnits(String parameter) async {
    try {
      isLoading(true);
      HealthTrackerUnitsModel? response = await TrackerService()
          .getHealthTrackerUnits(globalUserIdDetails!.userId!, parameter);
      if (response != null &&
          response.healthTrackerUnits!.units != null &&
          response.healthTrackerUnits!.units!.isNotEmpty) {
        if (response.healthTrackerUnits!.units!.length == 1) {
          response.healthTrackerUnits!.units!.first!.selected = true;
        } else {
          if (response.healthTrackerUnits!.units!
                  .firstWhereOrNull((element) => element!.selected == true) ==
              null) {
            response.healthTrackerUnits!.units!.first!.selected = true;
          }
        }
        healthTrackerUnitsData.value = response;
      } else {
        healthTrackerUnitsData.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> getUserHealthTrackingDetails(String parameter) async {
    try {
      isLoading(true);
      UserHealthTrackingModel? response = await TrackerService()
          .getUserHealthTrackingDetails(
              globalUserIdDetails!.userId!, parameter);
      if (response != null &&
          response.healthTracking != null &&
          response.healthTracking!.isNotEmpty) {
        userHealthTrackingDetails.value = response;
      } else {
        userHealthTrackingDetails.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
      update();
    }
  }

  setMinimumDate(DateTime changedDate) {
    minSelectedDate =
        DateTime(changedDate.year, changedDate.month, changedDate.day, 0, 0, 0);
  }

  setSelectedDate(DateTime changedDate) {
    if (changedDate.compareTo(minSelectedDate) >= 0) {
      selectedDate = changedDate;
      dateChanged = true;
      if (userHealthTrackingDetails.value != null) {
        for (var element in userHealthTrackingDetails.value!.healthTracking!) {
          if (DateFormat.yMMMd().format(selectedDate).toString() ==
              DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                element!.onDate!,
              ))) {
            userAnswer = element.value;
            for (var iterator
                in healthTrackerUnitsData.value!.healthTrackerUnits!.units!) {
              if (iterator!.unit == element.unit) {
                iterator.selected = true;
              } else {
                iterator.selected = false;
              }
            }
            break;
          }
        }
      }
    }
    update();
  }

  updateTrackerValue() async {
    bool isSubmitted = false;
    HealthTrackerUnitsModelHealthTrackerUnitsUnits? selectedUnit =
        healthTrackerUnitsData.value!.healthTrackerUnits!.units!
            .firstWhereOrNull((element) => element!.selected == true);
    if (selectedUnit != null) {
      dynamic postData = {
        "onDate": selectedDate.toString(),
        "parameter":
            healthTrackerUnitsData.value!.healthTrackerUnits!.parameter,
        "value": userAnswer,
        "unit": selectedUnit.unit,
        "source": "Manual"
      };
      isSubmitted = await TrackerService()
          .addHealthTracker(globalUserIdDetails!.userId!, postData);
      if (isSubmitted == true) {
        await getUserHealthTrackingDetails(
            healthTrackerUnitsData.value!.healthTrackerUnits!.parameter!);
      }
    }
    return isSubmitted;
  }
}
