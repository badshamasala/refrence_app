import 'package:aayu/config.dart';
import 'package:aayu/model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../view/shared/constants.dart';

class AppPropertiesService {
  fetchProperties() async {
    String apiBaseUrl = "";
    http.Response? httpResponse;
    dynamic responseData;
    try {
      apiBaseUrl = Config.apiBaseUrl["app-property-service"]["baseUrl"];
      print("fetchProperties | apiBaseUrl => $apiBaseUrl");
      httpResponse = await http.get(Uri.parse(apiBaseUrl));
      if (httpResponse.statusCode == 200) {
        responseData = json.decode(httpResponse.body);
        appProperties = AppProperties.fromJson(responseData);
        // print(
        //   '---------APP PROPERTIES---------\nmethod => httpGet\nURL => $apiBaseUrl\nstatusCode => ${httpResponse!.statusCode}\nresponse => ${json.encode(appProperties.toJson())}');
      }
    } catch (err) {
      print("FETCH PROPERTIES ERROR **************");
      print(err);
    }
  }
}
