import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/view/content/category_section.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentCategoryContent extends StatelessWidget {
  final HomeController homeController;
  const RecentCategoryContent({Key? key, required this.homeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      homeController.getRecentCategoryContent();
    });
    return Obx(() {
      if (homeController.isRecentCategoryLoading.value == true) {
        return showLoading();
      } else if (homeController.recentCategoryContent.value == null) {
        return const Offstage();
      } else if (homeController.recentCategoryContent.value!.categoryId ==
          null) {
        return const Offstage();
      } else if (homeController
          .recentCategoryContent.value!.categoryId!.isEmpty) {
        return const Offstage();
      }

      return CategorySection(
          source: "",
          categoryDetails: homeController.recentCategoryContent.value!);
    });
  }
}
