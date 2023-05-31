// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/check_slot/confirming_slot.dart';
import 'package:aayu/view/healing/consultant/check_slot/doctor_appointment_details.dart';
import 'package:aayu/view/healing/consultant/check_slot/doctor_available_slots.dart';
import 'package:aayu/view/healing/consultant/check_slot/widgets/consult_profile.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../services/payment.service.dart';
import 'widgets/consult_details.dart';

class DoctorSlots extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String doctorId;
  final String bookType;

  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionDoctorId;

  const DoctorSlots({
    Key? key,
    this.pageSource = "",
    required this.consultType,
    required this.doctorId,
    required this.bookType,
    this.isReschedule = false,
    this.prevSessionId = "",
    this.prevSessionDoctorId = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorController doctorController = Get.find();
    Future.delayed(Duration.zero, () async {
      await Future.wait([
        doctorController.getDoctorAvailableSlots(doctorId),
        doctorController.getDoctorProfile(doctorId),
      ]);
    });

    return Scaffold(
      body: Obx(() {
        if (doctorController.isProfileLoading.value == true) {
          return showLoading();
        } else if (doctorController.doctorProfile.value == null) {
          return showLoading();
        } else if (doctorController.doctorProfile.value!.coachDetails == null) {
          return showLoading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConsultProfile(
              consultType: "DOCTOR",
              profilePic: doctorController
                  .doctorProfile.value!.coachDetails!.profilePic!,
              consultName: doctorController
                  .doctorProfile.value!.coachDetails!.coachName!,
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
                      profilePic: doctorController
                          .doctorProfile.value!.coachDetails!.profilePic!,
                      consultName: doctorController
                          .doctorProfile.value!.coachDetails!.coachName!,
                      speciality: doctorController
                          .doctorProfile.value!.coachDetails!.speciality!
                          .join(", "),
                      speaks: doctorController
                          .doctorProfile.value!.coachDetails!.speaks!
                          .join(", "),
                      rating: doctorController
                          .doctorProfile.value!.coachDetails!.rating!,
                      desc: doctorController
                          .doctorProfile.value!.coachDetails!.bio!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const DoctorAvailableSlots()
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
          child: GetBuilder<DoctorController>(
            id: "AvailableSlotAction",
            builder: (doctorController) {
              return doctorController.checkSlotSeleted() == false
                  ? disabledButton((consultType == "GOT QUERY" &&
                          bookType == "PAID" &&
                          isReschedule == false &&
                          doctorController.singleSessionPrice.value != 0)
                      ? "BLOCK_SLOT".tr
                      : "BOOK_SLOT".tr)
                  : InkWell(
                      onTap: () async {
                        if (consultType == "GOT QUERY" &&
                            bookType == "PAID" &&
                            isReschedule == false &&
                            doctorController.singleSessionPrice.value != 0) {
                          confirmBlockSlot(context, doctorController);
                        } else {
                          handleBookSlot(context, doctorController);
                        }
                      },
                      child: mainButton((consultType == "GOT QUERY" &&
                              bookType == "PAID" &&
                              isReschedule == false)
                          ? "BLOCK_SLOT".tr
                          : "BOOK_SLOT".tr),
                    );
            },
          ),
        ),
      ],
    );
  }

  confirmBlockSlot(BuildContext context, DoctorController doctorController) {
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
                        doctorController
                            .doctorProfile.value!.coachDetails!.coachName!,
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
                              .format(doctorController.selectedDate)
                              .toString(),
                        ),
                        Divider(
                          color: AppColors.secondaryLabelColor.withOpacity(0.1),
                        ),
                        selectedCallDetails(
                            "Time: ",
                            DateFormat.jm().format(dateFromTimestamp(
                                doctorController.selectedSlot!.fromTime!))),
                      ]),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    InkWell(
                      onTap: () {
                        EventsService()
                            .sendEvent("Single_Doctor_Payment_Selected", {
                          "doctor_id": doctorController
                              .doctorProfile.value!.coachDetails!.coachId,
                          "doctor_name": doctorController
                              .doctorProfile.value!.coachDetails!.coachName,
                          "single_session_price":
                              doctorController.singleSessionPrice.value,
                          "selected_date": DateFormat.yMMMd()
                              .format(doctorController.selectedDate)
                              .toString(),
                          "from_time": doctorController.selectedSlot!.fromTime!,
                          "to_time": doctorController.selectedSlot!.fromTime!,
                        });
                        handleBlockSlot(context, doctorController);
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
                    "DOCTOR",
                    doctorController
                        .doctorProfile.value!.coachDetails!.profilePic,
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

  handleBlockSlot(
      BuildContext context, DoctorController doctorController) async {
    try {
      buildShowDialog(context);
      bool isBlocked = await doctorController.blockSlot(
          doctorController.doctorProfile.value!.coachDetails!.coachId!,
          doctorController.selectedSlot!.sessionId!);
      Navigator.pop(context);
      if (isBlocked == true) {
        EventsService().sendEvent("Block_Doctor_Slot", {
          "total_payment": doctorController.singleSessionPrice,
          "doctor_id":
              doctorController.doctorProfile.value!.coachDetails!.coachId!,
          "doctor_name":
              doctorController.doctorProfile.value!.coachDetails!.coachName!,
          "consult_type": consultType,
          "book_type": bookType,
        });
        Navigator.pop(context);
        Get.to(JuspayPayment(
          pageSource: "CONFIRM_DOCTOR_CONSULTATION",
          totalPayment: doctorController.singleSessionPrice.value,
          currency:
              doctorController.selectedSingleDoctorSession!.currency!.billing ??
                  "",
          paymentEvent: "DOCTOR_CONSULTATION",
          customData: {
            "pageSource": pageSource,
            "selectedConsultingPackage":
                doctorController.selectedSingleDoctorSession!.toJson(),
            "consultationType": "DOCTOR",
            "doctorId":
                doctorController.doctorProfile.value!.coachDetails!.coachId!,
            "doctorName":
                doctorController.doctorProfile.value!.coachDetails!.coachName!,
            "sessionId": doctorController.selectedSlot!.sessionId,
            "consultType": consultType,
            "bookType": bookType,
            "scheduleDate": DateFormat.yMMMd()
                .format(
                    dateFromTimestamp(doctorController.selectedSlot!.fromTime!))
                .toString(),
            "scheduleTime": DateFormat.jm()
                .format(
                    dateFromTimestamp(doctorController.selectedSlot!.fromTime!))
                .toString(),
            "promoCodeDetails": {
              "isApplied": doctorController.isPromoCodeApplied.value,
              "promoCode": {
                "promoCodeId": doctorController.appliedPromoCode?.promoCodeId,
                "promoCode": doctorController.appliedPromoCode?.promoCode,
                "promoCodeName":
                    doctorController.appliedPromoCode?.promoCodeName,
                "accessType": doctorController.appliedPromoCode?.accessType,
                "appUserCouponId":
                    doctorController.appliedPromoCode?.appUserCouponId,
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

  handleBookSlot(BuildContext context, DoctorController doctorController) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmingSlot(
          isScheduled: pageSource == "DAY_WISE_PROGRAM" ? true : false,
          consultationType: "DOCTOR",
          bookCall: () async {
            if (pageSource == "DAY_WISE_PROGRAM" ||
                pageSource == "PROGRAM_DETAILS" ||
                pageSource == "DOCTOR_SESSIONS" ||
                pageSource == "PERSONAL_CARE_PAYMENT" ||
                doctorController.singleSessionPrice.value == 0) {
              bool isBooked = false;
              if (isReschedule == true) {
                isBooked = await doctorController.rescheduleSlot(
                    prevSessionDoctorId,
                    prevSessionId,
                    doctorController
                        .doctorProfile.value!.coachDetails!.coachId!,
                    consultType,
                    bookType,
                    doctorController.selectedSlot!.sessionId!);
              } else {
                isBooked = await doctorController.bookSlot(
                    doctorController
                        .doctorProfile.value!.coachDetails!.coachId!,
                    doctorController.selectedSlot!.sessionId!,
                    consultType,
                    bookType,
                    "");
                if (isBooked == true) {
                  MyRoutineController myRoutineController = Get.find();
                  myRoutineController.checkUpcomingSession().then((value) {
                    myRoutineController.organize();
                  });
                }
              }

              if (isBooked == true) {
                EventsService().sendEvent("Book_Doctor_Slots", {
                  "doctorId": doctorController
                      .doctorProfile.value!.coachDetails!.coachId!,
                  "doctorName": doctorController
                      .doctorProfile.value!.coachDetails!.coachName!,
                  "consultType": consultType,
                  "bookType": bookType,
                  "pageSource": pageSource,
                  "isReschedule": isReschedule,
                  "prevSessionDoctorId": prevSessionDoctorId,
                  "prevSessionId": prevSessionId,
                });

                if (pageSource == "DAY_WISE_PROGRAM") {
                  DoctorSessionController doctorSessionController = Get.find();
                  await Future.wait([
                    doctorSessionController.getSessionSummary(),
                    doctorSessionController.getUpcomingSessions(),
                  ]);
                  MyRoutineController myRoutineController = Get.find();
                  await myRoutineController.checkUpcomingSession();
                  myRoutineController.organize();

                  /* Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context); */
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DayWiseProgramme");

                  Future.delayed(Duration.zero, () {
                    showScheduledSessionPopup(
                        "DOCTOR",
                        doctorController
                            .doctorProfile.value!.coachDetails!.coachName!,
                        doctorController
                            .doctorProfile.value!.coachDetails!.profilePic!,
                        DateFormat.yMMMd()
                            .format(doctorController.selectedDate)
                            .toString(),
                        DateFormat("hh:mm a").format(
                          dateFromTimestamp(
                              doctorController.selectedSlot!.fromTime!),
                        ));
                  });
                } else if (pageSource == "PROGRAM_DETAILS") {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  DoctorSessionController doctorSessionController = Get.find();
                  await Future.wait([
                    doctorSessionController.getSessionSummary(),
                  ]);

                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DoctorAppointmentDetails");
                  Get.to(
                    DoctorAppointmentDetails(
                      doctorId: doctorController
                          .doctorProfile.value!.coachDetails!.coachId!,
                      doctorName: doctorController
                          .doctorProfile.value!.coachDetails!.coachName!,
                      doctorProfilePic: doctorController
                          .doctorProfile.value!.coachDetails!.profilePic!,
                      selectedSlot: doctorController.selectedSlot!,
                      consultType: consultType,
                    ),
                  );
                } else if (pageSource == "DOCTOR_SESSIONS") {
                  DoctorSessionController doctorSessionController = Get.find();
                  await Future.wait([
                    doctorSessionController.getSessionSummary(),
                    doctorSessionController.getUpcomingSessions(),
                  ]);
                  doctorSessionController.setShowAll(true);
                  MyRoutineController myRoutineController = Get.find();
                  await myRoutineController.checkUpcomingSession();
                  myRoutineController.organize();

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DoctorSessions");
                } else if (pageSource == "PERSONAL_CARE_PAYMENT") {
                  /* Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context); */

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  DoctorSessionController doctorSessionController = Get.find();
                  await Future.wait([
                    doctorSessionController.getSessionSummary(),
                  ]);

                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DoctorAppointmentDetails");
                  Get.to(
                    DoctorAppointmentDetails(
                      doctorId: doctorController
                          .doctorProfile.value!.coachDetails!.coachId!,
                      doctorName: doctorController
                          .doctorProfile.value!.coachDetails!.coachName!,
                      doctorProfilePic: doctorController
                          .doctorProfile.value!.coachDetails!.profilePic!,
                      selectedSlot: doctorController.selectedSlot!,
                      consultType: "GOT QUERY", // consultType,
                    ),
                    // GOT QUERY passed to start the assessment
                  );
                } else if (doctorController.singleSessionPrice.value == 0) {
                  if (doctorController.isPromoCodeApplied.value == true &&
                      doctorController.appliedPromoCode?.promoCodeId != null) {
                    EventsService().sendEvent("Promo_Code_Transaction", {
                      "pageSource": pageSource,
                      "promo_code_id":
                          doctorController.appliedPromoCode?.promoCodeId ?? "",
                      "promo_code":
                          doctorController.appliedPromoCode?.promoCode ?? "",
                      "order_id": "FREE-PROMO-CODE",
                      "currency": doctorController
                              .selectedSingleDoctorSession?.currency?.billing ??
                          "",
                      "total_payment": 0
                    });
                    dynamic postPromoCodeData = {
                      "promoCodeId":
                          doctorController.appliedPromoCode?.promoCodeId,
                      "orderId": "FREE-PROMO-CODE"
                    };
                    await PaymentService()
                        .postPromoCodeTransaction(postPromoCodeData);
                  }

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Future.delayed(Duration.zero, () {
                    showScheduledSessionPopup(
                        "DOCTOR",
                        doctorController
                                .doctorProfile.value?.coachDetails?.coachName ??
                            "",
                        doctorController.doctorProfile.value?.coachDetails
                                ?.profilePic ??
                            "",
                        DateFormat.yMMMd()
                            .format(doctorController.selectedDate)
                            .toString(),
                        DateFormat("hh:mm a").format(
                          dateFromTimestamp(
                              doctorController.selectedSlot!.fromTime!),
                        ));
                  });
                }
              } else {
                Navigator.pop(context);
                showGetSnackBar("FAILED_TO_BOOK".tr, SnackBarMessageTypes.Info);
              }
            }
          },
        ),
      ),
    );
  }
}
