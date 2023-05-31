import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:aayu/services/programe.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProgramReminderController extends GetxController {
  DateTime reminderTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0, 0);
  List<ProgramReminderDetailsWeekDays?>? weekDays = [
    ProgramReminderDetailsWeekDays(day: "M", shortDay: "Mon", selected: true),
    ProgramReminderDetailsWeekDays(day: "T", shortDay: "Tue", selected: true),
    ProgramReminderDetailsWeekDays(day: "W", shortDay: "Wed", selected: true),
    ProgramReminderDetailsWeekDays(day: "T", shortDay: "Thu", selected: true),
    ProgramReminderDetailsWeekDays(day: "F", shortDay: "Fri", selected: true),
    ProgramReminderDetailsWeekDays(day: "S", shortDay: "Sat", selected: true),
    ProgramReminderDetailsWeekDays(day: "S", shortDay: "Sun", selected: true)
  ];

  Rx<bool> isLoading = false.obs;
  Rx<ProgramReminderDetails?> programReminderDetails =
      ProgramReminderDetails().obs;

  getReminderDetails() async {
    try {
      isLoading.value = true;
      ProgramReminderDetails? response = await ProgrameService()
          .getProgramReminderDetails(
              globalUserIdDetails!.userId!,
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
              subscriptionCheckResponse!.subscriptionDetails!.programId!);
      if (response != null) {
        programReminderDetails.value = response;
        int hour = DateTime.now().hour;
        int minute = DateTime.now().minute;
        if (response.reminderTime!.contains(":")) {
          hour = int.parse(response.reminderTime!.split(":")[0]);
          minute = int.parse(response.reminderTime!.split(":")[1]);
        }
        reminderTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, hour, minute);
        for (var element in response.weekDays!) {
          for (var item in weekDays!) {
            if (item!.shortDay == element!.shortDay) {
              item.selected = element.selected;
              break;
            }
          }
        }
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  setReminderTime(DateTime changedTime) {
    reminderTime = changedTime;
    update();
  }

  selectWeekDays(int index) {
    if (weekDays![index]!.selected == true) {
      for (var element in weekDays!) {
        element!.selected = true;
      }
      weekDays![index]!.selected = false;
    } else {
      weekDays![index]!.selected = true;
    }
    update();
  }

  updateProgramReminderTime() async {
    dynamic postData = {
      "reminderTime": DateFormat("HH:mm").format(
        reminderTime,
      ),
      "sendNotification":
          programReminderDetails.value!.sendNotification ?? true,
      "weekDays": []
    };
    for (var item in weekDays!) {
      postData["weekDays"].add(item!.toJson());
    }
    bool isUpdated = await ProgrameService().updateProgramReminderTime(
        globalUserIdDetails!.userId!,
        subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!,
        subscriptionCheckResponse!.subscriptionDetails!.programId!,
        postData);
    if (isUpdated) {
      List<String> selectedDays = [];
      for (var item in weekDays!) {
        if (item!.selected == true) {
          selectedDays.add(item.day!.toUpperCase());
        }
      }
      LocalNotificationService().schedulePrgoramReminder(
          selectedDays, reminderTime.hour, reminderTime.minute);
    }
    return isUpdated;
  }
}
