import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/view/live_events/live_events_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../shared/ui_helper/ui_helper.dart';

class LiveEventsInHours extends StatelessWidget {
  final String liveEventId;
  const LiveEventsInHours({Key? key, required this.liveEventId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveEventsController>(builder: (liveEventsController) {
      if (liveEventsController.isLoading.value == true) {
        return const Offstage();
      }
      if (liveEventsController.upcoming48HoursLiveEvents.value == null ||
          liveEventsController
                  .upcoming48HoursLiveEvents.value!.upcomingEvents ==
              null) {
        return const Offstage();
      }
      liveEventsController.removeEventFrom48Hours(liveEventId);

      if (liveEventsController
          .upcoming48HoursLiveEvents.value!.upcomingEvents!.isEmpty) {
        return const Offstage();
      }
      return SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: pagePadding(),
                child: Text(
                  'Live in 48 hours',
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
              SizedBox(
                height: 290.h,
                width: double.infinity,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: 14.6.w,
                  ),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: liveEventsController
                      .upcoming48HoursLiveEvents.value!.upcomingEvents!.length,
                  itemBuilder: (context, index) {
                    if (liveEventId ==
                        liveEventsController.upcoming48HoursLiveEvents.value!
                            .upcomingEvents![index]!.liveEventId) {
                      return const Offstage();
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 14.6.w,
                      ),
                      child: LiveEventsCard(
                        liveEvent: liveEventsController
                            .upcoming48HoursLiveEvents
                            .value!
                            .upcomingEvents![index],
                      ),
                    );
                  },
                ),
              )
            ]),
      );
    });
  }
}
