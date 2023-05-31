import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/services/sleep.tracker.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SleepTrackerSummaryController extends GetxController {
  RxList<dynamic> chartData = [].obs;
  RxBool todaysSummaryLoading = false.obs;
  RxBool dateWiseSleepCheckInLoading = false.obs;

  Rx<SleepCheckInModel?> recentSleepCheckInModel =
      // ignore: unnecessary_cast
      (null as SleepCheckInModel?).obs;
  Rx<DateWiseSleepCheckInModel?> dateWiseSleepCheckInModel =
      DateWiseSleepCheckInModel().obs;
  RxBool isReminderActive = false.obs;
  DateTime? reminderTime;
  RxBool isReminderLoading = false.obs;

  List<String> searchKeywords = [];
  Rx<ContentCategories?> recommendedContent = ContentCategories().obs;

  Future<void> getRecentSleepCheckIn() async {
    try {
      todaysSummaryLoading.value = true;
      TodaysSleepSummaryModel? response =
          await SleepTrackingService().getTodaysSleepSummary();

      if (response != null &&
          response.checkInDetails != null &&
          response.checkInDetails!.isNotEmpty &&
          response.checkInDetails![0] != null) {
        recentSleepCheckInModel.value = response.checkInDetails![0];
        response.checkInDetails![0]?.identifications?.forEach((element) {
          if (searchKeywords.contains(element?.identification) == false) {
            searchKeywords.add(element?.identification ?? "");
          }
        });
        if (searchKeywords.isNotEmpty) {
          getRecommendedContent();
        }
      }
      if (response?.reminder?.reminderTime != null) {
        reminderTime = dateFromTimestamp(response!.reminder!.reminderTime!);
      } else {
        DateTime todays = DateTime.now();
        reminderTime =
            DateTime(todays.year, todays.month, todays.day, 10, 0, 0);
      }
      isReminderActive.value = response?.reminder?.isActive ?? false;
    } finally {
      todaysSummaryLoading.value = false;
      update(['recentSleep']);
    }
  }

  Future<void> getDateWiseSleepCheckIn(DateTime dateTime) async {
    try {
      dateWiseSleepCheckInLoading.value = true;

      DateWiseSleepCheckInModel? response = await SleepTrackingService()
          .getDateWiseSleepSummary(DateFormat('yyyy-MM-dd').format(dateTime));
      if (response != null) {
        dateWiseSleepCheckInModel.value = response;
      }
    } finally {
      dateWiseSleepCheckInLoading.value = false;
    }
  }

  switchReminderActive() {
    isReminderActive.value = !isReminderActive.value;
    update(['reminder']);
  }

  Future<void> updateReminderTime() async {
    Map<String, dynamic> map = {
      "isActive": isReminderActive.value,
      "reminderTime": reminderTime!.millisecondsSinceEpoch
    };
    try {
      isReminderLoading.value = true;
      update(['reminder']);
      bool isUpdated = await SleepTrackingService().putReminderTime(map);
      if (isUpdated == true) {
        if (isReminderActive.value == true) {
          await LocalNotificationService().scheduleSleepReminder(reminderTime!);
        } else {
          await LocalNotificationService().cancelReminder("SLEEP_TRACKER");
        }

        if (isReminderActive.value == true) {
          EventsService().sendEvent("Sleep_CheckIn_Reminder_Set", {
            "reminderTime": DateFormat('hh:mm a').format(reminderTime!),
          });
        } else {
          EventsService().sendEvent("Sleep_CheckIn_Reminder_Off", {
            "reminderTime": DateFormat('hh:mm a').format(reminderTime!),
          });
        }
      }
    } finally {
      isReminderLoading.value = false;
      update(['reminder']);
    }
  }

  setSleepReminderTime(DateTime d) {
    reminderTime = d;
  }

  Future<void> getRecommendedContent() async {
    try {
      dynamic postData = {
        "data": {"keywords": searchKeywords.join(",")}
      };
      ContentCategories? response = await GrowService()
          .searchContentByKeywords(globalUserIdDetails?.userId!, postData);
      if (response != null &&
          response.content != null &&
          response.content!.isNotEmpty) {
        recommendedContent.value = response;
      } else {
        recommendedContent.value = null;
      }
    } finally {
      update(['recommendedContent']);
    }
  }
}
