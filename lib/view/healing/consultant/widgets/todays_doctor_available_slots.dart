import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/controller/consultant/doctor_session_controller.dart';
import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/check_slot/confirming_slot.dart';
import 'package:aayu/view/healing/consultant/check_slot/doctor_appointment_details.dart';
import 'package:aayu/view/payment/juspay_payment.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../services/payment.service.dart';

class TodaysDoctorAvailableSlots extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String bookType;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionDoctorId;
  final CoachListModelCoachList doctorDetails;
  const TodaysDoctorAvailableSlots(
      {Key? key,
      required this.doctorDetails,
      required this.consultType,
      required this.bookType,
      required this.isReschedule,
      required this.pageSource,
      required this.prevSessionId,
      required this.prevSessionDoctorId})
      : super(key: key);

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
          (doctorDetails.availableSlots != null &&
                  doctorDetails.availableSlots!.isNotEmpty)
              ? Container(
                  constraints: BoxConstraints(maxHeight: 80.h),
                  child: SingleChildScrollView(
                    child: GetBuilder<DoctorController>(
                        id: "coachListAvailableSlots",
                        builder: (doctorController) {
                          return Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            spacing: 3.w,
                            runSpacing: 6.h,
                            children: List.generate(
                              doctorDetails.availableSlots!.length,
                              (index) {
                                return InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    for (var element in doctorController
                                        .doctorList.value!.coachList!) {
                                      for (var item
                                          in element!.availableSlots!) {
                                        item!.selected = false;
                                      }
                                    }
                                    doctorDetails.availableSlots![index]!
                                        .selected = true;
                                    doctorController
                                        .update(["coachListAvailableSlots"]);
                                    if (doctorDetails
                                            .availableSlots![index]!.selected ==
                                        true) {
                                      doctorController.selectedSlot =
                                          CoachAvailableSlotsModelAvailableSlots
                                              .fromJson(doctorDetails
                                                  .availableSlots![index]!
                                                  .toJson());
                                      confirmSlot(context, doctorController);
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    width: 70.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32.w),
                                      color: doctorDetails
                                                  .availableSlots![index]!
                                                  .selected ==
                                              true
                                          ? AppColors.primaryColor
                                          : const Color(0xFFE5E5E5),
                                    ),
                                    child: Text(
                                      DateFormat.jm().format(dateFromTimestamp(
                                          doctorDetails.availableSlots![index]!
                                              .fromTime!)),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: doctorDetails
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

  confirmSlot(BuildContext context, DoctorController doctorController) {
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
                        doctorDetails.coachName!,
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
                          "doctor_id": doctorDetails.coachId,
                          "doctor_name": doctorDetails.coachName,
                          "single_session_price":
                              doctorController.singleSessionPrice.value,
                          "selected_date": DateFormat.yMMMd()
                              .format(doctorController.selectedDate)
                              .toString(),
                          "from_time": DateFormat.jm().format(dateFromTimestamp(
                              doctorController.selectedSlot!.fromTime!)),
                          "to_time": DateFormat.jm().format(dateFromTimestamp(
                              doctorController.selectedSlot!.toTime!)),
                        });
                        if (consultType == "GOT QUERY" &&
                            bookType == "PAID" &&
                            isReschedule == false &&
                            doctorController.singleSessionPrice.value != 0) {
                          handleBlockSlot(context, doctorController);
                        } else {
                          handleBookSlot(context, doctorController);
                        }
                      },
                      child: mainButton((consultType == "GOT QUERY" &&
                              bookType == "PAID" &&
                              isReschedule == false &&
                              doctorController.singleSessionPrice.value != 0)
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
                    "DOCTOR", doctorDetails.profilePic, 110, 110),
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
          doctorDetails.coachId!, doctorController.selectedSlot!.sessionId!);
      Navigator.pop(context);
      if (isBlocked == true) {
        EventsService().sendEvent("Block_Doctor_Slot", {
          "total_payment": doctorController.singleSessionPrice,
          "doctor_id": doctorDetails.coachId!,
          "doctor_name": doctorDetails.coachName!,
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
            "pageSource": "DOCTOR_LIST",
            "selectedConsultingPackage":
                doctorController.selectedSingleDoctorSession!.toJson(),
            "consultationType": "DOCTOR",
            "doctorId": doctorDetails.coachId!,
            "doctorName": doctorDetails.coachName!,
            "sessionId": doctorController.selectedSlot!.sessionId,
            "consultType": consultType,
            "bookType": bookType,
            "scheduleDate": DateFormat.yMMMd()
                .format(doctorController.selectedDate)
                .toString(),
            "scheduleTime": doctorController.selectedSlot!.fromTime!,
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
                    doctorDetails.coachId!,
                    consultType,
                    bookType,
                    doctorController.selectedSlot!.sessionId!);
              } else {
                isBooked = await doctorController.bookSlot(
                    doctorDetails.coachId!,
                    doctorController.selectedSlot!.sessionId!,
                    consultType,
                    bookType,
                    "");
                if (isBooked == true) {
                  MyRoutineController myRoutineController = Get.find();
                  myRoutineController.getData();
                }
              }

              if (isBooked == true) {
                EventsService().sendEvent("Book_Doctor_Slots", {
                  "doctorId": doctorDetails.coachId!,
                  "doctorName": doctorDetails.coachName!,
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DayWiseProgramme");
                  Future.delayed(Duration.zero, () {
                    showScheduledSessionPopup(
                        "DOCTOR",
                        doctorDetails.coachName!,
                        doctorDetails.profilePic!,
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
                  await Future.wait(
                      [doctorSessionController.getSessionSummary()]);
                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DoctorAppointmentDetails");
                  Get.to(
                    DoctorAppointmentDetails(
                      doctorId: doctorDetails.coachId!,
                      doctorName: doctorDetails.coachName!,
                      doctorProfilePic: doctorDetails.profilePic!,
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  DoctorSessionController doctorSessionController = Get.find();
                  await Future.wait(
                      [doctorSessionController.getSessionSummary()]);
                  EventsService().sendClickNextEvent(
                      "DoctorSlots", "Book a Slot", "DoctorAppointmentDetails");
                  Get.to(
                    DoctorAppointmentDetails(
                      doctorId: doctorDetails.coachId!,
                      doctorName: doctorDetails.coachName!,
                      doctorProfilePic: doctorDetails.profilePic!,
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
                        doctorDetails.coachName ?? "",
                        doctorDetails.profilePic ?? "",
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
