import 'package:aayu/controller/onboarding/healing_and_you_controller.dart';
import 'package:aayu/controller/onboarding/wellness_and_you_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:get/get.dart';

class MovementAndYouController extends GetxController {
  late OnboardAssessmentModelAssessment movementAssessment;
  MovementAndYouController(OnboardAssessmentModelAssessment assessment) {
    movementAssessment = assessment;
    update();
  }

  toggleSelection(index) {
    movementAssessment.options![index]!.selected =
        !movementAssessment.options![index]!.selected!;
    update();
  }

  Future<bool> updateOnboardingAssessment() async {
    String userId = "";
    UserRegistrationResponse? userIdDetails =
        await HiveService().getUserIdDetails();
    if (userIdDetails != null &&
        userIdDetails.userId != null &&
        userIdDetails.userId!.isNotEmpty) {
      userId = userIdDetails.userId!;
      bool assessmentSubmitted = await submitAssessmentAnswers(userId);
      return assessmentSubmitted;
    } else {
      return false;
    }
  }

  submitAssessmentAnswers(String userId) async {
    SubmitAssessmentRequestModel requestModel = SubmitAssessmentRequestModel();
    requestModel.assessment = [];

    WellnessAndYouController wellnessAndYouController = Get.find();
    SubmitAssessmentRequestModelAssessment wellnessAssessment =
        SubmitAssessmentRequestModelAssessment();
    wellnessAssessment.options = [];
    wellnessAssessment.assessmentId =
        wellnessAndYouController.wellnessAssessment.assessmentId;
    (wellnessAndYouController.wellnessAssessment.options!.forEach((element) {
      if (element!.selected == true) {
        wellnessAssessment.options!.add(
            SubmitAssessmentRequestModelAssessmentOptions.fromJson(
                element.toJson()));
      }
    }));
    requestModel.assessment!.add(wellnessAssessment);

    HealingAndYouController healingAndYouController = Get.find();
    SubmitAssessmentRequestModelAssessment healingAssessment =
        SubmitAssessmentRequestModelAssessment();
    healingAssessment.options = [];
    healingAssessment.assessmentId =
        healingAndYouController.healingAssessment.assessmentId;
    (healingAndYouController.healingAssessment.options!.forEach((element) {
      if (element!.selected == true) {
        healingAssessment.options!.add(
            SubmitAssessmentRequestModelAssessmentOptions.fromJson(
                element.toJson()));
      }
    }));
    requestModel.assessment!.add(healingAssessment);

    SubmitAssessmentRequestModelAssessment submitMovementAssessment =
        SubmitAssessmentRequestModelAssessment();
    submitMovementAssessment.options = [];
    submitMovementAssessment.assessmentId = movementAssessment.assessmentId;
    (movementAssessment.options!.forEach((element) {
      if (element!.selected == true) {
        submitMovementAssessment.options!.add(
            SubmitAssessmentRequestModelAssessmentOptions.fromJson(
                element.toJson()));
      }
    }));
    requestModel.assessment!.add(submitMovementAssessment);

    print(requestModel.toJson());

    SubmitAssessmentResponseModel? submitAssessmentResponse =
        await OnboardingService().submitAssessmentAnswers(userId, requestModel);
    if (submitAssessmentResponse != null) {
      return true;
    } else {
      return false;
    }
  }
}
