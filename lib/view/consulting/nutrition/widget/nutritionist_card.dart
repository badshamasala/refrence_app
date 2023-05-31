import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_plans/nutrition_plans.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NutritionistCard extends StatelessWidget {
  final String pageSource;
  final CoachListModelCoachList coachDetails;
  final String packageStartsFrom;
  const NutritionistCard(
      {Key? key,
      required this.coachDetails,
      required this.pageSource,
      required this.packageStartsFrom})
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
                    "NUTRITIONIST", coachDetails.profilePic, 64, 64),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (coachDetails.level != null &&
                            coachDetails.level!.isNotEmpty)
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: getLevelBG(coachDetails.level!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${coachDetails.level}",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.h,
                                ),
                              ),
                            ),
                          )
                        : const Offstage(),
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
                  (packageStartsFrom.isNotEmpty)
                      ? Text(
                          packageStartsFrom,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: const Color(0xFF7A8A98),
                            fontFamily: 'Circular Std',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.h,
                          ),
                        )
                      : Text(
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
                  InkWell(
                    onTap: () {
                      EventsService().sendEvent("Nutritionist_Selected", {
                        'coachId': coachDetails.coachId,
                        'coachName': coachDetails.coachName,
                        'level': coachDetails.level != null &&
                                coachDetails.level!.isNotEmpty
                            ? coachDetails.level!.toUpperCase()
                            : "BASIC"
                      });
                      Get.to(
                        NutritionPlans(
                          coachDetails: coachDetails,
                          packageType: coachDetails.level != null &&
                                  coachDetails.level!.isNotEmpty
                              ? coachDetails.level!.toUpperCase()
                              : "BASIC",
                        ),
                      );
                    },
                    child: Text(
                      "Check plan",
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
      case "EXPERTS":
        return const Color(0xFF3E3A93);
      case "SPECIALIST":
        return const Color(0xFFFDE47E);
      case "ADVANCED":
        return const Color(0xFFFAB789);
      default:
        return const Color(0xFFFAB789);
    }
  }
}
