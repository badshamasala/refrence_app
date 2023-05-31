import 'package:aayu/services/profile.service.dart';
import 'package:get/get.dart';

import '../../model/model.dart';

class UserPnSwitchController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<UserPnGetModal?> getPnSwitchList = UserPnGetModal().obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    await getUserPnSwitch();

    update();
  }

  Future<void> getUserPnSwitch() async {
    try {
      isLoading.value = true;
      UserPnGetModal? response = await ProfileService().getUserPnSwitchList();

      if (response != null && response.data != null) {
        getPnSwitchList.value = response;
      } else {
        getPnSwitchList.value = null;
      }
    } catch (exp) {
      print(exp);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  checkBoolean(index) async {
    if (getPnSwitchList.value?.data?.choices?[index]?.enabled == true) {
      getPnSwitchList.value?.data?.choices?[index]?.enabled = false;

      await ProfileService().postUserPnSwitchList(
          getPnSwitchList.value?.data?.choices?[index]?.pnTypeId ?? "", false);
    } else if (getPnSwitchList.value?.data?.choices?[index]?.enabled == false) {
      getPnSwitchList.value?.data?.choices?[index]?.enabled = true;

      await ProfileService().postUserPnSwitchList(
          getPnSwitchList.value?.data?.choices?[index]?.pnTypeId ?? "", true);
    }
    update();
  }
}
