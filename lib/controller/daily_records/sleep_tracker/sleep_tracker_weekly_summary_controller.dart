import 'package:aayu/model/model.dart';
import 'package:aayu/services/sleep.tracker.service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SleepTrackerWeeklySummaryController extends GetxController {
  DateTime? monday;
  DateTime? sunday;
  DateTime? now;
  Rx<String> range = ''.obs;
  RxBool isLoading = false.obs;
  Rx<WeeklySleepCheckInModel?> weeklySleepCheckInModel =
      (null as WeeklySleepCheckInModel).obs;

  RxList<ChartSampleData> chartData = <ChartSampleData>[].obs;
  late TooltipBehavior tooltipBehavior;
  @override
  void onInit() {
    super.onInit();
    tooltipBehavior = TooltipBehavior(
      enable: true,
      header: 'Duration',
    );

    now = DateTime.now();
    monday = now!.subtract(Duration(days: now!.weekday - 1));
    sunday = monday!.add(const Duration(days: 6));
    range.value =
        '${monday!.day} ${DateFormat.MMM().format(monday!)} - ${sunday!.day} ${DateFormat.MMM().format(sunday!)}';
    resetCharData();
  }

  resetCharData() {
    chartData.value = [];
    DateTime dateTime = monday!;
    while (dateTime.day != monday!.add(const Duration(days: 7)).day) {
      chartData.add(ChartSampleData(
          dateTime: dateTime,
          x: DateFormat('EEE\ndd').format(dateTime),
          val: 0));

      dateTime = dateTime.add(const Duration(days: 1));
    }
  }

  Future<void> getWeeklySummary() async {
    try {
      isLoading.value = true;
      update();
      WeeklySleepCheckInModel? response = await SleepTrackingService()
          .getWeeklySleepSummary(DateFormat('yyyy-MM-dd').format(monday!),
              DateFormat('yyyy-MM-dd').format(sunday!));
      resetCharData();

      weeklySleepCheckInModel.value = response;
      if (response != null) {
        int p = 0;
        while (p < 7) {
          WeeklySleepCheckInModelDayWiseCheckIns? model =
              weeklySleepCheckInModel.value!.dayWiseCheckIns!.firstWhereOrNull(
                  (element) =>
                      element!.checkInDate!.day == chartData[p].dateTime.day);

          if (model != null) {
            chartData.removeAt(p);
            chartData.insert(
                p,
                ChartSampleData(
                    dateTime: model.checkInDate!,
                    x: DateFormat('EEE\ndd').format(model.checkInDate!),
                    val: model.sleepHours ?? 0));
          }
          p++;
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  setPreviousWeekSummary() {
    monday = monday!.subtract(const Duration(days: 7));
    sunday = sunday!.subtract(const Duration(days: 7));
    range.value =
        '${monday!.day} ${DateFormat.MMM().format(monday!)} - ${sunday!.day} ${DateFormat.MMM().format(sunday!)}';
    getWeeklySummary();
    print(
        "setPreviousWeekSummary | currentWeek =>  ${DateFormat('yyyy-mm-dd').format(monday!)}");
    print(
        "setPreviousWeekSummary | weeklyMoodSummary.length => ${DateFormat('yyyy-mm-dd').format(sunday!)}");
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

    print(
        "setNextWeekSummary | currentWeek =>  ${DateFormat('yyyy-mm-dd').format(monday!)}");
    print(
        "setNextWeekSummary | weeklyMoodSummary.length =>  ${DateFormat('yyyy-mm-dd').format(sunday!)}");
  }
}

class ChartSampleData {
  final String x;
  final double val;
  final DateTime dateTime;

  ChartSampleData({required this.dateTime, required this.x, required this.val});
}
