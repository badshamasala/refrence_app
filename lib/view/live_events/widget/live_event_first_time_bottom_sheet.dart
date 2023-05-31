import 'package:aayu/controller/live_events/live_events_schedule_controller.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../model/live_events/live.events.schedule.model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../shared/ui_helper/icons.dart';
import '../../shared/ui_helper/images.dart';

class LiveEventFirstTimeBottomSheet extends StatelessWidget {
  const LiveEventFirstTimeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveEventScheduleController liveEventScheduleController =
        Get.put(LiveEventScheduleController());

    List<Widget> dailyLiveEvents = [
      SizedBox(
        height: 10.h,
      ),
    ];

    return Obx(() {
      if (liveEventScheduleController.isLoading.value == true) {
        return showLoading();
      }
      if (liveEventScheduleController.liveEventSchedule.value == null) {
        return showLoading();
      }
      if (liveEventScheduleController.liveEventSchedule.value!.schedule ==
          null) {
        return showLoading();
      }
      for (int i = 0;
          i <
              liveEventScheduleController
                  .liveEventSchedule.value!.schedule!.schedule!.length;
          i++) {
        dailyLiveEvents.add(buildEventRow(liveEventScheduleController
            .liveEventSchedule.value!.schedule!.schedule![i]!));
      }
      return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 34.w),
              decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 61.h,
                  ),
                  Text(
                    liveEventScheduleController
                            .liveEventSchedule.value!.schedule!.title ??
                        '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Baskerville",
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackLabelColor,
                        fontSize: 24.sp),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    liveEventScheduleController
                            .liveEventSchedule.value!.schedule!.desc ??
                        '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blueGreyAssessmentColor,
                        fontSize: 14.sp),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 20.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Text(
                      (liveEventScheduleController.liveEventSchedule.value!
                                  .schedule!.subTitle ??
                              "")
                          .toUpperCase(),
                      style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontSize: 11.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    runSpacing: 8.w,
                    spacing: 8.h,
                    children: dailyLiveEvents,
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 136.w,
                      height: 54.h,
                      decoration: AppTheme.mainButtonDecoration,
                      child: Center(
                        child: Text(
                          'Okay',
                          textAlign: TextAlign.center,
                          style: mainButtonTextStyle(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -44.h,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 51.5.h,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    Images.eventsAayu,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            )
          ]);
    });
  }

  String returnIcon(String eventType) {
    String icons = AppIcons.liveTalkLiveEventSVG;
    switch (eventType.toUpperCase()) {
      case "LIVE TALKS":
        icons = AppIcons.liveTalkLiveEventSVG;
        break;
      case "GENERIC YOGA":
        icons = AppIcons.genericYogaLiveEventSVG;
        break;
      case "MEDITATION":
        icons = AppIcons.meditationLiveEventSVG;
        break;
      case "SPECIFIC YOGA":
        icons = AppIcons.speceficYogaLiveEventSVG;
        break;
      default:
    }
    return icons;
  }

  buildEventRow(LiveEventScheduleModelScheduleSchedule model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColors.lightGreyAssessmentColor,
          borderRadius: BorderRadius.circular(16.w)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            returnIcon(model.scheduleType ?? ""),
            width: 12.h,
            height: 12.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            toTitleCase((model.scheduleType ?? "").toLowerCase()),
            style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
