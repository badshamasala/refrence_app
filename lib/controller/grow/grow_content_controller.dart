import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:get/state_manager.dart';

class GrowContentController extends GetxController {
  Rx<GrowPageContentResponse?> growPageCategoryContent =
      GrowPageContentResponse().obs;
  Rx<bool> isContentLoading = false.obs;

  String cagtegoryId = "";

  GrowContentController(String _categoryId) {
    cagtegoryId = _categoryId;
  }

  @override
  void onInit() async {
    getGrowPageContent();
    super.onInit();
  }

  getGrowPageContent() async {
    try {
      isContentLoading.value = true;
      GrowPageContentResponse? response = await GrowService()
          .getGrowPageCategoryContent(globalUserIdDetails?.userId, cagtegoryId);
      if (response != null) {
        growPageCategoryContent.value = response;
      }
    } finally {
      isContentLoading.value = false;
      update();
    }
  }

  favouriteAffirmation(int index) async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({
        "screenName": "AFFIRMATION",
        "contentId":
            growPageCategoryContent.value!.details!.content![index]!.contentId
      });
      return;
    }
    try {
      bool isFavourite =
          growPageCategoryContent.value!.details!.content![index]!.isFavourite!;

      bool isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!,
          growPageCategoryContent.value!.details!.content![index]!.contentId!,
          !isFavourite,
          "affirmations");
      if (isSuccess == true) {
        growPageCategoryContent.value!.details!.content![index]!.isFavourite =
            !isFavourite;
      }
    } finally {
      update();
    }
  }
}
