// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:aayu/controller/consultant/psychologist/psychology_initial_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubjectiveOptions extends StatelessWidget {
  final PsychologyInitialAssessmentController assessmentController;
  const SubjectiveOptions({
    Key? key,
    required this.assessmentController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          displayAnswer(context),
          SizedBox(
            height: 26.h,
          ),
          buildUnits(context),
          SizedBox(
            height: 26.h,
          ),
          showNormalRange(assessmentController),
          showInputPicker(context),
        ],
      ),
    );
  }

  displayAnswer(BuildContext context) {
    String? answer = assessmentController
            .initialAssessmentResponse
            .value!
            .assessments![assessmentController.selectedQuestionIndex.value]!
            .subjective!
            .answer ??
        "";
    if (answer.isNotEmpty) {
      NutritionInitialAssessmentModelAssessmentsSubjectiveUnits? selectedUnit;
      for (var element in assessmentController
          .initialAssessmentResponse
          .value!
          .assessments![assessmentController.selectedQuestionIndex.value]!
          .subjective!
          .units!) {
        if (element!.selected == true) {
          selectedUnit = element;
          break;
        }
      }
      String providedAnswer = "";
      if (selectedUnit!.unitPicker == "SINGLE") {
        providedAnswer = "${answer} ${selectedUnit.displayUnit}";
      } else {
        providedAnswer = "$answer ${selectedUnit.displayUnit}";
      }
      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            color: AppColors.secondaryLabelColor,
            fontSize: 16.sp,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
          text: "Your Answer: ",
          children: <TextSpan>[
            TextSpan(
              text: providedAnswer,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      );
    }
    return const Offstage();
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
          assessmentController
              .initialAssessmentResponse
              .value!
              .assessments![assessmentController.selectedQuestionIndex.value]!
              .subjective!
              .units!
              .length,
          (index) {
            bool isSelected = assessmentController
                .initialAssessmentResponse
                .value!
                .assessments![assessmentController.selectedQuestionIndex.value]!
                .subjective!
                .units![index]!
                .selected!;

            String unitText = assessmentController
                .initialAssessmentResponse
                .value!
                .assessments![assessmentController.selectedQuestionIndex.value]!
                .subjective!
                .units![index]!
                .displayUnit!;

            return InkWell(
              onTap: () {
                for (var element in assessmentController
                    .initialAssessmentResponse
                    .value!
                    .assessments![
                        assessmentController.selectedQuestionIndex.value]!
                    .subjective!
                    .units!) {
                  element!.selected = false;
                }
                assessmentController
                    .initialAssessmentResponse
                    .value!
                    .assessments![
                        assessmentController.selectedQuestionIndex.value]!
                    .subjective!
                    .units![index]!
                    .selected = true;

                assessmentController.update();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.w),
                  color: (isSelected == true)
                      ? AppColors.primaryColor
                      : AppColors.primaryLabelColor.withOpacity(0.2),
                ),
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

  showNormalRange(PsychologyInitialAssessmentController assessmentController) {
    NutritionInitialAssessmentModelAssessmentsSubjectiveUnits? selectedUnit;
    NutritionInitialAssessmentModelAssessmentsSubjectiveUnitsRanges?
        normalRange;
    for (var element in assessmentController
        .initialAssessmentResponse
        .value!
        .assessments![assessmentController.selectedQuestionIndex.value]!
        .subjective!
        .units!) {
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
    NutritionInitialAssessmentModelAssessmentsSubjectiveUnits? selectedUnit;
    for (var element in assessmentController
        .initialAssessmentResponse
        .value!
        .assessments![assessmentController.selectedQuestionIndex.value]!
        .subjective!
        .units!) {
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
      NutritionInitialAssessmentModelAssessmentsSubjectiveUnits selectedUnit) {
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

    String? answer = assessmentController
            .initialAssessmentResponse
            .value!
            .assessments![assessmentController.selectedQuestionIndex.value]!
            .subjective!
            .answer ??
        "";

    FixedExtentScrollController fixedExtentScrollController =
        FixedExtentScrollController(initialItem: 0);
    for (int index = minRange; index <= maxRange; index++) {
      firstUnitValues.add(index);
    }

    if (answer.isNotEmpty) {
      fixedExtentScrollController = FixedExtentScrollController(
          initialItem: firstUnitValues.indexOf(double.parse(answer).toInt()));
    } else {
      fixedExtentScrollController = FixedExtentScrollController(
          initialItem: firstUnitValues.indexOf(minRangeHigh));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController: fixedExtentScrollController,
            onSelectedItemChanged: (int index) {
              assessmentController
                  .initialAssessmentResponse
                  .value!
                  .assessments![
                      assessmentController.selectedQuestionIndex.value]!
                  .subjective!
                  .answer = firstUnitValues[index].toString();
              assessmentController.update();
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
      NutritionInitialAssessmentModelAssessmentsSubjectiveUnits selectedUnit) {
    // String firstUnit = selectedUnit.displayUnit!.split("/")[0];
    // String secondUnit = selectedUnit.displayUnit!.split("/")[1];

    List<int> firstUnitValues = [];
    FixedExtentScrollController fixedExtentScrollController =
        FixedExtentScrollController(initialItem: 0);
    FixedExtentScrollController fractionExtentScrollController =
        FixedExtentScrollController(initialItem: 0);
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
    if (assessmentController
            .initialAssessmentResponse
            .value!
            .assessments![assessmentController.selectedQuestionIndex.value]!
            .subjective!
            .measurement ==
        "HEIGHT") {
      fractionValues = List.generate(12, (index) => index);
    } else {
      fractionValues = List.generate(10, (index) => index);
    }

    String? answer = assessmentController
            .initialAssessmentResponse
            .value!
            .assessments![assessmentController.selectedQuestionIndex.value]!
            .subjective!
            .answer ??
        "";

    int integerPart = 0;
    int fractionPart = 0;

    if (answer.isNotEmpty) {
      if (answer.contains(".")) {
        integerPart = int.parse(answer.split(".")[0]);
        fractionPart = int.parse(answer.split(".")[1]);
      } else {
        integerPart = int.parse(answer);
      }
      fixedExtentScrollController = FixedExtentScrollController(
          initialItem: firstUnitValues.indexOf(integerPart));
      fractionExtentScrollController = FixedExtentScrollController(
          initialItem: fractionValues.indexOf(fractionPart.toInt()));
    } else {
      fixedExtentScrollController = FixedExtentScrollController(
          initialItem: firstUnitValues.indexOf(minRangeHigh));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: CupertinoPicker(
            itemExtent: 32.0,
            scrollController: fixedExtentScrollController,
            onSelectedItemChanged: (int index) {
              integerPart = firstUnitValues[index];
              assessmentController
                  .initialAssessmentResponse
                  .value!
                  .assessments![
                      assessmentController.selectedQuestionIndex.value]!
                  .subjective!
                  .answer = "${integerPart}.${fractionPart}";
              assessmentController.update();
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
            scrollController: fractionExtentScrollController,
            onSelectedItemChanged: (int index) {
              fractionPart = fractionValues[index];
              assessmentController
                  .initialAssessmentResponse
                  .value!
                  .assessments![
                      assessmentController.selectedQuestionIndex.value]!
                  .subjective!
                  .answer = "${integerPart}.${fractionPart}";
              assessmentController.update();
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
