import 'package:aayu/model/model.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:get/get.dart';

class DidYouKnowController extends GetxController {
  DidYouKnowModel? didYouKnowDetails;
  RxBool isLoading = false.obs;

  Future<void> getDidYouKnow(String category) async {
    isLoading.value = true;
    try {
      didYouKnowDetails = null;
      DidYouKnowModel? response =
          await TrackerService().getDidYouKnow(category);
      if (response != null && response.details != null) {
        didYouKnowDetails = response;
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
