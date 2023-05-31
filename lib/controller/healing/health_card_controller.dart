import 'package:aayu/controller/healing/user_identification_controller.dart';
import 'package:aayu/model/healing/healthcard.model.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/get.dart';

class HealthCardController extends GetxController {
  Rx<bool> isLoading = false.obs;
  RxBool isFirstTime = true.obs;
  Rx<HealthCardModel> healthCardModel = HealthCardModel().obs;
  Rx<InitialHealthCardResponse?> initialHealthCardResponse =
      InitialHealthCardResponse().obs;
  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;
  RxBool assessmentIntroViewed = false.obs;

  @override
  void onInit() async {
    super.onInit();
    userDetails.value = await HiveService().getUserDetails();
  }

  getInitialHealthCardDetails() async {
    try {
      isLoading.value = true;
      String userIdentification = "";
      UserIdentificationController userIdentificationController = Get.find();
      if (userIdentificationController.userIndentification.value != null &&
          userIdentificationController
                  .userIndentification.value!.identificationDetails !=
              null) {
        userIdentification = userIdentificationController.userIndentification
            .value!.identificationDetails!.userIdentification!;
      } else {}
      if (userIdentification.isNotEmpty) {
        InitialHealthCardResponse? response = await HealingService()
            .getInitialHealthCardDetails(
                globalUserIdDetails!.userId!, userIdentification);
        if (response != null) {
          initialHealthCardResponse.value = response;
          checkIfUserisFirstTime();
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  checkIfUserisFirstTime() {
    if (initialHealthCardResponse.value!.healthcard!.totalPercentage! > 0) {
      isFirstTime.value = false;
      assessmentIntroViewed.value = true;
      update();
    }
  }
}
