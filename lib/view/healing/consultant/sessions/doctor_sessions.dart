import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/coach.service.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/healing/consultant/sessions/buy_sessions/get_doctor_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/widgets/buy_slot.dart';
import 'package:aayu/view/healing/consultant/sessions/widgets/past_session.dart';
import 'package:aayu/view/healing/consultant/sessions/widgets/upcoming_session.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DoctorSessions extends StatelessWidget {
  const DoctorSessions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorSessionController controller = Get.put(DoctorSessionController());
    Future.delayed(Duration.zero, () {
      controller.getUpcomingSessions();
      controller.getPastSessions();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Obx(
            () {
              return Column(mainAxisSize: MainAxisSize.max, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25.w,
                    ),
                    Text(
                      'DOCTOR_CONSULTS'.tr,
                      style: AppTheme.secondarySmallFontTitleTextStyle,
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 7.h,
                ),
                (controller.isLoadingPastSessions.value == false &&
                        controller.pastSessionsList.value?.pastSessions !=
                            null &&
                        controller
                            .pastSessionsList.value!.pastSessions!.isNotEmpty)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 26.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<bool>(
                                  activeColor: AppColors.primaryColor,
                                  value: true,
                                  groupValue: controller.showAll.value,
                                  onChanged: (val) {
                                    controller.setShowAll(val!);
                                  }),
                              Text(
                                "All",
                                style: TextStyle(
                                  color: AppColors.blueGreyAssessmentColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: controller.showAll.value,
                                onChanged: (val) {
                                  controller.setShowAll(val!);
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              Text(
                                "Past Consultations",
                                style: TextStyle(
                                  color: AppColors.blueGreyAssessmentColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                        ],
                      )
                    : Offstage(),
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (controller.showAll.value)
                            ? buildUpcomingSessions(context)
                            : Offstage(),
                        buildPastSessions(),
                        SizedBox(
                          height: 100.h,
                        )
                      ],
                    ),
                  ),
                ),
              ]);
            },
          ),
          (appProperties.payment!.addOn!.consultation!.doctor!.enabled == true)
              ? Positioned(
                  bottom: 30.h,
                  child: InkWell(
                    onTap: () async {
                      bool isAllowed =
                          await checkIsPaymentAllowed("DOCTOR_CONSULTATION");
                      if (isAllowed == true) {
                        EventsService().sendClickNextEvent(
                            "Doctor Upcoming Sessions",
                            "Buy Sessions",
                            "Get Doctor Sessions");
                        buildShowDialog(context);
                        PostAssessmentController postAssessmentController =
                            Get.put(PostAssessmentController());
                        await postAssessmentController
                            .getConsultingPackageDetails();
                        Navigator.pop(context);
                        Get.bottomSheet(
                          const GetDoctorSessions(),
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: false,
                        );
                      }
                    },
                    child: SizedBox(
                      width: 270.w,
                      child: mainButton("Add More Consultations"),
                    ),
                  ),
                )
              : const Offstage(),
        ],
      ),
    );
  }

  buildUpcomingSessions(BuildContext context) {
    return GetBuilder<DoctorSessionController>(
      builder: (doctorSessionController) {
        if (doctorSessionController.isLoadingUpcomingSessions.value == true) {
          return showLoading();
        } else if (doctorSessionController.upcomingSessionsList.value == null) {
          return const BuySlot(
            sessionType: "Doctor",
          );
        } else if (doctorSessionController
                .upcomingSessionsList.value!.upcomingSessions ==
            null) {
          return const BuySlot(
            sessionType: "Doctor",
          );
        } else if (doctorSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isEmpty) {
          return const BuySlot(
            sessionType: "Doctor",
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          padding: pageHorizontalPadding(),
          physics: BouncingScrollPhysics(),
          itemCount: doctorSessionController
              .upcomingSessionsList.value!.upcomingSessions!.length,
          itemBuilder: (context, index) {
            String status = doctorSessionController
                .upcomingSessionsList.value!.upcomingSessions![index]!.status!
                .toUpperCase();

            return UpcomingSession(
                consultationType: "DOCTOR",
                sessionIndex: index,
                sessionDetails: doctorSessionController
                    .upcomingSessionsList.value!.upcomingSessions![index]!,
                onTap: (status == "BOOKED")
                    ? null
                    : () async {
                        if (status == "ACTIVE") {
                          doctorSessionController.handleCallJoin(
                              context,
                              doctorSessionController
                                  .upcomingSessionsList
                                  .value!
                                  .upcomingSessions![index]!
                                  .coach!
                                  .coachId!,
                              doctorSessionController.upcomingSessionsList
                                  .value!.upcomingSessions![index]!.sessionId!);
                        } else if (status == "PENDING") {
                          bool isAlreadyBooked = await CoachService()
                              .checkIsBooked(
                                  globalUserIdDetails!.userId!, "Doctor");

                          if (isAlreadyBooked == false) {
                            DiseaseDetailsRequest diseaseDetailsRequest =
                                DiseaseDetailsRequest();
                            diseaseDetailsRequest.disease = [];
                            if (subscriptionCheckResponse
                                    ?.subscriptionDetails?.disease !=
                                null) {
                              for (var element in subscriptionCheckResponse!
                                  .subscriptionDetails!.disease!) {
                                diseaseDetailsRequest.disease!.add(
                                  DiseaseDetailsRequestDisease(
                                    diseaseId: element!.diseaseId!,
                                  ),
                                );
                              }
                            }

                            EventsService().sendClickNextEvent(
                                "DoctorSessions", "Book", "BookDoctorSession");

                            Get.to(
                              DoctorList(
                                pageSource: "DOCTOR_SESSIONS",
                                consultType: "ADD-ON",
                                bookType: "PAID",
                              ),
                            );
                          } else {
                            showCustomSnackBar(
                                context, "COMPLETE_DOCTOR_CALL_BOOKED".tr);
                          }
                        }
                      },
                rescheduleTap: () {
                  if (doctorSessionController.upcomingSessionsList.value!
                          .upcomingSessions![index]!.allowReschedule ==
                      true) {
                    EventsService().sendClickNextEvent(
                        "DoctorSessions", "Reschedule", "BookDoctorSession");

                    Get.to(
                      DoctorList(
                        pageSource: "DOCTOR_SESSIONS",
                        consultType: doctorSessionController
                            .upcomingSessionsList
                            .value!
                            .upcomingSessions![index]!
                            .consultType!,
                        bookType: doctorSessionController.upcomingSessionsList
                                .value!.upcomingSessions![index]!.bookType ??
                            "",
                        isReschedule: true,
                        prevSessionId: doctorSessionController
                            .upcomingSessionsList
                            .value!
                            .upcomingSessions![index]!
                            .sessionId!,
                        prevSessionDoctorId: doctorSessionController
                            .upcomingSessionsList
                            .value!
                            .upcomingSessions![index]!
                            .coach!
                            .coachId!,
                      ),
                    );
                  } else {
                    showCustomSnackBar(
                      context,
                      "RESCHEDULE_UNTIL_1_HOUR_BEFORE_THE_SLOT_TIME".tr,
                    );
                  }
                });
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 24.h,
            );
          },
        );
      },
    );
  }

  buildPastSessions() {
    return GetBuilder<DoctorSessionController>(
      builder: (doctorSessionController) {
        if (doctorSessionController.isLoadingPastSessions.value == true) {
          return showLoading();
        } else if (doctorSessionController.pastSessionsList.value == null) {
          return const Offstage();
        } else if (doctorSessionController
                .pastSessionsList.value!.pastSessions ==
            null) {
          return const Offstage();
        } else if (doctorSessionController
            .pastSessionsList.value!.pastSessions!.isEmpty) {
          return const Offstage();
        }

        return Column(
          children: [
            (doctorSessionController.showAll.value)
                ? Padding(
                    padding:
                        EdgeInsets.only(left: 26.w, top: 26.h, bottom: 26.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Past Consultations",
                            style: TextStyle(
                              color: AppColors.blackLabelColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Baskerville',
                            ))
                      ],
                    ),
                  )
                : const Offstage(),
            ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: pageHorizontalPadding(),
              itemCount: doctorSessionController
                  .pastSessionsList.value!.pastSessions!.length,
              itemBuilder: (context, index) {
                return PastSession(
                  consultationType: "DOCTOR",
                  sessionIndex: index,
                  sessionDetails: doctorSessionController
                      .pastSessionsList.value!.pastSessions![index]!,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 24.h,
                );
              },
            ),
          ],
        );
      },
    );
  }

  handleScheduleSession(DoctorSessionController doctorSessionController) {
    if (doctorSessionController.upcomingSessionsList.value != null &&
        doctorSessionController.upcomingSessionsList.value!.upcomingSessions !=
            null &&
        doctorSessionController
            .upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      Get.to(
        DoctorList(
          pageSource: "DOCTOR_SESSIONS",
          consultType: "ADD-ON",
          bookType: "PAID",
        ),
      );
    }
  }
}
