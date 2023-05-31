import 'package:aayu/controller/healing/initial_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ObjectiveAssessment extends StatelessWidget {
  final InitialAssessmentController objectiveAssessmentController;
  const ObjectiveAssessment(
      {Key? key, required this.objectiveAssessmentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 26.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              objectiveAssessmentController.setInitialUserSelectedUnit();
              Get.bottomSheet(
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: pagePadding(),
                  decoration: const BoxDecoration(
                    color: AppColors.pageBackgroundColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          objectiveAssessmentController
                              .currentCategory
                              .value!
                              .question![objectiveAssessmentController
                                  .selectedQuestionIndex.value]!
                              .question!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.aayuUserChatTextColor,
                            fontFamily: 'Circular Std',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4285714285714286.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 26.h),
                      showObjectiveUnits(),
                      SizedBox(
                        height: 300.h,
                        child: showPicker(context),
                      ),
                      SizedBox(
                        width: 150.w,
                        child: InkWell(
                          onTap: () {
                            objectiveAssessmentController
                                .updateObjectiveAssessmentAnswer();
                            Get.back();
                          },
                          child: mainButton("Select"),
                        ),
                      ),
                      SizedBox(
                        height: 37.h,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 53.w,
                          height: 53.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0XFF6B8098).withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.secondaryLabelColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: false,
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(64, 117, 205, 0.08),
                      offset: Offset(0, 10),
                      blurRadius: 20,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      objectiveAssessmentController
                              .currentCategory
                              .value!
                              .question![objectiveAssessmentController
                                  .selectedQuestionIndex.value]!
                              .objective!
                              .answer!
                              .isEmpty
                          ? 'PICK_YOUR_REPLY'.tr
                          : objectiveAssessmentController
                              .currentCategory
                              .value!
                              .question![objectiveAssessmentController
                                  .selectedQuestionIndex.value]!
                              .objective!
                              .answer!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color.fromRGBO(
                            143, 156, 167, 0.699999988079071),
                        fontFamily: "Circular Std",
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0XFF9C9EB9),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          showNormalRange(objectiveAssessmentController)
        ],
      ),
    );
  }

  showNormalRange(InitialAssessmentController objectiveAssessmentController) {
    if (objectiveAssessmentController
        .currentCategory
        .value!
        .question![objectiveAssessmentController.selectedQuestionIndex.value]!
        .objective!
        .answer!
        .isEmpty) {
      return const Offstage();
    } else {
      bool showNormalRange = true;
      if (objectiveAssessmentController.selectedUnit.value!.normalRange ==
          null) {
        showNormalRange = false;
      } else if (objectiveAssessmentController
          .selectedUnit.value!.normalRange!.min!.isEmpty) {
        showNormalRange = false;
      } else if (objectiveAssessmentController
          .selectedUnit.value!.normalRange!.max!.isEmpty) {
        showNormalRange = false;
      }

      return (showNormalRange == false)
          ? const Offstage()
          : Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
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
                  "Normal range - ${objectiveAssessmentController.selectedUnit.value!.normalRange?.min ?? 0} to ${objectiveAssessmentController.selectedUnit.value!.normalRange?.max ?? 0} ${objectiveAssessmentController.selectedUnit.value!.unit}",
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
  }

  showPicker(BuildContext context) {
    return GetBuilder<InitialAssessmentController>(builder: (pickerController) {
      String measurement = pickerController.selectedUnit.value!.measurement!;

      switch (measurement.toUpperCase()) {
        case "INTEGER":
          return showSinglePicker(context, measurement, pickerController);
        case "HEIGHT":
          return showHeightPicker(context, measurement, pickerController);
        case "DOUBLE":
        case "WEIGHT":
        case "YEARS":
          return showDoublePicker(context, measurement, pickerController);
        default:
          return showSinglePicker(context, measurement, pickerController);
      }
    });
  }

  showHeightPicker(BuildContext context, String measurement,
      InitialAssessmentController pickerController) {
    List<Widget> selectionWidget = [];

    if (pickerController.selectedUnit.value!.unit == "Feet & Inches") {
      List<String> heightPart = [
        "3' 0\"",
        "3' 1\"",
        "3' 2\"",
        "3' 3\"",
        "3' 4\"",
        "3' 5\"",
        "3' 6\"",
        "3' 7\"",
        "3' 8\"",
        "3' 9\"",
        "3' 10\"",
        "3' 11\"",
        "4' 0\"",
        "4' 1\"",
        "4' 2\"",
        "4' 3\"",
        "4' 4\"",
        "4' 5\"",
        "4' 6\"",
        "4' 7\"",
        "4' 8\"",
        "4' 9\"",
        "4' 10\"",
        "4' 11\"",
        "5' 0\"",
        "5' 1\"",
        "5' 2\"",
        "5' 3\"",
        "5' 4\"",
        "5' 5\"",
        "5' 6\"",
        "5' 7\"",
        "5' 8\"",
        "5' 9\"",
        "5' 10\"",
        "5' 11\"",
        "6' 0\"",
        "6' 1\"",
        "6' 2\"",
        "6' 3\"",
        "6' 4\"",
        "6' 5\"",
        "6' 6\"",
        "6' 7\"",
        "6' 8\"",
        "6' 9\"",
        "6' 10\"",
        "6' 11\"",
        "7' 0\"",
        "7' 1\"",
        "7' 2\"",
        "7' 3\"",
        "7' 4\"",
        "7' 5\"",
        "7' 6\"",
        "7' 7\"",
        "7' 8\"",
        "7' 9\"",
        "7' 10\"",
        "7' 11\"",
        "8' 0\"",
      ];

      int initialItem = 0;
      int initialItemIndex = 0;

      for (int index = 0; index < heightPart.length; index++) {
        if (pickerController.selectedInteger == heightPart[index]) {
          initialItem = initialItemIndex;
        }
        selectionWidget.add(
          Text(
            heightPart[index],
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 28.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.0714285714285714.h,
            ),
          ),
        );
        initialItemIndex++;
      }

      return CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        children: selectionWidget,
        itemExtent: 40.h,
        looping: true,
        onSelectedItemChanged: (int index) {
          pickerController.selectedInteger = heightPart[index].toString();
          pickerController.update();
        },
      );
    } else {
      List<int> integerPart = [];

      int minRange =
          int.parse(pickerController.selectedUnit.value!.lowRange!.min!);
      int maxRange =
          int.parse(pickerController.selectedUnit.value!.veryHighRange!.max!);

      int initialItem = 0;
      int initialItemIndex = 0;

      for (int index = minRange; index <= maxRange; index++) {
        if (pickerController.selectedInteger == index.toString()) {
          initialItem = initialItemIndex;
        }
        integerPart.add(index);
        selectionWidget.add(
          Text(
            "$index",
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 28.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.0714285714285714.h,
            ),
          ),
        );
        initialItemIndex++;
      }

      return CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        children: selectionWidget,
        itemExtent: 40.h,
        looping: true,
        onSelectedItemChanged: (int index) {
          pickerController.selectedInteger = integerPart[index].toString();
          pickerController.update();
        },
      );
    }
  }

  showSinglePicker(BuildContext context, String measurement,
      InitialAssessmentController pickerController) {
    List<Widget> selectionWidget = [];
    List<int> integerPart = [];

    int minRange =
        int.parse(pickerController.selectedUnit.value!.lowRange!.min!);
    int maxRange =
        int.parse(pickerController.selectedUnit.value!.veryHighRange!.max!);

    int initialItem = 0;
    int initialItemIndex = 0;

    for (int index = minRange; index <= maxRange; index++) {
      if (pickerController.selectedInteger == index.toString()) {
        initialItem = initialItemIndex;
      }
      integerPart.add(index);
      selectionWidget.add(
        Text(
          "$index",
          style: TextStyle(
            color: AppColors.blackLabelColor,
            fontFamily: 'Circular Std',
            fontSize: 28.sp,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1.0714285714285714.h,
          ),
        ),
      );
      initialItemIndex++;
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialItem),
      children: selectionWidget,
      itemExtent: 40.h,
      looping: true,
      onSelectedItemChanged: (int index) {
        pickerController.selectedInteger = integerPart[index].toString();
        pickerController.update();
      },
    );
  }

  showDoublePicker(BuildContext context, String measurement,
      InitialAssessmentController pickerController) {
    int minRange =
        double.parse(pickerController.selectedUnit.value!.lowRange!.min!)
            .ceil();
    int maxRange =
        double.parse(pickerController.selectedUnit.value!.veryHighRange!.max!)
            .ceil();

    List<int> integerPart = [];
    List<Widget> integerWidget = [];
    int initialItem = 0;
    int initialItemIndex = 0;

    for (int index = minRange; index <= maxRange; index++) {
      if (pickerController.selectedInteger == index.toString()) {
        initialItem = initialItemIndex;
      }
      integerPart.add(index);
      integerWidget.add(
        Text(
          "$index",
          style: TextStyle(
            color: AppColors.blackLabelColor,
            fontFamily: 'Circular Std',
            fontSize: 28.sp,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1.0714285714285714.h,
          ),
        ),
      );
      initialItemIndex++;
    }

    List<String> decimalPart = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9"
    ];

    if (measurement.toUpperCase() == "YEARS") {
      decimalPart = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11",
      ];
    }

    int decimalPartInitialItem =
        decimalPart.indexOf(pickerController.selectedDecimal);

    return SizedBox(
      height: 300.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100.w,
            child: CupertinoPicker(
              children: integerWidget,
              scrollController:
                  FixedExtentScrollController(initialItem: initialItem),
              itemExtent: 40.h,
              looping: true,
              onSelectedItemChanged: (int index) {
                pickerController.selectedInteger =
                    integerPart[index].toString();
                pickerController.update();
              },
            ),
          ),
          Text(
            ".",
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 36.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.0714285714285714.h,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                  initialItem:
                      decimalPartInitialItem >= 0 ? decimalPartInitialItem : 0),
              children: List.generate(
                decimalPart.length,
                (index) => Text(
                  decimalPart[index],
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 28.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1.0714285714285714.h,
                  ),
                ),
              ),
              itemExtent: 40.h,
              looping: true,
              onSelectedItemChanged: (int index) {
                pickerController.selectedDecimal = decimalPart[index];
                pickerController.update();
              },
            ),
          )
        ],
      ),
    );
  }

  showObjectiveUnits() {
    return GetBuilder<InitialAssessmentController>(
      builder: (unitSelectorController) {
        if (unitSelectorController
                .currentCategory
                .value!
                .question![unitSelectorController.selectedQuestionIndex.value]!
                .objective ==
            null) {
          return const Offstage();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              unitSelectorController
                  .currentCategory
                  .value!
                  .question![
                      unitSelectorController.selectedQuestionIndex.value]!
                  .objective!
                  .units!
                  .length,
              (unitIndex) {
                return InkWell(
                  onTap: () {
                    unitSelectorController.setUserSelectedUnit(unitIndex);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: (unitSelectorController
                                    .currentCategory
                                    .value!
                                    .question![unitSelectorController
                                        .selectedQuestionIndex.value]!
                                    .objective!
                                    .units![unitIndex]!
                                    .selected ==
                                true)
                            ? 0.4
                            : 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            toTitleCase(
                              unitSelectorController
                                  .currentCategory
                                  .value!
                                  .question![unitSelectorController
                                      .selectedQuestionIndex.value]!
                                  .objective!
                                  .units![unitIndex]!
                                  .unit!
                                  .toLowerCase(),
                            ),
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontFamily: 'Circular Std',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (unitSelectorController
                                .currentCategory
                                .value!
                                .question![unitSelectorController
                                    .selectedQuestionIndex.value]!
                                .objective!
                                .units![unitIndex]!
                                .selected ==
                            true),
                        child: Container(
                          height: 5.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.5),
                              color: const Color(0xFFC0F9C7)),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
