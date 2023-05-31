import 'package:aayu/main_common.dart';

import 'config.dart';

Future<void> main() async {
  print(" ------------------main_dev.dart file called ------------------");
  Config.setEnvironment(Environment.DEV);
  initializeApp();
}
