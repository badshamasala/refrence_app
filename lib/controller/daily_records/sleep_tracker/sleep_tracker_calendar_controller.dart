import 'package:aayu/services/sleep.tracker.service.dart';
import 'package:get/get.dart';

class SleepTrackerCalenderController extends GetxController {
  DateTime todaysDate = DateTime.now();
  DateTime selectedMonth = DateTime.now();
  DateTime maxSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  RxBool dateWiseCheckInLoading = false.obs;
  RxList<DateTime> checkInDates = <DateTime>[].obs;

  getDateWiseCheckIns() async {
    try {
      dateWiseCheckInLoading.value = true;
      List<DateTime> response =
          await SleepTrackingService().getSleepCheckInDates();

      checkInDates.value = response;
    } finally {
      dateWiseCheckInLoading.value = false;
      update();
    }
  }

  setSelectedMonth(DateTime changedTime) {
    selectedMonth = changedTime;
    update();
  }
}
