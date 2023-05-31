import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/services/share.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiveEventName extends StatelessWidget {
  final LiveEventsController liveEventsController;
  final String liveEventId;
  final String source;
  final String imagepath;
  final String description;

  final bool isPremium;
  final bool isSubscribed;

  const LiveEventName(
      {Key? key,
      required this.source,
      required this.isPremium,
      required this.isSubscribed,
      required this.liveEventsController,
      required this.liveEventId,
      required this.imagepath,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            toTitleCase(liveEventsController
                    .liveEventDetails.value!.eventDetails!.eventTitle ??
                ""),
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Container(
          height: 32.h,
          width: 32.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                offset: const Offset(-5, 10),
                blurRadius: 20.h,
              )
            ],
          ),
          child: InkWell(
            onTap: () async {
              String message =
                  "Live Event: ${liveEventsController.liveEventDetails.value!.eventDetails!.eventTitle ?? ""}\n\n$description";

              ShareService()
                  .shareLiveEvent(liveEventId, imagepath, message, context);
            },
            child: SvgPicture.asset(
              AppIcons.shareSVG,
              width: 12.6.w,
              height: 14.7.h,
              color: const Color(0xFF9C9EB9),
            ),
          ),
        )
      ],
    );
  }
}
