import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/view/live_events/live_events_calender_card.dart';
import 'package:aayu/view/live_events/widget/live_event_first_time_bottom_sheet.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../../theme/app_colors.dart';

class LiveEventsCalender extends StatelessWidget {
  const LiveEventsCalender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveEventsController controller = Get.find();
    Future.delayed(Duration.zero, () {
      controller.getUpcomingLiveEvents();
    });
    return GetBuilder<LiveEventsController>(builder: (liveEventsController) {
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
      return ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 26.h,
            ),
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
                  builder: (context) => const LiveEventFirstTimeBottomSheet(),
                );
              },
              child: Padding(
                padding: pageHorizontalPadding(),
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
            SingleChildScrollView(
              padding: pageVerticalPadding(),
              physics: const BouncingScrollPhysics(),
              child: DatePicker(
                DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                controller: liveEventsController.datePickerController,
                initialSelectedDate: liveEventsController.selectedDate,
                selectionColor: AppColors.primaryColor,
                selectedTextColor: Colors.white,
                daysCount: 7,
                dateTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w700,
                ),
                monthTextStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w400,
                ),
                dayTextStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w400,
                ),
                onDateChange: (selectedDate) {
                  liveEventsController.getDateWiseLiveEvents(
                      selectedDate, true);
                  liveEventsController.datePickerController
                      .animateToDate(selectedDate);
                },
              ),
            ),
            (liveEventsController.dayWiseLiveEvents != null &&
                    liveEventsController.dayWiseLiveEvents!.isNotEmpty)
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: liveEventsController.dayWiseLiveEvents!.length,
                    itemBuilder: (context, index) {
                      return LiveEventsCalenderCard(
                        key: Key(liveEventsController.dayWiseLiveEvents!
                            .elementAt(index)!
                            .liveEventId!),
                        liveEvent: liveEventsController.dayWiseLiveEvents!
                            .elementAt(index)!,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 26.h,
                      );
                    },
                  )
                : Container(
                    width: 200.w,
                    height: 100.h,
                    alignment: Alignment.center,
                    child: Text(
                      'Live event is not available.\nPlease check another day for events schedule.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor.withOpacity(0.6),
                        fontFamily: 'Circular Std',
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ),
            SizedBox(
              height: 26.h,
            ),
          ]);
    });
  }
}
