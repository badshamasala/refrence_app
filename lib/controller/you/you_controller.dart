import 'dart:convert';
import 'dart:io';
import 'package:aayu/view/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:aayu/data/you_data.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:get/state_manager.dart';

class YouController extends GetxController {
  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isMinutesSummaryLoading = false.obs;
  Rx<YouMinutesSummaryModel?> minutesSummary = YouMinutesSummaryModel().obs;
  YouLinksModel linksData = YouLinksModel();

  @override
  void onInit() async {
    isLoading(true);
    userDetails.value = await HiveService().getUserDetails();
    getLinks();
    isLoading(false);
    super.onInit();
  }

  showUpdatedProfile() async {
    userDetails.value = await HiveService().getUserDetails();
  }

  getLinks() {
    linksData = YouLinksModel.fromJson(jsonDecode(jsonEncode(youLinksData)));
    update();
  }

  Future<void> getMinutesSummary() async {
    try {
      isMinutesSummaryLoading.value = true;

      YouMinutesSummaryModel youMinutesSummary = YouMinutesSummaryModel();
      youMinutesSummary = YouMinutesSummaryModel.fromJson(
          jsonDecode(jsonEncode(youMinutesSummaryData)));

      YouMinutesSummaryResponse? response =
          await GrowService().getMinutesSummary(globalUserIdDetails!.userId!);
      if (response != null && response.details != null) {
        for (var element in youMinutesSummary.summary!) {
          if (element!.type == "Yoga") {
            element.count = response.details!.yogaMinutes;
          } else if (element.type == "Meditation") {
            element.count = response.details!.meditationMinutes;
          } else if (element.type == "Streak") {
            element.count = response.details!.streak;
          }
        }

        EventsService().sendEvent("You_Minutes_Summary", {
          "yoga_minutes": response.details!.yogaMinutes,
          "meditation_minutes": response.details!.meditationMinutes,
          "streak": response.details!.streak,
        });

        minutesSummary.value = youMinutesSummary;
      } else {
        minutesSummary.value = youMinutesSummary;
      }
    } finally {
      isMinutesSummaryLoading.value = false;
      update();
    }
  }

  uploadProfileImage(File imageFile) async {
    try {
      isLoading.value = true;

      // open a bytestream
      var stream = http.ByteStream(Stream.castFrom((imageFile.openRead())));
      // get file length
      var length = await imageFile.length();
      final bytes = imageFile.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;
      print("SIZE OF IMAGE :::::::::::::::::::::::::::::::::::");
      print(mb);

      // multipart that takes file
      http.MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));

      ProfileImageUploadResponse? profileImageUploadResponse =
          await ProfileService().uploadProfileImage(
              userDetails.value!.userDetails!.userId!, multipartFile);

      if (profileImageUploadResponse != null &&
          profileImageUploadResponse.image != null &&
          profileImageUploadResponse.image!.isNotEmpty) {
        UserDetailsResponse? userDetailsResponse = await ProfileService()
            .getUserDetails(userDetails.value!.userDetails!.userId!);

        if (userDetailsResponse != null &&
            userDetailsResponse.userDetails != null) {
          if (userDetailsResponse.userDetails!.userId!.isNotEmpty &&
              userDetailsResponse.userDetails!.userId! ==
                  userDetails.value!.userDetails!.userId!) {
            await HiveService()
                .saveDetails("userDetails", userDetailsResponse.toJson());

            MoengageService()
                .setGender(userDetailsResponse.userDetails!.gender!);
          }
        }

        return true;
      }

      return false;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  removeProfileImage() async {
    bool? isRemoved = false;
    try {
      isLoading.value = true;
      isRemoved = await ProfileService()
          .removeProfileImage(userDetails.value!.userDetails!.userId!);
      if (isRemoved == true) {
        UserDetailsResponse? userDetailsResponse = await ProfileService()
            .getUserDetails(userDetails.value!.userDetails!.userId!);

        if (userDetailsResponse != null &&
            userDetailsResponse.userDetails != null) {
          if (userDetailsResponse.userDetails!.userId!.isNotEmpty &&
              userDetailsResponse.userDetails!.userId! ==
                  userDetails.value!.userDetails!.userId!) {
            await HiveService()
                .saveDetails("userDetails", userDetailsResponse.toJson());
          }
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }

    return isRemoved;
  }
}
