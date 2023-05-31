import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/psychologist/psychology_slots/psychologist_slots.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PsychologistCard extends StatelessWidget {
  final String pageSource;
  final CoachListModelCoachList coachDetails;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionCoachId;
  const PsychologistCard(
      {Key? key,
      required this.coachDetails,
      required this.pageSource,
      this.isReschedule = false,
      this.prevSessionId = "",
      this.prevSessionCoachId = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 322.w,
      decoration: BoxDecoration(
          color: AppColors.lightSecondaryColor,
          borderRadius: BorderRadius.circular(16.w)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circularConsultImage(
                    "PSYCHOLOGIST", coachDetails.profilePic, 64, 64),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        coachDetails.coachName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        "Speciality : ${coachDetails.speciality!.join(", ")}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor.withOpacity(0.7),
                          fontFamily: 'Circular Std',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        "Speaks : ${coachDetails.speaks!.join(", ")}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor.withOpacity(0.7),
                          fontFamily: 'Circular Std',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.primaryColor,
                          size: 14,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          "${coachDetails.rating ?? ""}",
                          style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontFamily: 'Circular Std',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              height: 36.h,
              width: double.infinity,
              padding: pageHorizontalPadding(),
              color: const Color(0xFFE5E5E5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (coachDetails.availableSessions! > 0)
                        ? "${coachDetails.availableSessions!} slots available"
                        : "No slots available!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF7A8A98),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.h,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PsychologistSlots(
                            pageSource: pageSource,
                            consultType: "ADD-ON",
                            coachId: coachDetails.coachId!,
                            bookType: "PAID",
                            isReschedule: isReschedule,
                            prevSessionId: prevSessionId,
                            prevSessionCoachId: prevSessionCoachId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Check Slots",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.primaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 11.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                        height: 1.h,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getLevelBG(String level) {
    switch (level.toUpperCase()) {
      case "BASIC":
        return const Color(0xFF3E3A93);
      case "STANDARD":
        return const Color(0xFFFDE47E);
      case "ADVANCED":
        return const Color(0xFFFAB789);
      default:
        return AppColors.primaryColor;
    }
  }

  getLevelTextColor(String level) {
    switch (level.toUpperCase()) {
      case "BASIC":
        return AppColors.whiteColor;
      case "STANDARD":
        return AppColors.blackLabelColor;
      case "ADVANCED":
        return AppColors.whiteColor;
      default:
        return AppColors.whiteColor;
    }
  }
}
