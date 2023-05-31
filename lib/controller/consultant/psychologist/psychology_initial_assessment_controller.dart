import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/psychology.service.dart';
import 'package:aayu/view/consulting/psychologist/initial_assessment/widgets/response_screen.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_consent.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PsychologyInitialAssessmentController extends GetxController {
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

  setInitialValues() {
    selectedQuestionIndex.value = 0;
    totalQuestions = 0;
    completedQuestions = 0;
    questionHistory.clear();
    pageController = PageController(initialPage: 0, keepPage: false);
  }

  getInitialAssessment() async {
    try {
      isLoading(true);
      setInitialValues();
      NutritionInitialAssessmentModel? response = await PsychologyService()
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

  getNextQuestion() async {
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
          bool isSubmitted = await PsychologyService()
              .submitAssessment(globalUserIdDetails!.userId!, postData);
          if (isSubmitted == true) {
            initialAssessmentResponse.value!
                .assessments![selectedQuestionIndex.value]!.isCompleted = true;
            calculateCompletedPercentage();
            if (initialAssessmentResponse
                    .value!.assessments!.last!.assessmentId ==
                assessmentId) {
              PsychologyController psychologyController = Get.find();
              await PsychologyService()
                  .completeAssessment(globalUserIdDetails!.userId!, {
                "userPsychologyMasterId": psychologyController
                        .userPsychologyDetails.value?.userPsychologyMasterId ??
                    ""
              });
              Navigator.of(Get.context!).popUntil((route) => route.isFirst);
              Get.to(const PsychologistConsent());
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
