import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/view/live_events/live_events_card.dart';
import 'package:aayu/view/live_events/widget/live_event_first_time_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../shared/constants.dart';
import '../shared/ui_helper/ui_helper.dart';

class LiveEvents extends StatelessWidget {
  const LiveEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveEventsController liveEventsController = Get.find();
    Future.delayed(Duration.zero, () {
      liveEventsController.getUpcomingLiveEvents();
    });
    return Obx(() {
      if (liveEventsController.isLoading.value == true) {
        return const Offstage();
      } else if (liveEventsController.upcomingLiveEvents.value == null) {
        return const Offstage();
      } else if (liveEventsController
              .upcomingLiveEvents.value!.upcomingEvents ==
          null) {
        return const Offstage();
      } else if (liveEventsController
          .upcomingLiveEvents.value!.upcomingEvents!.isEmpty) {
        return const Offstage();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: () {
            if (globalUserIdDetails?.userId == null) {
              return;
            }
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              )),
              builder: (context) =>
                  const LiveEventFirstTimeBottomSheet(),
            );
          },
          child: Padding(
            padding: pagePadding(),
            child: Text(
              'Aayu Live',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 290.h,
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: liveEventsController
                .upcomingLiveEvents.value!.upcomingEvents!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: 14.6.w,
                  left: index == 0 ? 14.6 : 0,
                ),
                child: LiveEventsCard(
                  liveEvent: liveEventsController
                      .upcomingLiveEvents.value!.upcomingEvents![index],
                ),
              );
            },
          ),
        ),
      ]);
    });
  }
}
