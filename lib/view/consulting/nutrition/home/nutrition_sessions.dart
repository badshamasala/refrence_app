// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/nutrition/nutrition_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_session_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_plans/nutrition_extend_plan.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_slots/nutritionist_slots.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NutritionSessions extends StatelessWidget {
  final String coachId;
  const NutritionSessions({Key? key, required this.coachId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NutritionSessionController nutritionSessionController =
        Get.put(NutritionSessionController());
    nutritionSessionController.getSessionSummary();
    return Obx(() {
      if (nutritionSessionController.isLoadingSessionsSummary.value == true) {
        return Padding(
          padding: pagePadding(),
          child: showLoading(),
        );
      } else if (nutritionSessionController.sessionsSummaryList.value == null) {
        return const Offstage();
      }

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 53.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7).withOpacity(0.4),
              borderRadius: BorderRadius.circular(16.w),
            ),
            width: 322.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 36.h,
                ),
                Text(
                  "Nutritionist consultation",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    height: 1.h,
                  ),
                ),
                SizedBox(
                  height: (nutritionSessionController
                                  .sessionsSummaryList.value!.sessionSummary !=
                              null &&
                          nutritionSessionController.sessionsSummaryList.value!
                              .sessionSummary!.isNotEmpty)
                      ? 22.h
                      : 5.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                (nutritionSessionController
                                .sessionsSummaryList.value!.sessionSummary !=
                            null &&
                        nutritionSessionController.sessionsSummaryList.value!
                            .sessionSummary!.isNotEmpty)
                    ? showSessionSummary(nutritionSessionController)
                    : const Offstage(),
                TextButton(
                  onPressed: () {
                    NutritionController nutritionController = Get.find();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => NutritionExtendPlan(
                          packageType: nutritionController.userNutritionDetails
                              .value!.selectedPackage!.packageType!,
                          coachId: nutritionController.userNutritionDetails
                              .value!.currentTrainer!.coachId!,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Upgrade your plan",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                )
              ],
            ),
          ),
          Image(
            width: 80.w,
            height: 80.h,
            image: const AssetImage(Images.foodBowlImage),
            fit: BoxFit.contain,
          ),
        ],
      );
    });
  }

  showSessionSummary(NutritionSessionController nutritionSessionController) {
    return Builder(builder: (context) {
      List<Widget> widgetList = List.generate(
          nutritionSessionController
              .sessionsSummaryList.value!.sessionSummary!.length, (index) {
        String status = nutritionSessionController
            .sessionsSummaryList.value!.sessionSummary![index]!.status!
            .toUpperCase();

        return InkWell(
          onTap: (status == "ACTIVE" || status == "PENDING")
              ? () async {
                  if (status == "PENDING") {
                    bool isAlreadyBooked = await CoachService().checkIsBooked(
                        globalUserIdDetails!.userId!, "Nutritionist");
                    if (isAlreadyBooked == false) {
                      Navigator.push(
                        navState.currentState!.context,
                        MaterialPageRoute(
                          builder: (context) => NutritionistSlots(
                            consultType: "ADD-ON",
                            coachId: coachId,
                            bookType: "PAID",
                          ),
                        ),
                      );
                    } else {
                      showCustomSnackBar(
                          context, "COMPLETE_NUTRITIONIST_CALL_BOOKED".tr);
                    }
                  } else if (status == "ACTIVE") {
                    nutritionSessionController.handleCallJoin(
                        context,
                        nutritionSessionController.sessionsSummaryList.value!
                            .sessionSummary![index]!.coach!.coachId!,
                        nutritionSessionController.sessionsSummaryList.value!
                            .sessionSummary![index]!.sessionId!);
                  }
                }
              : (status == "BOOKED" &&
                      nutritionSessionController.sessionsSummaryList.value!
                              .sessionSummary![index]!.allowReschedule ==
                          true)
                  ? () {
                      Navigator.push(
                        navState.currentState!.context,
                        MaterialPageRoute(
                          builder: (context) => NutritionistSlots(
                            consultType: "ADD-ON",
                            coachId: coachId,
                            bookType: "PAID",
                            isReschedule: true,
                            prevSessionCoachId: nutritionSessionController
                                .sessionsSummaryList
                                .value!
                                .sessionSummary![index]!
                                .coach!
                                .coachId!,
                            prevSessionId: nutritionSessionController
                                .sessionsSummaryList
                                .value!
                                .sessionSummary![index]!
                                .sessionId!,
                          ),
                        ),
                      );
                    }
                  : null,
          child: Container(
            width: 75.w,
            margin: (index == 0)
                ? EdgeInsets.only(right: 8.w, left: 8.w)
                : EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: status == "PENDING" ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10.sp),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: getBackgroundColor(status),
                        borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: const Color.fromRGBO(91, 112, 129, 0.8),
                            fontFamily: 'Circular Std',
                            fontSize: 16.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1.h,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: status != "PENDING",
                      child: Positioned(
                        bottom: -10.h,
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whiteColor,
                          ),
                          child: Container(
                            width: 16.w,
                            height: 16.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getBackgroundColor(status),
                            ),
                            child: getSVGIcon(status),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                getSessionDetails(nutritionSessionController
                    .sessionsSummaryList.value!.sessionSummary![index]!),
              ],
            ),
          ),
        );
      });

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList,
        ),
      );
    });
  }

  getSessionDetails(CoachSessionSummaryModelSessionSummary details) {
    DateTime scheduledDate = DateTime.now();
    String actionText = "";
    switch (details.status!.toUpperCase()) {
      case "ACTIVE":
        scheduledDate = dateFromTimestamp(details.fromTime!);
        actionText = "Join";
        break;
      case "BOOKED":
        if (details.allowReschedule == true) {
          actionText = "Reschedule";
        } else {
          actionText = "Booked";
        }
        scheduledDate = dateFromTimestamp(details.fromTime!);
        break;
      case "PENDING":
        actionText = "SCHEDULE".tr;
        break;
      case "MISSED SESSION":
      case "MISSED":
      case "ATTENDED":
      case "EXPIRED":
        scheduledDate = dateFromTimestamp(details.fromTime!);
        actionText = details.status!.toUpperCase();
        break;
      default:
        break;
    }

    if (actionText.isNotEmpty) {
      if (details.status!.toUpperCase() == "PENDING") {
        return Text(
          // (details.nextSchedule == null)
          //     ? "SCHEDULE".tr
          //     : DateFormat("dd MMM")
          //         .format(dateFromTimestamp(details.nextSchedule!)),
          "SCHEDULE".tr,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondaryLabelColor,
            decoration: TextDecoration.underline,
            fontFamily: 'Circular Std',
            fontSize: 13.sp,
            fontWeight: FontWeight.normal,
            height: 1.3.h,
          ),
        );
      } else {
        return Column(
          children: [
            Text(
              DateFormat("dd MMM").format(scheduledDate),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 13.sp,
                fontWeight: FontWeight.normal,
                height: 1.h,
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              DateFormat("hh:mm a").format(scheduledDate),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 13.sp,
                fontWeight: FontWeight.normal,
                height: 1.h,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: getBackgroundColor(details.status!.toUpperCase()),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.sp),
                  bottomRight: Radius.circular(10.sp),
                ),
              ),
              child: Text(
                toTitleCase(
                  actionText.toLowerCase(),
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  decoration:
                      (actionText == "Reschedule" || actionText == "Join")
                          ? TextDecoration.underline
                          : TextDecoration.none,
                  fontFamily: 'Circular Std',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  height: 1.h,
                ),
              ),
            ),
          ],
        );
      }
    }
    return const Offstage();
  }

  getBackgroundColor(status) {
    switch (status) {
      case "MISSED SESSION":
      case "MISSED":
      case "ATTENDED":
      case "EXPIRED":
        return AppColors.primaryColor;
      case "ACTIVE":
        return const Color(0xFFA0F4AA);
      case "BOOKED":
        return const Color(0xFFA0F4AA);
      default:
        return const Color(0xFFDCE2E9);
    }
  }

  getSVGIcon(status) {
    switch (status) {
      case "MISSED SESSION":
      case "MISSED":
        return Center(
          child: SvgPicture.asset(
            AppIcons.missedSessionsSVG,
            width: 4.5.w,
            height: 4.5.h,
            color: AppColors.whiteColor,
          ),
        );
      case "ATTENDED":
      case "EXPIRED":
        return Center(
          child: SvgPicture.asset(
            AppIcons.attendedSessionsSVG,
            width: 6.w,
            height: 7.h,
            color: AppColors.whiteColor,
          ),
        );
      case "ACTIVE":
        return const Center(
          child: Icon(
            Icons.arrow_forward,
            color: AppColors.whiteColor,
            size: 12,
          ),
        );
      case "BOOKED":
        return Center(
          child: SvgPicture.asset(
            AppIcons.scheduledSessionsSVG,
            width: 5.1.w,
            height: 6.01.h,
            color: AppColors.whiteColor,
          ),
        );
      default:
        return const Offstage();
    }
  }
}
