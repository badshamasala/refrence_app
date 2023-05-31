import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';

class PastEventsController extends GetxController {
  RxBool isLoading = false.obs;
  PastLiveEventsModel? artistWisePastLiveEvents;
  String trainerId = "";
  PastEventsController(String artistId) {
    trainerId = artistId;
  }

  @override
  void onInit() {
    getPastLiveEvents();
    super.onInit();
  }

  Future<void> getPastLiveEvents() async {
    isLoading(true);
    try {
      PastLiveEventsModel? response = await LiveEventService()
          .getPastLiveEvents(globalUserIdDetails?.userId, trainerId);
      if (response != null) {
        artistWisePastLiveEvents = response;
      } else {
        artistWisePastLiveEvents = null;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
       update();
    }
  }
}
