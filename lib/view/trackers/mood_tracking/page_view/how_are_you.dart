import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HowAreYou extends StatelessWidget {
  final PageController pageController;
  const HowAreYou({Key? key, required this.pageController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hello ${homeController.userDetails.value?.userDetails!.firstName ?? ""}'
                .toUpperCase(),
            style: moodTrackerPinkTitle(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'How are you?',
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.1666666666666667.h,
            ),
          ),
          SizedBox(
            height: 63.h,
          ),
          GetBuilder<MoodTrackerController>(
            builder: (moodListController) {
              if (moodListController.isLoading.value == true) {
                return showLoading();
              } else if (moodListController.moodList.value?.moods == null) {
                return const Offstage();
              } else if (moodListController.moodList.value!.moods!.isEmpty) {
                return const Offstage();
              }

              return SizedBox(
                width: 230.w,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 54.h,
                  spacing: 70.w,
                  children: List.generate(
                    moodListController.moodList.value!.moods!.length,
                    (index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          moodListController.updateSelectedMood(index);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(-4, 4),
                                    blurRadius: 8,
                                    color: Color.fromRGBO(0, 0, 0, 0.04),
                                  )
                                ],
                              ),
                              child: Image.asset(
                                moodListController
                                    .moodList.value!.moods![index]!.icon!,
                                width: 75.w,
                                color: moodListController.moodList.value!
                                            .moods![index]!.isSelected ==
                                        true
                                    ? const Color(0xFFFFE488)
                                    : null,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              moodListController
                                  .moodList.value!.moods![index]!.mood!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 103.h,
          ),
          GetBuilder<MoodTrackerController>(
            builder: (buttonController) {
              if (buttonController.selectedMood.value.isSelected == true) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: SizedBox(
                    width: 154.w,
                    child: mainButton("Next"),
                  ),
                );
              }
              return SizedBox(
                width: 154.w,
                child: disabledButton("Next"),
              );
            },
          ),
          SizedBox(
            height: 33.h,
          ),
        ],
      ),
    );
  }
}
