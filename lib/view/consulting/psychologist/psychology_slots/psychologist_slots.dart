// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/view/consulting/psychologist/home/psychology_home.dart';
import 'package:aayu/view/consulting/psychologist/psychology_slots/psychologist_available_slots.dart';
import 'package:aayu/view/healing/consultant/check_slot/confirming_slot.dart';
import 'package:aayu/view/healing/consultant/check_slot/widgets/consult_details.dart';
import 'package:aayu/view/healing/consultant/check_slot/widgets/consult_profile.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/consultant/psychologist/psychology_session_controller.dart';
import '../../../../controller/consultant/psychologist/pyschology_list_controller.dart';

class PsychologistSlots extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String coachId;
  final String bookType;

  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionCoachId;

  const PsychologistSlots({
    Key? key,
    this.pageSource = "",
    required this.consultType,
    required this.coachId,
    required this.bookType,
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionCoachId = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyListController psychologyListController =
        Get.put(PsychologyListController());
    Future.delayed(Duration.zero, () async {
      await Future.wait([
        psychologyListController.getPsychologyAvailableSlots(coachId),
        psychologyListController.getPsychologyProfile(coachId),
      ]);
    });

    return Scaffold(
      body: Obx(() {
        if (psychologyListController.isProfileLoading.value == true) {
          return showLoading();
        } else if (psychologyListController.coachProfile.value == null) {
          return showLoading();
        } else if (psychologyListController.coachProfile.value!.coachDetails ==
            null) {
          return showLoading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConsultProfile(
              consultType: "PSYCHOLOGIST",
              profilePic: psychologyListController
                  .coachProfile.value!.coachDetails!.profilePic!,
              consultName: psychologyListController
                  .coachProfile.value!.coachDetails!.coachName!,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: pageHorizontalPadding(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConsultDetails(
                      consultType: "PSYCHOLOGIST",
                      profilePic: psychologyListController
                          .coachProfile.value!.coachDetails!.profilePic!,
                      consultName: psychologyListController
                          .coachProfile.value!.coachDetails!.coachName!,
                      speciality: psychologyListController
                          .coachProfile.value!.coachDetails!.speciality!
                          .join(", "),
                      speaks: psychologyListController
                          .coachProfile.value!.coachDetails!.speaks!
                          .join(", "),
                      rating: psychologyListController
                          .coachProfile.value!.coachDetails!.rating!,
                      desc: psychologyListController
                          .coachProfile.value!.coachDetails!.bio!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const PsychologistAvailableSlots()
                  ],
                ),
              ),
            ),
            bottomNavigationBar(context)
          ],
        );
      }),
    );
  }

  bottomNavigationBar(context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 100.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 255, 255, 0),
                Color.fromRGBO(255, 255, 255, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 26.w),
          child: GetBuilder<PsychologyListController>(
            id: "AvailableSlotAction",
            builder: (psychologyListController) {
              return psychologyListController.checkSlotSeleted() == false
                  ? disabledButton((consultType == "GOT QUERY" &&
                          bookType == "PAID" &&
                          isReschedule == false)
                      ? "BLOCK_SLOT".tr
                      : "BOOK_SLOT".tr)
                  : InkWell(
                      onTap: () async {
                        handleBookSlot(context, psychologyListController);
                      },
                      child: mainButton("BOOK_SLOT".tr),
                    );
            },
          ),
        ),
      ],
    );
  }

  handleBookSlot(
      BuildContext context, PsychologyListController psychologyListController) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmingSlot(
            isScheduled: false,
            consultationType: "PSYCHOLOGIST",
            bookCall: () async {
              bool isBooked = false;
              if (isReschedule == true) {
                isBooked = await psychologyListController.rescheduleSlot(
                    prevSessionCoachId,
                    prevSessionId,
                    psychologyListController
                        .coachProfile.value!.coachDetails!.coachId!,
                    consultType,
                    bookType,
                    psychologyListController.selectedSlot!.sessionId!);
              } else {
                isBooked = await psychologyListController.bookSlot(
                    psychologyListController
                        .coachProfile.value!.coachDetails!.coachId!,
                    psychologyListController.selectedSlot!.sessionId!,
                    consultType,
                    bookType,
                    "");
                if (isBooked == true) {
                  // MyRoutineController myRoutineController = Get.find();
                  // myRoutineController.getData();
                }
              }

              if (isBooked == true) {
                EventsService().sendEvent("Book_Psychologist_Slots", {
                  "coachId": psychologyListController
                      .coachProfile.value!.coachDetails!.coachId!,
                  "coachName": psychologyListController
                      .coachProfile.value!.coachDetails!.coachName!,
                  "consultType": consultType,
                  "bookType": bookType,
                  "pageSource": pageSource,
                  "isReschedule": isReschedule,
                  "prevSessionCoachId": prevSessionCoachId,
                  "prevSessionId": prevSessionId,
                });

                if (pageSource == "PSYCHOLOGIST_SESSIONS") {
                  PsychologySessionController psychologySessionController =
                      Get.find();
                  await psychologySessionController.getSessionSummary();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Future.delayed(const Duration(seconds: 2), () {
                    showScheduledSessionPopup(
                      "PSYCHOLOGIST",
                      psychologyListController
                          .coachProfile.value!.coachDetails!.coachName!,
                      psychologyListController
                              .coachProfile.value!.coachDetails!.profilePic ??
                          "",
                      DateFormat.yMMMd()
                          .format(psychologyListController.selectedDate)
                          .toString(),
                      DateFormat("hh:mm a").format(
                        dateFromTimestamp(
                            psychologyListController.selectedSlot!.fromTime!),
                      ),
                    );
                  });
                } else {
                  late PsychologyController psychologyController;
                  if (PsychologyController().initialized == false) {
                    psychologyController = Get.put(PsychologyController());
                  } else {
                    psychologyController = Get.find();
                  }
                  await psychologyController.getUserPsychologyDetails();
                  Navigator.of(Get.context!).popUntil((route) => route.isFirst);
                  Future.delayed(const Duration(seconds: 2), () {
                    showScheduledSessionPopup(
                      "PSYCHOLOGIST",
                      psychologyListController
                              .coachProfile.value!.coachDetails!.coachName ??
                          "",
                      psychologyListController
                              .coachProfile.value!.coachDetails!.profilePic ??
                          "",
                      DateFormat.yMMMd()
                          .format(psychologyListController.selectedDate)
                          .toString(),
                      DateFormat("hh:mm a").format(
                        dateFromTimestamp(
                            psychologyListController.selectedSlot!.fromTime!),
                      ),
                    );
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PsychologyHome(),
                    ),
                  );
                }
              } else {
                Navigator.pop(context);
                showGetSnackBar("FAILED_TO_BOOK".tr, SnackBarMessageTypes.Info);
              }
            }),
      ),
    );
  }
}
