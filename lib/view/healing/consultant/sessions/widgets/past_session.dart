// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PastSession extends StatelessWidget {
  final String consultationType;
  final int sessionIndex;
  final CoachPastSessionsModelPastSessions? sessionDetails;
  const PastSession({
    Key? key,
    required this.consultationType,
    required this.sessionIndex,
    required this.sessionDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = sessionDetails!.status!.toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: 322.w,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          circularConsultImage(
              consultationType, sessionDetails!.coach?.profilePic, 64, 64),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (status == "ATTENDED" || status == "MISSED SESSION")
                      ? sessionDetails!.coach?.coachName ?? ""
                      : "Expired On: ${DateFormat('dd MMM yyyy, hh:mm aa').format(dateFromTimestamp(sessionDetails!.fromTime!))}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5.h,
                  ),
                ),
                Visibility(
                  visible: (status == "ATTENDED" || status == "MISSED SESSION"),
                  child: Text(
                    "${DateFormat('dd MMM yyyy, hh:mm aa').format(dateFromTimestamp(sessionDetails!.fromTime!))}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor.withOpacity(0.8),
                      fontFamily: 'Circular Std',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.5.h,
                    ),
                  ),
                ),
                Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      (status == "ATTENDED") ? Icons.done : Icons.close,
                      size: 16,
                      color: AppColors.secondaryLabelColor.withOpacity(0.7),
                    ),
                    SizedBox(
                      width: 5.38.w,
                    ),
                    Text(
                      toTitleCase(status.toLowerCase()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor.withOpacity(0.7),
                        fontFamily: 'Circular Std',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.5.h,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
