import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/live_events/live_events_calender_card.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TodaysLiveEvents extends StatelessWidget {
  const TodaysLiveEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveEventsController controller = Get.find();
    Future.delayed(Duration.zero, () {
      controller.getTodaysEventsForMentalWellBeing();
    });
    return GetBuilder<LiveEventsController>(
        id: "MentalWellBeingEvents",
        builder: (liveEventsController) {
          if (liveEventsController.mentalWellBeingEvents == null) {
            return const Offstage();
          } else if (liveEventsController.mentalWellBeingEvents!.isEmpty) {
            return const Offstage();
          }
          return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 26.h,
                ),
                Padding(
                  padding: pageHorizontalPadding(),
                  child: Text(
                    'LIVE for today',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 24.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: liveEventsController.mentalWellBeingEvents!.length,
                  itemBuilder: (context, index) {
                    return LiveEventsCalenderCard(
                      key: Key(liveEventsController.mentalWellBeingEvents!
                          .elementAt(index)!
                          .liveEventId!),
                      liveEvent: liveEventsController.mentalWellBeingEvents!
                          .elementAt(index)!,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 26.h,
                    );
                  },
                ),
                SizedBox(
                  height: 26.h,
                ),
              ]);
        });
  }
}
