import 'dart:convert';
import 'dart:math';

import 'package:aayu/controller/healing/user_identification_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/initialAssessment/widgets/assessment_completed.dart';
import 'package:aayu/view/healing/initialAssessment/widgets/response_screen.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialAssessmentController extends GetxController {
  String _pageSource = "";

  RxInt selectedQuestionIndex = 0.obs;
  RxInt prevSelectedQuestion = 0.obs;
  RxInt selectedCategoryIndex = 0.obs;
  Rx<InitialAssessment?> revisedAssessment = InitialAssessment().obs;

  Rx<InitialAssessmentAssessment?> currentCategory =
      InitialAssessmentAssessment().obs;

  Rx<InitialAssessmentAssessmentQuestionsObjectiveUnits?> selectedUnit =
      InitialAssessmentAssessmentQuestionsObjectiveUnits().obs;

  Rx<bool> isLoading = false.obs;

  late PageController categoryPageController;
  late PageController pageController;

  String selectedInteger = "";
  String selectedDecimal = "";

  List<String> questionHistory = [];
  UserIdentificationController userIdentificationController = Get.find();
  String userIdentificationId = "";

  double completedPercentage = 0;
  int totalQuestions = 0;
  int completedQuestions = 0;

  @override
  void onClose() {
    categoryPageController.dispose();
    pageController.dispose();
    super.onClose();
  }

  setInitialValues(String pageSource, String? categoryName) {
    _pageSource = pageSource;

    selectedQuestionIndex.value = 0;
    prevSelectedQuestion.value = 0;
    selectedCategoryIndex.value = 0;
    questionHistory = [];
    selectedInteger = "";
    selectedDecimal = "";

    userIdentificationId = userIdentificationController
        .userIndentification.value!.identificationDetails!.userIdentification!;

    categoryPageController = PageController(initialPage: 0, keepPage: true);
    pageController = PageController(initialPage: 0, keepPage: true);

    getRevisedAssessment(categoryName);
  }

  getRevisedAssessment(String? categoryName) async {
    try {
      isLoading.value = true;
      selectedQuestionIndex.value = 0;

      InitialAssessment? response = await HealingService().getInitialAssessment(
          globalUserIdDetails!.userId!, userIdentificationId);

      if (response != null &&
          response.categories != null &&
          response.categories!.isNotEmpty) {
        revisedAssessment.value = response;
        if (categoryName != null && categoryName.isNotEmpty) {
          int categoryIndex = 0;
          for (var element in revisedAssessment.value!.categories!) {
            if (element!.categoryName!.toUpperCase() ==
                categoryName.toUpperCase()) {
              selectedCategoryIndex.value = categoryIndex;
              break;
            }
            categoryIndex++;
          }
        }

        currentCategory.value =
            revisedAssessment.value!.categories![selectedCategoryIndex.value];

        calculateCompletedPercentage();
        setInitialUserSelectedUnit();
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  setSubjectiveAssessmentAnswer(int index) async {
    for (var element in revisedAssessment
        .value!
        .categories![selectedCategoryIndex.value]!
        .question![selectedQuestionIndex.value]!
        .subjective!) {
      element!.selected = false;
    }

    revisedAssessment
        .value!
        .categories![selectedCategoryIndex.value]!
        .question![selectedQuestionIndex.value]!
        .subjective![index]!
        .selected = true;

    update();
  }

  setInitialUserSelectedUnit() {
    if (currentCategory
                .value!.question![selectedQuestionIndex.value]!.objective !=
            null &&
        currentCategory.value!.question![selectedQuestionIndex.value]!
                .objective!.units !=
            null) {
      int selectedIndex = 0;
      bool isSelected = false;

      for (var index = 0;
          index <
              revisedAssessment
                  .value!
                  .categories![selectedCategoryIndex.value]!
                  .question![selectedQuestionIndex.value]!
                  .objective!
                  .units!
                  .length;
          index++) {
        selectedIndex = index;
        if (revisedAssessment
                .value!
                .categories![selectedCategoryIndex.value]!
                .question![selectedQuestionIndex.value]!
                .objective!
                .units![index]!
                .selected ==
            true) {
          isSelected = true;
          break;
        }
      }
      if (isSelected == false) {
        selectedIndex = 0;
      }

      setUserSelectedUnit(selectedIndex);
    }
  }

  setUserSelectedUnit(int selectedIndex) {
    if (currentCategory
                .value!.question![selectedQuestionIndex.value]!.objective !=
            null &&
        revisedAssessment
            .value!
            .categories![selectedCategoryIndex.value]!
            .question![selectedQuestionIndex.value]!
            .objective!
            .units!
            .isNotEmpty) {
      for (var element in currentCategory
          .value!.question![selectedQuestionIndex.value]!.objective!.units!) {
        element!.selected = false;
      }
      currentCategory.value!.question![selectedQuestionIndex.value]!.objective!
          .units![selectedIndex]!.selected = true;

      selectedUnit.value = currentCategory
          .value!
          .question![selectedQuestionIndex.value]!
          .objective!
          .units![selectedIndex]!;

      if (selectedUnit.value!.selectedValue!.isNotEmpty) {
        selectedDecimal = "0";
        if (selectedUnit.value!.measurement!.toUpperCase() == "INTEGER") {
          selectedInteger = selectedUnit.value!.selectedValue!;
        } else if (selectedUnit.value!.measurement!.toUpperCase() == "HEIGHT") {
          selectedInteger = selectedUnit.value!.selectedValue!;
        } else {
          if (selectedUnit.value!.selectedValue!.contains(".")) {
            List<String> decimals =
                selectedUnit.value!.selectedValue!.split(".");
            selectedInteger = decimals[0].isEmpty
                ? selectedUnit.value!.lowRange!.min!
                : decimals[0];
            selectedDecimal = decimals[1].isEmpty ? "0" : decimals[1];
          } else {
            selectedInteger = selectedUnit.value!.lowRange!.min!;
            selectedDecimal = "0";
          }
        }
      } else {
        selectedInteger = selectedUnit.value!.lowRange!.min!;
        selectedDecimal = "0";
      }
      update();
    }
  }

  setObjectiveUnitSelectedValue(String value) {
    selectedUnit.value!.selectedValue = value.toString();
    update();
  }

  setObjectiveAssessmentAnswer() async {
    InitialAssessmentAssessmentQuestionsObjectiveUnits? unit = currentCategory
        .value!.question![selectedQuestionIndex.value]!.objective!.units!
        .firstWhereOrNull((element) =>
            element!.selected == true && element.selectedValue!.isNotEmpty);

    if (unit != null) {
      String unitMeasurement = unit.measurement!.toUpperCase();

      if (unitMeasurement == "HEIGHT") {
        currentCategory.value!.question![selectedQuestionIndex.value]!
            .objective!.answer = "${unit.selectedValue}";
      } else {
        currentCategory.value!.question![selectedQuestionIndex.value]!
            .objective!.answer = "${unit.selectedValue} ${unit.unit}";
      }

      currentCategory
          .value!.question![selectedQuestionIndex.value]!.isCompleted = true;

      bool isSubmitted = await submitAssessmentAnswer();

      update();

      return isSubmitted;
    } else {
      return false;
    }
  }

  addToQuestionHistory() {
    questionHistory.add(revisedAssessment
        .value!
        .categories![selectedCategoryIndex.value]!
        .question![selectedQuestionIndex.value]!
        .questionId!);

    update();

    print("addToQuestionHistory ========> \n $questionHistory");
  }

  showPreviousQuestion() {
    if (questionHistory.isNotEmpty) {
      bool isFound = false;

      for (int categoryIndex = 0;
          categoryIndex < revisedAssessment.value!.categories!.length;
          categoryIndex++) {
        for (int questionIndex = 0;
            questionIndex <
                revisedAssessment
                    .value!.categories![categoryIndex]!.question!.length;
            questionIndex++) {
          if (questionHistory.last ==
              revisedAssessment.value!.categories![categoryIndex]!
                  .question![questionIndex]!.questionId) {
            selectedInteger = "";
            selectedDecimal = "";
            isFound = true;
            if (selectedCategoryIndex.value != categoryIndex) {
              selectedCategoryIndex.value = categoryIndex;
              selectedQuestionIndex.value = questionIndex;

              currentCategory.value = revisedAssessment
                  .value!.categories![selectedCategoryIndex.value];

              update();

              calculateCompletedPercentage();

              categoryPageController.previousPage(
                  duration:
                      Duration(milliseconds: defaultAnimateToPageDuration),
                  curve: Curves.easeOut);

              pageController.dispose();
              pageController =
                  PageController(initialPage: questionIndex, keepPage: true);

              setInitialUserSelectedUnit();
            } else {
              selectedQuestionIndex.value = questionIndex;
              calculateCompletedPercentage();
              update();
              pageController.jumpToPage(questionIndex);

              setInitialUserSelectedUnit();
            }

            break;
          }
        }
        if (isFound == true) {
          questionHistory.removeLast();
          update();
          break;
        }
      }
    }
  }

  showNextQuestion() async {
    if (currentCategory
            .value!.question![selectedQuestionIndex.value]!.questionType!
            .toUpperCase() ==
        "SUBJECTIVE ASSESSMENT") {
      String? childId = "";
      bool? isSelected = false;

      String generalResponse = currentCategory
          .value!.question![selectedQuestionIndex.value]!.generalResponse!;

      for (var element in revisedAssessment
          .value!
          .categories![selectedCategoryIndex.value]!
          .question![selectedQuestionIndex.value]!
          .subjective!) {
        if (element!.selected == true) {
          childId = element.childId;
          isSelected = true;
          break;
        }
      }

      if (isSelected == true) {
        bool isSubmitted = await submitAssessmentAnswer();

        if (isSubmitted == true) {
          currentCategory.value!.question![selectedQuestionIndex.value]!
              .isCompleted = true;

          if (childId != null && childId.isNotEmpty) {
            int nextPageIndex = 0;

            nextPageIndex = revisedAssessment
                .value!.categories![selectedCategoryIndex.value]!.question!
                .indexWhere((element) => element!.masterId == childId);

            addToQuestionHistory();
            selectedInteger = "";
            selectedDecimal = "";
            selectedQuestionIndex.value = nextPageIndex;
            update();

            if (generalResponse.isEmpty) {
              calculateCompletedPercentage();
              pageController.jumpToPage(nextPageIndex);
              setInitialUserSelectedUnit();
            } else {
              Get.bottomSheet(
                ResponseScreen(
                  generalResponse: generalResponse,
                  nextAction: () {
                    Get.back();
                    calculateCompletedPercentage();
                    pageController.jumpToPage(nextPageIndex);
                    setInitialUserSelectedUnit();
                  },
                ),
                isScrollControlled: true,
              );
            }
          } else {
            int currentCatIndex = selectedCategoryIndex.value;
            await HealingService().completeAssessmentCategory(
                globalUserIdDetails!.userId!,
                userIdentificationId,
                revisedAssessment
                    .value!.categories![currentCatIndex]!.categoryId!);

            EventsService().sendEvent("Initial_Assessment_Category_Completed", {
              "assessment_category": revisedAssessment
                  .value!.categories![currentCatIndex]!.categoryName!
            });

            revisedAssessment.value!.categories![currentCatIndex]!.isCompleted =
                true;

            if (selectedCategoryIndex.value <
                revisedAssessment.value!.categories!.length - 1) {
              addToQuestionHistory();

              selectedCategoryIndex.value = selectedCategoryIndex.value + 1;
              selectedQuestionIndex.value = 0;

              currentCategory.value = revisedAssessment
                  .value!.categories![selectedCategoryIndex.value];

              selectedInteger = "";
              selectedDecimal = "";

              update();

              if (generalResponse.isEmpty) {
                categoryPageController.nextPage(
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeIn);
                pageController.dispose();
                pageController = PageController(initialPage: 0, keepPage: true);
                calculateCompletedPercentage();
                setInitialUserSelectedUnit();
              } else {
                Get.bottomSheet(
                  ResponseScreen(
                    generalResponse: generalResponse,
                    nextAction: () {
                      Get.back();
                      categoryPageController.nextPage(
                          duration: Duration(
                              milliseconds: defaultAnimateToPageDuration),
                          curve: Curves.easeIn);

                      pageController.dispose();
                      pageController =
                          PageController(initialPage: 0, keepPage: true);
                      calculateCompletedPercentage();
                      setInitialUserSelectedUnit();
                    },
                  ),
                  isScrollControlled: true,
                );
              }
            } else {
              bool isAnyCategoryPending = revisedAssessment
                  .value!.categories!
                  .any((element) => element!.isCompleted == false);
              if (isAnyCategoryPending == false) {
                await submitCompleteAssessment();
              }
              Get.bottomSheet(
                AssessmentCompleted(pageSource: _pageSource),
                isScrollControlled: true,
              );
            }
          }
        } else {
          showGetSnackBar(
              "Failed to submit answer!", SnackBarMessageTypes.Info);
        }
      } else {
        showGetSnackBar("Please select your answer", SnackBarMessageTypes.Info);
      }
    } else {
      bool isValid = validateObjectiveAssessmentAnswer();

      if (isValid == true) {
        bool isSubmitted = await setObjectiveAssessmentAnswer();

        if (isSubmitted == true) {
          String generalResponse = currentCategory
              .value!.question![selectedQuestionIndex.value]!.generalResponse!;

          if (selectedQuestionIndex.value ==
              currentCategory.value!.question!.length - 1) {
            int currentCatIndex = selectedCategoryIndex.value;

            await HealingService().completeAssessmentCategory(
                globalUserIdDetails!.userId!,
                userIdentificationId,
                revisedAssessment
                    .value!.categories![currentCatIndex]!.categoryId!);

            EventsService().sendEvent("Initial_Assessment_Category_Completed", {
              "assessment_category": revisedAssessment
                  .value!.categories![currentCatIndex]!.categoryName!
            });

            revisedAssessment.value!.categories![currentCatIndex]!.isCompleted =
                true;

            if (selectedCategoryIndex.value <
                revisedAssessment.value!.categories!.length - 1) {
              addToQuestionHistory();
              selectedCategoryIndex.value = selectedCategoryIndex.value + 1;
              selectedQuestionIndex.value = 0;

              currentCategory.value = revisedAssessment
                  .value!.categories![selectedCategoryIndex.value];

              selectedInteger = "";
              selectedDecimal = "";

              update();

              if (generalResponse.isEmpty) {
                categoryPageController.nextPage(
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeIn);

                pageController.dispose();
                pageController = PageController(initialPage: 0, keepPage: true);
                calculateCompletedPercentage();
                setInitialUserSelectedUnit();
              } else {
                Get.bottomSheet(
                  ResponseScreen(
                    generalResponse: generalResponse,
                    nextAction: () async {
                      Get.back();
                      categoryPageController.nextPage(
                          duration: Duration(
                              milliseconds: defaultAnimateToPageDuration),
                          curve: Curves.easeIn);

                      pageController.dispose();
                      pageController =
                          PageController(initialPage: 0, keepPage: true);
                      calculateCompletedPercentage();
                      setInitialUserSelectedUnit();
                    },
                  ),
                  isScrollControlled: true,
                );
              }
            } else {
              bool isAnyCategoryPending = revisedAssessment
                  .value!.categories!
                  .any((element) => element!.isCompleted == false);
              if (isAnyCategoryPending == false) {
                await submitCompleteAssessment();
              }
              Get.bottomSheet(
                AssessmentCompleted(pageSource: _pageSource),
                isScrollControlled: true,
              );
            }
          } else {
            addToQuestionHistory();

            selectedInteger = "";
            selectedDecimal = "";

            update();

            if (generalResponse.isEmpty) {
              calculateCompletedPercentage();
              pageController.nextPage(
                  duration:
                      Duration(milliseconds: defaultAnimateToPageDuration),
                  curve: Curves.easeIn);

              setInitialUserSelectedUnit();
            } else {
              Get.bottomSheet(
                ResponseScreen(
                  generalResponse: generalResponse,
                  nextAction: () {
                    Get.back();
                    calculateCompletedPercentage();
                    pageController.nextPage(
                        duration: Duration(
                            milliseconds: defaultAnimateToPageDuration),
                        curve: Curves.easeIn);
                    setInitialUserSelectedUnit();
                  },
                ),
                isScrollControlled: true,
              );
            }
          }
        } else {
          showGetSnackBar(
              "Failed to submit answer!", SnackBarMessageTypes.Info);
        }
      } else {
        showGetSnackBar("Please select your answer", SnackBarMessageTypes.Info);
      }
    }
  }

  validateObjectiveAssessmentAnswer() {
    bool isSelected = false;
    for (var element in currentCategory
        .value!.question![selectedQuestionIndex.value]!.objective!.units!) {
      if (element!.selected == true && element.selectedValue!.isNotEmpty) {
        isSelected = true;
        break;
      }
    }

    return isSelected;
  }

  updateObjectiveAssessmentAnswer() {
    String unitMeasurement = selectedUnit.value!.measurement!.toUpperCase();

    if (unitMeasurement == "INTEGER") {
      selectedUnit.value!.selectedValue = selectedInteger;

      if (selectedInteger.isNotEmpty) {
        revisedAssessment.value!.categories![selectedCategoryIndex.value]!
                .question![selectedQuestionIndex.value]!.objective!.answer =
            "${selectedUnit.value!.selectedValue} ${selectedUnit.value!.unit}";

        currentCategory.value!.question![selectedQuestionIndex.value]!
                .objective!.answer =
            "${selectedUnit.value!.selectedValue} ${selectedUnit.value!.unit}";

        update();
      }
    } else if (unitMeasurement == "HEIGHT") {
      selectedUnit.value!.selectedValue = selectedInteger;

      if (selectedInteger.isNotEmpty) {
        revisedAssessment
            .value!
            .categories![selectedCategoryIndex.value]!
            .question![selectedQuestionIndex.value]!
            .objective!
            .answer = "${selectedUnit.value!.selectedValue}";

        currentCategory.value!.question![selectedQuestionIndex.value]!
            .objective!.answer = "${selectedUnit.value!.selectedValue}";

        update();
      }
    } else {
      if (selectedInteger.isNotEmpty && selectedDecimal.isNotEmpty) {
        selectedUnit.value!.selectedValue = "$selectedInteger.$selectedDecimal";

        currentCategory.value!.question![selectedQuestionIndex.value]!
                .objective!.answer =
            "${selectedUnit.value!.selectedValue} ${selectedUnit.value!.unit}";

        revisedAssessment.value!.categories![selectedCategoryIndex.value]!
                .question![selectedQuestionIndex.value]!.objective!.answer =
            "${selectedUnit.value!.selectedValue} ${selectedUnit.value!.unit}";

        update();
      }
    }

    print(currentCategory
        .value!.question![selectedQuestionIndex.value]!.objective!.answer);
  }

  submitAssessmentAnswer() async {
    try {
      buildShowDialog(navState.currentState!.context);

      String questionType = currentCategory
          .value!.question![selectedQuestionIndex.value]!.questionType!
          .toUpperCase();

      print("--------------------SUBMIT ASSESSMENT--------------------");
      print(currentCategory
          .value!.question![selectedQuestionIndex.value]!.questionId!);
      print(currentCategory
          .value!.question![selectedQuestionIndex.value]!.question!);

      dynamic postJson = {
        "questionId": currentCategory
            .value!.question![selectedQuestionIndex.value]!.questionId,
        "categoryId": currentCategory.value!.categoryId,
        "masterId": currentCategory
            .value!.question![selectedQuestionIndex.value]!.masterId,
        "objective": null,
        "subjective": null,
        "isCompleted": true
      };

      if (questionType.toUpperCase() == "OBJECTIVE ASSESSMENT") {
        print(json.encode(currentCategory
            .value!.question![selectedQuestionIndex.value]!.objective!
            .toJson()));

        InitialAssessmentAssessmentQuestionsObjectiveUnits? selectedUnit =
            currentCategory.value!.question![selectedQuestionIndex.value]!
                .objective!.units!
                .firstWhereOrNull((element) => element!.selected == true);

        postJson["subjective"] = null;
        if (selectedUnit != null) {
          postJson["objective"] = {
            "units": [
              {
                "unit": selectedUnit.unit,
                "selected": true,
                "selectedValue": selectedUnit.selectedValue
              }
            ],
            "answer": currentCategory.value!
                .question![selectedQuestionIndex.value]!.objective!.answer
          };
        }
      } else if (questionType.toUpperCase() == "SUBJECTIVE ASSESSMENT") {
        InitialAssessmentAssessmentQuestionsSubjective? selectedAnswer =
            currentCategory
                .value!.question![selectedQuestionIndex.value]!.subjective!
                .firstWhereOrNull((element) => element!.selected == true);

        postJson["objective"] = null;
        if (selectedAnswer != null) {
          postJson["subjective"] = [selectedAnswer.toJson()];
        }
      }

      print("----------SUBMIT ASSESSMENT | postJson-----------");
      print(json.encode(postJson));

      print("--------------------");

      bool? isSubmitted = await HealingService().submitInitialAssessmentAnswer(
          globalUserIdDetails!.userId!, userIdentificationId, postJson);

      return isSubmitted!;
    } finally {
      Navigator.pop(navState.currentState!.context);
    }
  }

  submitCompleteAssessment() async {
    //for assessment via BOOK_DOCTOR_SLOT is only for general questions.
    if (_pageSource != "BOOK_DOCTOR_SLOT") {
      await HealingService().submitCompleteAssessment(
        globalUserIdDetails!.userId!,
        userIdentificationId,
      );
    }
  }

  setCategory(int categoryIndex) {
    selectedQuestionIndex.value = 0;
    prevSelectedQuestion.value = 0;
    selectedCategoryIndex.value = categoryIndex;
    questionHistory = [];
    selectedInteger = "";
    selectedDecimal = "";

    currentCategory.value = revisedAssessment.value!.categories![categoryIndex];
    categoryPageController.jumpToPage(categoryIndex);
    pageController = PageController(initialPage: 0, keepPage: true);

    calculateCompletedPercentage();

    update();
  }

  calculateCompletedPercentage() {
    completedPercentage = 0;
    totalQuestions = currentCategory.value!.question!.length;
    completedQuestions = currentCategory.value!.question!
        .where((element) => element!.isCompleted == true)
        .length;
    if (currentCategory.value!.isCompleted == true) {
      completedPercentage = 1;
    } else {
      completedPercentage = completedQuestions / totalQuestions;
    }

    print("----------completePercentage-------------");
    print("totalQuestions: $totalQuestions");
    print("completedQuestions: $completedQuestions");
    print("completedPercentage: $completedPercentage");
  }
}
