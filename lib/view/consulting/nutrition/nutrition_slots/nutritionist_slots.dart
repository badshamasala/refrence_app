// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/nutrition/nutrition_list_controller.dart';
import 'package:aayu/controller/consultant/nutrition/nutrition_session_controller.dart';
import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/view/consulting/nutrition/nutrition_slots/nutritionist_available_slots.dart';
import 'package:aayu/view/healing/consultant/check_slot/confirming_slot.dart';
import 'package:aayu/view/healing/consultant/check_slot/widgets/consult_details.dart';
import 'package:aayu/view/healing/consultant/check_slot/widgets/consult_profile.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NutritionistSlots extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String coachId;
  final String bookType;

  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionCoachId;

  const NutritionistSlots({
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
    NutritionListController nutritionListController =
        Get.put(NutritionListController());
    Future.delayed(Duration.zero, () async {
      await Future.wait([
        nutritionListController.getNutritionAvailableSlots(coachId),
        nutritionListController.getNutritionProfile(coachId),
      ]);
    });

    return Scaffold(
      body: Obx(() {
        if (nutritionListController.isProfileLoading.value == true) {
          return showLoading();
        } else if (nutritionListController.coachProfile.value == null) {
          return showLoading();
        } else if (nutritionListController.coachProfile.value!.coachDetails ==
            null) {
          return showLoading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConsultProfile(
              consultType: "NUTRITIONIST",
              profilePic: nutritionListController
                  .coachProfile.value!.coachDetails!.profilePic!,
              consultName: nutritionListController
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
                      consultType: "NUTRITIONIST",
                      profilePic: nutritionListController
                          .coachProfile.value!.coachDetails!.profilePic!,
                      consultName: nutritionListController
                          .coachProfile.value!.coachDetails!.coachName!,
                      speciality: nutritionListController
                          .coachProfile.value!.coachDetails!.speciality!
                          .join(", "),
                      speaks: nutritionListController
                          .coachProfile.value!.coachDetails!.speaks!
                          .join(", "),
                      rating: nutritionListController
                          .coachProfile.value!.coachDetails!.rating!,
                      desc: nutritionListController
                          .coachProfile.value!.coachDetails!.bio!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const NutritionistAvailableSlots()
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
          child: GetBuilder<NutritionListController>(
            id: "AvailableSlotAction",
            builder: (nutritionListController) {
              return nutritionListController.checkSlotSeleted() == false
                  ? disabledButton((consultType == "GOT QUERY" &&
                          bookType == "PAID" &&
                          isReschedule == false)
                      ? "BLOCK_SLOT".tr
                      : "BOOK_SLOT".tr)
                  : InkWell(
                      onTap: () async {
                        handleBookSlot(context, nutritionListController);
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
      BuildContext context, NutritionListController nutritionListController) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmingSlot(
            isScheduled: false,
            consultationType: "NUTRITIONIST",
            bookCall: () async {
              bool isBooked = false;
              if (isReschedule == true) {
                isBooked = await nutritionListController.rescheduleSlot(
                    prevSessionCoachId,
                    prevSessionId,
                    nutritionListController
                        .coachProfile.value!.coachDetails!.coachId!,
                    consultType,
                    bookType,
                    nutritionListController.selectedSlot!.sessionId!);
              } else {
                isBooked = await nutritionListController.bookSlot(
                    nutritionListController
                        .coachProfile.value!.coachDetails!.coachId!,
                    nutritionListController.selectedSlot!.sessionId!,
                    consultType,
                    bookType,
                    "");
              }

              if (isBooked == true) {
                MyRoutineController myRoutineController = Get.find();
                myRoutineController.getData();

                EventsService().sendEvent(
                    isReschedule == true
                        ? "Nutritionist_Slot_Rescheduled"
                        : "Nutritionist_Slot_Booked",
                    {
                      "coachId": nutritionListController
                          .coachProfile.value!.coachDetails!.coachId!,
                      "coachName": nutritionListController
                          .coachProfile.value!.coachDetails!.coachName!,
                      "consultType": consultType,
                      "bookType": bookType,
                      "pageSource": pageSource,
                      "isReschedule": isReschedule,
                      "prevSessionCoachId": prevSessionCoachId,
                      "prevSessionId": prevSessionId,
                    });

                NutritionSessionController nutritionSessionController =
                    Get.find();
                await nutritionSessionController.getSessionSummary();

                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                showGetSnackBar("FAILED_TO_BOOK".tr, SnackBarMessageTypes.Info);
              }
            }),
      ),
    );
  }
}
