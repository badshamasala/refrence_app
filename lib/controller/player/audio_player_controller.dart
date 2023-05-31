import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/state_manager.dart';

class AudioPlayerController extends GetxController {
  RxBool contentRatingAvailable = false.obs;

  List<Map<String, Object>> options = [
    {
      "text": "It's not relevant to me",
      "selected": false,
      "popPage": true,
    },
    {
      "text": "I am running out of time",
      "selected": false,
      "popPage": true,
    },
    {
      "text": "The content can be better",
      "selected": false,
      "popPage": true,
    },
    {
      "text": "Resume playing",
      "selected": false,
      "popPage": false,
    }
  ];

  int contentRating = -1;

  getContentRating(String contentId) async {
    try {
      contentRatingAvailable.value = await GrowService()
          .getContentRating(globalUserIdDetails!.userId!, contentId);
    } catch (exp) {
      print("Video | getContentRating => ${exp.toString()}");
    } finally {}
  }

  updateContentRating(int rating) {
    contentRating = rating;
    update();
  }

  resetOptions() {
    for (var element in options) {
      element["selected"] = false;
    }
    update();
  }

  setSelectedOptions(int index) {
    resetOptions();
    options[index]["selected"] = true;
    update();
  }

  postRecentContent(String contentId) {
    try {
      GrowService().postRecentContent(globalUserIdDetails!.userId!, contentId);
    } catch (exp) {
      print("Audio | postRecentContent => ${exp.toString()}");
    } finally {}
  }

  postContentRating(String contentId, String comments) {
    GrowService().postContentRating(
        globalUserIdDetails!.userId!, contentId, (contentRating + 1), comments);
  }

  postContentCompletion(String contentId, int day) async {
    await GrowService()
        .postContentCompletion(globalUserIdDetails!.userId!, contentId, day, "");
  }

  Future<bool> favouriteContent(String contentId, bool isFavourite) async {
    bool isSuccess = false;
    try {
      isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!, contentId, isFavourite, "grow");
    } finally {
      update();
    }
    return isSuccess;
  }
}
