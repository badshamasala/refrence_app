import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/controller/live_events/past_events_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/live_events/artist_wise_event/past_events_card.dart';
import 'package:aayu/view/live_events/live_events_card.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArtistWiseEvents extends StatelessWidget {
  final String? trainerId;
  const ArtistWiseEvents({Key? key, required this.trainerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          GetBuilder<LiveEventsController>(
              id: "ArtistWiseLiveEvents",
              builder: (liveEventsController) {
                return (liveEventsController.artistWiseLiveEvents != null &&
                        liveEventsController.artistWiseLiveEvents!.isNotEmpty)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 26.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26.w),
                            child: Text(
                              'Live or Upcoming Events',
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
                            height: 26.h,
                          ),
                          SizedBox(
                            height: 290.h,
                            width: double.infinity,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: liveEventsController
                                  .artistWiseLiveEvents!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: 26.w,
                                    left: index == 0 ? 26 : 0,
                                  ),
                                  child: LiveEventsCard(
                                    key: Key(liveEventsController
                                        .artistWiseLiveEvents!
                                        .elementAt(index)!
                                        .liveEventId!),
                                    liveEvent: liveEventsController
                                        .artistWiseLiveEvents!
                                        .elementAt(index),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const Offstage();
              }),
          SizedBox(
            height: 26.h,
          ),
          Padding(
            padding: pageHorizontalPadding(),
            child: Text(
              "Past Events",
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
            height: 26.h,
          ),
          GetBuilder<PastEventsController>(
              tag: trainerId,
              init: PastEventsController(trainerId!),
              autoRemove: false,
              builder: (pastEventController) {
                if (pastEventController.isLoading.value == true) {
                  return const Offstage();
                } else if (pastEventController.artistWisePastLiveEvents ==
                    null) {
                  return noPastEventsAvailable();
                } else if (pastEventController
                        .artistWisePastLiveEvents!.pastEvents ==
                    null) {
                  return noPastEventsAvailable();
                } else if (pastEventController
                    .artistWisePastLiveEvents!.pastEvents!.isEmpty) {
                  return noPastEventsAvailable();
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: pastEventController
                      .artistWisePastLiveEvents!.pastEvents!.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: PastEventCard(
                        trainerDetails: pastEventController
                            .artistWisePastLiveEvents!.trainerDetails!,
                        liveEvent: pastEventController
                            .artistWisePastLiveEvents!.pastEvents![index]!,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 26.h,
                    );
                  },
                );
              }),
          SizedBox(
            height: 100.h,
          ),
        ]);
  }

  noPastEventsAvailable() {
    return Container(
      width: 200.w,
      height: 100.h,
      alignment: Alignment.center,
      child: Text(
        'Past event is not available.\nPlease check another coach events.',
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
    );
  }
}
