import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_session_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/view/consulting/nutrition/home/nutrition_home.dart';
import 'package:aayu/view/consulting/nutrition/how_it_works.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_assessment_start.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_consent.dart';
import 'package:aayu/view/consulting/psychologist/psychologist_plans/psychologist_plans.dart';
import 'package:aayu/view/home/widgets/my_routine/doctor_call_Reminder.dart';
import 'package:aayu/view/home/widgets/my_routine/nutrition/access_healing_nutrition.dart';
import 'package:aayu/view/home/widgets/my_routine/assessment_routine.dart';
import 'package:aayu/view/home/widgets/my_routine/disease_routine_widget.dart';
import 'package:aayu/view/home/widgets/my_routine/explore_healing_programs.dart';
import 'package:aayu/view/home/widgets/my_routine/nutrition/get_healing_nutrition.dart';
import 'package:aayu/view/home/widgets/my_routine/nutrition/nutrition_call_reminder.dart';
import 'package:aayu/view/home/widgets/my_routine/psychologist/access_psychologist_routine_widget.dart';
import 'package:aayu/view/home/widgets/my_routine/psychologist/get_psychologist_routine_widget.dart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/services.dart';
import '../../theme/app_colors.dart';
import '../../view/consulting/psychologist/home/psychology_home.dart';
import '../../view/healing/initialAssessment/initial_health_card.dart';
import '../../view/home/widgets/my_routine/breath_routine.dart';
import '../../view/home/widgets/my_routine/breathing_exercise.dart';
import '../../view/home/widgets/my_routine/daily_routine_widget.dart';
import '../../view/home/widgets/my_routine/doctor_call_widget.dart';
import '../../view/home/widgets/my_routine/psychologist/psychology_call_reminder.dart';
import '../../view/home/widgets/my_routine/share_aayu.dart';
import '../../view/home/widgets/my_routine/trainer_call_reminder.dart';
import '../../view/home/widgets/my_routine/trainer_session_routine_widget.dart';
import '../../view/profile/help_and_support.dart';
import '../../view/shared/constants.dart';
import '../../view/shared/ui_helper/images.dart';
import '../consultant/doctor_session_controller.dart';
import '../consultant/psychologist/psychology_controller.dart';
import '../consultant/psychologist/psychology_session_controller.dart';
import '../healing/insight_card_controller.dart';
import '../program/programme_controller.dart';

class MyRoutineController extends GetxController {
  RxBool isLoading = false.obs;
  bool showBookDoctor = true;
  bool showBookTherapistSession = true;

  bool showUpComingDoctorSession = false;
  bool showUpComingTrainerSession = false;
  bool showExploreHealing = true;
  bool showAayuScore = false;
  bool showCompleteAssessment = false;
  bool ifStartedAssessment = false;
  List<Widget> listOfWidgets = [];
  Function? gotoHealing;

  bool nutritionistEnabled = false;
  bool showGetHealingNutrition = true;
  bool showUpComingNutritionSession = false;

  bool showGetMentalWellbeing = false;
  bool showUpComingPsychologySession = false;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    listOfWidgets = [];
    try {
      isLoading.value = true;
      update();

      nutritionistEnabled =
          appProperties.consultation?.nutritionist?.enabled ?? false;
      List<Future> futureList = [
        checkUpcomingSession(),
        checkHealingStatus(),
      ];
      if (nutritionistEnabled) {
        futureList.add(checkNutritionStatus());
      } else {
        showGetHealingNutrition = false;
        showUpComingNutritionSession = false;
      }
      futureList.add(checkPsychologyStatus());
      await Future.wait(futureList);
      await organize();
    } catch (err) {
      rethrow;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> checkUpcomingSession() async {
    DoctorSessionController doctorSessionController =
        Get.put(DoctorSessionController());
    TrainerSessionController trainerSessionController =
        Get.put(TrainerSessionController());
    await doctorSessionController.getUpcomingSessions();
    await trainerSessionController.getUpcomingSessions();
    if (doctorSessionController.upcomingSessionsList.value != null &&
        doctorSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        doctorSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty &&
        doctorSessionController.upcomingSessionsList.value!.upcomingSessions!
                .firstWhereOrNull((element) => element!.status != "PENDING") !=
            null) {
      showUpComingDoctorSession = true;
      showBookDoctor = false;
    } else {
      showUpComingDoctorSession = false;
      showBookDoctor = true;
    }
    if (trainerSessionController.upcomingSessionsList.value != null &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        trainerSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions!
                .firstWhereOrNull((element) => element!.status != "PENDING") !=
            null) {
      showUpComingTrainerSession = true;
      showBookTherapistSession = false;
    } else {
      showUpComingTrainerSession = false;
      showBookTherapistSession = true;
    }
  }

  Future<void> checkHealingStatus() async {
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!.subscriptionDetails!.programId!.isNotEmpty) {
      showExploreHealing = false;
      ProgrammeController programmeController = Get.put(ProgrammeController(
          subscriptionCheckResponse!.subscriptionDetails!.canStartProgram!));
      await programmeController.getDayWiseProgramContent();
      HomeController homeController = Get.find();
      await homeController.getInitialAssessmentStatus();

      if (homeController.statusContent.value!.data!.isCompleted == true) {
        showCompleteAssessment = false;
      } else {
        showCompleteAssessment = true;
        if (homeController.statusContent.value!.data!.isStarted == true) {
          ifStartedAssessment = true;
        }
      }
      if (homeController.statusContent.value!.data!.isStarted == true) {
        InsightCardController insightCardController =
            Get.put(InsightCardController());
        await insightCardController.getWeeklyHealthCardDetails();
        if (insightCardController.weeklyHealthCardDetails.value!.healthCardList!
                    .weeks!.last!.totalPercentage !=
                null &&
            insightCardController.weeklyHealthCardDetails.value!.healthCardList!
                    .weeks!.last!.totalPercentage !=
                0) {
          showAayuScore = true;
        } else {
          showAayuScore = false;
        }
      } else {
        showAayuScore = false;
      }
    } else {
      showExploreHealing = true;
    }
  }

  Future<void> checkNutritionStatus() async {
    late NutritionController nutritionController;
    if (NutritionController().initialized == false) {
      nutritionController = Get.put(NutritionController());
    } else {
      nutritionController = Get.find();
    }
    await nutritionController.getUserNutritionDetails();
    if (nutritionController.userNutritionDetails.value != null) {
      showGetHealingNutrition = false;
      await checkNutritionUpcomingSession();
    } else {
      showGetHealingNutrition = true;
    }
  }

  Future<void> checkPsychologyStatus() async {
    late PsychologyController psychologyController;
    if (PsychologyController().initialized == false) {
      psychologyController = Get.put(PsychologyController());
    } else {
      psychologyController = Get.find();
    }
    await psychologyController.getUserPsychologyDetails();
    if (psychologyController.userPsychologyDetails.value != null) {
      showGetMentalWellbeing = false;
      await checkPsychologyUpcomingSession();
    } else {
      showGetMentalWellbeing = true;
    }
  }

  checkNutritionUpcomingSession() async {
    NutritionSessionController nutritionSessionController =
        Get.put(NutritionSessionController());
    await nutritionSessionController.getUpcomingSessions();
    if (nutritionSessionController.upcomingSessionsList.value != null &&
        nutritionSessionController
                .upcomingSessionsList.value!.upcomingSessions !=
            null &&
        nutritionSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty &&
        nutritionSessionController.upcomingSessionsList.value!.upcomingSessions!
                .firstWhereOrNull((element) => element!.status != "PENDING") !=
            null) {
      showUpComingNutritionSession = true;
    } else {
      showUpComingNutritionSession = false;
    }
  }

  checkPsychologyUpcomingSession() async {
    PsychologySessionController psychologySessionController =
        Get.put(PsychologySessionController());
    await psychologySessionController.getUpcomingSessions();
    if (psychologySessionController.upcomingSessionsList.value != null &&
        psychologySessionController
                .upcomingSessionsList.value!.upcomingSessions !=
            null &&
        psychologySessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty &&
        psychologySessionController
                .upcomingSessionsList.value!.upcomingSessions!
                .firstWhereOrNull((element) => element!.status != "PENDING") !=
            null) {
      showUpComingPsychologySession = true;
    } else {
      showUpComingPsychologySession = false;
    }
  }

  Future<void> organize() async {
    listOfWidgets = [];
    print("-------------My Routine Cards-------------\n"
        "showBookDoctor => $showBookDoctor\n"
        "showBookTherapistSessions => $showBookTherapistSession\n"
        "showUpComingDoctorSession => $showUpComingDoctorSession\n"
        "showUpComingTrainerSession => $showUpComingTrainerSession\n"
        "showAayuScore => $showAayuScore\n"
        "showExploreHealing => $showExploreHealing\n"
        "showCompleteAssessment => $showCompleteAssessment\n"
        "nutritionistEnabled => $nutritionistEnabled\n"
        "showGetHealingNutrition => $showGetHealingNutrition\n"
        "showUpComingNutritionSession => $showUpComingNutritionSession\n"
        "showGetMentalWellbeing => $showGetMentalWellbeing\n"
        "showUpComingPsychologySession => $showUpComingPsychologySession\n");

    //DOCTOR AND THERAPIST WIDGETS
    if (showBookDoctor == true || globalUserIdDetails?.userId == null) {
      listOfWidgets.add(const DoctorRoutineWidget());
    }
    if (showBookTherapistSession == true ||
        globalUserIdDetails?.userId == null) {
      listOfWidgets.add(const TrainerSessionRoutineWidget());
    }

    if (showUpComingDoctorSession == true) {
      listOfWidgets.add(const DoctorCallReminder());
    }
    if (showUpComingTrainerSession == true) {
      listOfWidgets.add(const TrainerCallReminder());
    }

    //NUTRITION WIDGETS
    if (nutritionistEnabled == true) {
      if (showGetHealingNutrition == true) {
        listOfWidgets.add(InkWell(
            onTap: () async {
              Get.to(const HowItWorks());
            },
            child: const GetHealingNutrition()));
      } else {
        if (showUpComingNutritionSession == true) {
          listOfWidgets.add(const NutritionCallReminder());
        } else {
          listOfWidgets.add(InkWell(
              onTap: () async {
                Get.to(const NutritionHome());
              },
              child: const AccessHealingNutrition()));
        }
      }
    }

    //PSYCHOLOGIST WIDGETS
    if (showGetMentalWellbeing == true) {
      listOfWidgets.add(
        InkWell(
          onTap: () async {
            Get.to(const PsychologistPlans(
              extendPlan: false,
            ));
          },
          child: const GetPsychologistRoutineWidget(),
        ),
      );
    } else {
      if (showUpComingPsychologySession == true) {
        listOfWidgets.add(const PsychologyCallReminder());
      } else {
        listOfWidgets.add(
          InkWell(
            onTap: () async {
              PsychologyController psychologyController = Get.find();
              if (psychologyController.userPsychologyDetails.value
                      ?.initialAssessment?.isCompleted ==
                  false) {
                Get.to(const PsychologistAssessmentStart());
              } else if (psychologyController
                      .userPsychologyDetails.value?.consent?.isAccepted ==
                  false) {
                Get.to(const PsychologistConsent());
              } else {
                Get.to(const PsychologyHome());
              }
            },
            child: const AccessPsychologyRoutineWidget(),
          ),
        );
      }
    }

    if (showExploreHealing) {
      listOfWidgets.add(InkWell(
        onTap: () {
          gotoHealing!();
        },
        child: const ExploreHealingWidget(),
      ));
    } else {
      HealingListController healingListController =
          Get.put(HealingListController());
      await healingListController.getHealingList();
      ProgrammeController programmeController = Get.find();

      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        listOfWidgets.add(InkWell(
          onTap: () {
            gotoHealing!();
          },
          child: DiseaseRoutineWidget(
            day:
                "Day ${!subscriptionCheckResponse!.subscriptionDetails!.canStartProgram! ? 0 : programmeController.todaysContent.value?.day ?? 0}",
            title:
                "${!subscriptionCheckResponse!.subscriptionDetails!.canStartProgram! ? "${subscriptionCheckResponse!.subscriptionDetails!.diseaseName} Program" : (programmeController.healingProgrammeContent.value != null && programmeController.healingProgrammeContent.value!.programDetails != null && programmeController.healingProgrammeContent.value!.programDetails!.sliverAppBar!.title!.isNotEmpty) ? programmeController.healingProgrammeContent.value!.programDetails!.sliverAppBar!.title : ""}",
            subtitle:
                "Keep practicing, staying healthy needs a daily commitment.",
            topImage: Images.myRoutineExplore,
            networkImage: healingListController.getImageFromDiseaseId(
                subscriptionCheckResponse!
                    .subscriptionDetails!.disease![0]!.diseaseId!),
          ),
        ));
      }
    }
    listOfWidgets.add(InkWell(
        onTap: () {
          Get.to(const BreathingExercise());
        },
        child: const BreathingRoutineWidget()));
    if (showCompleteAssessment) {
      listOfWidgets.add(
        InkWell(
            onTap: () {
              Get.to(const InitialHealthCard(
                action: "Initial Assessment",
              ));
            },
            child: AssessmentRoutine(
              title:
                  "${ifStartedAssessment ? "Complete" : "Start"} your \nAssessment",
            )),
      );
    }
    /* if (globalUserIdDetails?.userId != null) {
      listOfWidgets.add(
        InkWell(
          onTap: () {
            Get.to(const Onboarding(showSkip: false));
          },
          child: const DailyRoutineWidget(
            title: "Personify",
            subtitle: "Your Journey to better health starts here.",
            topImage: Images.myRoutinePersonalise,
            ctaText: "Customize",
            bgColor: AppColors.shareAayuBackgroundColor,
          ),
        ),
      );
    } */
    if (globalUserIdDetails?.userId != null) {
      listOfWidgets.add(
        InkWell(
          onTap: () {
            Get.to(const HelpAndSupport());
          },
          child: const DailyRoutineWidget(
            title: "Ask Me",
            subtitle: "We’re there with you at every step.",
            topImage: Images.helpAndSupportImage,
            ctaText: "Connect",
            bgColor: AppColors.lightPrimaryColor,
          ),
        ),
      );
    }

    if (listOfWidgets.length % 2 != 0) {
      listOfWidgets.add(InkWell(
          onTap: () async {
            Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
                barrierDismissible: false);
            await ShareService().shareApp();
            Get.close(1);
          },
          child: const ShareAayuWidget()));
    }
  }

  setGotoHealing(Function function) {
    gotoHealing = function;
  }
}
