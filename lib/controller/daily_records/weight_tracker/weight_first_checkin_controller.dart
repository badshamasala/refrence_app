import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeightFirstCheckInController extends GetxController {
  List<String> genderList = ["Male", "Female", "Non-Binary"];
  String selectedGender = "Male";

  List<String> heightUnitList = ["FT", "CM"];
  String selectedHeightUnit = "FT";
  String selectedHeight = "";

  List<String> weightUnitList = ["KG", "LBS"];
  String selectedWeightUnit = "KG";
  String selectedWeight = "";

  List<int> firstScrollValues = [];
  List<String> secondScrollValues = [];

  FixedExtentScrollController fixedExtentScrollControllerFirst =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController fixedExtentScrollControllerSecond =
      FixedExtentScrollController(initialItem: 0);

  List<String> popUpUnitList = ["FT", "CM"];
  String selectedPopUpUnit = "";
  String selectedPopUpValue = "";

  double bmiValue = 0;
  bool bmiCalculated = false;
  String weightRange = "";
  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;

  getUserDetails() async {
    userDetails.value = await HiveService().getUserDetails();
  }

  setUnitsForPopup(String type) {
    if (type == "HEIGHT") {
      popUpUnitList = ["FT", "CM"];
      selectedPopUpUnit = selectedHeightUnit;
      selectedPopUpValue = selectedHeight;
      setFixedExtentScrollController(type, selectedHeightUnit, selectedHeight);
    } else if (type == "WEIGHT") {
      popUpUnitList = ["KG", "LBS"];
      selectedPopUpUnit = selectedWeightUnit;
      selectedPopUpValue = selectedWeight;
      setFixedExtentScrollController(type, selectedWeightUnit, selectedWeight);
    }
    update(["UnitInfoForPopUp"]);
  }

  setFixedExtentScrollController(
      String type, String unit, String selectedValue) {
    int integerPart = 0;
    String fractionPart = "";
    if (type == "HEIGHT") {
      if (unit == "FT") {
        firstScrollValues = List.generate(8, (index) => index + 1);
        secondScrollValues = List.generate(12, (index) => (index).toString());
      } else if (unit == "CM") {
        firstScrollValues.clear();
        for (var index = 30; index <= 274; index++) {
          firstScrollValues.add(index);
        }
        secondScrollValues = List.generate(10, (index) => (index).toString());
      }
    } else if (type == "WEIGHT") {
      if (unit == "KG") {
        firstScrollValues.clear();
        for (var index = 20; index <= 200; index++) {
          firstScrollValues.add(index);
        }
        secondScrollValues = List.generate(10, (index) => (index).toString());
      } else if (unit == "LBS") {
        firstScrollValues.clear();
        for (var index = 44; index <= 442; index++) {
          firstScrollValues.add(index);
        }
        secondScrollValues = List.generate(10, (index) => (index).toString());
      }
    }

    update(["ModalPopupScrollValues"]);

    if (selectedValue.isNotEmpty) {
      if (selectedValue.contains(".")) {
        integerPart = int.parse(selectedValue.split(".")[0]);
        fractionPart = selectedValue.split(".")[1];
      } else {
        integerPart = int.parse(selectedValue);
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

  setValues(String type, String unit) {
    if (type == "HEIGHT") {
      selectedHeight = selectedPopUpValue;
      selectedHeightUnit = unit;
      update(["HeightInfo"]);
    } else if (type == "WEIGHT") {
      selectedWeight = selectedPopUpValue;
      selectedWeightUnit = unit;
      update(["WeightInfo"]);
    }
  }

  convertWeight(String fromUnit, String toUnit) {
    if (selectedWeight.isNotEmpty && fromUnit != toUnit) {
      if (fromUnit == "KG") {
        selectedWeight =
            (double.parse(selectedWeight) * 2.205).toStringAsFixed(1);
      } else {
        selectedWeight =
            (double.parse(selectedWeight) / 2.205).toStringAsFixed(1);
      }
    }
  }

  convertHeight(String fromUnit, String toUnit) {
    if (selectedHeight.isNotEmpty && fromUnit != toUnit) {
      if (fromUnit == "FT") {
        List<String> list = selectedHeight.split(".");
        int inches = int.parse(list[0]) * 12;
        inches += int.parse(list[1]);

        selectedHeight = (inches * 2.54).toStringAsFixed(1);
      } else {
        double inches = double.parse(selectedHeight) / 2.54;
        String convertedValue =
            "${(inches / 12).floor()}.${(inches % 12).floor()}";
        // String convertedValue =
        //     (double.parse(selectedHeight) / 30.48).toStringAsFixed(2);
        if (convertedValue.contains(".")) {
          if (convertedValue.toString().split(".")[1] == "10" ||
              convertedValue.toString().split(".")[1] == "11") {
            selectedHeight = convertedValue;
          } else {
            selectedHeight = double.parse(convertedValue).toStringAsFixed(1);
          }
        } else {
          selectedHeight = double.parse(convertedValue).toStringAsFixed(1);
        }
      }
    }
  }

  convertPoupUpValues(String type, String fromUnit, String toUnit) {
    if (type == "HEIGHT") {
      if (selectedPopUpValue.isNotEmpty && fromUnit != toUnit) {
        if (fromUnit == "FT") {
          List<String> list = selectedPopUpValue.split(".");
          int inches = int.parse(list[0]) * 12;
          inches += int.parse(list[1]);
          selectedPopUpValue = (inches * 2.54).toStringAsFixed(1);
        } else {
          double inches = double.parse(selectedPopUpValue) / 2.54;
          String convertedValue =
              "${(inches / 12).floor()}.${(inches % 12).floor()}";

          if (convertedValue.contains(".")) {
            if (convertedValue.toString().split(".")[1] == "10" ||
                convertedValue.toString().split(".")[1] == "11") {
              selectedPopUpValue = convertedValue;
            } else {
              selectedPopUpValue =
                  double.parse(convertedValue).toStringAsFixed(1);
            }
          } else {
            selectedPopUpValue =
                double.parse(convertedValue).toStringAsFixed(1);
          }
        }
        setFixedExtentScrollController(
            type, selectedPopUpUnit, selectedPopUpValue);
      }
    } else if (type == "WEIGHT") {
      if (selectedPopUpValue.isNotEmpty && fromUnit != toUnit) {
        if (fromUnit == "KG") {
          selectedPopUpValue =
              (double.parse(selectedPopUpValue) * 2.205).toStringAsFixed(1);
        } else {
          selectedPopUpValue =
              (double.parse(selectedPopUpValue) / 2.205).toStringAsFixed(1);
        }
        setFixedExtentScrollController(
            type, selectedPopUpUnit, selectedPopUpValue);
      }
    }
  }

  calculateBMI() {
    bmiCalculated = true;
    bmiValue = 0;
    if (selectedWeight.isNotEmpty && selectedHeight.isNotEmpty) {
      double weightInKG = double.parse(selectedWeight);
      if (selectedWeightUnit == "LBS") {
        weightInKG = weightInKG / 2.205;
      }
      double heightInMeter = 0;
      if (selectedHeightUnit == "FT") {
        List<String> list = selectedHeight.split(".");
        int inches = int.parse(list[0]) * 12;
        inches += int.parse(list[1]);
        heightInMeter = inches / 39.37;
      } else if (selectedHeightUnit == "CM") {
        heightInMeter = double.parse(selectedHeight) / 100;
      }
      bmiValue = weightInKG / (heightInMeter * heightInMeter);
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
  }

  Future<bool> submitFirstCheckInDetails() async {
    bool isUpdated = false;
    try {
      dynamic postData = {
        "height": {
          "unit": selectedHeightUnit.toUpperCase(),
          "value": selectedHeight
        },
        "weight": {
          "unit": selectedWeightUnit.toUpperCase(),
          "value": double.parse(selectedWeight)
        }
      };
      isUpdated = await TrackerService().submitFirstCheckInDetails(postData);
    } catch (e) {
      print(e);
    }
    return isUpdated;
  }
}
