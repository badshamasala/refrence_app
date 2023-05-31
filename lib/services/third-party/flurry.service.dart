import 'package:flutter_flurry_sdk/flurry.dart';

const String flurryAndroidAPIKey = '89PZQ54D7KRHMD2QKHVH';
const String flurryIosAPIKey = '5575YNN3P6S8RBW7T9DF';

class FlurryService {
  initialize() {
    try {
      Flurry.builder
          .withCrashReporting(true)
          .withLogEnabled(true)
          .withLogLevel(LogLevel.debug)
          .build(
              androidAPIKey: flurryAndroidAPIKey, iosAPIKey: flurryIosAPIKey);

      print("-------FlurryService | initialize | Success-------");
    } catch (e) {
      print("-------FlurryService | initialize | Failed-------");
      print(e);
    } finally {}
  }

  setUserId(String userId) {
    try {
      Flurry.setUserId(userId);
      print("-------FlurryService | setUserId | $userId | Success-------");
    } catch (e) {
      print("-------FlurryService | setUserId | Failed-------");
      print(e);
    }
  }
}
