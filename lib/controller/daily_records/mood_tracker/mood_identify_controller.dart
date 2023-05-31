import 'package:aayu/model/model.dart';
import 'package:aayu/services/mood.tracking.service.dart';
import 'package:get/state_manager.dart';


class MoodIdentifyController extends GetxController {
  MoodIdentifyModel pageContent = MoodIdentifyModel();
  int optionsSelected = 0;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    getMoodIdentifications();

    super.onInit();
  }

  getMoodIdentifications() async {
    try {
      isLoading.value = true;
      update();
      MoodIdentifyModel? response =
          await MoodTrackingService().getMoodIdentifications();
      if (response != null) {
        pageContent = response;
        clearSelection();
        countOptionsSelected();
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  countOptionsSelected() {
    optionsSelected = 0;
    for (var element in pageContent.identifications!) {
      if (element!.selected == true) {
        optionsSelected++;
      }
    }
    update();
  }

  changeOptionStatus(int index) {
    pageContent.identifications![index]!.selected =
        !pageContent.identifications![index]!.selected!;
    countOptionsSelected();
    update();
  }

  clearSelection() {
    if (pageContent.identifications != null) {
      for (var element in pageContent.identifications!) {
        element!.selected = false;
      }
      optionsSelected = 0;
      update();
    }
  }
}
