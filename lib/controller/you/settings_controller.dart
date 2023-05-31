import 'package:aayu/model/model.dart';
import 'package:aayu/services/hive.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:get/state_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends GetxController {
  Rx<bool> showNotification = false.obs;
  RxString buildNumber = "".obs;
  Rx<bool> showCheatLinks = false.obs;
  Rx<String> mobileNumber = "".obs;
  @override
  onInit() {
    getVersionName();
    checkIsWhiteListedNumber();
    super.onInit();
  }

  getVersionName() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    buildNumber.value = "${info.version}+${info.buildNumber}";
    update();
  }

  switchNotification() {
    showNotification.value = !showNotification.value;
    update();
  }

  checkIsWhiteListedNumber() async {
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();
    if (userDetailsResponse != null &&
        userDetailsResponse.userDetails != null &&
        userDetailsResponse.userDetails!.mobileNumber != null) {
      showCheatLinks.value = appProperties.whiteListNumbers!
          .contains(userDetailsResponse.userDetails!.mobileNumber);
      mobileNumber.value = userDetailsResponse.userDetails!.mobileNumber!;
      print("showCheatLinks => $showCheatLinks");
    }
  }
}
