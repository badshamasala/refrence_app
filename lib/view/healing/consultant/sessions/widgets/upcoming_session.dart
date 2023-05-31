import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpcomingSession extends StatelessWidget {
  final String consultationType;
  final int sessionIndex;
  final CoachUpcomingSessionsModelUpcomingSessions? sessionDetails;
  final Function? onTap;
  final Function? rescheduleTap;
  const UpcomingSession({
    Key? key,
    required this.consultationType,
    required this.sessionIndex,
    this.sessionDetails,
    this.onTap,
    this.rescheduleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = sessionDetails!.status!.toUpperCase();
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
              onTap!();
            },
      child: Container(
        width: 322.w,
        decoration: BoxDecoration(
          color: const Color(0xFFDCE2E9).withOpacity(0.4),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circularConsultImage(consultationType,
                      sessionDetails!.coach?.profilePic ?? "", 64, 64),
                  SizedBox(
                    width: 14.w,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (status == "ACTIVE" || status == "BOOKED")
                              ? sessionDetails!.coach?.coachName ?? ""
                              : "Expires On: ${DateFormat('dd MMM yyyy').format(dateFromTimestamp(sessionDetails!.expiresOn!))}",
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
                        Text(
                          (status == "ACTIVE" || status == "BOOKED")
                              ? ("${DateFormat('dd MMM yyyy, hh:mm aa').format(dateFromTimestamp(sessionDetails!.fromTime!))}")
                              : "Pending Session",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                AppColors.secondaryLabelColor.withOpacity(0.8),
                            fontFamily: 'Circular Std',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: status == "ACTIVE",
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Container(
                  height: 36.h,
                  width: double.infinity,
                  color: const Color(0xFFA0F4AA),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(
                        Icons.video_call,
                        color: AppColors.secondaryLabelColor,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "JOIN_THE_SESSION".tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 11.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          height: 1.h,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: status == "BOOKED",
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          rescheduleTap!();
                        },
                        child: Container(
                          height: 36.h,
                          color: const Color(0xFFBCBCBC).withOpacity(0.4),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "RESCHEDULE".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 11.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                  height: 1.h,
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    const RescheduleSessionInfo(),
                                    isScrollControlled: false,
                                    isDismissible: true,
                                    enableDrag: false,
                                  );
                                },
                                child: const Icon(
                                  Icons.info_outline,
                                  color: AppColors.secondaryLabelColor,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: 0.4,
                        child: Container(
                          color: const Color(0xFFA0F4AA),
                          width: double.infinity,
                          height: 36.h,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.video_call,
                                color: AppColors.secondaryLabelColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                "JOIN_THE_SESSION".tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 11.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                  height: 1.h,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: status == "PENDING",
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Container(
                  height: 36.h,
                  width: double.infinity,
                  color: const Color(0xFFBCBCBC).withOpacity(0.4),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.calenderSVG,
                        width: 16.w,
                        height: 16.h,
                        color: AppColors.secondaryLabelColor,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "SCHEDULE".tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 11.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          height: 1.h,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
