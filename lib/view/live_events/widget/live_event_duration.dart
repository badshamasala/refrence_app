import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LiveEventDuration extends StatelessWidget {
  final String eventType;
  final String duration;
  const LiveEventDuration(
      {Key? key, required this.eventType, required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            returnIcon(),
            width: 12.h,
            height: 12.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            duration,
            style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String returnIcon() {
    String icons = AppIcons.liveTalkLiveEventSVG;
    switch (eventType.toUpperCase()) {
      case "LIVE TALKS":
        icons = AppIcons.liveTalkLiveEventSVG;
        break;
      case "GENERIC YOGA":
        icons = AppIcons.genericYogaLiveEventSVG;
        break;
      case "MEDITATION":
        icons = AppIcons.meditationLiveEventSVG;
        break;
      case "SPECIFIC YOGA":
        icons = AppIcons.speceficYogaLiveEventSVG;
        break;
      default:
    }
    return icons;
  }
}
