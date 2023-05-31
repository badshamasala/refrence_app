import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/state_manager.dart';

class UserIdentificationController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<UserIdentificationResponse?> userIndentification =
      UserIdentificationResponse().obs;
  DiseaseDetailsRequest? diseases;

  Future<bool> getUserIdentificationId(
      String identificationType,
      DiseaseDetailsRequest diseaseDetailsRequest,
      String subscriptionId) async {
    try {
      isLoading.value = true;
      diseases = diseaseDetailsRequest;
      UserIdentificationResponse? response = await HealingService()
          .getUserIdentificationDetails(globalUserIdDetails!.userId!,
              identificationType, diseaseDetailsRequest, subscriptionId);
      if (response != null) {
        userIndentification.value = response;
        return true;
      }
    } finally {
      isLoading.value = false;
      update();
    }

    return false;
  }

  updateUserIdentificationId(
      String identificationType,
      DiseaseDetailsRequest diseaseDetailsRequest,
      String subscriptionId) async {
    if (userIndentification.value != null &&
        userIndentification.value!.identificationDetails != null) {
      updateIdentificationId(diseaseDetailsRequest, subscriptionId);
    } else {
      bool isAvailable = await getUserIdentificationId(
          identificationType, diseaseDetailsRequest, subscriptionId);
      if (isAvailable == true) {
        updateIdentificationId(diseaseDetailsRequest, subscriptionId);
      }
    }
  }

  updateIdentificationId(DiseaseDetailsRequest diseaseDetailsRequest,
      String subscriptionId) async {
    await HealingService().updateIdentificationId(
      globalUserIdDetails!.userId!,
      userIndentification.value!.identificationDetails!.userIdentification!,
      subscriptionId,
      diseaseDetailsRequest,
    );
  }
}
