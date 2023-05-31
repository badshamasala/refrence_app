import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/state_manager.dart';

class ExpertsIFollowController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<ExpertsIFollowResponse?> expertsIFollow = ExpertsIFollowResponse().obs;

  getExpertsIFollow() async {
    try {
      isLoading.value = true;
      ExpertsIFollowResponse? response =
          await GrowService().getExpertsIFollow(globalUserIdDetails!.userId!);
      if (response != null) {
        expertsIFollow.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
