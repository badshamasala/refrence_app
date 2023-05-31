import 'package:aayu/controller/daily_records/mood_tracker/mood_identify_controller.dart';
import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/trackers/mood_tracking/page_view/express_your_self.dart';
import 'package:aayu/view/trackers/mood_tracking/page_view/mood_identify.dart';
import 'package:aayu/view/trackers/mood_tracking/page_view/how_are_you.dart';
import 'package:aayu/view/trackers/mood_tracking/page_view/what_you_feel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoodTrackerPageView extends StatelessWidget {
  final String pageSource;
  const MoodTrackerPageView({Key? key, this.pageSource = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoodTrackerController moodTrackerController = Get.find();
    Future.delayed(Duration.zero, () {
      moodTrackerController.setInitialValues();
    });

    MoodIdentifyController moodIdentifyController =
        Get.put(MoodIdentifyController());
    Future.delayed(Duration.zero, () {
      moodIdentifyController.clearSelection();
    });

    AppBar customAppBar = AppBar(
      iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: GetBuilder<MoodTrackerController>(builder: (sliderController) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            sliderController.totalPages,
            (index) {
              return AnimatedContainer(
                margin: (index == sliderController.totalPages - 1)
                    ? EdgeInsets.zero
                    : EdgeInsets.only(right: 5.w),
                height: 4.h,
                width: 25.h,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: (index == sliderController.pageIndex)
                      ? AppColors.primaryColor
                      : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(2),
                ),
                duration: const Duration(milliseconds: 400),
              );
            },
          ),
        );
      }),
      leading: IconButton(
        onPressed: () {
          handleBackNavigation(moodTrackerController, context);
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
          color: AppColors.blackLabelColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            size: 25,
            color: AppColors.blackLabelColor,
          ),
        )
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        handleBackNavigation(moodTrackerController, context);
        return false;
      },
      child: Scaffold(
        appBar: customAppBar,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: moodTrackerController.pageController,
          onPageChanged: (index) {
            moodTrackerController.pageIndex = index;
            moodTrackerController.update();
          },
          children: [
            HowAreYou(
              pageController: moodTrackerController.pageController,
            ),
            WhatYouFeel(
              pageController: moodTrackerController.pageController,
            ),
            MoodIdentify(
              pageController: moodTrackerController.pageController,
              appBarHeight: customAppBar.preferredSize.height,
            ),
            ExpressYourself(
              pageSource: pageSource,
              pageController: moodTrackerController.pageController,
            )
          ],
        ),
      ),
    );
  }

  handleBackNavigation(
      MoodTrackerController moodTrackerController, BuildContext context) {
    if (moodTrackerController.pageIndex == 0) {
      Navigator.pop(context);
    } else {
      moodTrackerController.pageController.animateToPage(
        moodTrackerController.pageIndex - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
