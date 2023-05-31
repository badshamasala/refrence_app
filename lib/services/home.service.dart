import 'package:aayu/model/model.dart';
import 'package:aayu/services/http.service.dart';
import 'package:aayu/view/shared/shared.dart';

import 'request.id.service.dart';

class HomeService {
  static const String serviceName = "content-service";
  Future<ShortcutResponse?> getShortcutList() async {
    dynamic response = await httpGet(serviceName,
        'onboarding-service/v1/home/category?requestId=${getRequestId()}');
    if (response != null && response["success"] == true) {
      ShortcutResponse shortcutResponse = ShortcutResponse();
      shortcutResponse = ShortcutResponse.fromJson(response["data"]);
      print(response["data"]);
      return shortcutResponse;
    } else {
      showError(response["error"]);
      return null;
    }
  }
}
