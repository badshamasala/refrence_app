import 'dart:convert';
import 'package:aayu/model/model.dart';
import 'package:get/get.dart';

class GetStartedController extends GetxController {
  Rx<int> currentIndex = 0.obs;
  Rx<GetStartedScreenModel> getStartedScreenData = GetStartedScreenModel().obs;

  Map<String, List<Map<String, String>>> screenOptions = {
    "screens": [
      {
        "heading": "Get Online Consultation\nwith a Doctor",
        "subTitle":
            "Talk to our integrative medical doctors for all your health needs and get personalised health programs that suits to you. Everybody's health is unique so is the cure.",
        "image": "assets/images/onboarding/free_doctor_consultation.png"
      },
      {
        "heading": "Synchronised \nGrowth",
        "subTitle":
            "De-stress yourself with guided yoga,\nmeditation, calming music, daily affirmations and a lot more to help you heal and grow.",
        "image": "assets/images/onboarding/grow_content.png"
      },
      {
        "heading": "Aayu Live",
        "subTitle":
            "Watch experts, discuss the secrets of life, yoga therapy, diet, fitness, healing, personal growth, mental health and everything in between that will help you thrive.",
        "image": "assets/images/onboarding/live-event-walkthrough.png"
      },
      {
        "heading": "Online Therapy\nSessions",
        "subTitle":
            "LIVE interactive yoga therapy sessions for all your fitness and health goals from the comforts of your home.",
        "image": "assets/images/onboarding/therapist-walkthrough.png"
      },
      {
        "heading": "Track Health \nInsights",
        "subTitle":
            "Check your health index, updated \nperiodically basis your assessments and \nyour daily practice commitments.",
        "image": "assets/images/onboarding/health_insights_image.png"
      },
    ]
  };

  @override
  void onInit() {
    getStartedScreens();
    super.onInit();
  }

  getStartedScreens() {
    try {
      getStartedScreenData.value =
          GetStartedScreenModel.fromJson(jsonDecode(jsonEncode(screenOptions)));
    } finally {}
  }
}
