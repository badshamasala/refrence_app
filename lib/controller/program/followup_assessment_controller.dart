import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/state_manager.dart';

class FollowupAssessmentController extends GetxController {
  Rx<bool> isQuestionLoading = false.obs;
  Rx<FollowupAssessmentResponse?> followupAssessmentQuestion =
      FollowupAssessmentResponse().obs;

  @override
  onInit() {
    getTodaysQuestion();
    super.onInit();
  }

  getTodaysQuestion() async {
    try {
      isQuestionLoading.value = true;
      followupAssessmentQuestion.value =
          await HealingService().getFolloupAssessmentQuestion(
        globalUserIdDetails!.userId!,
        subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
      );
    } catch (exp) {
      print(exp);
    } finally {
      isQuestionLoading.value = false;
    }
  }

  updateTodaysQuestionAnswer(int selectedIndex) {
    if (followupAssessmentQuestion.value!.postAssessment!.isCompleted ==
        false) {
      for (var element
          in followupAssessmentQuestion.value!.postAssessment!.subjective!) {
        element!.selected = false;
      }
      followupAssessmentQuestion
          .value!.postAssessment!.subjective![selectedIndex]!.selected = true;
      update();
    }
  }

  submitTodaysAnswer() async {
    FollowupAssessmentResponse postData = FollowupAssessmentResponse.fromJson(
        followupAssessmentQuestion.value!.toJson());
    postData.postAssessment!.subjective = [];

    FollowupAssessmentResponsePostAssessmentSubjective? selectedOption =
        followupAssessmentQuestion.value!.postAssessment!.subjective!
            .firstWhere((element) => element!.selected == true);
    if (selectedOption != null) {
      postData.postAssessment!.subjective!.add(selectedOption);
      bool isSubmitted = await HealingService().postFolloupAssessmentQuestion(
          globalUserIdDetails!.userId!,
          subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
          postData.postAssessment!);
      if (isSubmitted == true) {
        followupAssessmentQuestion.value!.postAssessment!.isCompleted = true;
        update();
      }
      return isSubmitted;
    } else {
      return false;
    }
  }
}
