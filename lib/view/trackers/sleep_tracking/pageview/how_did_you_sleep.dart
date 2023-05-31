import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_controller.dart';
import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widget/pillow_image.dart';

class HowDidYouSleepLastNight extends StatelessWidget {
  const HowDidYouSleepLastNight({Key? key}) : super(key: key);

  Widget buildPillows(
    SleepTrackerListModelSleeps model,
    bool selected,
  ) {
    return Container(
      width: 46,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      child: RotatedBox(
        quarterTurns: 1,
        child: selected
            ? PillowImage(
                active: true,
                fit: BoxFit.fitHeight,
                height: 56,
                icon: model.icon ?? "",
              )
            : PillowImage(
                active: false,
                fit: BoxFit.fitHeight,
                height: 56,
                icon: model.icon ?? "",
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            return Text(
              'Hello ${homeController.userDetails.value?.userDetails!.firstName ?? ""}'
                  .toUpperCase(),
              style: AppTheme.pageViewSleepTrackerTitle,
              textAlign: TextAlign.center,
            );
          }),
          SizedBox(
            height: 14.h,
          ),
          const Text(
            'How did you sleep last night?',
            style: AppTheme.secondarySmallFontTitleTextStyleSleeptracker,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 31.h,
          ),
          GetBuilder<SleepTrackerController>(builder: (sleepTrackerController) {
            if (sleepTrackerController.isLoading.value == true) {
              return showLoading();
            } else if (sleepTrackerController.sleepTrackerList.value?.sleeps ==
                null) {
              return showLoading();
            } else if (sleepTrackerController
                .sleepTrackerList.value!.sleeps!.isEmpty) {
              return showLoading();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PillowImage(
                  icon:
                      sleepTrackerController.selectedHowWasSleep.value?.icon ??
                          "",
                  active: true,
                  fit: BoxFit.fitWidth,
                  width: 218.w,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  sleepTrackerController.selectedHowWasSleep.value?.sleep ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baskerville',
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 200.h,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: ListWheelScrollView(
                          onSelectedItemChanged: (value) {
                            sleepTrackerController.selectHowWasSleep(value);
                          },
                          itemExtent: 76,
                          diameterRatio: 1.0,
                          children: List.generate(
                            sleepTrackerController
                                .sleepTrackerList.value!.sleeps!.length,
                            (index) => buildPillows(
                              sleepTrackerController
                                  .sleepTrackerList.value!.sleeps![index]!,
                              sleepTrackerController
                                      .selectedHowWasSleep.value?.sleepId ==
                                  sleepTrackerController.sleepTrackerList.value!
                                      .sleeps![index]!.sleepId,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      child: Container(
                        width: 2.w,
                        height: 43.h,
                        color: const Color(0xFF75CAE2),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
