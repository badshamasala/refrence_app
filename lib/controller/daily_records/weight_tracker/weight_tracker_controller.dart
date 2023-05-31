import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeightTrackerController extends GetxController {
  List<int> firstScrollValues = [];
  List<String> secondScrollValues = [];

  FixedExtentScrollController fixedExtentScrollControllerFirst =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController fixedExtentScrollControllerSecond =
      FixedExtentScrollController(initialItem: 0);

  List<String> popUpUnitList = ["KG", "LBS"];
  String selectedPopUpUnit = "KG";
  String selectedPopUpValue = "";

  setFixedExtentScrollController(String unit, String weightOfDate) {
    int integerPart = 0;
    String fractionPart = "";
    if (unit.toUpperCase() == "KG") {
      firstScrollValues.clear();
      for (var index = 20; index <= 200; index++) {
        firstScrollValues.add(index);
      }
      secondScrollValues = List.generate(10, (index) => (index).toString());
    } else if (unit.toUpperCase() == "LBS") {
      firstScrollValues.clear();
      for (var index = 44; index <= 440; index++) {
        firstScrollValues.add(index);
      }
      secondScrollValues = List.generate(10, (index) => (index).toString());
    }
    selectedPopUpUnit = unit.toUpperCase();
    selectedPopUpValue = weightOfDate;
    if (selectedPopUpValue.isNotEmpty) {
      if (selectedPopUpValue.contains(".")) {
        integerPart = int.parse(selectedPopUpValue.split(".")[0]);
        fractionPart = selectedPopUpValue.split(".")[1];
      } else {
        integerPart = int.parse(selectedPopUpValue);
      }
    }
    int firstScrollIndex = firstScrollValues.indexOf(integerPart);
    if (firstScrollIndex == -1) {
      firstScrollIndex = 0;
    }
    int secondScrollIndex = secondScrollValues.indexOf(fractionPart);
    if (secondScrollIndex == -1) {
      secondScrollIndex = 0;
    }
    fixedExtentScrollControllerFirst =
        FixedExtentScrollController(initialItem: firstScrollIndex);
    fixedExtentScrollControllerSecond =
        FixedExtentScrollController(initialItem: secondScrollIndex);
    update(["UnitInfoForPopUp"]);
    update(["ModalPopupScrollValues"]);
  }

  setSelectedPopUpValue(int firstIndex, int secondIndex) {
    if (firstIndex < firstScrollValues.length &&
        secondIndex < secondScrollValues.length) {
      selectedPopUpValue =
          "${firstScrollValues[firstIndex]}.${secondScrollValues[secondIndex]}";
    }
    update(["ModalPopupScrollValues"]);
  }

  convertWeight(String fromUnit, String toUnit) {
    if (selectedPopUpValue.isNotEmpty && fromUnit != toUnit) {
      if (fromUnit.toUpperCase() == "KG") {
        selectedPopUpValue =
            (double.parse(selectedPopUpValue) * 2.205).toStringAsFixed(1);
      } else {
        selectedPopUpValue =
            (double.parse(selectedPopUpValue) / 2.205).toStringAsFixed(1);
      }
      setFixedExtentScrollController(selectedPopUpUnit, selectedPopUpValue);
    }
  }
}
