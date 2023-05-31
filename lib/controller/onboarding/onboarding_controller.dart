import 'package:aayu/controller/onboarding/healing_and_you_controller.dart';
import 'package:aayu/controller/onboarding/movement_and_you_controller.dart';
import 'package:aayu/controller/onboarding/wellness_and_you_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt selectedPage = 0.obs;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);

  RxBool isLoading = false.obs;
  Rx<OnboardAssessmentModel?> onboardingAssessment =
      OnboardAssessmentModel().obs;

  getOnboardingAssessment() async {
    try {
      isLoading.value = true;

      String userId = "";
      UserRegistrationResponse? userIdDetails =
          await HiveService().getUserIdDetails();
      if (userIdDetails != null &&
          userIdDetails.userId != null &&
          userIdDetails.userId!.isNotEmpty) {
        userId = userIdDetails.userId!;
      }

      OnboardAssessmentModel? response =
          await OnboardingService().getOnboardingAssessment(userId);
      if (response != null &&
          response.assessment != null &&
          response.assessment!.isNotEmpty) {
        onboardingAssessment.value = response;
      }
    } finally {
      initializeWellnessAndYouController();
      initializeHealingAndYouController();
      initializeMovementAndYouController();
      isLoading.value = false;
      update();
    }
  }

  setSelectedPage(int index) {
    selectedPage.value = index;
  }

  initializeWellnessAndYouController() {
    if (onboardingAssessment.value != null &&
        onboardingAssessment.value!.assessment != null &&
        onboardingAssessment.value!.assessment!.isNotEmpty) {
      Get.put(WellnessAndYouController(
          onboardingAssessment.value!.assessment![0]!));
    } else {
      OnboardAssessmentModelAssessment assessment =
          OnboardAssessmentModelAssessment.fromJson({
        "assessmentId": "b436a3a0-c77a-11ec-9a20-273c6ff69cdd",
        "title": "Wellness and You",
        "question": "What would you like help with?",
        "image":
            "https://content.aayu.live/aayu/app/onboard/wellnessandyou.png",
        "options": [
          {"text": "Stress", "selected": false},
          {"text": " Self-Care", "selected": false},
          {"text": " Personal Growth", "selected": false},
          {"text": " Anxiety", "selected": false},
          {"text": " Sleep", "selected": false},
          {"text": " Inner Peace", "selected": false},
          {"text": " Letting Go", "selected": false},
          {"text": " Relaxation", "selected": false},
          {"text": " Mindfulness", "selected": false}
        ]
      });
      Get.put(WellnessAndYouController(assessment));
    }
  }

  initializeHealingAndYouController() {
    if (onboardingAssessment.value != null &&
        onboardingAssessment.value!.assessment != null &&
        onboardingAssessment.value!.assessment!.isNotEmpty &&
        onboardingAssessment.value!.assessment![1] != null) {
      Get.put(
          HealingAndYouController(onboardingAssessment.value!.assessment![1]!));
    } else {
      OnboardAssessmentModelAssessment assessment =
          OnboardAssessmentModelAssessment.fromJson({
        "assessmentId": "940c62e0-c77a-11ec-9a20-273c6ff69cdd",
        "title": "Healing and You",
        "question": "Which ailments are you dealing with?",
        "image": "https://content.aayu.live/aayu/app/onboard/healingandyou.png",
        "options": [
          {"text": "Heart Disease", "selected": false},
          {"text": " PCOS", "selected": false},
          {"text": " Anxiety Disorder", "selected": false},
          {"text": " Hypertension", "selected": false},
          {"text": " Insomnia", "selected": false}
        ]
      });
      Get.put(HealingAndYouController(assessment));
    }
  }

  initializeMovementAndYouController() {
    if (onboardingAssessment.value != null &&
        onboardingAssessment.value!.assessment != null &&
        onboardingAssessment.value!.assessment!.isNotEmpty &&
        onboardingAssessment.value!.assessment![2] != null) {
      Get.put(MovementAndYouController(
          onboardingAssessment.value!.assessment![2]!));
    } else {
      OnboardAssessmentModelAssessment assessment =
          OnboardAssessmentModelAssessment.fromJson({
        "assessmentId": "7c980d80-c77a-11ec-9a20-273c6ff69cdd",
        "title": "Movement and You",
        "question": "Do you have any pain or injuries?",
        "image":
            "https://content.aayu.live/aayu/app/onboard/movementandyou.png",
        "options": [
          {"text": "Back", "selected": false},
          {"text": " Hips", "selected": false},
          {"text": " Neck", "selected": false},
          {"text": " Knee", "selected": false},
          {"text": " Ankle", "selected": false},
          {"text": " Shoulder", "selected": false}
        ]
      });
      Get.put(MovementAndYouController(assessment));
    }
  }
}
