import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/view/content/affirmation_section.dart';
import 'package:aayu/view/content/category_section.dart';
import 'package:aayu/view/ghost_screens/ghost_screen.dart';
import 'package:aayu/view/home/widgets/trackers/daily_records.dart';
import 'package:aayu/view/home/widgets/my_routine/my_routine.dart';
import 'package:aayu/view/home/widgets/recent_category_content.dart';
import 'package:aayu/view/home/widgets/top_section.dart';
import 'package:aayu/view/live_events/live_events_calender.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/you_tracker/user_tracker_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../trackers/step_tracking/step_tracking_intro.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Obx(() {
      if (homeController.isLoading.value == true) {
        return const GhostScreen(
          image: Images.homepageGhostScreenLottie,
        );
      } else if (homeController.homePageContent.value == null) {
        return const GhostScreen(
          image: Images.homepageGhostScreenLottie,
        );
      } else if (homeController.homePageContent.value!.details == null) {
        return const GhostScreen(
          image: Images.homepageGhostScreenLottie,
        );
      } else if (homeController.homePageContent.value!.details!.sequence ==
          null) {
        return const GhostScreen(
          image: Images.homepageGhostScreenLottie,
        );
      }
      return HomePageContent();
    });
  }
}

class HomePageContent extends StatelessWidget {
  HomePageContent({Key? key}) : super(key: key);
  var quickAccessKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homePageController) {
      if (homePageController.isLoading.value == true) {
        return showLoading();
      } else if (homePageController.homePageContent.value == null) {
        return showLoading();
      } else if (homePageController.homePageContent.value!.details!.sequence ==
          null) {
        return showLoading();
      } else if (homePageController
          .homePageContent.value!.details!.sequence!.isEmpty) {
        return showLoading();
      }
      scrolltoQuickAcces() {
        Scrollable.ensureVisible(quickAccessKey.currentContext!,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }

      SingularDeepLinkController singularDeepLinkController = Get.find();
      singularDeepLinkController.getGotoQuickAccess(scrolltoQuickAcces);

      return Scaffold(
       floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
              navState.currentState!.context,
              MaterialPageRoute(
                builder: (context) => const StepTrackingIntro(),
              ));
       }),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                homePageController
                    .homePageContent.value!.details!.sequence!.length, (index) {
              switch (homePageController
                  .homePageContent.value!.details!.sequence![index]!.type!) {
                case "Listings":
                  ContentCategories? categoryDetails = homePageController
                      .homePageContent.value!.details!.listings!
                      .firstWhereOrNull((element) =>
                          element!.categoryId ==
                          homePageController.homePageContent.value!.details!
                              .sequence![index]!.sequenceId!);

                  if (categoryDetails == null) {
                    return const Offstage();
                  }
                  return CategorySection(
                    categoryDetails: categoryDetails,
                    source: "",
                  );
                case "Affirmation":
                  return GetBuilder<HomeController>(
                      id: "Affirmation",
                      builder: (controller) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 36.h),
                          child: AffirmationSection(
                              content: homePageController
                                  .homePageContent.value!.details!.affirmation!,
                              favouriteAction: () {
                                homePageController.favouriteAffirmation();
                              }),
                        );
                      });
                case "DailyRoutine":
                  return MyRoutine(
                      key: quickAccessKey,
                      dailyRoutineData: homePageController
                          .homePageContent.value!.details!.dailyRoutine!);
                case "LiveEvents":
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [LiveEventsCalender(), DailyRecords()],
                  );
                case "TopBanners":
                  return const HomeTopSection();

                case "Recent":
                  return RecentCategoryContent(
                      homeController: homePageController);
                default:
                  return const Offstage();
              }
            }),
          ),
        ),
      );
    });
  }
}
