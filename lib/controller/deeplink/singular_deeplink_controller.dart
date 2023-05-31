import 'package:aayu/controller/consultant/nutrition/nutrition_plan_controller.dart';
import 'package:aayu/controller/consultant/psychologist/psychology_plan_controller.dart';
import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/controller/daily_records/water_intake/water_intake_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/controller/deeplink/disease_details_deeplink_controller.dart';
import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_plans/psychologist_plans.dart';
import 'package:aayu/view/content/content_details/content_details.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions_info.dart';
import 'package:aayu/view/healing/disease_details/disease_details.dart';
import 'package:aayu/view/home/widgets/my_routine/breathing_exercise.dart';
import 'package:aayu/view/live_events/live_events_details.dart';
import 'package:aayu/view/new_deeplinks/book_freee_doctor.dart';
import 'package:aayu/view/new_deeplinks/thank_you_screens/thank_you_book_doctor_deeplink.dart';
import 'package:aayu/view/new_deeplinks/thank_you_screens/thank_you_disease_deeplink.dart';
import 'package:aayu/view/onboarding/get_started.dart';
import 'package:aayu/view/profile/my_subscriptions.dart';
import 'package:aayu/view/search/affirmation_screen.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:aayu/view/subscription/upgrade_subscription.dart';
import 'package:aayu/view/trackers/sleep_tracking/intro/sleep_tracker_intro.dart';
import 'package:aayu/view/trackers/water_intake/intro/water_intake_intro.dart';
import 'package:aayu/view/trackers/weight_tracking/intro/weight_tracking_intro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:aayu/view/consulting/nutrition/home/nutrition_home.dart';
import 'package:aayu/view/consulting/nutrition/how_it_works.dart';
import 'package:aayu/view/consulting/psychologist/home/psychology_home.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/healing/consultant/trainer_list.dart';
import 'package:aayu/view/new_deeplinks/disease_details_test.dart';
import 'package:aayu/view/new_deeplinks/single_option_disease_subscription.dart';
import 'package:aayu/view/onboarding/onboarding_bottom_sheet.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/view/trackers/mood_tracking/intro/mood_checkin_intro.dart';
import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/content/content_details_controller.dart';
import 'package:aayu/controller/payment/subscription_package_controller.dart';
import '../../view/subscription/renew_subscription.dart';

class SingularDeepLinkController extends GetxController {
  Map<String, dynamic>? deepLinkData;
  Map<String, dynamic>? deepLinkDataContinued;
  Map<String, dynamic>? contentDeeplinkData;
  Function? goToHealing;
  Function? goToGrow;
  Function? diseaseDetailAlreadySubscribed;
  Function? freeDoctorConsultation;
  String utmSource = 'Not Available';
  String utmCampaign = 'Not Available';
  Function? goToQuickAccess;

  storeData(Map<String, dynamic> data) {
    print("SINgULAR DEEEPLINK DATA=========> $data");
    deepLinkData = data;
  }

  setDeepLinkDataContinued(Map<String, dynamic> data) {
    deepLinkDataContinued = data;
  }

  getGotoHealing(Function healing, Function grow) {
    goToHealing = healing;
    goToGrow = grow;
  }

  getFreedoctorConsult(Function function) {
    freeDoctorConsultation = function;
  }

  getDiseaseDetailsAlreadySubscribed(Function function) {
    diseaseDetailAlreadySubscribed = function;
  }

  nullDeepLinkData() {
    deepLinkData = null;
  }

  getGotoQuickAccess(Function function) {
    goToQuickAccess = function;
  }

  handleNavigationBeforeRegistration() async {
    if (deepLinkData != null) {
      Future.delayed(const Duration(seconds: 1), () {
        switch (deepLinkData!["screenName"].toString().toUpperCase()) {
          case "DISEASE_DETAILS":
            DiseaseDetailsDeeplinkController diseaseDetailsDeeplinkController =
                Get.put(DiseaseDetailsDeeplinkController());
            if (deepLinkData!['diseaseId'] != null) {
              diseaseDetailsDeeplinkController
                  .getDiseaseDetails(deepLinkData!['diseaseId'])
                  .then((value) {
                Get.to(DiseaseDetailsTest(
                  deepLinkData: deepLinkData!,
                ))!
                    .then((value) {
                  deepLinkData = null;
                });
              });
            }
            break;
          case "PERSONALIZED_CARE":
            personalizedCareBeforeRegistration();
            break;
          case "BOOK_DOCTOR_CONSULT":
            Get.to(
                BookFreeDoctor(deeplinkData: deepLinkData!, allowBack: false));
            deepLinkData = null;
            break;
          case "CONTENT_DETAILS":
            contentDeeplinkData = deepLinkData;
            contentDetailsBeforeRegistration();
            break;
          default:
            EventsService().sendClickNextEvent(
                "WelcomePage", "AutoRedirect", "GetStarted");
            Get.off(
              const GetStarted(),
            );
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        EventsService()
            .sendClickNextEvent("WelcomePage", "AutoRedirect", "GetStarted");
        Get.off(
          const GetStarted(),
        );
      });
    }
  }

  handleClickOnContentDetailsBeforeReg(String contentId) {
    deepLinkDataContinued = contentDeeplinkData;
    deepLinkDataContinued!['contentId'] = contentId;
    deepLinkData = null;
    Get.to(const OnboardingBottomSheet());
  }

  handleNavigationContinued() {
    print("PRINTING CONTINUED DATA");
    print(deepLinkDataContinued);
    if (deepLinkDataContinued != null) {
      switch (deepLinkDataContinued!["screenName"].toString().toUpperCase()) {
        case "DISEASE_DETAILS":
          diseaseDetailsContinued().then((value) {
            deepLinkDataContinued = null;
          });
          break;
        case "BOOK_DOCTOR_CONSULT":
          Get.to(ThankYouBookDoctorDeepLink(
            data: deepLinkDataContinued!,
          ))!
              .then((value) {
            deepLinkDataContinued = null;
          });
          break;
        case "CONTENT_DETAILS":
          contentDetailsContinued();
          break;
        default:
      }
    }
  }

  handleNavigation() async {
    print("DATA BEFORE HANDLING $deepLinkData");

    if (deepLinkData != null) {
      print("HEANDLING NAVIGATION ===========");
      switch (deepLinkData!["screenName"].toString().toUpperCase()) {
        case "CONTENT_DETAILS":
          contentDetails();
          deepLinkData = null;
          break;
        case "HEALING_LIST":
          healingList();
          deepLinkData = null;
          break;
        case "DISEASE_DETAILS":
          diseaseDetails().then((value) {
            deepLinkData = null;
          });
          break;
        case "AAYU_BREATHE":
          Get.to(const BreathingExercise());
          deepLinkData = null;
          break;
        case "PERSONALIZED_CARE":
          personalizedCare().then((value) {
            deepLinkData = null;
          });
          break;
        case "GROW":
        case "GROW_TAB":
          goToGrow!(deepLinkData!['tab']);
          deepLinkData = null;
          break;
        case "BOOK_DOCTOR_CONSULT":
          bookDoctorConsult(deepLinkData?["promoCode"]).then((value) {
            deepLinkData = null;
          });
          break;
        case "BOOK_TRAINER_CONSULT":
          bookTrainerConsult(deepLinkData?["promoCode"]).then((value) {
            deepLinkData = null;
          });
          break;
        case "INITIAL_ASSESSMENT":
          diseaseDetailAlreadySubscribed!();
          deepLinkData = null;
          break;
        case "DAY_WISE_PROGRAM":
          diseaseDetailAlreadySubscribed!();
          deepLinkData = null;
          break;
        case "DOCTOR_SESSIONS":
          Get.to(const DoctorSessions());
          deepLinkData = null;
          break;
        case "TRAINER_SESSIONS":
          Get.to(TrainerSessionsInfo(bookFunction: () {
            Get.to(const TrainerSessions());
          }));
          deepLinkData = null;
          break;
        case "LIVE_EVENT":
          if (deepLinkData!["liveEventId"] != null) {
            Get.to(LiveEventsDetails(
              source: "",
              heroTag: "LiveEvent_${deepLinkData!["liveEventId"] ?? ""}",
              liveEventId: deepLinkData!["liveEventId"] ?? "",
            ));
          }

          deepLinkData = null;
          break;
        case "SUBSCRIBE_TO_AAYU":
          if (!(subscriptionCheckResponse != null &&
              subscriptionCheckResponse!.subscriptionDetails != null &&
              subscriptionCheckResponse!
                  .subscriptionDetails!.subscriptionId!.isNotEmpty)) {
            Get.bottomSheet(
              SubscribeToAayu(
                subscribeVia: "DEEPLINK",
                content: null,
                packageType: deepLinkData?["packageType"],
                promoCode: deepLinkData?["promoCode"],
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
            );
          }

          deepLinkData = null;
          break;
        case "AFFIRMATION":
          if (deepLinkData!['contentId'] != null) {
            String contentId = deepLinkData!['contentId'];
            ContentDetailsController contentController =
                Get.put(ContentDetailsController(), tag: contentId);
            contentController.returnContentDetails(contentId).then((value) {
              if (value != null && value.content != null) {
                Get.to(AffirmationScreen(
                  content: value.content!,
                  favouriteAction: () {},
                  moreAffirmations: null,
                ));
              }
            });
          }
          deepLinkData = null;
          break;
        case "SINGLE_OPTION_DISEASE_SUBSCRIPTION":
          singleOptionDiseaseSubscription().then((value) {
            deepLinkData = null;
          });
          break;
        case "MOOD_TRACKER":
          if (MoodTrackerController().initialized == false) {
            Get.put(MoodTrackerController());
          }
          Navigator.of(Get.context!)
              .push(
            MaterialPageRoute(
              builder: (context) => const MoodCheckInIntro(),
            ),
          )
              .then((value) {
            deepLinkData = null;
          });
          break;
        case "SLEEP_TRACKER":
          if (SleepTrackerController().initialized == false) {
            Get.put(SleepTrackerController());
          }
          Get.to(const SleepTrackerIntro())!
              .then((value) => deepLinkData = null);
          break;
        case "WATER_INTAKE_TRACKER":
          Get.put(WaterIntakesController());
          Navigator.of(Get.context!)
              .push(
                MaterialPageRoute(
                  builder: (context) => const WaterIntakeIntro(),
                ),
              )
              .then((value) => deepLinkData = null);
          break;
        case "WEIGHT_TRACKER":
          Get.put(WeightDetailsController());
          Navigator.of(Get.context!)
              .push(
                MaterialPageRoute(
                  builder: (context) => const WeightTrackingIntro(),
                ),
              )
              .then((value) => deepLinkData = null);

          break;
        case "BOOK_NUTRITION_CONSULT":
          bookNutritionConsult(deepLinkData?["promoCode"]).then((value) {
            deepLinkData = null;
          });
          break;
        case "BOOK_PSYCHOLOGY_CONSULT":
          bookPsychologyConsult(deepLinkData?["promoCode"]).then((value) {
            deepLinkData = null;
          });
          break;
        case "UPGRADE_SUBSCRIPTION":
          handleUpgradeSubscription(deepLinkData?["promoCode"]).then((value) {
            deepLinkData = null;
          });
          break;
        case "RENEW_SUBSCRIPTION":
          handleRenewSubscription(deepLinkData?["promoCode"]).then((value) {
            deepLinkData = null;
          });
          break;
        case "QUICK_ACCESS":
          if (goToQuickAccess != null) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              goToQuickAccess!();
            });
          }

          deepLinkData = null;
          break;

        default:
          break;
      }
    }
  }

  Future<void> singleOptionDiseaseSubscription() async {
    if (deepLinkData!['diseaseId'] != null &&
        deepLinkData!['packageType'] != null &&
        !(subscriptionCheckResponse != null &&
            subscriptionCheckResponse!.subscriptionDetails != null &&
            subscriptionCheckResponse!
                .subscriptionDetails!.subscriptionId!.isNotEmpty)) {
      buildShowDialog(Get.context!);
      SubscriptionPackageController subscriptionPackageController = Get.find();
      await subscriptionPackageController.getSubscriptionPackages(
          "SINGLE DISEASE", "SUBSCRIBE");
      HealingListController healingListController = Get.find();
      await healingListController.getHealingList();
      await healingListController
          .setDiseaseFromDeepLink(deepLinkData!['diseaseId']);

      DiseaseDetailsController diseaseDetailsController =
          Get.put(DiseaseDetailsController());
      await diseaseDetailsController.getDiseaseDetails();
      Navigator.of(Get.context!).pop();

      Get.to(SingleOptionDiseaseSubscription(
        packageType: deepLinkData!['packageType'] ?? "",
      ));
    }
  }

  contentDetails() {
    if (deepLinkData!["contentId"].isNotEmpty) {
      EventsService()
          .sendClickNextEvent("Home", "Dynamic Link", "ContentDetails");
      Get.to(
        ContentDetails(
          source: "",
          heroTag: "SharedContent_${deepLinkData!["contentId"]}",
          contentId: deepLinkData!["contentId"],
          categoryContent: const [],
          autoPlayContent: deepLinkData!["autoPlayContent"] ?? false,
        ),
      )!
          .then((value) {
        deepLinkData = null;
        EventsService().sendClickBackEvent("ContentDetails", "Back", "Home");
      });
    }
  }

  contentDetailsContinued() {
    if (deepLinkDataContinued!["contentId"].isNotEmpty) {
      EventsService()
          .sendClickNextEvent("Home", "Dynamic Link", "ContentDetails");
      Get.to(
        ContentDetails(
          source: "THANKYOU",
          heroTag: "SharedContent_${deepLinkDataContinued!["contentId"]}",
          contentId: deepLinkDataContinued!["contentId"],
          categoryContent: const [],
          autoPlayContent: deepLinkData!["autoPlayContent"] ?? false,
        ),
      )!
          .then((value) {
        deepLinkDataContinued = null;
        EventsService().sendClickBackEvent("ContentDetails", "Back", "Home");
      });
    }
  }

  contentDetailsBeforeRegistration() {
    if (deepLinkData!["contentId"].isNotEmpty) {
      Get.to(
        ContentDetails(
          source: "DEEPLINK",
          heroTag: "SharedContent_${deepLinkData!["contentId"]}",
          contentId: deepLinkData!["contentId"],
          categoryContent: const [],
          autoPlayContent: deepLinkData!["autoPlayContent"] ?? false,
        ),
      )!
          .then((value) {
        deepLinkData = null;
      });
    }
  }

  healingList() async {
    HealingListController healingListController = Get.find();
    await healingListController.getHealingList();
    goToHealing!();
  }

  Future<void> diseaseDetails() async {
    if (deepLinkData!['diseaseId'] != null) {
      HealingListController healingListController = Get.find();
      await healingListController.getHealingList();
      await healingListController
          .setDiseaseFromDeepLink(deepLinkData!['diseaseId']);
      EventsService().sendClickNextEvent(
          "Healing List", "View Program", "Disease Details");
      Get.put(DiseaseDetailsController());

      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null &&
          subscriptionCheckResponse!.subscriptionDetails!.programId != null &&
          subscriptionCheckResponse!
              .subscriptionDetails!.programId!.isNotEmpty) {
        //diseaseDetailAlreadySubscribed!();
        Get.to(
          const DiseaseDetails(
            fromThankYou: false,
            pageSource: "EXPLORE_PROGRAM",
          ),
        );
      } else {
        Get.to(const DiseaseDetails(
          fromThankYou: false,
        ))!
            .then((value) {
          EventsService()
              .sendClickBackEvent("Disease Details", "Back", "Healing List");
        });
      }
    }
  }

  Future<void> diseaseDetailsContinued() async {
    if (deepLinkDataContinued!['diseaseId'] != null) {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        diseaseDetailAlreadySubscribed!();
      } else {
        HealingListController healingListController =
            Get.put(HealingListController());
        await healingListController.getHealingList();

        await healingListController
            .setDiseaseFromDeepLink(deepLinkDataContinued!['diseaseId']);

        Get.to(ThankYouDiseaseDeepLink());
      }
    }
  }

  Future<void> personalizedCare() async {
    if (deepLinkData!['diseaseId'] != null) {
      final String diseaseId = deepLinkData!['diseaseId'] as String;
      List<String> diseaseList = diseaseId.trim().split(',');
      HealingListController healingListController = Get.find();
      await healingListController.getHealingList();

      await healingListController
          .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);

      Get.to(const DiseaseDetails(
        fromThankYou: false,
      ))!
          .then((value) {
        deepLinkData = null;
      });
    }
  }

  Future<void> personalizedCareBeforeRegistration() async {
    if (deepLinkData!['diseaseId'] != null) {
      final String diseaseId = deepLinkData!['diseaseId'] as String;
      List<String> diseaseList = diseaseId.trim().split(',');
      DiseaseDetailsDeeplinkController diseaseDetailsDeeplinkController =
          Get.put(DiseaseDetailsDeeplinkController());
      diseaseDetailsDeeplinkController.setIsPersonalized();
      await diseaseDetailsDeeplinkController
          .getDiseaseDetailsPersonalizedCare(diseaseList);
      Get.to(DiseaseDetailsTest(
        deepLinkData: deepLinkData!,
      ))!
          .then((value) {
        deepLinkData = null;
      });
    }
  }

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
      // Get.bottomSheet(
      //   TrainerSessionsInfo(bookFunction: () async {
      //     buildShowDialog(Get.context!);
      //     bool isAllowed =
      //         await checkIsPaymentAllowed("THERAPIST_CONSULTATION");
      //     if (isAllowed == true) {
      //       PostAssessmentController postAssessmentController =
      //           Get.put(PostAssessmentController());
      //       await postAssessmentController.getConsultingPackageDetails();
      //       Navigator.pop(Get.context!);
      //       Navigator.pop(Get.context!);

      //       Get.bottomSheet(
      //         const GetTrainerSessions(),
      //         isScrollControlled: true,
      //         isDismissible: true,
      //         enableDrag: false,
      //       );
      //     }
      //   }),
      //   isScrollControlled: true,
      //   isDismissible: true,
      //   enableDrag: false,
      // );
    }
  }

  setUtmParams(String? source, String? campaign) {
    print('========STORING SOURCE & CAMPAIGN============');
    print(source);
    print(campaign);
    if (source != null && source.isNotEmpty) {
      utmSource = source;
    }
    if (campaign != null && campaign.isNotEmpty) {
      utmCampaign = campaign;
    }
  }

  Future<void> bookNutritionConsult(String? promoCode) async {
    late NutritionController nutritionController;
    if (NutritionController().initialized == false) {
      nutritionController = Get.put(NutritionController());
    } else {
      nutritionController = Get.find();
    }
    await nutritionController.getUserNutritionDetails();
    if (nutritionController.userNutritionDetails.value != null) {
      Get.to(const NutritionHome());
    } else {
      if (promoCode != null) {
        late NutritionPlanController nutritionPlanController;
        if (NutritionPlanController().initialized == false) {
          nutritionPlanController = Get.put(NutritionPlanController());
        } else {
          nutritionPlanController = Get.find();
        }
        nutritionPlanController.setAutoApplyPromoCode(promoCode);
      }

      Get.to(const HowItWorks());
    }
  }

  Future<void> bookPsychologyConsult(String? promoCode) async {
    late PsychologyController psychologyController;
    if (PsychologyController().initialized == false) {
      psychologyController = Get.put(PsychologyController());
    } else {
      psychologyController = Get.find();
    }
    await psychologyController.getUserPsychologyDetails();
    if (psychologyController.userPsychologyDetails.value != null) {
      Get.to(const PsychologyHome());
    } else {
      if (promoCode != null) {
        late PsychologyPlanController psychologyPlanController;
        if (PsychologyPlanController().initialized == false) {
          psychologyPlanController = Get.put(PsychologyPlanController());
        } else {
          psychologyPlanController = Get.find();
        }
        psychologyPlanController.setAutoApplyPromoCode(promoCode);
      }
      Get.to(const PsychologistPlans(
        extendPlan: false,
      ));
    }
  }

  Future<void> handleUpgradeSubscription(String? promoCode) async {
    late SubscriptionController subscriptionController;
    if (SubscriptionController().initialized == false) {
      subscriptionController = Get.put(SubscriptionController());
    } else {
      subscriptionController = Get.find();
    }

    await subscriptionController.getSubscriptionDetails();

    if (subscriptionController
                .subscriptionDetailsResponse.value?.subscriptionDetails !=
            null &&
        (subscriptionController.subscriptionDetailsResponse.value!
                    .subscriptionDetails!.allowUpgrade ??
                false) ==
            true) {
      SubscriptionPackageController subscriptionPackageController = Get.find();
      await subscriptionPackageController.getUpgradeSubscriptionPackages();

      Get.bottomSheet(
          UpgradeSubscription(
              subscriptionController: subscriptionController,
              subscribeVia: "MY_SUBSCRIPTION"),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          )));
    }
  }

  Future<void> handleRenewSubscription(String? promoCode) async {
    late SubscriptionController subscriptionController;
    if (SubscriptionController().initialized == false) {
      subscriptionController = Get.put(SubscriptionController());
    } else {
      subscriptionController = Get.find();
    }

    await subscriptionController.getSubscriptionDetails();

    if (subscriptionController
            .subscriptionDetailsResponse.value?.subscriptionDetails !=
        null) {
      Get.bottomSheet(
        RenewSubscription(
          renewalVia: "MY_SUBSCRIPTIONS",
          promoCode: promoCode,
        ),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      );
    } else {
      Get.to(MySubscriptions(
        promoCode: promoCode,
      ));
    }
  }
}
