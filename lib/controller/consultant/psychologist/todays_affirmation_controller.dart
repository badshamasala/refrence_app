import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';

class TodaysAffirmationController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<ContentCategories?> todaysAffirmation = ContentCategories().obs;
  Future<void> getRandomAffirmation() async {
    try {
      isLoading.value = true;
      ContentCategories? response = await GrowService()
          .getRandomAffirmation(globalUserIdDetails?.userId!);
      if (response != null &&
          response.content != null &&
          response.content!.isNotEmpty) {
        todaysAffirmation.value = response;
      } else {
        todaysAffirmation.value = null;
      }
    } finally {
      isLoading.value = false;
    }
  }
  favouriteAffirmation() async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({
        "screenName": "AFFIRMATION",
        "contentId": todaysAffirmation.value!.content?.first?.contentId ?? ""
      });
      return;
    }
    try {
      bool isFavourite =
          todaysAffirmation.value!.content?.first?.isFavourite! ?? false;
      bool isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!,
          todaysAffirmation.value!.content?.first?.contentId??"",
          !isFavourite,
          "affirmations");
      if (isSuccess == true) {
        todaysAffirmation.value!.content?.first?.isFavourite = !isFavourite;
      }
    } finally {
      update(["Affirmation"]);
    }
  }
}
