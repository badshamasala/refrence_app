// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:aayu/controller/consultant/nutrition/health_tracker_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HealthTrackerUnitOptions extends StatelessWidget {
  final HealthTrackerController healthTrackerController;
  const HealthTrackerUnitOptions({
    Key? key,
    required this.healthTrackerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildUnits(context),
          SizedBox(
            height: 26.h,
          ),
          showNormalRange(healthTrackerController),
          showInputPicker(context),
        ],
      ),
    );
  }

  buildUnits(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          healthTrackerController
              .healthTrackerUnitsData.value!.healthTrackerUnits!.units!.length,
          (index) {
            bool isSelected = healthTrackerController.healthTrackerUnitsData
                .value!.healthTrackerUnits!.units![index]!.selected!;

            String unitText = healthTrackerController.healthTrackerUnitsData
                .value!.healthTrackerUnits!.units![index]!.displayUnit!;

            return InkWell(
              onTap: () {
                for (var element in healthTrackerController
                    .healthTrackerUnitsData.value!.healthTrackerUnits!.units!) {
                  element!.selected = false;
                }
                healthTrackerController.healthTrackerUnitsData.value!
                    .healthTrackerUnits!.units![index]!.selected = true;

                healthTrackerController.update();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.w),
                    color: (isSelected == true)
                        ? AppColors.primaryColor
                        : AppColors.primaryLabelColor.withOpacity(0.2)),
                constraints: BoxConstraints(minWidth: 100.w),
                child: Text(
                  unitText.toString(),
                  textAlign: TextAlign.center,
                  style: (isSelected == true)
                      ? TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontFamily: "Circular Std",
                        )
                      : TextStyle(
                          color: AppColors.primaryLabelColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontFamily: "Circular Std",
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showNormalRange(HealthTrackerController healthTrackerController) {
    HealthTrackerUnitsModelHealthTrackerUnitsUnits? selectedUnit;
    HealthTrackerUnitsModelHealthTrackerUnitsUnitsRanges? normalRange;
    for (var element in healthTrackerController
        .healthTrackerUnitsData.value!.healthTrackerUnits!.units!) {
      if (element!.selected == true) {
        selectedUnit = element;
        break;
      }
    }

    bool showNormalRangeDetails = false;
    if (selectedUnit != null) {
      normalRange = selectedUnit.ranges!
          .firstWhereOrNull((element) => element!.range == "NORMAL");
      if (normalRange != null && normalRange.low != null) {
        showNormalRangeDetails = true;
      }
    }

    return (showNormalRangeDetails == false)
        ? const Offstage()
        : Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              Icon(
                Icons.help,
                size: 15.w,
                color: AppColors.blueGreyAssessmentColor,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                "Normal range - ${normalRange?.low ?? 0} to ${normalRange?.high ?? 0} ${selectedUnit!.unit}",
                style: TextStyle(
                  color: AppColors.blueGreyAssessmentColor,
                  fontFamily: 'Circular Std',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          );
  }

  showInputPicker(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    HealthTrackerUnitsModelHealthTrackerUnitsUnits? selectedUnit;
    for (var element in healthTrackerController
        .healthTrackerUnitsData.value!.healthTrackerUnits!.units!) {
      if (element!.selected == true) {
        selectedUnit = element;
        break;
      }
    }

    return Container(
      height: 200,
      padding: EdgeInsets.zero,
      child: (selectedUnit!.unitPicker == "SINGLE")
          ? buildSingleValuePicker(context, selectedUnit)
          : buildDoubleValuePicker(context, selectedUnit),
    );
  }

  buildSingleValuePicker(BuildContext context,
      HealthTrackerUnitsModelHealthTrackerUnitsUnits selectedUnit) {
    List<int> firstUnitValues = [];
    int minRange = selectedUnit.ranges!
        .firstWhere((element) => element!.range == "LOW")!
        .low!
        .toInt();
    int minRangeHigh = selectedUnit.ranges!
        .firstWhere((element) => element!.range == "LOW")!
        .high!
        .toInt();
    int maxRange = selectedUnit.ranges!
        .firstWhere((element) => element!.range == "VERY-HIGH")!
        .high!
        .toInt();

    for (int index = minRange; index <= maxRange; index++) {
      firstUnitValues.add(index);
    }

    if (healthTrackerController.userAnswer != null &&
        healthTrackerController.userAnswer!.isNotEmpty) {
      if (healthTrackerController.dateChanged == true) {
        Future.delayed(Duration.zero, () {
          healthTrackerController.fixedExtentScrollController =
              FixedExtentScrollController(
                  initialItem: firstUnitValues.indexOf(
                      double.parse(healthTrackerController.userAnswer!)
                          .toInt()));
        });
        healthTrackerController.dateChanged = false;
      }
    } else {
      if (healthTrackerController.dateChanged == true) {
        Future.delayed(Duration.zero, () {
          healthTrackerController.fixedExtentScrollController.jumpToItem(
            firstUnitValues.indexOf(minRangeHigh),
          );
        });
        healthTrackerController.dateChanged = false;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController:
                healthTrackerController.fixedExtentScrollController,
            onSelectedItemChanged: (int index) {
              healthTrackerController.userAnswer =
                  firstUnitValues[index].toString();
              healthTrackerController.update();
            },
            children: List.generate(firstUnitValues.length, (index) {
              return Center(
                child: Text(
                  '${firstUnitValues[index]}',
                  style: const TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              "${selectedUnit.displayUnit}",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 16.sp,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildDoubleValuePicker(BuildContext context,
      HealthTrackerUnitsModelHealthTrackerUnitsUnits selectedUnit) {
    // String firstUnit = selectedUnit.displayUnit!.split("/")[0];
    // String secondUnit = selectedUnit.displayUnit!.split("/")[1];

    List<int> firstUnitValues = [];

    int minValue = selectedUnit.ranges!
        .firstWhere((element) => element!.range == "LOW")!
        .low!
        .toInt();
    int minRangeHigh = selectedUnit.ranges!
        .firstWhere((element) => element!.range == "LOW")!
        .high!
        .toInt();
    int maxValue = selectedUnit.ranges!
        .firstWhere((element) => element!.range == "VERY-HIGH")!
        .high!
        .toInt();
    for (var index = minValue; index < maxValue; index++) {
      firstUnitValues.add(index);
    }

    List<int> fractionValues = [];
    if (healthTrackerController
            .healthTrackerUnitsData.value!.healthTrackerUnits!.parameter ==
        "HEIGHT") {
      fractionValues = List.generate(12, (index) => index);
    } else {
      fractionValues = List.generate(10, (index) => index);
    }
    int integerPart = 0;
    int fractionPart = 0;

    if (healthTrackerController.userAnswer != null &&
        healthTrackerController.userAnswer!.isNotEmpty) {
      if (healthTrackerController.userAnswer.toString().contains(".")) {
        fractionPart = int.parse(
            healthTrackerController.userAnswer.toString().split(".")[1]);
      }

      if (healthTrackerController.userAnswer.toString().contains(".")) {
        integerPart = int.parse(
            healthTrackerController.userAnswer.toString().split(".")[0]);
        fractionPart = int.parse(
            healthTrackerController.userAnswer.toString().split(".")[1]);
      } else {
        integerPart = int.parse(healthTrackerController.userAnswer.toString());
      }
      if (healthTrackerController.dateChanged == true) {
        Future.delayed(Duration.zero, () {
          healthTrackerController.fixedExtentScrollController
              .jumpToItem(firstUnitValues.indexOf(integerPart));
          healthTrackerController.fractionExtentScrollController
              .jumpToItem(fractionValues.indexOf(fractionPart.toInt()));
          healthTrackerController.dateChanged = false;
        });
      }
    } else {
      if (healthTrackerController.dateChanged == true) {
        Future.delayed(Duration.zero, () {
          healthTrackerController.fixedExtentScrollController
              .jumpToItem(firstUnitValues.indexOf(minRangeHigh));
          healthTrackerController.dateChanged = false;
        });
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController:
                healthTrackerController.fixedExtentScrollController,
            onSelectedItemChanged: (int index) {
              integerPart = firstUnitValues[index];
              healthTrackerController.userAnswer =
                  "${integerPart}.${fractionPart}";
              healthTrackerController.update();
            },
            children: List.generate(firstUnitValues.length, (index) {
              return Center(
                child: Text(
                  '${firstUnitValues[index]}',
                  style: const TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              ".", //firstUnit,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 22.sp,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController:
                healthTrackerController.fractionExtentScrollController,
            onSelectedItemChanged: (int index) {
              fractionPart = fractionValues[index];
              healthTrackerController.userAnswer =
                  "${integerPart}.${fractionPart}";
              healthTrackerController.update();
            },
            children: List.generate(fractionValues.length, (index) {
              return Center(
                child: Text(
                  '${fractionValues[index]}',
                  style: const TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              selectedUnit.displayUnit ?? "", //secondUnit,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 16.sp,
                color: AppColors.blackLabelColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
