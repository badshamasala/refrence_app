import 'package:aayu/model/model.dart';
import 'package:aayu/services/nutrition.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/consulting/nutrition/initial_assessment/post_initial_assessment.dart';
import 'package:aayu/view/consulting/nutrition/initial_assessment/widgets/response_screen.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NutritionInitialAssessmentController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<NutritionInitialAssessmentModel?> initialAssessmentResponse =
      NutritionInitialAssessmentModel().obs;

  double completedPercentage = 0;
  int totalQuestions = 0;
  int completedQuestions = 0;

  RxInt selectedQuestionIndex = 0.obs;
  late PageController pageController;
  List<String> questionHistory = [];

  TextEditingController otherInputController = TextEditingController();
  bool showOtherInputBox = false;

  Rx<NutritionInitialAssessmentStatusModel?> initialAssessmentStatus =
      NutritionInitialAssessmentStatusModel().obs;

  setInitialValues() {
    selectedQuestionIndex.value = 0;
    totalQuestions = 0;
    completedQuestions = 0;
    questionHistory.clear();
    pageController = PageController(initialPage: 0, keepPage: true);
  }

  getInitialAssessmentStatus() async {
    try {
      NutritionInitialAssessmentStatusModel? response = await NutritionService()
          .getInitialAssessmentStatus(globalUserIdDetails!.userId!);
      if (response != null && response.assessmentStatus != null) {
        initialAssessmentStatus.value = response;
      } else {
        initialAssessmentStatus.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      update(["InitialAssessmentStatus"]);
    }
  }

  submitInitialAssessmentStatus(bool isStarted, bool isCompleted) async {
    try {
      dynamic postData = {
        "isStarted": isStarted,
        "isCompleted": isCompleted,
      };
      await NutritionService().submitInitialAssessmentStatus(
          globalUserIdDetails!.userId!, postData);
    } catch (exp) {
      print(exp);
    } finally {}
  }

  getInitialAssessment() async {
    try {
      isLoading(true);
      setInitialValues();
      NutritionInitialAssessmentModel? response = await NutritionService()
          .getInitialAssessment(globalUserIdDetails!.userId!);
      if (response != null &&
          response.assessments != null &&
          response.assessments!.isNotEmpty) {
        for (var element in response.assessments!) {
          if (element!.category == "SUBJECTIVE") {
            if (element.subjective!.units!.length == 1) {
              element.subjective!.units!.first!.selected = true;
            } else {
              if (element.subjective!.units!.firstWhereOrNull(
                      (element) => element!.selected == true) ==
                  null) {
                element.subjective!.units!.first!.selected = true;
              }
            }
          }
        }
        initialAssessmentResponse.value = response;
        totalQuestions = response.assessments!.length;
        calculateCompletedPercentage();
      } else {
        initialAssessmentResponse.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading(false);
      update();
    }
  }

  checkAndNavigateToQuestionNotAnswered(String pageSource) async{
    int index = 0;
    for (int i = 0;
        i < initialAssessmentResponse.value!.assessments!.length;
        i++) {
      var element = initialAssessmentResponse.value!.assessments![i];
      if (element!.category == "SUBJECTIVE") {
        if (element.subjective?.answer != null) {
          index = i;
        }
      }
      if (element.category == "OBJECTIVE") {
        if (element.objective!.options!.indexWhere((element2) {
              return element2!.selected == true;
            }) !=
            -1) {
          index = i;
        }
      }
    }
    if (index + 1 < initialAssessmentResponse.value!.assessments!.length) {
      pageController.jumpToPage(index + 1);
    } else {
      HiveService().initNutritionAssessmentComplete();
      await submitInitialAssessmentStatus(true, false);
      Get.to(PostInitialAssessment(
        pageSource: pageSource,
      ));
    }
  }

  getPreviousQuestion() {
    if (questionHistory.isNotEmpty) {
      int prevQuestionIndex = initialAssessmentResponse.value!.assessments!
          .indexWhere(
              (element) => element!.assessmentId == questionHistory.last);
      pageController.jumpToPage(prevQuestionIndex);
      questionHistory.removeLast();
      update();
    }
  }

  getNextQuestion(String pageSource) async {
    if (selectedQuestionIndex.value < totalQuestions) {
      String assessmentId = initialAssessmentResponse
          .value!.assessments![selectedQuestionIndex.value]!.assessmentId!;
      if (questionHistory.contains(assessmentId) == false) {
        dynamic postData = {
          "assessmentId": assessmentId,
          "objective": {"options": [], "otherOptionAnswer": ""},
          "subjective": {"answer": "", "unit": ""}
        };
        String assessmentCategory = initialAssessmentResponse
            .value!.assessments![selectedQuestionIndex.value]!.category!
            .toUpperCase();

        bool isValid = false;
        String replyMessage = "";
        String nextQuestionId = "";

        if (assessmentCategory == "OBJECTIVE") {
          for (var element in initialAssessmentResponse.value!
              .assessments![selectedQuestionIndex.value]!.objective!.options!) {
            if (element!.selected == true) {
              isValid = true;
              replyMessage = element.replyMessage ?? "";
              nextQuestionId = element.nextQuestionId ?? "";
              postData["objective"]["options"]
                  .add({"optionId": element.optionId!});
            }
            if (element.option!.toUpperCase() == "OTHER") {
              initialAssessmentResponse
                  .value!
                  .assessments![selectedQuestionIndex.value]!
                  .objective!
                  .otherOptionAnswer = otherInputController.text.trim();
              postData["objective"]["otherOptionAnswer"] =
                  otherInputController.text.trim();
            }
          }
        } else if (assessmentCategory == "SUBJECTIVE") {
          NutritionInitialAssessmentModelAssessmentsSubjectiveUnits?
              selectedUnit;
          for (var element in initialAssessmentResponse.value!
              .assessments![selectedQuestionIndex.value]!.subjective!.units!) {
            if (element!.selected == true) {
              selectedUnit = element;
              break;
            }
          }
          if (selectedUnit != null) {
            replyMessage = initialAssessmentResponse
                    .value!
                    .assessments![selectedQuestionIndex.value]!
                    .subjective!
                    .replyMessage ??
                "";
            if (selectedUnit.unitPicker == "SINGLE") {
              postData["subjective"]["answer"] = (initialAssessmentResponse
                          .value!
                          .assessments![selectedQuestionIndex.value]!
                          .subjective!
                          .answer ??
                      0)
                  .toString();
            } else {
              postData["subjective"]["answer"] = (initialAssessmentResponse
                          .value!
                          .assessments![selectedQuestionIndex.value]!
                          .subjective!
                          .answer ??
                      0)
                  .toString();
            }
            postData["subjective"]["unit"] = selectedUnit.unit;
            isValid = true;
          }
        }

        if (isValid == true) {
          if (selectedQuestionIndex.value == 0) {
            HiveService().initFirstTimeNutritionAssessment();
            submitInitialAssessmentStatus(true, false);
          }

          bool isSubmitted = await NutritionService()
              .submitAssessment(globalUserIdDetails!.userId!, postData);
          if (isSubmitted == true) {
            initialAssessmentResponse.value!
                .assessments![selectedQuestionIndex.value]!.isCompleted = true;
            calculateCompletedPercentage();

            if (initialAssessmentResponse
                    .value!.assessments!.last!.assessmentId ==
                assessmentId) {
              HiveService().initNutritionAssessmentComplete();
              await submitInitialAssessmentStatus(false, true);
              Get.to(PostInitialAssessment(pageSource: pageSource));
            } else {
              if (replyMessage.isEmpty) {
                questionHistory.add(assessmentId);
                if (nextQuestionId.isEmpty) {
                  pageController.nextPage(
                      duration:
                          Duration(milliseconds: defaultAnimateToPageDuration),
                      curve: Curves.easeIn);
                } else {
                  int nextQuestionIndex =
                      initialAssessmentResponse.value!.assessments!.indexWhere(
                          (element) => element!.mappingId == nextQuestionId);
                  pageController.jumpToPage(nextQuestionIndex);
                }
                update();
              } else {
                Get.bottomSheet(
                  AssessmentResponseMessage(
                      responseMessage: replyMessage,
                      nextAction: () {
                        questionHistory.add(assessmentId);
                        if (nextQuestionId.isEmpty) {
                          pageController.nextPage(
                              duration: Duration(
                                  milliseconds: defaultAnimateToPageDuration),
                              curve: Curves.easeIn);
                        } else {
                          int nextQuestionIndex = initialAssessmentResponse
                              .value!.assessments!
                              .indexWhere((element) =>
                                  element!.mappingId == nextQuestionId);
                          pageController.jumpToPage(nextQuestionIndex);
                        }
                        update();
                        Get.back();
                      }),
                  isScrollControlled: true,
                );
              }
            }
          } else {
            showGetSnackBar("Something went wrong. Please try again!",
                SnackBarMessageTypes.Error);
          }
        }
      }
    }
  }

  skipQuestion() {
    questionHistory.add(initialAssessmentResponse
        .value!.assessments![selectedQuestionIndex.value]!.assessmentId!);
    pageController.nextPage(
        duration: Duration(milliseconds: defaultAnimateToPageDuration),
        curve: Curves.easeIn);
    update();
  }

  calculateCompletedPercentage() {
    completedPercentage = 0;
    completedQuestions = initialAssessmentResponse.value!.assessments!
        .where((element) => element!.isCompleted == true)
        .length;
    completedPercentage = completedQuestions / totalQuestions;
  }
}
