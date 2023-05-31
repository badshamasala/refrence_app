import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/live_events/live_events_controller.dart';

class LiveEventArtistSection extends StatelessWidget {
  final String source;
  final LiveEventsController liveEventsController;

  final bool isPremium;
  final bool isSubscribed;
  const LiveEventArtistSection(
      {Key? key,
      required this.liveEventsController,
      required this.source,
      required this.isPremium,
      required this.isSubscribed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40.w),
          child: ShowNetworkImage(
            imgWidth: 40.w,
            imgHeight: 40.h,
            imgPath: liveEventsController
                    .liveEventDetails.value!.eventDetails!.trainer!.photo ??
                "",
            boxFit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                toTitleCase(liveEventsController
                        .liveEventDetails.value!.eventDetails!.trainer!.name ??
                    "".trim()),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  height: 1.1428571428571428.h,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
      ],
    );
  }
}
