import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/state_manager.dart';

class ViewAllContentController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<ContentCategories?> categoryDetails = ContentCategories().obs;

  getAllContent(String categoryId) async {
    try {
      isLoading.value = true;
      ContentCategories? response = await GrowService()
          .getViewAllContent(globalUserIdDetails?.userId, categoryId);
      if (response != null) {
        categoryDetails.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
