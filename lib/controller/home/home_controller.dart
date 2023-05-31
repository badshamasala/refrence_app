import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;
  Rx<HomePageContentResponse?> homePageContent = HomePageContentResponse().obs;
  Rx<ContentCategories?> recentCategoryContent = ContentCategories().obs;
  Rx<InitialStatusModel?> statusContent = InitialStatusModel().obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isRecentCategoryLoading = false.obs;
  Rx<bool> isStatusLoading = false.obs;

  @override
  void onInit() async {
    getHomePageContent();
    userDetails.value = await HiveService().getUserDetails();
    getInitialAssesmentStatusRequest();
    super.onInit();
  }

  Future<void> getHomePageContent() async {
    try {
      isLoading.value = true;

      String userId = globalUserIdDetails?.userId ?? "";
      HomePageContentResponse? response =
          await GrowService().getHomePageContent(userId);
      if (response != null) {
        homePageContent.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }

  getRecentCategoryContent() async {
    try {
      isRecentCategoryLoading.value = true;
      String userId = globalUserIdDetails?.userId ?? "";
      if (userId.isNotEmpty) {
        ContentCategories? response =
            await GrowService().getRecentCategoryContent(userId);
        if (response != null) {
          recentCategoryContent.value = response;
        }
      }
    } finally {
      isRecentCategoryLoading.value = false;
    }
  }

  getInitialAssesmentStatusRequest() async {
    try {
      if (subscriptionCheckResponse != null &&
          subscriptionCheckResponse!.subscriptionDetails != null &&
          subscriptionCheckResponse!
              .subscriptionDetails!.programId!.isNotEmpty) {
        isStatusLoading.value = true;
        statusContent.value = await HealingService().getStatus(
            subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);
        /* if (statusContent.value?.data?.isCompleted == false) {
          showAssesementDialog(() {
            Get.back();
          }, () {
            Get.to(const InitialHealthCard(
              action: "Initial Assessment",
            ));
          });
        } */
      }
    } catch (exp) {
      print(exp);
    } finally {
      isStatusLoading.value = false;
    }
  }

  Future<void> getInitialAssessmentStatus() async {
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!.subscriptionDetails!.programId!.isNotEmpty) {
      statusContent.value = await HealingService().getStatus(
          subscriptionCheckResponse!.subscriptionDetails!.subscriptionId!);
    }
  }

  favouriteAffirmation() async {
    if (globalUserIdDetails?.userId == null) {
      userLoginDialog({
        "screenName": "AFFIRMATION",
        "contentId": homePageContent.value!.details!.affirmation!.contentId
      });
      return;
    }
    try {
      bool isFavourite =
          homePageContent.value!.details!.affirmation!.isFavourite!;
      bool isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!,
          homePageContent.value!.details!.affirmation!.contentId!,
          !isFavourite,
          "affirmations");
      if (isSuccess == true) {
        homePageContent.value!.details!.affirmation!.isFavourite = !isFavourite;
      }
    } finally {
      update(["Affirmation"]);
    }
  }
}
