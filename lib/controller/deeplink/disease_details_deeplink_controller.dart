import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:get/get.dart';

import '../../data/deeplink_data.dart';
import '../../model/deeplinks/how.to.proceed.model.dart';
import '../../model/healing/disease.details.response.model.dart';
import '../../services/healing.service.dart';

class DiseaseDetailsDeeplinkController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPersonalizedCare = false.obs;
  Rx<DiseaseDetailsResponse?> diseaseDetails = DiseaseDetailsResponse().obs;
  Rx<HowToProceedModel> howToProceedContent = HowToProceedModel().obs;

  Future<void> getDiseaseDetails(String diseaseId) async {
    try {
      isLoading.value = true;
      howToProceedContent.value =
          HowToProceedModel.fromJson(howToProceedDataSingle);

      HealingListController healingListController =
          Get.put(HealingListController());
      await healingListController.getHealingList();

      await healingListController.setDiseaseFromDeepLink(diseaseId);

      DiseaseDetailsResponse? response = await HealingService()
          .getDiseaseDetails(healingListController.diseaseDetailsRequest);
      if (response != null) {
        diseaseDetails.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDiseaseDetailsPersonalizedCare(
      List<String> diseaseList) async {
    try {
      isLoading.value = true;
      howToProceedContent.value =
          HowToProceedModel.fromJson(howToProceedDataPeronalized);

      HealingListController healingListController =
          Get.put(HealingListController());
      await healingListController.getHealingList();
      await healingListController
          .setSelectedDiseaseFromMultiDiseaseIds(diseaseList);

      DiseaseDetailsResponse? response = await HealingService()
          .getDiseaseDetails(healingListController.diseaseDetailsRequest);
      if (response != null) {
        diseaseDetails.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }

  setIsPersonalized() {
    isPersonalizedCare.value = true;
  }
}
