// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/content/widgets/premium_content.dart';
import 'package:aayu/view/live_events/live_events_details.dart';
import 'package:aayu/view/live_events/widget/live_event_cancelled_bottomsheet.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/live_events/live_events_controller.dart';
import '../../model/live_events/upcoming.live.events.model.dart';
import 'package:intl/intl.dart';

import 'widget/live_event_duration.dart';

class LiveEventsCalenderCard extends StatefulWidget {
  final UpcomingLiveEventsModelUpcomingEvents? liveEvent;
  const LiveEventsCalenderCard({Key? key, required this.liveEvent})
      : super(key: key);

  @override
  State<LiveEventsCalenderCard> createState() => _LiveEventsCalenderCardState();
}

class _LiveEventsCalenderCardState extends State<LiveEventsCalenderCard> {
  int secondsRemaining = 0;
  bool showLive = false;
  TimeFormat timeFormat = TimeFormat.showDate;
  Timer? timer;
  String formatDate = '';
  DateTime? startTime;

  bool timerInSecondsSet = false;

  calculateTimeRemaining(bool reduce, bool fromMinute) {
    if (secondsRemaining <= 300) {
      timeFormat = TimeFormat.showSeconds;
      secondsRemaining = reduce ? secondsRemaining - 1 : secondsRemaining;
      if (fromMinute) {
        if (timer != null) {
          timer!.cancel();
          timer = null;
        }
      }
    } else if (secondsRemaining <= 3600) {
      timeFormat = TimeFormat.showMinutes;
      secondsRemaining = reduce ? secondsRemaining - 60 : secondsRemaining;
    } else if (secondsRemaining < 86400 && secondsRemaining > 3600) {
      timeFormat = TimeFormat.showHours;
      secondsRemaining = reduce ? secondsRemaining - 60 : secondsRemaining;
    }
    if (secondsRemaining <= 0) {
      showLive = true;
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
    } else if (secondsRemaining <= 300) {
      if (timer == null) {
        if (timerInSecondsSet == false) {
          timer = Timer.periodic(const Duration(seconds: 1), (ti) {
            if (mounted) {
              setState(() {
                timerInSecondsSet = true;
                calculateTimeRemaining(true, false);
              });
            }
          });
        }
      }
    } else if (secondsRemaining <= 86400) {
      if (timer == null) {
        timerInSecondsSet = false;
        timer = Timer.periodic(const Duration(minutes: 1), (ti) {
          if (mounted) {
            setState(() {
              calculateTimeRemaining(true, true);
            });
          }
        });
      }
    }

    if (timeFormat == TimeFormat.showSeconds) {
      if (secondsRemaining <= 60) {
        formatDate = (secondsRemaining < 10)
            ? '0${secondsRemaining.toString()} seconds'
            : '$secondsRemaining seconds';
      } else {
        int mins = (secondsRemaining / 60).floor();
        int seconds = secondsRemaining.remainder(60);
        formatDate =
            "${(mins < 10) ? '0${mins.toString()} ${mins <= 1 ? 'min' : 'mins'}' : '$mins mins'} ${(seconds < 10) ? '0${seconds.toString()} sec' : '$seconds sec'}";
      }
    } else if (timeFormat == TimeFormat.showMinutes) {
      int mins = (secondsRemaining / 60).floor();
      formatDate = (mins < 10)
          ? '0${mins.toString()} ${mins <= 1 ? 'min' : 'mins'}'
          : '$mins mins';
    } else if (timeFormat == TimeFormat.showHours) {
      int hours = (secondsRemaining / 3600).floor();
      int mins = (secondsRemaining / 60).floor() % 60;
      formatDate =
          '${(hours < 10) ? '0${hours.toString()} ${hours <= 1 ? 'hr' : 'hrs'}' : '$hours hrs.'} ${(mins < 10) ? '0${mins.toString()} ${mins <= 1 ? 'min' : 'mins'}' : '$mins mins'}';
    }
  }

  @override
  void initState() {
    super.initState();
    secondsRemaining = widget.liveEvent!.schedule!.secondsRemaining!;
    startTime = DateTime.fromMillisecondsSinceEpoch(
      widget.liveEvent!.schedule!.epochTime!.startTime ?? 0,
    );
    if (widget.liveEvent!.status != 'CANCELED') {
      calculateTimeRemaining(false, true);
    }
  }

  @override
  void dispose() {
    // if (timer != null && timer!.isActive) {
    //   timer!.cancel();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 26.w),
      width: 300.w,
      child: InkWell(
        onTap: () {
          if (widget.liveEvent!.status == 'CANCELED') {
            Get.bottomSheet(const LiveEventCancelledBottomSheet());
          } else {
            EventsService()
                .sendClickNextEvent("Live Event", "Card", "LiveEventDetails");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveEventsDetails(
                  source: "",
                  heroTag: "LiveEvent_${widget.liveEvent!.liveEventId}",
                  liveEventId: widget.liveEvent!.liveEventId ?? "",
                ),
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.59),
                child: ColorFiltered(
                  colorFilter: widget.liveEvent!.status == 'CANCELED'
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: ShowNetworkImage(
                    imgWidth: 134.w,
                    imgHeight: 184.h,
                    imgPath: widget.liveEvent!.eventImages!.preview ?? "",
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.59),
                      bottomRight: Radius.circular(15.59),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.5),
                        Color.fromRGBO(0, 0, 0, 0)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 13,
                left: 11,
                child: PremiumContent(
                  isPremiumContent:
                      widget.liveEvent!.metaData!.isPremium ?? false,
                  color: const Color(0xFFAAFDB4),
                ),
              ),
              widget.liveEvent!.status == 'CANCELED'
                  ? Positioned(
                      bottom: 12.h,
                      child: buildCanceledEvent(),
                    )
                  : showLive
                      ? Positioned(
                          bottom: 12.h,
                          left: 13.w,
                          child: buildLiveEvent(),
                        )
                      : timeFormat == TimeFormat.showDate
                          ? Positioned(
                              bottom: 9.h,
                              left: 10.w,
                              child: buildDateTimer(),
                            )
                          : Positioned(bottom: 12.h, child: buildEventTimer()),
              if (showLive && widget.liveEvent!.status != 'CANCELED')
                Positioned(
                  bottom: 10.41,
                  right: 8.96,
                  child: InkWell(
                    onTap: () async {
                      joinLiveEvent();
                    },
                    child: SvgPicture.asset(
                      AppIcons.playSVG,
                      width: 24.h,
                      fit: BoxFit.fitWidth,
                      color: const Color(0xFFAAFDB4),
                    ),
                  ),
                ),
            ]),
            SizedBox(
              width: 13.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.liveEvent!.eventTitle ?? "",
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    widget.liveEvent!.trainer!.name ?? "",
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Visibility(
                    visible: widget.liveEvent!.status == "CANCELED",
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm aa').format(
                          dateFromTimestamp(widget
                              .liveEvent!.schedule!.epochTime!.startTime!)),
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.liveEvent!.status == "CANCELED",
                    child: SizedBox(
                      height: 12.h,
                    ),
                  ),
                  Text(
                    toTitleCase((widget.liveEvent!.eventType ?? "").toLowerCase()),
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  LiveEventDuration(
                    eventType: widget.liveEvent!.eventType!,
                    duration: widget.liveEvent!.schedule!.duration ?? "",
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  buildActionButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildLiveEvent() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFAAFDB4),
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      child: Text(
        'LIVE',
        style: TextStyle(
          color: const Color(0xFF298634),
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  buildCanceledEvent() {
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 3.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cancelled ',
            style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.blueGreyAssessmentColor,
            size: 17.h,
          )
        ],
      ),
    );
  }

  buildEventTimer() {
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 2,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      child: Text(
        'in $formatDate',
        style: TextStyle(
          color: AppColors.blueGreyAssessmentColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  joinLiveEvent() async {
    bool isSubscribed = false;
    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!
            .subscriptionDetails!.subscriptionId!.isNotEmpty) {
      isSubscribed = true;
    }
    if (widget.liveEvent!.metaData!.isPremium == true &&
        isSubscribed == false) {
      buildShowDialog(context);
      SubscriptionController subscriptionController = Get.find();
      await subscriptionController.getPreviousSubscriptionDetails();
      Navigator.pop(context);
      if (subscriptionController.previousSubscriptionDetails.value != null &&
          subscriptionController
                  .previousSubscriptionDetails.value!.subscriptionDetails !=
              null) {
        EventsService()
            .sendClickNextEvent("Live Event", "Play", "PreviousSubscription");
        Get.bottomSheet(
          const PreviousSubscription(),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
        );
      } else {
        bool isAllowed = await checkIsPaymentAllowed("LIVE_EVENT");
        if (isAllowed == true) {
          LiveEventsController liveEventsController = Get.find();
          liveEventsController.setSelectedLiveEvent(widget.liveEvent!);
          EventsService()
              .sendClickNextEvent("Live Event", "Play", "SubscribeToAayu");
          Get.bottomSheet(
            const SubscribeToAayu(subscribeVia: "LIVE_EVENT", content: null),
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
          );
        }
      }
    } else {
      EventsService().sendEvent("Join_Event_Clicked", {
        "live_event_id": widget.liveEvent!.liveEventId!,
        "live_event_name": widget.liveEvent!.eventTitle!,
      });
      buildShowDialog(context);
      LiveEventsController liveEventsController = Get.find();
      await liveEventsController
          .getLiveEventDetails(widget.liveEvent!.liveEventId ?? "");
      Navigator.pop(context);
      if (liveEventsController.liveEventDetails.value != null &&
          liveEventsController.liveEventDetails.value!.eventDetails != null) {
        liveEventsController.joinLiveEvent(
            liveEventsController
                .liveEventDetails.value!.eventDetails!.liveEventId!,
            context,
            liveEventsController
                    .liveEventDetails.value!.eventDetails!.trainer!.name ??
                "",
            liveEventsController
                    .liveEventDetails.value!.eventDetails!.trainer!.gender ??
                "");
      }
    }
  }

  buildActionButton() {
    if (widget.liveEvent!.status == 'CANCELED') {
      return const Offstage();
    } else if (showLive && widget.liveEvent!.status != 'CANCELED') {
      return ElevatedButton(
        onPressed: () {
          joinLiveEvent();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF88EF95),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 26.w),
        ),
        child: Text(
          'Join event',
          style: TextStyle(
            color: const Color(0xFF5C7F6B),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Circular Std",
          ),
        ),
      );
    } else if (widget.liveEvent?.isAttending == false) {
      return ElevatedButton(
        onPressed: () async {
          if (globalUserIdDetails?.userId == null) {
            userLoginDialog({
              "screenName": "LIVE_EVENT",
              "liveEventId": widget.liveEvent?.liveEventId
            });
            return;
          }
          bool isSubscribed = false;
          if (subscriptionCheckResponse?.subscriptionDetails != null &&
              subscriptionCheckResponse!
                  .subscriptionDetails!.subscriptionId!.isNotEmpty) {
            isSubscribed = true;
          }

          LiveEventsController liveEventsController = Get.find();
          await liveEventsController
              .getLiveEventDetails(widget.liveEvent?.liveEventId ?? "");

          if (widget.liveEvent?.metaData?.isPremium == true &&
              isSubscribed == false) {
            buildShowDialog(context);
            SubscriptionController subscriptionController = Get.find();
            await subscriptionController.getPreviousSubscriptionDetails();
            Navigator.pop(context);
            if (subscriptionController.previousSubscriptionDetails.value !=
                    null &&
                subscriptionController.previousSubscriptionDetails.value!
                        .subscriptionDetails !=
                    null) {
              EventsService().sendClickNextEvent(
                  "Live Event", "Attend Event", "PreviousSubscription");
              Get.bottomSheet(
                const PreviousSubscription(),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              );
            } else {
              bool isAllowed = await checkIsPaymentAllowed("LIVE_EVENT");
              if (isAllowed == true) {
                liveEventsController.setSelectedLiveEvent(
                    UpcomingLiveEventsModelUpcomingEvents.fromJson(
                        liveEventsController
                            .liveEventDetails.value!.eventDetails!
                            .toJson()));
                EventsService().sendClickNextEvent(
                    "Live Event Details", "Attend Event", "SubscribeToAayu");
                Get.bottomSheet(
                  const SubscribeToAayu(
                      subscribeVia: "LIVE_EVENT", content: null),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                );
              }
            }
          } else {
            EventsService().sendEvent("Attend_Event_Clicked", {
              "live_event_id": widget.liveEvent!.liveEventId!,
              "live_event_name": widget.liveEvent!.eventTitle!,
            });
            buildShowDialog(context);
            bool isAttending = await liveEventsController.attendEvent(
                widget.liveEvent!.liveEventId!, true);
            Navigator.pop(context);
            if (isAttending) {
              EventsService().sendEvent("Attend_Event_Success", {
                "live_event_id": widget.liveEvent!.liveEventId!,
                "live_event_name": widget.liveEvent!.eventTitle!,
              });
              liveEventsController
                  .markAsAttending(widget.liveEvent!.liveEventId!);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF88EF95),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 26.w),
        ),
        child: Text(
          'Attend this event',
          style: TextStyle(
            color: const Color(0xFF5C7F6B),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Circular Std",
          ),
        ),
      );
    } else if (widget.liveEvent?.isAttending == true) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF88EF95),
          disabledBackgroundColor: const Color(0xFF88EF95),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 26.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline_outlined,
              color: AppColors.blueGreyAssessmentColor,
              size: 20,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              'I am attending',
              style: TextStyle(
                color: const Color(0xFF5C7F6B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: "Circular Std",
              ),
            ),
          ],
        ),
      );
    } else {
      return const Offstage();
    }
  }

  buildDateTimer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 2,
                    offset: Offset(0, 2))
              ]),
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${startTime!.day}',
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                DateFormat('MMM').format(startTime!),
                style: TextStyle(
                  color: AppColors.blueGreyAssessmentColor,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 7.w,
        ),
        Text(
          DateFormat('hh:mm aa').format(startTime!).toLowerCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}