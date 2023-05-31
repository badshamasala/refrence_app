import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class FavouritesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<bool> isLoading = false.obs;
  Rx<FavouritesContentResponse?> favouritesContent =
      FavouritesContentResponse().obs;
  List<String> tabs = ["Grow", "Affirmations"];

  late TabController tabController;

  @override
  void onInit() async {
    tabController = TabController(length: tabs.length, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  getFavouritesContent() async {
    try {
      isLoading.value = true;
      FavouritesContentResponse? response =
          await GrowService().getFavouritesContent(globalUserIdDetails!.userId!);
      if (response != null) {
        favouritesContent.value = response;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  favouriteContent(
      String contentType, String contentId, int index, bool isFavourite) async {
    try {
      bool isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!, contentId, isFavourite, contentType);
      if (isSuccess == true) {
        if (contentType == "grow") {
          favouritesContent.value!.content!.grow![index]!.isFavourite =
              isFavourite;
        } else if (contentType == "affirmations") {
          favouritesContent.value!.content!.affirmations![index]!.isFavourite =
              isFavourite;
        } else if (contentType == "tips") {
          favouritesContent.value!.content!.tips![index]!.isFavourite =
              isFavourite;
        }
      }
    } finally {
      update();
    }
  }
}
