import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/state_manager.dart';

import '../../model/healing/weekly.health.card.model.dart';

class InsightCardController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<WeeklyHealthCardModel?> weeklyHealthCardDetails =
      WeeklyHealthCardModel().obs;
  Rx<InsightCardResponse?> insightDetails = InsightCardResponse().obs;
  RxInt selectedDateIndex = 0.obs;
  // List<Map<String, Object>> daysList = [
  //   {"day": "01D", "selected": true},
  //   {"day": "05D", "selected": false},
  //   {"day": "10D", "selected": false},
  //   {"day": "15D", "selected": false},
  //   {"day": "20D", "selected": false},
  //   {"day": "30D", "selected": false},
  // ];
  @override
  void onInit() {
    super.onInit();
    getWeeklyHealthCardDetails();
  }

  // getInsightCardDetails() async {
  //   try {
  //     isLoading.value = true;
  //     InsightCardResponse? response =
  //         await HealingService().getInsightCardDetails();
  //     if (response != null) {
  //       insightDetails.value = response;
  //     }
  //   } finally {
  //     isLoading.value = false;
  //     update();
  //   }
  // }

  Future<void> getWeeklyHealthCardDetails() async {
    try {
      isLoading.value = true;
      weeklyHealthCardDetails.value = await HealingService().getWeeklyInsight(
          globalUserIdDetails!.userId!,
          subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  setDaysList(int index) {
    selectedDateIndex.value = index;
    update();
  }
}
