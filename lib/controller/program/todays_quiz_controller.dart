import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class TodaysProgrammeQuizController extends GetxController {
  Rx<bool> isQuizLoading = false.obs;
  Rx<HealingQuizResponse?> healingQuizResponse = HealingQuizResponse().obs;

  String diseaseId = "";
  String programId = "";

  getTodaysQuiz(String _diseaseId, String _programId) async {
    try {
      isQuizLoading.value = true;

      diseaseId = _diseaseId;
      programId = _programId;

      HealingQuizResponse? response =
          await ProgrameService().getTodaysQuiz(globalUserIdDetails!.userId!, diseaseId, programId);

      if (response != null) {
        healingQuizResponse.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isQuizLoading.value = false;
    }
  }

  updateTodaysQuizAnswer(int selectedIndex) async {
    for (var element in healingQuizResponse.value!.todaysQuiz!.options!) {
      element!.selected = false;
      if (element.correctAnswer == true) {
        element.selected = true;
      }
    }
    healingQuizResponse.value!.todaysQuiz!.options![selectedIndex]!.selected =
        true;

    HealingQuizSubmitAnswerRequest postData = HealingQuizSubmitAnswerRequest();
    postData.diseaseId = diseaseId;
    postData.programId = programId;
    postData.quizId = healingQuizResponse.value!.todaysQuiz!.quizId;

    List<HealingQuizSubmitAnswerRequestOptions> options = [];
    healingQuizResponse.value!.todaysQuiz!.options!.forEach((element) {
      options.add(
          HealingQuizSubmitAnswerRequestOptions.fromJson(element!.toJson()));
    });
    postData.options = options;

    bool isSubmitted =
        await ProgrameService().submitTodaysTipAnswer(globalUserIdDetails!.userId!, postData);

    if (isSubmitted == true) {
      Future.delayed(const Duration(seconds: 2), () {
        healingQuizResponse.value!.todaysQuiz!.answerSubmitted = true;
        update();
      });
    }
    update();
    return isSubmitted;
  }

  getTodaysQuizColor(int selectedIndex) {
    HealingQuizResponseTodaysQuizOptions options =
        healingQuizResponse.value!.todaysQuiz!.options![selectedIndex]!;

    if (options.selected == true && options.correctAnswer == true) {
      return const Color(0xFF8EF29B);
    } else if (options.selected == true && options.correctAnswer == false) {
      return const Color(0xFFEE736C);
    } else {
      return const Color(0xFFDADADD);
    }
  }
}
