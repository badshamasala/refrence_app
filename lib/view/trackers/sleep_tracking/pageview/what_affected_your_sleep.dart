import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WhatAffectedYourSleep extends StatelessWidget {
  const WhatAffectedYourSleep({Key? key}) : super(key: key);
  Widget buildOptions(SleepTrackerListModelSleepsIdentifications model,
      int index, SleepTrackerController controller) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        controller.selectWhatYouFeelModel(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: model.selected!
              ? const Color(0xFF76C8E2)
              : const Color(0xFF5550B6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          model.identification ?? "",
          style: TextStyle(
            color: model.selected!
                ? AppColors.sleepTrackerOptionsColor
                : Colors.white60,
            fontSize: 14.sp,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w400,
            fontFamily: "Circular Std",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Let’s Identify...'.toUpperCase(),
            style: AppTheme.pageViewSleepTrackerTitle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 14.h,
          ),
          const Text(
            'What affected your sleep?',
            style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 23.h,
          ),
          Image.asset(
            Images.sleeptrackerIdentify,
            fit: BoxFit.fitWidth,
            width: 238.w,
          ),
          SizedBox(
            height: 72.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.w),
            child: GetBuilder<SleepTrackerController>(
                id: 'identification',
                builder: (controller) {
                  if (controller.selectedHowWasSleep.value?.identifications ==
                      null) {
                    return const Offstage();
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      runAlignment: WrapAlignment.center,
                      children: List.generate(
                          controller.selectedHowWasSleep.value!.identifications!
                              .length, (index) {
                        if (controller.selectedHowWasSleep.value
                                ?.identifications?[index] ==
                            null) {
                          return const Offstage();
                        }
                        return buildOptions(
                            controller.selectedHowWasSleep.value!
                                .identifications![index]!,
                            index,
                            controller);
                      }),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
