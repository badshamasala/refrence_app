import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/state_manager.dart';

class ContentReviewController extends GetxController {
  String contentId = "";
  Rx<bool> isLoading = false.obs;
  Rx<ContentReviewsModel?> contentReviews = ContentReviewsModel().obs;
  Rx<ContentReviewsModel?> allContentReviews = ContentReviewsModel().obs;

  ContentReviewController(String _contentId) {
    contentId = _contentId;
  }

  @override
  void onInit() async {
    getContentReviewDetails(contentId);
    super.onInit();
  }

  Future<void> getContentReviewDetails(String contentId) async {
    try {
      contentReviews.value = null;
      isLoading.value = true;
      ContentReviewsModel? response = await GrowService()
          .getContentReviews(globalUserIdDetails?.userId, contentId);
      if (response != null) {
        contentReviews.value = response;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getAllContentReviewDetails(String contentId) async {
    try {
      allContentReviews.value = null;
      isLoading.value = true;
      ContentReviewsModel? response = await GrowService()
          .getAllContentReviews(globalUserIdDetails?.userId, contentId);
      if (response != null) {
        allContentReviews.value = response;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
