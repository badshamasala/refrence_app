import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/state_manager.dart';

class PsychologyRecommendedContentController extends GetxController {
  List<String> searchKeywords = [];
  Rx<ContentCategories?> recommendedContent = ContentCategories().obs;

  Future<void> getContent() async {
    try {
      TodaysMoodSummaryModel? response =
          await MoodTrackingService().getTodaysMoodSummary();
      if (response != null && response.checkInDetails != null) {
        if (searchKeywords.contains(response.checkInDetails?.mood?.mood) ==
            false) {
          searchKeywords.add(response.checkInDetails?.mood?.mood ?? "");
        }
        if (searchKeywords.isNotEmpty) {
          getRecommendedContent();
        } else {
          searchKeywords = ["Good", "Awsome"];
          getRecommendedContent();
        }
      } else {
        searchKeywords = ["Good", "Awsome"];
        getRecommendedContent();
      }
    } finally {
      update();
    }
  }

  Future<void> getRecommendedContent() async {
    try {
      dynamic postData = {
        "data": {"keywords": searchKeywords.join(",")}
      };
      ContentCategories? response = await GrowService()
          .searchContentByKeywords(globalUserIdDetails?.userId!, postData);
      if (response != null &&
          response.content != null &&
          response.content!.isNotEmpty) {
        recommendedContent.value = response;
      } else {
        recommendedContent.value = null;
      }
    } finally {
      update(['recommendedContent']);
    }
  }

  shuffleContent() {
    /* if (recommendedContent.value != null) {
      recommendedContent.value!.content!.shuffle();
      update(['recommendedContent']);
    } */
    getRecommendedContent();
  }
}
