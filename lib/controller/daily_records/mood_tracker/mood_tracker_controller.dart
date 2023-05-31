import 'package:aayu/controller/daily_records/mood_tracker/mood_identify_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodTrackerController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> sendReminder = true.obs;
  RxBool isCompleteCheckinLoading = false.obs;
  Rx<DateTime?> submitTime = (null as DateTime).obs;
  Rx<DateTime?> moodReminderTime = (null as DateTime).obs;

  Rx<bool> isFirstTimeCheckIn = true.obs;

  TextEditingController expressYourselfTextController = TextEditingController();

  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  int totalPages = 4;

  Rx<MoodListModel?> moodList = MoodListModel().obs;
  Rx<MoodListModelMoods> selectedMood = MoodListModelMoods().obs;

  @override
  void onInit() {
    getMoodList();
    super.onInit();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  setInitialValues() {
    pageIndex = 0;
    if (moodList.value?.moods != null) {
      for (var element in moodList.value!.moods!) {
        element!.isSelected = false;
      }
    }
    if (selectedMood.value.feelings != null &&
        selectedMood.value.feelings!.isNotEmpty) {
      for (var element in selectedMood.value.feelings!) {
        element!.isSelected = false;
      }
    }
    expressYourselfTextController.text = "";
    update();
  }

  getMoodList() async {
    try {
      isLoading.value = true;
      MoodListModel? response = await MoodTrackingService().getMoodList();
      if (response != null) {
        moodList.value = response;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  updateSelectedMood(int selectedIndex) {
    for (var element in moodList.value!.moods!) {
      element!.isSelected = false;
    }
    moodList.value!.moods![selectedIndex]!.isSelected = true;
    selectedMood.value = moodList.value!.moods![selectedIndex]!;
    update();
  }

  updateFeelFactors(int selectedIndex) {
    selectedMood.value.feelings![selectedIndex]!.isSelected =
        !selectedMood.value.feelings![selectedIndex]!.isSelected!;

    update();
  }

  checkFeelFactorSelected() {
    int selectedIndex = selectedMood.value.feelings!
        .indexWhere((element) => element!.isSelected == true);

    if (selectedIndex >= 0) {
      return true;
    }
    return false;
  }

  submitExpressYourselfText(DateTime dateTime) {
    submitTime.value = dateTime;
    update();
  }

  setBoolSendReminder(bool boolean) {
    sendReminder.value = boolean;
    update();
  }

  Future<void> completeCheckin() async {
    try {
      isCompleteCheckinLoading(true);
      update();
      Map<String, dynamic> postData = {};
      postData['moodId'] = selectedMood.value.moodId;
      List<MoodListModelMoodsFeelings> listFeelings = [];
      List<MoodIdentifyModelIdentifications> listIdentifications = [];
      if (selectedMood.value.feelings != null) {
        for (var m in selectedMood.value.feelings!) {
          if (m?.isSelected ?? false) {
            listFeelings.add(m!);
          }
        }
      }
      MoodIdentifyController moodIdentifyController = Get.find();
      if (moodIdentifyController.pageContent.identifications != null) {
        for (var m in moodIdentifyController.pageContent.identifications!) {
          if (m?.selected ?? false) {
            listIdentifications.add(m!);
          }
        }
      }
      postData['feelings'] = listFeelings.map((e) => e.feelingId).toList();
      postData['identifications'] =
          listIdentifications.map((e) => e.identificationId).toList();
      postData['note'] = expressYourselfTextController.text.trim();

      bool isAdded = await MoodTrackingService().postMoodCheckIn(postData);

      if (isAdded == true) {
        EventsService().sendEvent("Mood_CheckIn_Completed", {
          "mood": selectedMood.value.mood,
          "feelings": listFeelings.map((e) => e.feeling).join(","),
          "identifications":
              listIdentifications.map((e) => e.identification).join(","),
          "checkInTime": DateTime.now().toString()
        });
      }
    } finally {
      isCompleteCheckinLoading(false);
      update();
    }
  }
}
