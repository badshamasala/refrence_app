import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:get/state_manager.dart';

class ShortcutController extends GetxController {
  Rx<ShortcutResponse?> shortcuts = ShortcutResponse().obs;
  Rx<bool> isLoading = false.obs;
  @override
  void onInit() async {
    try {
      isLoading.value = true;
      ShortcutResponse? cachedShortcuts = await HomeService().getShortcutList();
      if (cachedShortcuts != null) {
        shortcuts.value = cachedShortcuts;
      }
      super.onInit();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  reOrderShortcuts(int oldIndex, int newIndex) {
    if (shortcuts.value!.categories![oldIndex]!.name != "Organize" &&
        shortcuts.value!.categories![newIndex]!.name != "Organize") {
      shortcuts.value!.categories!
          .insert(newIndex, shortcuts.value!.categories!.removeAt(oldIndex));
      update();
    }
  }
}
