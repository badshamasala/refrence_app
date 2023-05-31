import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class WhatYouFeel extends StatelessWidget {
  final PageController pageController;
  const WhatYouFeel({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Let\'s Figure'.toUpperCase(),
            style: moodTrackerPinkTitle(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'What you feel?',
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
            height: 34.h,
          ),
          Image.asset(
            Images.moodWateringImage,
            width: 254.w,
            height: 232.h,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 40.h,
          ),
          GetBuilder<MoodTrackerController>(
            builder: (feelFactorController) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 500.w,
                padding: EdgeInsets.only(left: 28.w),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.start,
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(
                    feelFactorController.selectedMood.value.feelings!.length,
                    (index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          feelFactorController.updateFeelFactors(index);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 19.w, vertical: 11.h),
                          decoration: BoxDecoration(
                            color: feelFactorController.selectedMood.value
                                        .feelings![index]!.isSelected ==
                                    true
                                ? const Color(0xFFFFE488)
                                : const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            feelFactorController.selectedMood.value
                                    .feelings?[index]?.feeling ??
                                "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Circular Std",
                              height: 1.h,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 76.h,
          ),
          GetBuilder<MoodTrackerController>(
            builder: (buttonController) {
              if (buttonController.checkFeelFactorSelected() == true) {
                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    pageController.animateToPage(2,
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
        ],
      ),
    );
  }
}
