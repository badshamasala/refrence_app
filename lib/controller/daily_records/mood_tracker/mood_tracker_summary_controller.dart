import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class MoodTrackerSummaryController extends GetxController {
  RxBool todaysSummaryLoading = false.obs;
  RxBool isMoodCheckInDatesLoading = false.obs;
  RxBool isReminderActive = false.obs;
  DateTime? reminderTime;
  // ignore: unnecessary_cast
  Rx<MoodCheckInModel?> todaysMoodSummary = (null as MoodCheckInModel?).obs;
  RxBool isReminderLoading = false.obs;

  List<String> searchKeywords = [];
  Rx<ContentCategories?> recommendedContent = ContentCategories().obs;

  Future<void> getTodaysMoodSummary() async {
    try {
      todaysSummaryLoading.value = true;
      TodaysMoodSummaryModel? response =
          await MoodTrackingService().getTodaysMoodSummary();
      if (response != null && response.checkInDetails != null) {
        todaysMoodSummary.value = response.checkInDetails;
        if (searchKeywords.contains(response.checkInDetails?.mood?.mood) ==
            false) {
          searchKeywords.add(response.checkInDetails?.mood?.mood ?? "");
        }
        response.checkInDetails!.feelings?.forEach((element) {
          if (searchKeywords.contains(element?.feeling) == false) {
            searchKeywords.add(element?.feeling ?? "");
          }
        });
        response.checkInDetails!.identifications?.forEach((element) {
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
      update();
    }
  }

  switchReminderActive() {
    isReminderActive.value = !isReminderActive.value;
    update(['reminder']);
  }

  Future<void> updateReminderTime() async {
    Map<String, dynamic> map = {
      "isActive": isReminderActive.value,
      "reminderTime": reminderTime!.millisecondsSinceEpoch,
    };
    try {
      isReminderLoading.value = true;
      update(['reminder']);
      bool isUpdated = await MoodTrackingService().putReminderTime(map);
      if (isUpdated == true) {
        if (isReminderActive.value == true) {
          await LocalNotificationService().scheduleMoodReminder(reminderTime!);
        } else {
          await LocalNotificationService().cancelReminder("MOOD_TRACKER");
        }

        if (isReminderActive.value == true) {
          EventsService().sendEvent("Mood_CheckIn_Reminder_Set", {
            "reminderTime": DateFormat('hh:mm a').format(reminderTime!),
          });
        } else {
          EventsService().sendEvent("Mood_CheckIn_Reminder_Off", {
            "reminderTime": DateFormat('hh:mm a').format(reminderTime!),
          });
        }
      }
    } finally {
      isReminderLoading.value = false;
      update(['reminder']);
    }
  }

  setMoodReminderTime(DateTime d) {
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
