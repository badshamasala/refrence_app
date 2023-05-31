import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/personal_care_switch_yearly_subscription_bottom_sheet.dart';
import 'package:aayu/view/healing/programme_selection/personal_care/personal_care_program_selection.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/subscription/personalised_care_subscription.dart';
import 'package:get/get.dart';

import '../../view/healing/disease_details/disease_details.dart';
import '../../view/healing/programme_selection/program_selection.dart';
import '../../view/shared/ui_helper/ui_helper.dart';
import '../healing/disease_details_controller.dart';
import '../healing/post_assessment_controller.dart';

class ProgramRecommendationController extends GetxController {
  Rx<RecommendedProgramResponse?> recommendation =
      RecommendedProgramResponse().obs;
  RxBool isLoading = false.obs;

  getProgramRecommendationForSessionId(String sessionId) async {
    try {
      isLoading.value = true;

      recommendation.value = await ConsultantService()
          .getProgramRecommendationForSessionId(
              globalUserIdDetails!.userId!, sessionId);
    } catch (error) {
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  getProgramRecommendation() async {
    try {
      isLoading.value = true;

      recommendation.value = await ConsultantService()
          .getProgramRecommendation(globalUserIdDetails!.userId!);
    } catch (error) {
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteDoctorsRecommendation() async {
    if (recommendation.value != null &&
        recommendation.value!.recommendation != null) {
      bool deleted = false;

      deleted = await ConsultantService().deleteDoctorsRecommendation(
          recommendation.value!.recommendation!.sessionId ?? "");
      if (deleted == true) {
        recommendation.value = null;
      }
      return deleted;
    } else {
      return false;
    }
  }

  Future<void> handleProgramRecommendation(
      SubscriptionController subscriptionController) async {
    HealingListController healingListController = Get.find();
    if (recommendation.value!.recommendation!.programType == "SINGLE DISEASE") {
      //SINGLE DISEASE RECOMMENDATION
      if (subscriptionController.subscriptionDetailsResponse.value != null &&
          subscriptionController
                  .subscriptionDetailsResponse.value!.subscriptionDetails !=
              null) {
        //USER SUBSCRIBED TO AAYU
        if (subscriptionController.subscriptionDetailsResponse.value!
            .subscriptionDetails!.programId!.isNotEmpty) {
          //USER SUBSCRIBED TO HEALING
          healingListController.setDiseaseFromDeepLink(
              recommendation.value!.recommendation!.disease![0]!.diseaseId ??
                  "");
          Get.put(DiseaseDetailsController());
          Get.to(const DiseaseDetails(
            fromThankYou: false,
            fromDoctorRecommended: true,
            pageSource: "SWITCH_PROGRAM",
          ));
        } else {
          //USER NOT SUBSCRIBED TO HEALING
          healingListController.setDiseaseFromDeepLink(
              recommendation.value!.recommendation!.disease![0]!.diseaseId ??
                  "");
          Get.put(DiseaseDetailsController());
          Get.to(const DiseaseDetails(
            fromThankYou: false,
            fromDoctorRecommended: true,
            pageSource: "",
          ));
        }
      } else {
        //USER NOT SUBSCRIBED TO AAYU
        healingListController.setDiseaseFromDeepLink(
            recommendation.value!.recommendation!.disease![0]!.diseaseId ?? "");
        Get.put(DiseaseDetailsController());
        Get.to(const DiseaseDetails(
          fromThankYou: false,
          fromDoctorRecommended: true,
        ));
      }
    } else {
      //MULTIPLE DISEASE RECOMMENDATION
      if (subscriptionController.subscriptionDetailsResponse.value != null &&
          subscriptionController
                  .subscriptionDetailsResponse.value!.subscriptionDetails !=
              null) {
        //USER SUBSCRIBED TO AAYU
        if (subscriptionController.subscriptionDetailsResponse.value!
            .subscriptionDetails!.programId!.isNotEmpty) {
          //USER SUBSCRIBED TO HEALING
          bool allow = await SubscriptionService().checkFreeSwitchForYearly();
          if (allow == true) {
            Get.bottomSheet(const PersonalCareSwitchYearlySubBottomSheet(),
                isScrollControlled: true);
          } else {
            // Get.to(const PersonalisedCareSwitchProgram());
            Get.to(
              const PersonalisedCareSubscription(
                subscribeVia: 'RECOMMENDED_PROGRAM',
                isProgramRecommended: true,
              ),
            );
          }
        } else {
          //USER NOT SUBSCRIBED TO HEALING
          bool allow = await SubscriptionService().checkFreeSwitchForYearly();
          if (allow == true) {
            buildShowDialog(Get.context!);
            DiseaseDetailsController diseaseDetailsController =
                Get.put(DiseaseDetailsController());
            await diseaseDetailsController.getPersonalCareDetails();

            HealingListController healingListController = Get.find();
            ProgramRecommendationController programRecommendationController =
                Get.find();
            List<String> diseaseList = programRecommendationController
                .recommendation.value!.recommendation!.disease!
                .map((element) => element!.diseaseId!)
                .toList();

            healingListController
                .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);
            PostAssessmentController postAssessmentController =
                Get.put(PostAssessmentController());

            String programId = programRecommendationController
                    .recommendation.value!.recommendation!.programId ??
                "";
            bool isDataAvailable =
                await postAssessmentController.getProgramDetails(programId);

            Get.back();
            if (isDataAvailable == true) {
              Get.back();
              Get.bottomSheet(
                const PersonalCareProgramSelection(startProgram: true),
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: false,
              );
              // Get.bottomSheet(
              //   const ProgramSelection(
              //       isProgramSwitch: false, isRecommendedProgramSwitch: true),
              //   isScrollControlled: true,
              //   isDismissible: true,
              //   enableDrag: false,
              // );
            } else {
              showSnackBar(Get.context, "PERFERENCES_DETAILS_NOT_AVAILABLE".tr,
                  SnackBarMessageTypes.Info);
            }
          } else {
            List<String> diseaseList = recommendation
                .value!.recommendation!.disease!
                .map((element) => element!.diseaseId!)
                .toList();
            healingListController
                .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);
            Get.to(
              const PersonalisedCareSubscription(
                subscribeVia: 'RECOMMENDED_PROGRAM',
                isProgramRecommended: true,
              ),
            );
          }
        }
      } else {
        List<String> diseaseList = recommendation
            .value!.recommendation!.disease!
            .map((element) => element!.diseaseId!)
            .toList();
        healingListController
            .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);
        Get.to(
          const PersonalisedCareSubscription(
            subscribeVia: 'RECOMMENDED_PROGRAM',
            isProgramRecommended: true,
          ),
        );
      }
    }
  }
}
