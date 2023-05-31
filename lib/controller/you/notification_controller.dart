import 'package:aayu/data/you_data.dart';
import 'package:aayu/model/you/notifications.model.dart';
import 'package:get/state_manager.dart';

class NotificationController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<NotificationsModel> notificationContent = NotificationsModel().obs;
  List<NotificationsModelDataList> todaysList = [];
  List<NotificationsModelDataList> thisWeeksList = [];
  List<NotificationsModelDataList> lastWeeksList = [];
  List<NotificationsModelDataList> thisMonthsList = [];
  List<NotificationsModelDataList> olderList = [];

  @override
  void onInit() {
    super.onInit();
    notificationContent.value = NotificationsModel.fromJson(notificationsData);
    segregate();
  }

  void segregate() {
    for (var element in notificationContent.value.data!.list!) {
      DateTime now = DateTime.now();
      if (now
              .difference(DateTime.parse(element!.date!))
              .compareTo(const Duration(hours: 24)) <
          0) {
        print(now.difference(DateTime.parse(element.date!)).inHours);
        todaysList.add(element);
      } else if (now
              .difference(DateTime.parse(element.date!))
              .compareTo(const Duration(days: 7)) <
          0) {
        thisWeeksList.add(element);
      } else if (now
              .difference(DateTime.parse(element.date!))
              .compareTo(const Duration(days: 14)) <
          0) {
        lastWeeksList.add(element);
      } else if (DateTime.parse(element.date!).month == now.month &&
          DateTime.parse(element.date!).year == now.year) {
        thisMonthsList.add(element);
      } else {
        olderList.add(element);
      }
    }
  }
}
