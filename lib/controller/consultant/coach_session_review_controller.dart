import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';

class CoachSessionReviewController extends GetxController {
  Rx<CoachPendingReviewsModel?> pendingReviewsList =
      CoachPendingReviewsModel().obs;

  getPendingReviews(String coachType) async {
    try {
      pendingReviewsList.value = null;
      CoachPendingReviewsModel? response = await CoachService()
          .getPendingReviews(globalUserIdDetails!.userId!,
              toTitleCase(coachType.toLowerCase()));
      if (response != null && response.pendingReviews!.isNotEmpty) {
        pendingReviewsList.value = response;
      }
    } catch (exp) {
      print(exp);
    } finally {
      update(["CoachSessionReviews"]);
    }
  }
}
