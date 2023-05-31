import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:get/get.dart';

class VideoPlayerController extends GetxController {
  int contentRating = -1;
  RxBool contentRatingAvailable = false.obs;

  updateContentRating(int rating) {
    contentRating = rating;
    update();
  }

  getContentRating(String contentId) async {
    try {
      contentRatingAvailable.value = await GrowService()
          .getContentRating(globalUserIdDetails!.userId!, contentId);
    } catch (exp) {
      print("Video | getContentRating => ${exp.toString()}");
    } finally {}
  }

  postRecentContent(String contentId) {
    try {
      GrowService().postRecentContent(globalUserIdDetails!.userId!, contentId);
    } catch (exp) {
      print("Video | postRecentContent => ${exp.toString()}");
    } finally {}
  }

  postContentRating(String contentId, String comments) async {
    await GrowService().postContentRating(
        globalUserIdDetails!.userId!, contentId, (contentRating + 1), comments);
  }

  postContentCompletion(String contentId, int day, String programId) async {
    bool isPosted = await GrowService().postContentCompletion(
        globalUserIdDetails!.userId!, contentId, day, programId);
        if(isPosted == true){
          YouController youController = Get.find();
          youController.getMinutesSummary();
        }
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

  updateContentViewStatus(
      String subscriptionId, String programId, String day) async {
    bool isUpdated = await ProgrameService().updateContentViewStatus(
        globalUserIdDetails!.userId!, programId, subscriptionId, day, "Viewed");

    if (isUpdated) {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null) {
        EventsService().sendEvent("Program_Video_Viewed", {
          "program_id":
              subscriptionCheckResponse!.subscriptionDetails!.programId,
          "program_name":
              subscriptionCheckResponse!.subscriptionDetails!.programName,
          "subscription_id":
              subscriptionCheckResponse!.subscriptionDetails!.subscriptionId,
          "disease_name":
              subscriptionCheckResponse!.subscriptionDetails!.diseaseName,
          "day": day
        });
      }
    }
  }
}
