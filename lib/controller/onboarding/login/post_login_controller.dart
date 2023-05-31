import 'package:aayu/view/search/artist_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/third-party/events.service.dart';
import '../../../view/content/content_details/content_details.dart';
import '../../../view/healing/consultant/doctor_list.dart';
import '../../../view/healing/consultant/sessions/buy_sessions/get_trainer_sessions.dart';
import '../../../view/healing/consultant/sessions/doctor_sessions.dart';
import '../../../view/healing/consultant/sessions/trainer_sessions.dart';
import '../../../view/healing/consultant/sessions/trainer_sessions_info.dart';
import '../../../view/healing/disease_details/disease_details.dart';
import '../../../view/live_events/live_events_details.dart';
import '../../../view/new_deeplinks/book_freee_doctor.dart';
import '../../../view/search/affirmation_screen.dart';
import '../../../view/shared/constants.dart';
import '../../../view/shared/ui_helper/ui_helper.dart';
import '../../../view/subscription/personalised_care_subscription.dart';
import '../../consultant/doctor_session_controller.dart';
import '../../consultant/trainer_session_controller.dart';
import '../../content/content_details_controller.dart';
import '../../healing/disease_details_controller.dart';
import '../../healing/healing_list_controller.dart';
import '../../healing/post_assessment_controller.dart';
import '../../search/search_controller.dart';
import '../../subscription/subscription_controller.dart';

class PostLoginController extends GetxController {
  Map<String, dynamic>? data;

  Function? changeMainPageTo;
  Function? changePageToGrow;

  storeData(Map<String, dynamic> map) {
    print("POST LOGIN DATA=========> $map");
    data = map;
  }

  getFunctions(Function function, Function growFunction) {
    changeMainPageTo = function;
    changePageToGrow = growFunction;
  }

  handleNavigation() async {
    print("DATA BEFORE HANDLING $data");

    if (data != null) {
      print("HEANDLING NAVIGATION POST LOGIN===========");
      switch (data!["screenName"].toString().toUpperCase()) {
        case "CONTENT_DETAILS":
          contentDetails();
          data = null;
          break;
        // case "HEALING_LIST":
        //   healingList();
        //   deepLinkData = null;
        //   break;
        case "DISEASE_DETAILS":
          diseaseDetails().then((value) {
            data = null;
          });
          break;
        // case "AAYU_BREATHE":
        //   Get.to(const BreathingExercise());
        //   deepLinkData = null;
        //   break;
        case "PERSONALIZED_CARE":
          personalisedCare().then((value) {
            data = null;
          });
          break;
        case "YOU":
          changeMainPageTo!(3);
          data = null;
          break;
        case "GROW":
        case "GROW_TAB":
          changePageToGrow!(data!['tab']);
          data = null;
          break;
        case "BOOK_DOCTOR_CONSULT":
          bookDoctorConsult(data).then((value) {
            data = null;
          });
          break;
        case "BOOK_TRAINER_CONSULT":
          bookTrainerConsult().then((value) {
            data = null;
          });
          break;
        // case "INITIAL_ASSESSMENT":
        //   diseaseDetailAlreadySubscribed!();
        //   deepLinkData = null;
        //   break;
        // case "DAY_WISE_PROGRAM":
        //   diseaseDetailAlreadySubscribed!();
        //   deepLinkData = null;
        //   break;
        // case "DOCTOR_SESSIONS":
        //   Get.to(const DoctorSessions());
        //   deepLinkData = null;
        //   break;
        // case "TRAINER_SESSIONS":
        //   Get.to(TrainerSessionsInfo(bookFunction: () {
        //     Get.to(const TrainerSessions());
        //   }));
        //   deepLinkData = null;
        //   break;
        case "LIVE_EVENT":
          if (data!["liveEventId"] != null) {
            Get.to(LiveEventsDetails(
              source: "",
              heroTag: "LiveEvent_${data!["liveEventId"] ?? ""}",
              liveEventId: data!["liveEventId"] ?? "",
            ));
          }

          data = null;
          break;
        // case "SUBSCRIBE_TO_AAYU":
        //   if (!(subscriptionCheckResponse != null &&
        //       subscriptionCheckResponse!.subscriptionDetails != null &&
        //       subscriptionCheckResponse!
        //           .subscriptionDetails!.subscriptionId!.isNotEmpty)) {
        //     Get.bottomSheet(
        //       const SubscribeToAayu(
        //         subscribeVia: "DEEPLINK",
        //         content: null,
        //       ),
        //       isScrollControlled: true,
        //       isDismissible: false,
        //       enableDrag: false,
        //     );
        //   }

        //   deepLinkData = null;
        //   break;
        case "AFFIRMATION":
          if (data!['contentId'] != null) {
            String contentId = data!['contentId'];
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
          data = null;
          break;
        // case "SINGLE_OPTION_DISEASE_SUBSCRIPTION":
        //   singleOptionDiseaseSubscription().then((value) {
        //     deepLinkData = null;
        //   });
        //   break;
        case "ARTIST_DETAILS":
          asrtistDetails();
          break;

        default:
          break;
      }
    }
  }

  asrtistDetails() async {
    if (data?["artistId"] != null) {
      buildShowDialog(Get.context!);
      SearchController searchController = Get.put(SearchController());
      searchController.nullSearchResults();
      await searchController.getAuthorDetails(data?["artistId"]);
      Navigator.pop(Get.context!);
      Navigator.of(Get.context!).push(MaterialPageRoute(
        builder: (context) => const ArtistDetails(),
      ));
    }
    data = null;
  }

  Future<void> diseaseDetails() async {
    if (data?['diseaseId'] != null) {
      HealingListController healingListController = Get.find();
      await healingListController.getHealingList();
      await healingListController.setDiseaseFromDeepLink(data?['diseaseId']);
      EventsService().sendClickNextEvent(
          "Healing List", "View Program", "Disease Details");
      Get.put(DiseaseDetailsController());

      if (subscriptionCheckResponse?.subscriptionDetails?.programId != null &&
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

  contentDetails() {
    if (data!["contentId"].isNotEmpty) {
      Get.to(
        ContentDetails(
          source: "",
          heroTag: "SharedContent_${data!["contentId"]}",
          contentId: data!["contentId"],
          categoryContent: const [],
        ),
      )!
          .then((value) {
        data = null;
      });
    }
  }

  personalisedCare() async {
    buildShowDialog(Get.context!);
    SubscriptionController subscriptionController = Get.find();
    bool blockHealingAccess = await subscriptionController.checkHealingAccess();
    Navigator.pop(Get.context!);
    if (blockHealingAccess == true) {
      showCustomSnackBar(Get.context!,
          "Soon you'll find out which healing program is perfect for you. Wait just a little longer and take the right step forward with the doctor's recommendation.");
    } else {
      Get.put(DiseaseDetailsController());
      Get.to(const PersonalisedCareSubscription(
          subscribeVia: "PERSONAL_CARE_CARD", isProgramRecommended: false));
    }
  }

  Future<void> bookDoctorConsult(Map<String, dynamic>? data) async {
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
      Get.bottomSheet(
        BookFreeDoctor(
          allowBack: true,
          bookFunction: () {
            Navigator.of(Get.context!).popUntil((route) => route.isFirst);

            redirectToDoctorList(Get.context!);
          },
        ),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
      );
    }
  }

  redirectToDoctorList(BuildContext context) async {
    EventsService().sendClickNextEvent(
        "DoctorConsultationInfo", "Select Doctor", "DoctorList");
    Get.to(DoctorList(
      pageSource: "MY_ROUTINE",
      consultType: "GOT QUERY",
      bookType: "PAID",
    ));
  }

  Future<void> bookTrainerConsult() async {
    buildShowDialog(Get.context!);
    TrainerSessionController trainerSessionController =
        Get.put(TrainerSessionController());
    await trainerSessionController.getUpcomingSessions();
    Navigator.of(Get.context!).pop();

    if (trainerSessionController.upcomingSessionsList.value != null &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions != null &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      Get.to(TrainerSessionsInfo(bookFunction: () {
        Navigator.of(Get.context!).pop();
        Get.to(const TrainerSessions());
      }));
    } else {
      Get.bottomSheet(
        TrainerSessionsInfo(bookFunction: () async {
          buildShowDialog(Get.context!);
          bool isAllowed =
              await checkIsPaymentAllowed("THERAPIST_CONSULTATION");
          if (isAllowed == true) {
            PostAssessmentController postAssessmentController =
                Get.put(PostAssessmentController());
            await postAssessmentController.getConsultingPackageDetails();
            Navigator.pop(Get.context!);
            Navigator.pop(Get.context!);

            Get.bottomSheet(
              const GetTrainerSessions(),
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: false,
            );
          }
        }),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
      );
    }
  }
}
