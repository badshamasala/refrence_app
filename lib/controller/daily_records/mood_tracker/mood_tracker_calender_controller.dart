import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoodTrackerCalenderController extends GetxController {
  DateTime todaysDate = DateTime.now();
  DateTime selectedMonth = DateTime.now();
  DateTime maxSelectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  RxBool dateWiseCheckInLoading = false.obs;
  Rx<DateWiseMoodCheckInModel> dateWiseMoodCheckIns =
      DateWiseMoodCheckInModel().obs;
  RxList<DateTime> checkInDates = <DateTime>[].obs;

  RxBool dateWiseCheckInDetailsLoading = false.obs;
  Rx<DateWiseMoodCheckInDetailsModel?> checkInDetails =
      DateWiseMoodCheckInDetailsModel().obs;

  getDateWiseCheckIns() async {
    try {
      dateWiseCheckInLoading.value = true;
      List<DateTime> response =
          await MoodTrackingService().getMoodCheckInDates();

      checkInDates.value = response;
    } finally {
      dateWiseCheckInLoading.value = false;
      update();
    }
  }

  getDateWiseCheckInDetails(DateTime selectedDate, String moodType) async {
    try {
      dateWiseCheckInDetailsLoading.value = true;
      DateWiseMoodCheckInDetailsModel? response = await MoodTrackingService()
          .getDateWiseCheckInsDetails(
              DateFormat('yyyy-MM-dd').format(selectedDate));

      if (response != null) {
        checkInDetails.value = response;
      }
    } finally {
      dateWiseCheckInDetailsLoading.value = false;
      update();
    }
  }

  setSelectedMonth(DateTime changedTime) {
    selectedMonth = changedTime;
    update();
  }
}
