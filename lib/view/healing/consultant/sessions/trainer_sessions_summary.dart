import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/sessions/buy_sessions/get_trainer_sessions.dart';
import 'package:aayu/view/healing/consultant/trainer_list.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrainerSessionsSummary extends StatelessWidget {
  const TrainerSessionsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrainerSessionController trainerSessionController =
        Get.put(TrainerSessionController());
    return Obx(() {
      if (trainerSessionController.isLoadingSessionsSummary.value == true) {
        return Padding(
          padding: pagePadding(),
          child: showLoading(),
        );
      } else if (trainerSessionController.sessionsSummaryList.value == null) {
        return const Offstage();
      }

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7).withOpacity(0.4),
              borderRadius: BorderRadius.circular(16.w),
            ),
            margin: EdgeInsets.only(
              top: 41.h,
            ),
            width: 322.w,
            height: 180.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "YOGA_THERAPIST_SESSIONS".tr,
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
                  height: (trainerSessionController
                                  .sessionsSummaryList.value!.sessionSummary !=
                              null &&
                          trainerSessionController.sessionsSummaryList.value!
                              .sessionSummary!.isNotEmpty)
                      ? 22.h
                      : 5.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                (trainerSessionController
                                .sessionsSummaryList.value!.sessionSummary !=
                            null &&
                        trainerSessionController.sessionsSummaryList.value!
                            .sessionSummary!.isNotEmpty)
                    ? showSessionSummary(trainerSessionController)
                    : const BuyTrainerSessionMessage(),
              ],
            ),
          ),
          Image(
            width: 86.w,
            height: 60.h,
            image: const AssetImage(Images.personalTrainingImageGrey),
            fit: BoxFit.contain,
          ),
        ],
      );
    });
  }

  showSessionSummary(TrainerSessionController trainerSessionController) {
    return Expanded(
      child: Builder(builder: (context) {
        List<Widget> widgetList = List.generate(
            trainerSessionController
                .sessionsSummaryList.value!.sessionSummary!.length, (index) {
          String status = trainerSessionController
              .sessionsSummaryList.value!.sessionSummary![index]!.status!
              .toUpperCase();

          return InkWell(
            onTap: (status == "ACTIVE" || status == "PENDING")
                ? () async {
                    if (status == "PENDING") {
                      bool isAlreadyBooked = await CoachService().checkIsBooked(
                          globalUserIdDetails!.userId!, "Trainer");

                      if (isAlreadyBooked == false) {
                        DiseaseDetailsRequest diseaseDetailsRequest =
                            DiseaseDetailsRequest();
                        diseaseDetailsRequest.disease = [];
                        for (var element in subscriptionCheckResponse!
                            .subscriptionDetails!.disease!) {
                          diseaseDetailsRequest.disease!.add(
                            DiseaseDetailsRequestDisease(
                              diseaseId: element!.diseaseId!,
                            ),
                          );
                        }
                        EventsService().sendClickNextEvent(
                            "TrainersessionsSummaryList",
                            "List",
                            "BookTrainerSession");
                        Get.to(
                          TrainerList(
                            pageSource: "DAY_WISE_PROGRAM",
                            consultType: "ADD-ON",
                            bookType: "PAID",
                          ),
                        );
                      } else {
                        showCustomSnackBar(
                            context, "COMPLETE_THERAPIST_CALL_BOOKED".tr);
                      }
                    } else if (status == "ACTIVE") {
                      trainerSessionController.handleCallJoin(
                          context,
                          trainerSessionController.sessionsSummaryList.value!
                              .sessionSummary![index]!.coach!.coachId!,
                          trainerSessionController.sessionsSummaryList.value!
                              .sessionSummary![index]!.sessionId!);
                    }
                  }
                : null,
            child: Container(
              margin: (index == 0)
                  ? EdgeInsets.only(right: 5.w, left: 5.w)
                  : EdgeInsets.only(right: 5.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(
                      Size(55.w, 55.h),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Container(
                          width: 46.w,
                          height: 46.h,
                          decoration: status == "PENDING"
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getBackgroundColor(status),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.07000000029802322),
                                      offset: Offset(0, 4),
                                      blurRadius: 10,
                                    )
                                  ],
                                )
                              : (status == "ACTIVE" || status == "BOOKED")
                                  ? null
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getBackgroundColor(status),
                                    ),
                          child: Center(
                            child: (status == "ACTIVE" || status == "BOOKED")
                                ? circularConsultImage(
                                    "THERAPIST",
                                    trainerSessionController
                                        .sessionsSummaryList
                                        .value!
                                        .sessionSummary![index]!
                                        .coach
                                        ?.profilePic!,
                                    46,
                                    46)
                                : Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                          91, 112, 129, 0.8),
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
                          visible: status == "ACTIVE",
                          child: Positioned(
                            left: 40.w,
                            child: Container(
                              width: 12.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFAAFDB4),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: status != "PENDING",
                          child: Positioned(
                            top: 36.h,
                            child: Container(
                              width: 19.w,
                              height: 19.h,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: status != "PENDING",
                          child: Positioned(
                            top: 38.h,
                            child: Container(
                              width: 15.w,
                              height: 15.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getBackgroundColor(status),
                              ),
                              child: getSVGIcon(status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  getSessionDetails(trainerSessionController
                      .sessionsSummaryList.value!.sessionSummary![index]!),
                ],
              ),
            ),
          );
        });

        widgetList.add(buyNowWidget(context));

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetList,
          ),
        );
      }),
    );
  }

  buyNowWidget(BuildContext context) {
    if (appProperties.payment!.addOn!.consultation!.therapist!.enabled ==
        false) {
      return const Offstage();
    }
    return InkWell(
      onTap: () async {
        bool isAllowed = await checkIsPaymentAllowed("THERAPIST_CONSULTATION");
        if (isAllowed == true) {
          EventsService().sendClickNextEvent("Therapist Session Summary",
              "Buy More Sessions", "Get Therapist Sessions");
          buildShowDialog(context);
          PostAssessmentController postAssessmentController =
              Get.put(PostAssessmentController());
          await postAssessmentController.getConsultingPackageDetails();
          Navigator.pop(context);

          Get.bottomSheet(
            const GetTrainerSessions(),
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: false,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(
                Size(65.w, 55.h),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 46.w,
                    height: 46.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.buySessionsSVG,
                        width: 14.w,
                        height: 14.h,
                        color: AppColors.secondaryLabelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            SizedBox(
              width: 65.w,
              height: 32.h,
              child: Text(
                "BUY_MORE".tr,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  decoration: TextDecoration.underline,
                  fontFamily: 'Circular Std',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.normal,
                  height: 1.h,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getSessionDetails(CoachSessionSummaryModelSessionSummary details) {
    switch (details.status!.toUpperCase()) {
      case "ACTIVE":
        return SizedBox(
          width: 65.w,
          height: 32.h,
          child: Text(
            "Join",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              decoration: TextDecoration.underline,
              fontFamily: 'Circular Std',
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
              height: 1.h,
            ),
          ),
        );
      case "BOOKED":
        DateTime scheduledDate = dateFromTimestamp(details.fromTime!);
        return SizedBox(
          width: 65.w,
          height: 32.h,
          child: Column(
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
              Text(
                DateFormat.jm().format(scheduledDate),
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
            ],
          ),
        );
      case "PENDING":
        return SizedBox(
          width: 65.w,
          height: 32.h,
          child: Text(
            "SCHEDULE".tr,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              decoration: TextDecoration.underline,
              fontFamily: 'Circular Std',
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
              height: 1.h,
            ),
          ),
        );
      case "MISSED SESSION":
      case "MISSED":
      case "ATTENDED":
      case "EXPIRED":
        return SizedBox(
          width: 65.w,
          height: 32.h,
          child: Text(
            toTitleCase(
              details.status!.toLowerCase(),
            ),
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
        );
      default:
        return SizedBox(
          height: 32.h,
        );
    }
  }

  getBackgroundColor(status) {
    switch (status) {
      case "MISSED SESSION":
      case "MISSED":
        return AppColors.primaryColor;
      case "ATTENDED":
      case "EXPIRED":
        return AppColors.primaryColor;
      case "ACTIVE":
        return AppColors.primaryColor;
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

class BuyTrainerSessionMessage extends StatelessWidget {
  const BuyTrainerSessionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: pageHorizontalPadding(),
          child: Text(
            "FIRST_SESSION_WITH_A_YOGA_THERAPIST".tr +
                ((appProperties
                            .payment!.addOn!.consultation!.therapist!.enabled ==
                        true)
                    ? ""
                    : " (Upcoming)"),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 14.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.4.h,
            ),
          ),
        ),
        SizedBox(
          height: 22.h,
        ),
        (appProperties.payment!.addOn!.consultation!.therapist!.enabled == true)
            ? InkWell(
                onTap: () async {
                  bool isAllowed =
                      await checkIsPaymentAllowed("THERAPIST_CONSULTATION");
                  if (isAllowed == true) {
                    EventsService().sendClickNextEvent(
                        "Therapist Session Summary",
                        "Buy Sessions",
                        "Get Therapist Sessions");
                    buildShowDialog(context);
                    PostAssessmentController postAssessmentController =
                        Get.put(PostAssessmentController());
                    await postAssessmentController
                        .getConsultingPackageDetails();
                    Navigator.pop(context);
                    Get.bottomSheet(
                      const GetTrainerSessions(),
                      isScrollControlled: true,
                      isDismissible: true,
                      enableDrag: false,
                    );
                  }
                },
                child: Container(
                  width: 133.2.w,
                  height: 36.h,
                  decoration: AppTheme.mainButtonDecoration,
                  child: Center(
                    child: Text(
                      "BUY_SESSIONS".tr,
                      textAlign: TextAlign.center,
                      style: mainButtonTextStyle(),
                    ),
                  ),
                ),
              )
            : const Offstage()
      ],
    );
  }
}
