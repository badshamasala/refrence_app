import 'dart:async';

import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/content/widgets/premium_content.dart';
import 'package:aayu/view/live_events/live_events_in_hours.dart';
import 'package:aayu/view/live_events/widget/live_event_artist_section.dart';
import 'package:aayu/view/live_events/widget/live_event_cancelled_bottomsheet.dart';
import 'package:aayu/view/live_events/widget/live_event_first_time_bottom_sheet.dart';
import 'package:aayu/view/live_events/widget/live_event_name.dart';
import 'package:aayu/view/live_events/widget/live_events_tags.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/subscription/subscription_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../content/content_details/content_desc.dart';
import '../onboarding/get_started.dart';
import '../shared/constants.dart';
import '../shared/network_image.dart';
import '../shared/ui_helper/ui_helper.dart';
import '../subscription/previous_subscription.dart';
import 'widget/live_event_attendee.dart';
import 'widget/live_event_duration.dart';

class LiveEventsDetails extends StatefulWidget {
  final String source;
  final String heroTag;
  final String liveEventId;
  const LiveEventsDetails({
    Key? key,
    required this.heroTag,
    required this.liveEventId,
    required this.source,
  }) : super(key: key);

  @override
  State<LiveEventsDetails> createState() => _LiveEventsDetailsState();
}

class _LiveEventsDetailsState extends State<LiveEventsDetails> {
  late LiveEventsController liveEventsController;
  ScrollController scrollController = ScrollController();
  double top = 0.0;

  bool isSubscribed = false;
  int secondsRemaining = 0;
  Timer? timer;

  bool showChangeLiveEventCountDialog = false;

  @override
  void initState() {
    liveEventsController = Get.find();
    Future.delayed(Duration.zero, () async {
      showChangeLiveEventCountDialog =
          await liveEventsController.checkIfChangeLiveCountAllowed();
      await liveEventsController.getLiveEventDetails(widget.liveEventId);
      liveEventsController.getUpcoming48HoursLiveEvents(widget.liveEventId);
      setTimer();
    });

    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!
            .subscriptionDetails!.subscriptionId!.isNotEmpty) {
      isSubscribed = true;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      showFirstTimeBottomSheet();
    });

    super.initState();
  }

  setTimer() {
    if (liveEventsController.liveEventDetails.value != null &&
        liveEventsController.liveEventDetails.value!.eventDetails != null) {
      secondsRemaining = liveEventsController
          .liveEventDetails.value!.eventDetails!.schedule!.secondsRemaining!;
      if (secondsRemaining <= 300) {
        timer = Timer.periodic(const Duration(seconds: 1), (ti) {
          setState(() {
            secondsRemaining = secondsRemaining - 1;
            if (secondsRemaining <= 0 && timer!.isActive) {
              timer!.cancel();
            }
          });
        });
      }
    }
  }

  @override
  dispose() {
    scrollController.dispose();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    super.dispose();
  }

  initScrollController() {
    scrollController = ScrollController()
      ..addListener(() {
        liveEventsController.appBarTextColor = isSliverAppBarExpanded
            ? AppColors.blackLabelColor
            : Colors.transparent;
        liveEventsController.update();
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (200 - kToolbarHeight).h;
  }

  showFirstTimeBottomSheet() {
    if (globalUserIdDetails?.userId == null) {
      return;
    }
    HiveService().isFirstTimeLiveEvent().then((value) {
      if (value == true) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          )),
          builder: (context) => const LiveEventFirstTimeBottomSheet(),
        ).then((value) {
          HiveService().initFirstTimeLiveEvent();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (liveEventsController.isDetailLoading.value == true) {
          return showLoading();
        } else if (liveEventsController.liveEventDetails.value == null) {
          return showLoading();
        } else if (liveEventsController.liveEventDetails.value!.eventDetails ==
            null) {
          return showLoading();
        } else if (liveEventsController
                .liveEventDetails.value!.eventDetails!.liveEventId ==
            null) {
          return showLoading();
        } else if (liveEventsController
            .liveEventDetails.value!.eventDetails!.liveEventId!.isEmpty) {
          return showLoading();
        }

        return NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Offstage(),
                  leading: const Offstage(),
                  pinned: true,
                  stretch: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 278.h,
                  elevation: 0,
                  centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  iconTheme: IconThemeData(
                      color: isSliverAppBarExpanded
                          ? liveEventsController.appBarTextColor
                          : Colors.transparent),
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      centerTitle: true,
                      title: top.floor() ==
                              (MediaQuery.of(context).padding.top +
                                      kToolbarHeight +
                                      15.0)
                                  .floor()
                          ? AppBar(
                              elevation: 0,
                              centerTitle: true,
                              iconTheme: const IconThemeData(
                                  color: AppColors.blackLabelColor),
                              backgroundColor: const Color(0xFFF8FAFC),
                              title: Text(
                                liveEventsController.liveEventDetails.value!
                                        .eventDetails!.eventTitle ??
                                    "",
                                style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            )
                          : const SizedBox(),
                      background: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Hero(
                            tag: widget.heroTag,
                            child: ShowNetworkImage(
                              imgPath: liveEventsController
                                      .liveEventDetails
                                      .value!
                                      .eventDetails!
                                      .eventImages!
                                      .landscape ??
                                  "",
                              imgHeight: (278 + kToolbarHeight).h,
                              imgWidth: double.infinity,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0.7),
                                    Color.fromRGBO(0, 0, 0, 0)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30.h,
                            left: 26.w,
                            child: InkWell(
                              onTap: () {
                                if (widget.source == "DEEPLINK") {
                                  Get.close(2);
                                  Get.to(const GetStarted());
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: CircleAvatar(
                                  radius: 16.h,
                                  backgroundColor:
                                      const Color.fromRGBO(255, 255, 255, 0.6),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.blackLabelColor,
                                  )),
                            ),
                          ),
                          Positioned(
                              left: 26.w,
                              bottom: 25.h,
                              right: 26.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                              blurRadius: 2,
                                              offset: Offset(0, 2))
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7.w, vertical: 7.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${liveEventsController.eventStartTime!.day}',
                                          style: TextStyle(
                                            color: AppColors.blackLabelColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM').format(
                                              liveEventsController
                                                  .eventStartTime!),
                                          style: TextStyle(
                                            color: AppColors
                                                .blueGreyAssessmentColor,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13.6.w,
                                  ),
                                  Text(
                                    DateFormat('hh:mm aa')
                                        .format(liveEventsController
                                            .eventStartTime!)
                                        .toLowerCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  PremiumContent(
                                    isPremiumContent: liveEventsController
                                            .liveEventDetails
                                            .value!
                                            .eventDetails!
                                            .metaData!
                                            .isPremium ??
                                        false,
                                    color: const Color(0xFFAAFDF4),
                                  )
                                ],
                              )),
                        ],
                      ),
                    );
                  }),
                  backgroundColor: const Color(0xFFF8FAFC),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(15),
                    child: Container(
                      height: 15,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border.all(
                            color: const Color(0xFFF8FAFC), width: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              buildContentSection(),
              LiveEventsInHours(
                liveEventId: widget.liveEventId,
              ),
              SizedBox(
                height: 34.h,
              ),
            ],
          ),
        );
      }),
    );
  }

  buildContentSection() {
    return Container(
      padding: EdgeInsets.only(
        left: 26.w,
        right: 26.w,
        top: 90.h,
        bottom: 23.h,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 26.h),
            width: double.infinity,
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(color: const Color(0xFFF8FAFC), width: 0)),
            child: LiveEventName(
              source: widget.source,
              description: liveEventsController
                      .liveEventDetails.value!.eventDetails!.description ??
                  "",
              imagepath: liveEventsController.liveEventDetails.value!
                      .eventDetails!.eventImages!.preview ??
                  "",
              isPremium: liveEventsController.liveEventDetails.value!
                      .eventDetails!.metaData!.isPremium ??
                  false,
              liveEventId: liveEventsController
                      .liveEventDetails.value!.eventDetails!.liveEventId ??
                  "",
              liveEventsController: liveEventsController,
              isSubscribed: isSubscribed,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LiveEventDuration(
                eventType: liveEventsController
                    .liveEventDetails.value!.eventDetails!.eventType!,
                duration: liveEventsController.liveEventDetails.value!
                        .eventDetails!.schedule!.duration ??
                    "",
              ),
              SizedBox(
                width: 10.h,
              ),
              LiveEventAttendee(
                  totalAttendees: liveEventsController.liveEventDetails.value!
                          .eventDetails!.attendee!.totalAttendees ??
                      0),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          ContentDesc(
            description: liveEventsController
                    .liveEventDetails.value!.eventDetails!.description ??
                "",
          ),
          SizedBox(
            height: 16.h,
          ),
          LiveEventTags(
              tags: liveEventsController
                      .liveEventDetails.value!.eventDetails!.metaData!.tags ??
                  []),
          SizedBox(
            height: 20.h,
          ),
          buildAction(),
          SizedBox(
            height: 15.h,
          ),
          if (showChangeLiveEventCountDialog)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: liveEventsController.liveEventsCountController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintStyle: AppTheme.hintTextStyle,
                      errorStyle: AppTheme.errorTextStyle,
                      hintText: "Live Events Count",
                      labelText: "Live Events Count",
                      labelStyle: AppTheme.hintTextStyle,
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.whiteColor,
                      focusColor: AppColors.whiteColor,
                      hoverColor: AppColors.whiteColor,
                      errorBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.errorColor, width: 3),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (liveEventsController.changeLiveCountLoading.value ==
                      true) {
                    return const CircularProgressIndicator();
                  }
                  return TextButton(
                      onPressed: () {
                        if (liveEventsController.liveEventsCountController.text
                            .trim()
                            .isNotEmpty) {
                          liveEventsController
                              .sendLiveEventCount(widget.liveEventId)
                              .then((value) {
                            liveEventsController.liveEventsCountController
                                .clear();
                          });
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 18.sp),
                      ));
                })
              ],
            ),
          if (showChangeLiveEventCountDialog)
            SizedBox(
              height: 15.h,
            ),
          SizedBox(
            width: 322.w,
            child: const Divider(
              height: 0,
              thickness: 1,
              color: Color(0xFFE4ECEA),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          LiveEventArtistSection(
            source: widget.source,
            liveEventsController: liveEventsController,
            isPremium: liveEventsController.liveEventDetails.value!
                    .eventDetails!.metaData!.isPremium ??
                false,
            isSubscribed: isSubscribed,
          ),
        ],
      ),
    );
  }

  buildAction() {
    bool isAttending = liveEventsController
        .liveEventDetails.value!.eventDetails!.attendee!.isAttending!;
    if (liveEventsController.liveEventDetails.value!.eventDetails!.status ==
        'CANCELED') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey[400],
          minimumSize: Size(double.infinity, 44.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: EdgeInsets.symmetric(
            vertical: 9.h,
          ),
        ),
        onPressed: () async {
          Get.bottomSheet(const LiveEventCancelledBottomSheet());
        },
        child: Text(
          'Event Cancelled',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Circular Std",
          ),
        ),
      );
    }

    if (secondsRemaining <= 0) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF88EF95),
          minimumSize: Size(double.infinity, 44.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: EdgeInsets.symmetric(
            vertical: 9.h,
          ),
        ),
        onPressed: () async {
          if (globalUserIdDetails?.userId == null) {
            userLoginDialog({
              "screenName": "LIVE_EVENT",
              "liveEventId": widget.liveEventId
            });
            return;
          }
          bool isSubscribed = false;
          if (subscriptionCheckResponse != null &&
              subscriptionCheckResponse!.subscriptionDetails != null &&
              subscriptionCheckResponse!
                  .subscriptionDetails!.subscriptionId!.isNotEmpty) {
            isSubscribed = true;
          }
          if (liveEventsController.liveEventDetails.value!.eventDetails!
                      .metaData!.isPremium ==
                  true &&
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
                  "Live Event", "Play", "PreviousSubscription");
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
                    "Live Event Details", "Join Event", "SubscribeToAayu");
                Get.bottomSheet(
                  const SubscribeToAayu(
                    subscribeVia: "LIVE_EVENT",
                    content: null,
                  ),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                );
              }
            }
          } else {
            EventsService().sendEvent("Join_Event_Clicked", {
              "live_event_id": liveEventsController
                  .liveEventDetails.value!.eventDetails!.liveEventId!,
              "live_event_name": liveEventsController
                  .liveEventDetails.value!.eventDetails!.eventTitle!,
            });
            liveEventsController.joinLiveEvent(
                liveEventsController
                    .liveEventDetails.value!.eventDetails!.liveEventId!,
                context,
                liveEventsController
                        .liveEventDetails.value!.eventDetails!.trainer!.name ??
                    "",
                liveEventsController.liveEventDetails.value!.eventDetails!
                        .trainer!.gender ??
                    "");
          }
        },
        child: Text(
          'Join Event',
          style: TextStyle(
            color: const Color(0xFF5C7F6B),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Circular Std",
          ),
        ),
      );
    } else {
      if (isAttending == true) {
        return Container(
          height: 44.h,
          decoration: BoxDecoration(
              color: const Color(0xFF88EF95),
              borderRadius: BorderRadius.circular(100)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Circular Std",
                ),
              ),
            ],
          ),
        );
      } else {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF88EF95),
            minimumSize: Size(double.infinity, 44.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            padding: EdgeInsets.symmetric(
              vertical: 9.h,
            ),
          ),
          onPressed: () async {
            if (globalUserIdDetails?.userId == null) {
              userLoginDialog({
                "screenName": "LIVE_EVENT",
                "liveEventId": widget.liveEventId
              });
              return;
            }
            if (subscriptionCheckResponse?.subscriptionDetails != null &&
                subscriptionCheckResponse!
                    .subscriptionDetails!.subscriptionId!.isNotEmpty) {
              isSubscribed = true;
            }
            if (liveEventsController.liveEventDetails.value!.eventDetails!
                        .metaData!.isPremium ==
                    true &&
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
                "live_event_id": liveEventsController
                    .liveEventDetails.value!.eventDetails!.liveEventId!,
                "live_event_name": liveEventsController
                    .liveEventDetails.value!.eventDetails!.eventTitle!,
              });
              buildShowDialog(context);
              bool isAttending = await liveEventsController.attendEvent(
                  liveEventsController
                      .liveEventDetails.value!.eventDetails!.liveEventId!,
                  true);
              Navigator.pop(context);

              if (isAttending) {
                EventsService().sendEvent("Attend_Event_Success", {
                  "live_event_id": liveEventsController
                      .liveEventDetails.value!.eventDetails!.liveEventId!,
                  "live_event_name": liveEventsController
                      .liveEventDetails.value!.eventDetails!.eventTitle!,
                });
                setState(() {});
              }
            }
          },
          child: Text(
            'Attend this event',
            style: TextStyle(
              color: const Color(0xFF5C7F6B),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Circular Std",
            ),
          ),
        );
      }
    }
  }
}
