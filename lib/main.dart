import 'package:aayu/config.dart';
import 'package:aayu/main_common.dart';

void main() async {
  print(" ------------------main.dart file called ------------------");
  if (Environment.values.isNotEmpty) {
    Environment envVALUE = Environment.values.firstWhere((e) =>
        e.toString() ==
        "Environment." +
            const String.fromEnvironment('ENV_VALUE', defaultValue: 'PROD'));
    Config.setEnvironment(envVALUE);
  } else {
    print(" ------------------main.dart | Default Env Set ------------------");
    Config.setEnvironment(Environment.PROD);
  }

  initializeApp();
}