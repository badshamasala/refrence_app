import 'dart:math';
import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/view/consulting/nutrition/how_it_works.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions_info.dart';
import 'package:aayu/view/healing/healing_list.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/services.dart';
import '../../view/healing/consultant/doctor_list.dart';
import '../../view/healing/consultant/sessions/doctor_sessions.dart';
import '../../view/healing/consultant/trainer_list.dart';
import '../../view/new_deeplinks/book_freee_doctor.dart';
import '../../view/trackers/mood_tracking/intro/mood_checkin_intro.dart';
import '../consultant/doctor_session_controller.dart';
import '../consultant/trainer_session_controller.dart';
import '../daily_records/weight_tracker/weight_details_controller.dart';

class CrossPromotionsController extends GetxController {
  Random random = Random();
  RxBool isLoading = false.obs;

  Map<String, List<Map<String, String>>> messageList = {
    "NUTRITION": [
      // {
      //   "title": "Nutrition Care",
      //   "icon": Images.foodBowlImage,
      //   "subTitle": "At Aayu, we match your health needs with our expertise",
      //   "desc":
      //       "Aayu’s range of personalised health management programs are designed to suit your health needs. All our doctors are experts, trained in Integrated Yoga Therapy",
      //   "ctaText": "Book a Call",
      //   "bgImage": Images.crossPromoNutrition
      // },
      {
        "title": "Healing Nutrition",
        "icon": Images.foodBowlImage,
        "subTitle": "At Aayu, we match your health needs with our expertise",
        "desc":
            "Let’s get you on the road to optimum wellness. Get personalised food plan that fits your lifestyle",
        "ctaText": "Nourish!",
        "bgImage": Images.crossPromoYellowBG
      },
      // {
      //   "title": "Nutrition Care",
      //   "icon": Images.foodBowlImage,
      //   "subTitle":
      //       "Eating healthy is the first steps towards Healthy lifestyle",
      //   "desc":
      //       "Aayu’s range of personalised health management programs are designed to suit your health needs. All our doctors are experts, trained in Integrated Yoga Therapy",
      //   "ctaText": "Book a Call",
      //   "bgImage": Images.crossPromoNutrition
      // },
    ],
    "AAYU_NOT_SUBSCRIBED": [
      {
        "title": "Subscribe, Reap Benefits!",
        "icon": Images.personalisedCareLogo,
        "subTitle":
            "If you have any aliments, Start your Healing Journey Today",
        "desc":
            "Take charge of your health with our incredible health and wellness programs. Don’t wait, subscribe today for a healthier, happier you!",
        "ctaText": "Subscribe Now!",
        "bgImage": Images.crossPromoPinkBG
      },
    ],
    "HEALING_NOT_SUBSCRIBED": [
      {
        "title": "Personalised Transformation",
        "icon": Images.personalisedCareLogo,
        "subTitle":
            "If you have any aliments, Start your Healing Journey Today",
        "desc":
            "True transformation starts with personalised attention. With our health management program, you'll be able to achieve real, lasting change that fits into your lifestyle.",
        "ctaText": "Transform!",
        "bgImage": Images.crossPromoPinkBG
      },
    ],
    "PSYCHOLOGIST": [
      {
        "title": "Mental Wellbeing",
        "icon": Images.crossPromoMentalWellBeingImage,
        "subTitle":
            "Mind and Body both needs the different treatment, Speak to our experts for mindfulness",
        "desc":
            "Its worth investing in your mental health. Our evidence-based approach combines yoga therapy, mindfulness, and self-care techniques to cultivate greater resilience.",
        "ctaText": "Embrace Awareness!",
        "bgImage": Images.crossPromoGreenBG
      },
    ],
    "THERAPIST_CONSULTATION": [
      {
        "title": "Hire Yoga Therapist",
        "icon": Images.crossPromoTherapistImage,
        "subTitle":
            "Yoga is the best mate anyone can have; It helps you to connect to your Inner peace",
        "desc":
            "Heal your body and mind with personalized yoga therapy sessions - hire a one-on-one coach now! Get focused attention from a professional coach.",
        "ctaText": "Book Now!",
        "bgImage": Images.crossPromoBlueBG
      },
    ],
    "DOCTOR_CONSULTATION": [
      {
        "title": "Doctor Consultation",
        "icon": Images.doctorConsultant3Image,
        "subTitle":
            "Yoga is the best mate anyone can have; It helps you to connect to your Inner peace",
        "desc":
            "Say goodbye to lifestyle disorders. Consult with a doctor trained in yoga therapy for a personalized healing experience!",
        "ctaText": "Book Now!",
        "bgImage": Images.crossPromoPinkBG
      },
    ],
    "MOOD_CHECKIN": [
      {
        "title": "Know Your Mood",
        "icon": Images.crossPromoMoodImage,
        "subTitle":
            "Yoga is the best mate anyone can have; It helps you to connect to your Inner peace",
        "desc":
            "Stay in control of your emotions and thrive with our expert mood tracker!",
        "ctaText": "Thrive!",
        "bgImage": Images.crossPromoYellowBG
      },
    ]
  };

  Rx<CrossPromotionModel?> crossPromotionDetails = CrossPromotionModel().obs;

  Future<void> getCrossPromotion({required String moduleName}) async {
    isLoading(true);
    crossPromotionDetails.value = null;
    List<String> typeList = [];

    switch (moduleName.toUpperCase()) {
      case "WEIGHT_TRACKER":
        WeightDetailsController weightDetailsController = Get.find();
        double bmi = weightDetailsController.bmiValue;
        if (bmi < 18.5) {
          if (await canGiveNutrition()) {
            typeList.add("NUTRITION");
          }

          if (subscriptionCheckResponse == null ||
              subscriptionCheckResponse?.subscriptionDetails == null) {
            typeList.add("AAYU_NOT_SUBSCRIBED");
          }
          typeList.add("MOOD_CHECKIN");
        } else if (bmi >= 18.5 && bmi <= 25) {
          if (canGiveHealing()) {
            typeList.add("HEALING_NOT_SUBSCRIBED");
          }
          typeList.add("THERAPIST_CONSULTATION");
          if (subscriptionCheckResponse == null ||
              subscriptionCheckResponse?.subscriptionDetails == null) {
            typeList.add("AAYU_NOT_SUBSCRIBED");
          }
          typeList.add("MOOD_CHECKIN");
        } else {
          if (await canGiveNutrition()) {
            typeList.add("NUTRITION");
          }
          if (canGiveHealing()) {
            typeList.add("HEALING_NOT_SUBSCRIBED");
          }
          typeList.add("THERAPIST_CONSULTATION");
          typeList.add("DOCTOR_CONSULTATION");
          if (subscriptionCheckResponse == null ||
              subscriptionCheckResponse?.subscriptionDetails == null) {
            typeList.add("AAYU_NOT_SUBSCRIBED");
          }
          typeList.add("MOOD_CHECKIN");
        }
        setCrossPromotion(typeList[random.nextInt(typeList.length)]);
        break;
      case "WATER_INTAKE":
        if (subscriptionCheckResponse != null &&
            subscriptionCheckResponse!.subscriptionDetails != null) {
          if (subscriptionCheckResponse!
              .subscriptionDetails!.programId!.isEmpty) {
            typeList.add("HEALING_NOT_SUBSCRIBED");
          }
          if (await canGiveNutrition()) {
            typeList.add("NUTRITION");
          }
          // typeList.add("PSYCHOLOGIST");
          typeList.add("THERAPIST_CONSULTATION");
          setCrossPromotion(typeList[random.nextInt(typeList.length)]);
        } else {
          typeList.add("AAYU_NOT_SUBSCRIBED");
          if (await canGiveNutrition()) {
            typeList.add("NUTRITION");
          }
          setCrossPromotion(typeList[random.nextInt(typeList.length)]);
        }
        break;
      default:
        break;
    }
    isLoading(false);
    update();
  }

  setCrossPromotion(String type) {
    crossPromotionDetails.value =
        CrossPromotionModel.fromJson(messageList[type]![0]);
    crossPromotionDetails.value!.type = type;
  }

  handleNavigation() async {
    switch (crossPromotionDetails.value!.type) {
      case "AAYU_NOT_SUBSCRIBED":
        Get.to(const SubscribeToAayu(
            subscribeVia: "CROSS_PROMOTION", content: null));
        break;
      case "HEALING_NOT_SUBSCRIBED":
        Get.to(const HealingList(pageSource: "CROSS_PROMOTION"));
        break;
      case "NUTRITION":
        Get.to(const HowItWorks());

        break;
      case "THERAPIST_CONSULTATION":
        bookTrainerConsult(null);

        break;
      case "DOCTOR_CONSULTATION":
        bookDoctorConsult(null);

        break;

      case "MOOD_CHECKIN":
        Get.to(const MoodCheckInIntro());
        break;
    }
  }

  Future<bool> canGiveNutrition() async {
    late NutritionController nutritionController;
    if (NutritionController().initialized == false) {
      nutritionController = Get.put(NutritionController());
    } else {
      nutritionController = Get.find();
    }
    await nutritionController.getUserNutritionDetails();
    return nutritionController.userNutritionDetails.value == null;
  }

  bool canGiveHealing() {
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null) {
      if (subscriptionCheckResponse!
          .subscriptionDetails!.programId!.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  // Future<bool> canGivePsychology() async {
  //   late PsychologyController psychologyController;
  //   if (PsychologyController().initialized == false) {
  //     psychologyController = Get.put(PsychologyController());
  //   } else {
  //     psychologyController = Get.find();
  //   }
  //   await psychologyController.getUserPsychologyDetails();
  //   return psychologyController.userPsychologyDetails.value == null;
  // }

  Future<void> bookDoctorConsult(String? promoCode) async {
    buildShowDialog(Get.context!);
    DoctorSessionController doctorSessionController =
        Get.put(DoctorSessionController());
    await doctorSessionController.getUpcomingSessions();

    if (doctorSessionController.upcomingSessionsList.value != null &&
        doctorSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        doctorSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      EventsService().sendClickNextEvent(
          "DoctorConsultationInfo", "Select Doctor", "DoctorSessions");
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      Get.to(const DoctorSessions());
    } else {
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);

      Get.bottomSheet(
        BookFreeDoctor(
          allowBack: true,
          bookFunction: () {
            Navigator.of(Get.context!).popUntil((route) => route.isFirst);

            redirectToDoctorList(Get.context!, promoCode);
          },
        ),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
      );
    }
  }

  redirectToDoctorList(BuildContext context, String? promoCode) async {
    EventsService().sendClickNextEvent(
        "DoctorConsultationInfo", "Select Doctor", "DoctorList");
    Get.to(DoctorList(
      promoCode: promoCode,
      pageSource: "MY_ROUTINE",
      consultType: "GOT QUERY",
      bookType: "PAID",
    ));
  }

  Future<void> bookTrainerConsult(String? promoCode) async {
    buildShowDialog(Get.context!);
    TrainerSessionController trainerSessionController =
        Get.put(TrainerSessionController());
    await trainerSessionController.getUpcomingSessions();
    Navigator.of(Get.context!).pop();

    if (trainerSessionController.upcomingSessionsList.value != null &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        trainerSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      Get.to(TrainerSessionsInfo(bookFunction: () {
        Navigator.of(Get.context!).pop();
        Get.to(const TrainerSessions());
      }));
    } else {
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);

      Get.bottomSheet(
        TrainerSessionsInfo(
          bookFunction: () {
            Navigator.of(Get.context!).popUntil((route) => route.isFirst);
            Get.to(TrainerList(
              promoCode: promoCode,
              pageSource: "MY_ROUTINE",
              consultType: "GOT QUERY",
              bookType: "PAID",
            ));
          },
        ),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
      );
    }
  }
}

class CrossPromotionModel {
/*
{
  "type":"SUBSCRIPTION",
  "title": "Aayu Subscription",
  "icon": "Images.aayuHealingImage",
  "subTitle": "If you have any aliments, Start your Healing Journey Today",
  "desc": "Aayu’s range of personalised health management programs are designed to suit your health needs. All our doctors are experts, trained in Integrated Yoga Therapy",
  "ctaText": "Explore Now",
  "bgImage":"image"
} 
*/

  String? type;
  String? title;
  String? icon;
  String? subTitle;
  String? desc;
  String? ctaText;
  String? bgImage;

  CrossPromotionModel(
      {this.title,
      this.icon,
      this.subTitle,
      this.desc,
      this.ctaText,
      this.bgImage});
  CrossPromotionModel.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    title = json['title']?.toString();
    icon = json['icon']?.toString();
    subTitle = json['subTitle']?.toString();
    desc = json['desc']?.toString();
    ctaText = json['ctaText']?.toString();
    bgImage = json['bgImage']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['icon'] = icon;
    data['subTitle'] = subTitle;
    data['desc'] = desc;
    data['ctaText'] = ctaText;
    data['bgImage'] = bgImage;
    return data;
  }
}
