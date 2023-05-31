import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepGoalController extends GetxController {
  List<int> firstScrollValues = [];
  int targetStep = 1000;
  FixedExtentScrollController fixedExtentScrollControllerFirst =
      FixedExtentScrollController(initialItem: 0);

  String selectedPopUpValue = "";

 setFixedExtentScrollController(String stepOfDate) {
  firstScrollValues.clear();
  for (var index = 500; index <= 50000; index += 100) {
    firstScrollValues.add(index);
  }

  selectedPopUpValue = stepOfDate;

  int firstScrollIndex = firstScrollValues.indexOf(int.parse(stepOfDate));
  if (firstScrollIndex == -1) {
    firstScrollIndex = 0;
  }

  fixedExtentScrollControllerFirst =
      FixedExtentScrollController(initialItem: firstScrollIndex);
  update(["ModalPopupScrollValues"]);
}


  setSelectedPopUpValue(int firstIndex, int secondIndex) {
    if (firstIndex < firstScrollValues.length) {
      selectedPopUpValue = "${firstScrollValues[firstIndex]}";
    }
    update(["ModalPopupScrollValues"]);
  }

  
  setStepGoal(int step, bool callApi) async {
    targetStep = step;
    update(["StepGoalInputDetails"]);
  }
}
