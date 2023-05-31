import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/get.dart';

class HomeTopSectionController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<HomePageTopSectionResponse?> topSectionContent =
      HomePageTopSectionResponse().obs;

  RxInt currentContentPosition = 0.obs;
  RxInt countDownTimer = 0.obs;

  @override
  void onInit() async {
    getHomePageTopSectionContent();
    super.onInit();
  }

  Future<void> getHomePageTopSectionContent() async {
    try {
      currentContentPosition.value = 0;
      isLoading.value = true;
      HomePageTopSectionResponse? response = await GrowService()
          .getHomePageTopContent(globalUserIdDetails?.userId);
      if (response != null) {
        topSectionContent.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
