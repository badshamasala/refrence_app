import 'package:aayu/model/live_events/live.events.schedule.model.dart';
import 'package:aayu/view/shared/constants.dart';

import 'package:get/get.dart';

import '../../services/services.dart';

class LiveEventScheduleController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<LiveEventScheduleModel?> liveEventSchedule = LiveEventScheduleModel().obs;
  List<String> eventTypes = [];
  @override
  void onInit() {
    super.onInit();
    getLiveEventScheduleData();
  }

  Future<void> getLiveEventScheduleData() async {
    isLoading(true);
    try {
      LiveEventScheduleModel? response = await LiveEventService()
          .getLiveEventSchedule(globalUserIdDetails!.userId ?? "");

      if (response != null && response.schedule != null) {
        liveEventSchedule.value = response;
        eventTypes.clear();
        response.schedule?.schedule?.forEach((element) {
          eventTypes.add(element?.scheduleType ?? "");
        });
        if (eventTypes.isNotEmpty) {
          eventTypes.insert(0, "ALL");
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}
