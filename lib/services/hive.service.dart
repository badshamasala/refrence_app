import 'dart:convert';

import 'package:aayu/model/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

class HiveService {
  final String _userDetailsBoxName = "userDetails";
  final String _userFirstTimeDetails = "userFirstTimeDetails";
  final String _userRecentSearches = 'userRecentSearches';
  initialize() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      print(
          "HiveService | initHiveService => appDocumentDir: ${appDocumentDir.path}");
      Hive.init(appDocumentDir.path);
      print("-------HiveService | initialize | Success-------");
    } catch (e) {
      print("-------HiveService | initialize | Failed-------");
      print(e);
    } finally {}
  }

  clearAllCachedData() async {
    await Hive.deleteFromDisk();
  }

  saveDetails(String keyName, dynamic data) async {
    String boxName = "";
    switch (keyName) {
      case "userIdDetails":
      case "userDetails":
        boxName = _userDetailsBoxName;
        final userDetails = await Hive.openBox(_userDetailsBoxName);
        userDetails.put(keyName, data);

        break;
      default:
        break;
    }

    print(
        "---------HiveService|saveDetails---------\nboxName => $boxName\nkeyName=> $keyName\ndata => ${json.encode(data)}");
  }

  initFirstTime() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time\ndata => false");
  }

  Future<bool> isFirstTime() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time") &&
          firstTime.get("first_time") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  Future<List<String>> addToRecentSearches(String text) async {
    final userRecentSearch = await Hive.openBox(_userRecentSearches);
    List<String>? list =
        userRecentSearch.get('recentSearchList') as List<String>?;
    if (list == null) {
      await userRecentSearch.put('recentSearchList', [text]);
    } else {
      if (list.contains(text)) {
        list.remove(text);
      }
      list.insert(0, text);
      if (list.length >= 10) {
        list = list.getRange(0, 9).toList();
      }
      await userRecentSearch.put('recentSearchList', list);
    }
    return list ?? [];
  }

  Future<List<String>> returnRecentSearchList() async {
    final userRecentSearch = await Hive.openBox(_userRecentSearches);
    List<String>? list =
        userRecentSearch.get('recentSearchList') as List<String>?;
    return list ?? [];
  }

  Future<List<String>> removeFromRecentSearchList(int index) async {
    final userRecentSearch = await Hive.openBox(_userRecentSearches);
    List<String>? list =
        userRecentSearch.get('recentSearchList') as List<String>?;
    if (list != null && list.isNotEmpty) {
      list.removeAt(index);
      await userRecentSearch.put('recentSearchList', list);
    }
    return list ?? [];
  }

  initFirstTimeLiveEvent() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_live_event", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_live_event\ndata => false");
  }

  initSwitchProgramToPersonalPopup() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("show_switch_popup", true);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> show_switch_popup\ndata => true");
  }

  Future<bool> showSwitchProgramSuccessfullyPopup() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("show_switch_popup") &&
          firstTime.get("show_switch_popup") == true) {
        return true;
      }
    } catch (err) {
      return false;
    }
    return false;
  }

  seenSwitchProgramToPersonalPopup() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("show_switch_popup", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> show_switch_popup\ndata => false");
  }

  Future<bool> isFirstTimeLiveEvent() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_live_event") &&
          firstTime.get("first_time_live_event") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  Future<bool> showCoachMark() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_coach_mark") &&
          firstTime.get("first_time_coach_mark") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  seenCoachMarks() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_coach_mark", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_coach_mark\ndata => false");
  }

  initFirstTimeDoctorConsultation() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_doctor_consultation", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_doctor_consultation\ndata => false");
  }

  initFirstTimeTrainerSession() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_trainer_session", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_trainer_session\ndata => false");
  }

  Future<bool> isFirstTimeDoctorConsultation() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_doctor_consultation") &&
          firstTime.get("first_time_doctor_consultation") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  Future<bool> isFirstTimeTrainerSession() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_trainer_session") &&
          firstTime.get("first_time_trainer_session") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  Future<UserRegistrationResponse?> getUserIdDetails() async {
    dynamic json;
    try {
      final userDetailsBox = await Hive.openBox(_userDetailsBoxName);
      if (userDetailsBox.isNotEmpty &&
          userDetailsBox.containsKey("userIdDetails")) {
        json = userDetailsBox.get("userIdDetails");
        if (json != null) {
          json = jsonDecode(jsonEncode(json));
          return UserRegistrationResponse.fromJson(json);
        }
      }
    } catch (excp) {
      print(excp);
    } finally {
      print(
          "---------HiveService|getDetails---------\nboxName => userDetails\nkeyName=> userIdDetails\ndata => $json");
    }
    return json;
  }

  Future<UserDetailsResponse?> getUserDetails() async {
    UserDetailsResponse userDetails = UserDetailsResponse();
    try {
      final userDetailsBox = await Hive.openBox(_userDetailsBoxName);
      if (userDetailsBox.isNotEmpty &&
          userDetailsBox.containsKey("userDetails")) {
        dynamic json = userDetailsBox.get("userDetails");
        if (json != null) {
          json = jsonDecode(jsonEncode(json));
          userDetails = UserDetailsResponse.fromJson(json);
          return userDetails;
        }
      }
    } catch (excp) {
      print(excp);
    } finally {
      print(
          "---------HiveService|getDetails---------\nboxName => userDetails\nkeyName=> userDetails\ndata => ${userDetails.toJson()}");
    }

    return userDetails;
  }

  initFirstTimeMoodCkeckIn() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_mood_check_in", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_mood_check_in\ndata => false");
  }

  Future<bool> isFirstTimeMoodCkeckIn() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_mood_check_in") &&
          firstTime.get("first_time_mood_check_in") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  initFirstTimeSleepCkeckIn() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_sleep_check_in", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_sleep_check_in\ndata => false");
  }

  Future<bool> isFirstTimeSleepCkeckIn() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_sleep_check_in") &&
          firstTime.get("first_time_sleep_check_in") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  Future<bool> isFirstTimeWaterIntake() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_water_intake") &&
          firstTime.get("first_time_water_intake") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  initFirstTimeWaterIntake() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_water_intake", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_water_intake\ndata => false");
  }

  Future<bool> isFirstTimeWeightTracker() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_weight_tracker") &&
          firstTime.get("first_time_weight_tracker") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  initFirstTimeWeightTracker() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_weight_tracker", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_weight_tracker\ndata => false");
  }

  Future<bool> isFirstTimeNutritionAssessment() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("first_time_nutrition_assessment") &&
          firstTime.get("first_time_nutrition_assessment") == false) {
        return false;
      }
    } catch (err) {
      return true;
    }
    return true;
  }

  initFirstTimeNutritionAssessment() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("first_time_nutrition_assessment", false);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> first_time_nutrition_assessment\ndata => false");
  }

  Future<bool> isNutritionAssessmentCompleted() async {
    try {
      final firstTime = await Hive.openBox(_userFirstTimeDetails);
      if (firstTime.isNotEmpty &&
          firstTime.containsKey("nutrition_assessment_completed") &&
          firstTime.get("nutrition_assessment_completed") == true) {
        return true;
      }
    } catch (err) {
      return false;
    }
    return false;
  }

  initNutritionAssessmentComplete() async {
    final firstTime = await Hive.openBox(_userFirstTimeDetails);
    firstTime.put("nutrition_assessment_completed", true);
    print(
        "---------HiveService|saveDetails---------\nboxName => $_userFirstTimeDetails\nkeyName=> nutrition_assessment_completed\ndata => true");
  }
}
