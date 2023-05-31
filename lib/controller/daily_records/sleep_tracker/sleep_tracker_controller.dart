import 'package:aayu/model/model.dart';
import 'package:aayu/services/sleep.tracker.service.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SleepTrackerController extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  int totalPages = 3;
  Rx<SleepTrackerListModelSleeps?> selectedHowWasSleep =
      SleepTrackerListModelSleeps().obs;

  Rx<DateTime?> sleepRemindTime = (null as DateTime).obs;
  Rx<int> inBedTime = 276.obs;
  Rx<int> outBedTime = 84.obs;
  Rx<bool> showRemider = true.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isCompleteCheckinLoading = false.obs;

  Rx<SleepTrackerListModel?> sleepTrackerList = SleepTrackerListModel().obs;

  @override
  void onInit() {
    super.onInit();
    getSleepTrackerList();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  getSleepTrackerList() async {
    try {
      isLoading.value = true;
      SleepTrackerListModel? response =
          await SleepTrackingService().getSleepList();
      if (response != null) {
        sleepTrackerList.value = response;
        selectedHowWasSleep.value = sleepTrackerList.value?.sleeps?[0];
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> postSleepCheckIn() async {
    try {
      isCompleteCheckinLoading.value = true;
      Map<String, dynamic> postData = {
        "sleepId": selectedHowWasSleep.value?.sleepId,
        "checkInDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "bedTime": formatTime(inBedTime.value),
        "wakeupTime": formatTime(outBedTime.value),
      };
      List<SleepTrackerListModelSleepsIdentifications> list = [];
      if (selectedHowWasSleep.value?.identifications != null &&
          selectedHowWasSleep.value!.identifications!.isNotEmpty) {
        for (var element in selectedHowWasSleep.value!.identifications!) {
          if (element?.selected ?? false) {
            list.add(element!);
          }
        }
      }
      postData['identifications'] =
          list.map((e) => e.identificationId).toList();
      bool isAdded = await SleepTrackingService().postSleepCheckIn(postData);
      if (isAdded == true) {
        EventsService().sendEvent("Sleep_CheckIn_Completed", {
          "sleep": selectedHowWasSleep.value?.sleep,
          "identifications": list.map((e) => e.identification).join(","),
          "checkInTime": DateTime.now().toString()
        });
      }
    } finally {
      isCompleteCheckinLoading.value = true;

      update();
    }
  }

  setInitialValues() {
    pageIndex = 0;
    selectedHowWasSleep.value = sleepTrackerList.value?.sleeps?[0];
    inBedTime.value = 276;
    outBedTime.value = 84;

    update();
  }

  selectWhatYouFeelModel(int index) {
    selectedHowWasSleep.value!.identifications![index]!.selected =
        !selectedHowWasSleep.value!.identifications![index]!.selected!;

    update(['identification']);
  }

  selectHowWasSleep(int index) {
    selectedHowWasSleep.value = sleepTrackerList.value?.sleeps?[index];
    update();
  }

  setSleepReminderTime(DateTime? dateTime) {
    sleepRemindTime.value = dateTime;

    update();
  }

  updateSleepTime({required int inTime, required int outTime}) {
    inBedTime.value = inTime;
    outBedTime.value = outTime;
    update();
  }

  int formatTime(int time) {
    DateTime now = DateTime.now();
    if (time == 0 || time == 288) {
      return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    }

    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    if (hours > now.hour) {
      return DateTime(now.year, now.month, now.day - 1, hours, minutes)
          .millisecondsSinceEpoch;
    } else if (hours == now.hour) {
      if (minutes > now.minute) {
        return DateTime(now.year, now.month, now.day - 1, hours, minutes)
            .millisecondsSinceEpoch;
      }
    }
    return DateTime(now.year, now.month, now.day, hours, minutes)
        .millisecondsSinceEpoch;
  }

  setShowReminder(bool boolean) {
    showRemider.value = boolean;
    update();
  }
}
