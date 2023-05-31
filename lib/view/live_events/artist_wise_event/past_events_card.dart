// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/live_events/live.events.past.model.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/content/widgets/premium_content.dart';
import 'package:aayu/view/live_events/artist_wise_event/live_event_player.dart';
import 'package:aayu/view/live_events/widget/live_event_duration.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PastEventCard extends StatelessWidget {
  final PastLiveEventsModelTrainerDetails? trainerDetails;
  final PastLiveEventsModelPastEvents? liveEvent;
  const PastEventCard(
      {Key? key, required this.liveEvent, required this.trainerDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (322).w,
      child: InkWell(
        onTap: () async {
          bool isSubscribed = false;
          if (subscriptionCheckResponse != null &&
              subscriptionCheckResponse!.subscriptionDetails != null &&
              subscriptionCheckResponse!
                  .subscriptionDetails!.subscriptionId!.isNotEmpty) {
            isSubscribed = true;
          }
          if (liveEvent!.metaData!.isPremium == true && isSubscribed == false) {
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
                LiveEventsController liveEventsController = Get.find();
                await liveEventsController
                    .getLiveEventDetails(liveEvent!.liveEventId!);
                EventsService().sendClickNextEvent(
                    "Live Event", "Play", "SubscribeToAayu");
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
            buildShowDialog(context);
            await LiveEventService().joinPastEvent(
                globalUserIdDetails!.userId!, liveEvent!.liveEventId!);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveEventPlayer(liveEvent: liveEvent),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  ),
                  child: ShowNetworkImage(
                    imgWidth: 322.w,
                    imgHeight: 182.h,
                    imgPath: liveEvent!.eventImages!.landscape ?? "",
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
                  isPremiumContent: liveEvent!.metaData!.isPremium ?? false,
                  color: const Color(0xFFAAFDB4),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 12,
                left: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildSocialData(
                        "Views", liveEvent!.metaData!.joiners ?? ""),
                    SizedBox(
                      width: 12.w,
                    ),
                    buildSocialData(
                        "Likes", liveEvent!.metaData!.smileUsers ?? ""),
                    SizedBox(
                      width: 12.w,
                    ),
                    buildSocialData("Ratings",
                        (liveEvent!.metaData!.rating ?? 0).toStringAsFixed(1)),
                    const Spacer(),
                    LiveEventDuration(
                      eventType: liveEvent!.eventType!,
                      duration: liveEvent!.schedule!.duration ?? "",
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(
              height: 13.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  liveEvent!.eventTitle ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        trainerDetails!.name ?? "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm aa').format(
                            dateFromTimestamp(liveEvent!.schedule!.startTime!)),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            /* SizedBox(
              height: 8.h,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                    List.generate(liveEvent!.metaData!.tags!.length, (index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    margin: EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.h),
                    constraints: BoxConstraints(minWidth: 80.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.w),
                      color: AppColors.lightSecondaryColor,
                    ),
                    child: Text(
                      toTitleCase(
                          (liveEvent!.metaData!.tags![index]!.displayTag!)
                              .toLowerCase()),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  );
                }),
              ),
            ), */
          ],
        ),
      ),
    );
  }

  buildSocialData(String type, String value) {
    SvgPicture svgPicture = SvgPicture.asset(
      AppIcons.contentViewsSVG,
      width: 13.h,
      height: 10.12.h,
      color: AppColors.primaryColor,
    );
    if (type == "Views") {
      svgPicture = SvgPicture.asset(
        AppIcons.contentViewsSVG,
        width: 16.h,
        height: 16.h,
        color: AppColors.primaryColor,
      );
    } else if (type == "Likes") {
      svgPicture = SvgPicture.asset(
        AppIcons.favouriteFillSVG,
        width: 16.h,
        height: 16.h,
        color: AppColors.primaryColor,
      );
    } else if (type == "Comments") {
      svgPicture = svgPicture = SvgPicture.asset(
        AppIcons.completedSVG,
        width: 16.h,
        height: 16.h,
        color: AppColors.primaryColor,
      );
    } else if (type == "Ratings") {
      svgPicture = svgPicture = SvgPicture.asset(
        AppIcons.contentRatingSVG,
        width: 16.h,
        height: 16.h,
        color: AppColors.primaryColor,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        svgPicture,
        SizedBox(
          width: 3.w,
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
