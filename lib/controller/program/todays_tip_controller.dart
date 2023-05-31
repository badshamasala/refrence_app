import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/state_manager.dart';

class TodaysProgrammeTipController extends GetxController {
  Rx<bool> isTipLoading = false.obs;
  Rx<HealingTipsResponse?> healingTipResponse = HealingTipsResponse().obs;

  @override
  onInit() {
    getTodaysTip();
    super.onInit();
  }

  getTodaysTip() async {
    try {
      isTipLoading.value = true;
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        String diseaseId = subscriptionCheckResponse!
            .subscriptionDetails!.disease!.first!.diseaseId!;
        String programId =
            subscriptionCheckResponse!.subscriptionDetails!.programId!;

        HealingTipsResponse? response = await ProgrameService()
            .getTodaysTip(globalUserIdDetails!.userId!, diseaseId, programId);

        if (response != null) {
          healingTipResponse.value = response;
        }
      }
    } catch (exp) {
      print(exp);
    } finally {
      isTipLoading.value = false;
      update();
    }
  }

  updateTipsFavorite() {
    if (healingTipResponse.value!.todaysTip!.isFavourite == false) {
      healingTipResponse.value!.todaysTip!.isFavourite = true;
    } else {
      healingTipResponse.value!.todaysTip!.isFavourite = false;
    }
    update();
  }
}
