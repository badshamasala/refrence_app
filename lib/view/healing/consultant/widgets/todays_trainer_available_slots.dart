import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/consultant/personal_trainer_controller.dart';
import '../../../../controller/consultant/trainer_session_controller.dart';
import '../../../../services/payment.service.dart';

class TodaysTrainerAvailableSlots extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String bookType;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionTrainerId;
  final CoachListModelCoachList trainerDetails;
  const TodaysTrainerAvailableSlots({
    Key? key,
    required this.consultType,
    required this.bookType,
    required this.isReschedule,
    required this.pageSource,
    required this.prevSessionId,
    required this.prevSessionTrainerId,
    required this.trainerDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available slots",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              fontFamily: "Circular Std",
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          (trainerDetails.availableSlots != null &&
                  trainerDetails.availableSlots!.isNotEmpty)
              ? Container(
                  constraints: BoxConstraints(maxHeight: 80.h),
                  child: SingleChildScrollView(
                    child: GetBuilder<PersonalTrainerController>(
                        id: "coachListAvailableSlots",
                        builder: (personalTrainerController) {
                          return Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            spacing: 3.w,
                            runSpacing: 6.h,
                            children: List.generate(
                              trainerDetails.availableSlots!.length,
                              (index) {
                                return InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    for (var element
                                        in personalTrainerController
                                            .personalTrainerList
                                            .value!
                                            .coachList!) {
                                      for (var item
                                          in element!.availableSlots!) {
                                        item!.selected = false;
                                      }
                                    }
                                    trainerDetails.availableSlots![index]!
                                        .selected = true;
                                    personalTrainerController
                                        .update(["coachListAvailableSlots"]);
                                    if (trainerDetails
                                            .availableSlots![index]!.selected ==
                                        true) {
                                      personalTrainerController.selectedSlot =
                                          CoachAvailableSlotsModelAvailableSlots
                                              .fromJson(trainerDetails
                                                  .availableSlots![index]!
                                                  .toJson());
                                      confirmSlot(
                                          context, personalTrainerController);
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    width: 70.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32.w),
                                      color: trainerDetails
                                                  .availableSlots![index]!
                                                  .selected ==
                                              true
                                          ? AppColors.primaryColor
                                          : const Color(0xFFE5E5E5),
                                    ),
                                    child: Text(
                                      DateFormat.jm().format(dateFromTimestamp(
                                          trainerDetails.availableSlots![index]!
                                              .fromTime!)),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: trainerDetails
                                                    .availableSlots![index]!
                                                    .selected ==
                                                true
                                            ? AppColors.whiteColor
                                            : AppColors.secondaryLabelColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Circular Std",
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
                )
              : Text(
                  "No slots available. Please check another day for slots availability",
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor.withOpacity(0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontFamily: "Circular Std",
                  ),
                ),
        ],
      ),
    );
  }

  confirmSlot(BuildContext context,
      PersonalTrainerController personalTrainerController) {
    Get.bottomSheet(
      Wrap(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 55.h),
                padding: pagePadding(),
                decoration: BoxDecoration(
                  color: AppColors.pageBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 46.h,
                    ),
                    Text(
                      "Confirm your slot with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontFamily: 'Baskerville',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.normal,
                        height: 1.h,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        trainerDetails.coachName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Baskerville',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.normal,
                          height: 1.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 17.h),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      width: 242.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F5),
                        borderRadius: BorderRadius.circular(16.w),
                      ),
                      child: Column(children: [
                        selectedCallDetails(
                          "Date: ",
                          DateFormat.yMMMd()
                              .format(personalTrainerController.selectedDate)
                              .toString(),
                        ),
                        Divider(
                          color: AppColors.secondaryLabelColor.withOpacity(0.1),
                        ),
                        selectedCallDetails(
                            "Time: ",
                            DateFormat.jm().format(dateFromTimestamp(
                                personalTrainerController
                                    .selectedSlot!.fromTime!))),
                      ]),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    InkWell(
                      onTap: () {
                        EventsService()
                            .sendEvent("Single_Trainer_Payment_Selected", {
                          "trainer_id": trainerDetails.coachId,
                          "trainer_name": trainerDetails.coachName,
                          "single_session_price": personalTrainerController
                              .singleSessionPrice.value,
                          "selected_date": DateFormat.yMMMd()
                              .format(personalTrainerController.selectedDate)
                              .toString(),
                          "from_time":
                              personalTrainerController.selectedSlot!.fromTime!,
                          "to_time":
                              personalTrainerController.selectedSlot!.fromTime!,
                        });
                        if (consultType == "GOT QUERY" &&
                            bookType == "PAID" &&
                            isReschedule == false &&
                            personalTrainerController
                                    .singleSessionPrice.value !=
                                0) {
                          handleBlockSlot(context, personalTrainerController);
                        } else {
                          handleBookSlot(context, personalTrainerController);
                        }
                      },
                      child: mainButton((consultType == "GOT QUERY" &&
                              bookType == "PAID" &&
                              isReschedule == false &&
                              personalTrainerController
                                      .singleSessionPrice.value !=
                                  0)
                          ? "Pay Now"
                          : "BOOK_SLOT".tr),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0.w,
                right: 0,
                child: circularConsultImage(
                    "TRAINER", trainerDetails.profilePic, 110, 110),
              ),
              Positioned(
                top: 76.h,
                left: 22.w,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.blackLabelColor,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
    );
  }

  selectedCallDetails(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              fontFamily: "Circular Std",
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: "Circular Std",
            ),
          )
        ],
      ),
    );
  }

  handleBlockSlot(BuildContext context,
      PersonalTrainerController personalTrainerController) async {
    try {
      buildShowDialog(context);
      bool isBlocked = await personalTrainerController.blockSlot(
          trainerDetails.coachId!,
          personalTrainerController.selectedSlot!.sessionId!);
      Navigator.pop(context);
      if (isBlocked == true) {
        EventsService().sendEvent("Block_Trainer_Slot", {
          "total_payment": personalTrainerController.singleSessionPrice,
          "trainer_id": trainerDetails.coachId,
          "trainer_name": trainerDetails.coachName,
          "consult_type": consultType,
          "book_type": bookType,
        });
        Navigator.pop(context);
        Get.to(JuspayPayment(
          pageSource: "CONFIRM_THERAPIST_CONSULTATION",
          totalPayment: personalTrainerController.singleSessionPrice.value,
          currency: personalTrainerController
                  .selectedSingleTrainerSession?.currency?.billing ??
              "",
          paymentEvent: "THERAPIST_CONSULTATION",
          customData: {
            "pageSource": pageSource,
            "selectedConsultingPackage": personalTrainerController
                .selectedSingleTrainerSession!
                .toJson(),
            "consultationType": "THERAPIST",
            "trainerId": trainerDetails.coachId,
            "trainerName": trainerDetails.coachName,
            "sessionId": personalTrainerController.selectedSlot!.sessionId,
            "consultType": consultType,
            "bookType": bookType,
            "scheduleDate": DateFormat.yMMMd()
                .format(personalTrainerController.selectedDate)
                .toString(),
            "scheduleTime": personalTrainerController.selectedSlot!.fromTime!,
            "promoCodeDetails": {
              "isApplied": personalTrainerController.isPromoCodeApplied.value,
              "promoCode": {
                "promoCodeId":
                    personalTrainerController.appliedPromoCode?.promoCodeId,
                "promoCode":
                    personalTrainerController.appliedPromoCode?.promoCode,
                "promoCodeName":
                    personalTrainerController.appliedPromoCode?.promoCodeName,
                "accessType":
                    personalTrainerController.appliedPromoCode?.accessType,
                "appUserCouponId":
                    personalTrainerController.appliedPromoCode?.appUserCouponId,
              },
            }
          },
        ));
      } else {
        showCustomSnackBar(
            context, "Failed to block session. Please try again later.");
      }
    } catch (e) {}
  }

  handleBookSlot(BuildContext context,
      PersonalTrainerController personalTrainerController) async {
    if (pageSource == "DAY_WISE_PROGRAM" ||
        pageSource == "TRAINER_SESSIONS" ||
        personalTrainerController.singleSessionPrice.value == 0) {
      bool isBooked = false;
      if (isReschedule == true) {
        isBooked = await personalTrainerController.rescheduleSlot(
            prevSessionTrainerId,
            prevSessionId,
            trainerDetails.coachId!,
            consultType,
            bookType,
            personalTrainerController.selectedSlot!.sessionId!);
      } else {
        isBooked = await personalTrainerController.bookSlot(
            trainerDetails.coachId!,
            personalTrainerController.selectedSlot!.sessionId!,
            consultType,
            bookType,
            "");
      }

      if (isBooked == true) {
        EventsService().sendEvent("Book_Trainer_Slots", {
          "trainerId": trainerDetails.coachId!,
          "trainerName": trainerDetails.coachName!,
          "consultType": consultType,
          "bookType": bookType,
          "pageSource": pageSource,
          "isReschedule": isReschedule,
          "prevSessionTrainerId": prevSessionTrainerId,
          "prevSessionId": prevSessionId,
        });

        if (pageSource == "DAY_WISE_PROGRAM") {
          TrainerSessionController trainerSessionController = Get.find();
          MyRoutineController myRoutineController = Get.find();
          await Future.wait([
            trainerSessionController.getSessionSummary(),
            trainerSessionController.getUpcomingSessions(),
          ]);
          await myRoutineController.checkUpcomingSession().then((value) {
            myRoutineController.organize();
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          EventsService().sendClickNextEvent(
              "TrainerSlots", "Book a Slot", "DayWiseProgramme");

          Future.delayed(Duration.zero, () {
            showScheduledSessionPopup(
                "THERAPIST",
                trainerDetails.coachName!,
                trainerDetails.profilePic!,
                DateFormat.yMMMd()
                    .format(personalTrainerController.selectedDate)
                    .toString(),
                DateFormat("hh:mm a").format(
                  dateFromTimestamp(
                      personalTrainerController.selectedSlot!.fromTime!),
                ));
          });
        } else if (pageSource == "TRAINER_SESSIONS") {
          TrainerSessionController trainerSessionController = Get.find();
          MyRoutineController myRoutineController = Get.find();
          await Future.wait([
            trainerSessionController.getSessionSummary(),
            trainerSessionController.getUpcomingSessions(),
          ]);
          await myRoutineController.checkUpcomingSession().then((value) {
            myRoutineController.organize();
          });
          trainerSessionController.setShowAll(true);
          Navigator.of(context).popUntil((route) => route.isFirst);
          Get.to(const TrainerSessions());
          EventsService().sendClickNextEvent(
              "TrainerSlots", "Book a Slot", "TrainerSessions");
        } else if (personalTrainerController.singleSessionPrice.value == 0) {
          MyRoutineController myRoutineController = Get.find();

          await myRoutineController.checkUpcomingSession().then((value) {
            myRoutineController.organize();
          });
          if (personalTrainerController.isPromoCodeApplied.value == true &&
              personalTrainerController.appliedPromoCode?.promoCodeId != null) {
            EventsService().sendEvent("Promo_Code_Transaction", {
              "pageSource": pageSource,
              "promo_code_id":
                  personalTrainerController.appliedPromoCode?.promoCodeId ?? "",
              "promo_code":
                  personalTrainerController.appliedPromoCode?.promoCode ?? "",
              "order_id": "FREE-PROMO-CODE",
              "currency": personalTrainerController
                      .selectedSingleTrainerSession?.currency?.billing ??
                  "",
              "total_payment": 0
            });
            dynamic postPromoCodeData = {
              "promoCodeId":
                  personalTrainerController.appliedPromoCode?.promoCodeId,
              "orderId": "FREE-PROMO-CODE"
            };
            await PaymentService().postPromoCodeTransaction(postPromoCodeData);
          }
          Navigator.of(context).popUntil((route) => route.isFirst);

          Future.delayed(Duration.zero, () {
            showScheduledSessionPopup(
                "THERAPIST",
                trainerDetails.coachName ?? "",
                trainerDetails.profilePic ?? "",
                DateFormat.yMMMd()
                    .format(personalTrainerController.selectedDate)
                    .toString(),
                DateFormat("hh:mm a").format(
                  dateFromTimestamp(
                      personalTrainerController.selectedSlot!.fromTime!),
                ));
          });
        }
      } else {
        showGetSnackBar("FAILED_TO_BOOK".tr, SnackBarMessageTypes.Info);
        Navigator.pop(context);
      }
    }
  }
}
