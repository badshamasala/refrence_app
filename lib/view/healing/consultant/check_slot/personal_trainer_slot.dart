import 'package:aayu/controller/consultant/personal_trainer_controller.dart';
import 'package:aayu/controller/consultant/trainer_session_controller.dart';
import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/check_slot/personal_trainer_available_slots.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../services/payment.service.dart';
import '../../../payment/juspay_payment.dart';
import 'widgets/consult_details.dart';
import 'widgets/consult_profile.dart';

class PersonalTrainerSlots extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String trainerId;
  final String bookType;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionTrainerId;
  const PersonalTrainerSlots({
    Key? key,
    this.pageSource = "",
    required this.consultType,
    required this.trainerId,
    required this.bookType,
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionTrainerId = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersonalTrainerController personalTrainerController = Get.find();
    Future.delayed(Duration.zero, () async {
      await Future.wait([
        personalTrainerController.getTrainerAvailableSlots(trainerId),
        personalTrainerController.getTrainerProfile(trainerId),
      ]);
    });

    return Scaffold(
      body: Obx(() {
        if (personalTrainerController.isProfileLoading.value == true) {
          return showLoading();
        } else if (personalTrainerController.trainerProfile.value == null) {
          return showLoading();
        } else if (personalTrainerController
                .trainerProfile.value!.coachDetails ==
            null) {
          return showLoading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConsultProfile(
              consultType: "TRAINER",
              profilePic: personalTrainerController
                  .trainerProfile.value!.coachDetails!.profilePic!,
              consultName: personalTrainerController
                  .trainerProfile.value!.coachDetails!.coachName!,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: pageHorizontalPadding(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConsultDetails(
                      consultType: "DOCTOR",
                      profilePic: personalTrainerController
                          .trainerProfile.value!.coachDetails!.profilePic!,
                      consultName: personalTrainerController
                          .trainerProfile.value!.coachDetails!.coachName!,
                      speciality: personalTrainerController
                          .trainerProfile.value!.coachDetails!.speciality!
                          .join(", "),
                      speaks: personalTrainerController
                          .trainerProfile.value!.coachDetails!.speaks!
                          .join(", "),
                      rating: personalTrainerController
                          .trainerProfile.value!.coachDetails!.rating!,
                      desc: personalTrainerController
                          .trainerProfile.value!.coachDetails!.bio!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const PersonalTrainerAvailableSlots()
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
          child: GetBuilder<PersonalTrainerController>(
              id: "AvailableSlotAction",
              builder: (personalTrainerController) {
                return personalTrainerController.checkSlotSeleted() == false
                    ? disabledButton((consultType == "GOT QUERY" &&
                            bookType == "PAID" &&
                            isReschedule == false &&
                            personalTrainerController
                                    .singleSessionPrice.value !=
                                0)
                        ? "BLOCK_SLOT".tr
                        : "BOOK_SLOT".tr)
                    : InkWell(
                        onTap: () async {
                          if (consultType == "GOT QUERY" &&
                              bookType == "PAID" &&
                              isReschedule == false &&
                              personalTrainerController
                                      .singleSessionPrice.value !=
                                  0) {
                            confirmBlockSlot(
                                context, personalTrainerController);
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
                            ? "BLOCK_SLOT".tr
                            : "BOOK_SLOT".tr),
                      );
              }),
        ),
      ],
    );
  }

  confirmBlockSlot(BuildContext context,
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
                        personalTrainerController
                            .trainerProfile.value!.coachDetails!.coachName!,
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
                          "trainer_id": personalTrainerController
                              .trainerProfile.value!.coachDetails!.coachId!,
                          "trainer_name": personalTrainerController
                              .trainerProfile.value!.coachDetails!.coachName!,
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
                        handleBlockSlot(context, personalTrainerController);
                      },
                      child: mainButton("Pay Now"),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0.w,
                right: 0,
                child: circularConsultImage(
                    "TRAINER",
                    personalTrainerController
                        .trainerProfile.value!.coachDetails!.profilePic,
                    110,
                    110),
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

  handleBlockSlot(BuildContext context,
      PersonalTrainerController personalTrainerController) async {
    try {
      buildShowDialog(context);
      bool isBlocked = await personalTrainerController.blockSlot(
          personalTrainerController
              .trainerProfile.value!.coachDetails!.coachId!,
          personalTrainerController.selectedSlot!.sessionId!);
      Navigator.pop(context);
      if (isBlocked == true) {
        EventsService().sendEvent("Block_Trainer_Slot", {
          "total_payment": personalTrainerController.singleSessionPrice,
          "trainer_id": personalTrainerController
              .trainerProfile.value!.coachDetails!.coachId!,
          "trainer_name": personalTrainerController
              .trainerProfile.value!.coachDetails!.coachName!,
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
            "trainerId": personalTrainerController
                .trainerProfile.value!.coachDetails!.coachId!,
            "trainerName": personalTrainerController
                .trainerProfile.value!.coachDetails!.coachName!,
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
            personalTrainerController
                .trainerProfile.value!.coachDetails!.coachId!,
            consultType,
            bookType,
            personalTrainerController.selectedSlot!.sessionId!);
      } else {
        isBooked = await personalTrainerController.bookSlot(
            personalTrainerController
                .trainerProfile.value!.coachDetails!.coachId!,
            personalTrainerController.selectedSlot!.sessionId!,
            consultType,
            bookType,
            "");
      }

      if (isBooked == true) {
        EventsService().sendEvent("Book_Trainer_Slots", {
          "trainerId": personalTrainerController
              .trainerProfile.value!.coachDetails!.coachId!,
          "trainerName": personalTrainerController
              .trainerProfile.value!.coachDetails!.coachName!,
          "consultType": consultType,
          "bookType": bookType,
          "pageSource": pageSource,
          "mediator": "AGORA",
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
                personalTrainerController
                    .trainerProfile.value!.coachDetails!.coachName!,
                personalTrainerController
                    .trainerProfile.value!.coachDetails!.profilePic!,
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
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
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
                personalTrainerController
                    .trainerProfile.value!.coachDetails!.coachName!,
                personalTrainerController
                    .trainerProfile.value!.coachDetails!.profilePic!,
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
