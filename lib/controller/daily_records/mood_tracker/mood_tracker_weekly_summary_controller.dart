import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/mood.tracking.service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class MoodTrackerWeeklySummaryController extends GetxController {
  DateTime? monday;
  DateTime? sunday;
  DateTime? now;
  Rx<String> range = ''.obs;
  RxBool isLoading = false.obs;
  RxList<WeeklyMoodCheckInModelDayWiseCheckIns?>? dayWiseCheckIns =
      <WeeklyMoodCheckInModelDayWiseCheckIns?>[].obs;
  Rx<WeeklyMoodCheckInModel?> weeklyMoodCheckInModel =
      (null as WeeklyMoodCheckInModel).obs;
  @override
  void onInit() {
    super.onInit();

    now = DateTime.now();
    monday = now!.subtract(Duration(days: now!.weekday - 1));
    sunday = monday!.add(const Duration(days: 6));
    range.value =
        '${monday!.day} ${DateFormat.MMM().format(monday!)} - ${sunday!.day} ${DateFormat.MMM().format(sunday!)}';
  }

  Future<void> getWeeklySummary() async {
    try {
      isLoading.value = true;
      WeeklyMoodCheckInModel? response = await MoodTrackingService()
          .getWeeklyMoodSummary(DateFormat('yyyy-MM-dd').format(monday!),
              DateFormat('yyyy-MM-dd').format(sunday!));
      resetDayWiseCheckins();

      weeklyMoodCheckInModel.value = response;
      if (response != null) {
        int p = 0;
        while (p < 7) {
          WeeklyMoodCheckInModelDayWiseCheckIns? model = weeklyMoodCheckInModel
              .value!.dayWiseCheckIns!
              .firstWhereOrNull((element) =>
                  element!.checkInDate!.day ==
                  dayWiseCheckIns![p]!.checkInDate!.day);

          if (model != null) {
            for (WeeklyMoodCheckInModelDayWiseCheckInsMoods? element3
                in model.moods!) {
              int index = dayWiseCheckIns![p]!
                  .moods!
                  .indexWhere((element2) => element3!.mood == element2!.mood);
              if (index != -1) {
                dayWiseCheckIns![p]!.moods![index] = element3;
              }
            }
          }
          p++;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  setPreviousWeekSummary() {
    monday = monday!.subtract(const Duration(days: 7));
    sunday = sunday!.subtract(const Duration(days: 7));
    range.value =
        '${monday!.day} ${DateFormat.MMM().format(monday!)} - ${sunday!.day} ${DateFormat.MMM().format(sunday!)}';
    getWeeklySummary();
    // print(
    //     "setPreviousWeekSummary | currentWeek => ${DateFormat('yyyy-mm-dd').format(monday!)} - ${DateFormat('yyyy-mm-dd').format(sunday!)}");
  }

  setNextWeekSummary() {
    if (monday == now!.subtract(Duration(days: now!.weekday - 1))) {
      return;
    }
    monday = monday!.add(const Duration(days: 7));
    sunday = sunday!.add(const Duration(days: 7));
    range.value =
        '${monday!.day} ${DateFormat.MMM().format(monday!)} - ${sunday!.day} ${DateFormat.MMM().format(sunday!)}';
    getWeeklySummary();
    // print(
    //     "setNextWeekSummary | currentWeek => ${DateFormat('yyyy-mm-dd').format(monday!)} - ${DateFormat('yyyy-mm-dd').format(sunday!)}");
  }

  resetDayWiseCheckins() {
    dayWiseCheckIns!.value = [];
    MoodTrackerController moodTrackerController = Get.find();
    List<WeeklyMoodCheckInModelDayWiseCheckInsMoods> moods = [];
    for (var element in moodTrackerController.moodList.value!.moods!) {
      moods.add(WeeklyMoodCheckInModelDayWiseCheckInsMoods(
          checkIns: 0,
          icon: element?.icon ?? "",
          mood: element?.mood,
          moodId: element?.moodId ?? ""));
    }

    DateTime dateTime = monday!;
    while (dateTime.day != monday!.add(const Duration(days: 7)).day) {
      dayWiseCheckIns!.add(WeeklyMoodCheckInModelDayWiseCheckIns(
          checkInDate: dateTime, moods: List.from(moods)));
      dateTime = dateTime.add(const Duration(days: 1));
    }
  }
}
