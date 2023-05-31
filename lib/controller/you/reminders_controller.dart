import 'package:aayu/data/you_data.dart';
import 'package:aayu/model/you/reminders.model.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class RemindersController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<RemindersModel> remindersContent = RemindersModel().obs;

  @override
  void onInit() {
    super.onInit();
    remindersContent.value = RemindersModel.fromJson(remindersData);
  }

  changeSwitch(RemindersModelData data) {
    data.active = !data.active!;
    update();
  }

  changeTime(DateTime dateTime, RemindersModelData data) {
    data.time = DateFormat('hh:mm a').format(dateTime);
    update();
  }
}
