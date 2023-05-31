import 'package:aayu/controller/grow/grow_content_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrowController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Color appBarTextColor = AppColors.blackLabelColor;

  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;
  Rx<GrowCategoriesResponse?> growCategories = GrowCategoriesResponse().obs;
  Rx<GrowPageContentResponse?> growPageCategoryContent =
      GrowPageContentResponse().obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isContentLoading = false.obs;

  int selectedTabIndex = 0;

  @override
  void onInit() async {
    getGrowPageCategories();
    userDetails.value = await HiveService().getUserDetails();
    super.onInit();
  }

  getGrowPageCategories() async {
    try {
      isLoading.value = true;

      GrowCategoriesResponse? response = await GrowService()
          .getGrowPageCategories(globalUserIdDetails?.userId);
      if (response != null) {
        growCategories.value = response;
        if (growCategories.value != null &&
            growCategories.value!.categories!.isNotEmpty) {
          String cagtegoryId =
              growCategories.value!.categories![0]!.categoryId ?? "";
          Get.put(
            GrowContentController(cagtegoryId),
            tag: cagtegoryId,
          );
        }
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  getTabIndex(String selectedTab) {
    int index = 0;
    index = growCategories.value!.categories!.indexWhere((element) =>
        element!.categoryName!.toUpperCase().trim() ==
        selectedTab.toUpperCase().trim());

    if (index == -1) {
      return 0;
    }

    return index;
  }
}
