import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/check_slot/doctor_slot.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'todays_doctor_available_slots.dart';

class DoctorCard extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String bookType;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionDoctorId;
  final bool showSessionPrice;
  final String currency;
  final double singleSessionPrice;
  final CoachListModelCoachList doctorDetails;
  const DoctorCard({
    Key? key,
    required this.showSessionPrice,
    required this.currency,
    required this.singleSessionPrice,
    required this.doctorDetails,
    required this.pageSource,
    required this.consultType,
    required this.bookType,
    required this.isReschedule,
    required this.prevSessionId,
    required this.prevSessionDoctorId,
  }) : super(key: key);

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
                    "DOCTOR", doctorDetails.profilePic, 64, 64),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        doctorDetails.coachName!,
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
                        "Speciality : ${doctorDetails.speciality!.join(", ")}",
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
                        "Speaks : ${doctorDetails.speaks!.join(", ")}",
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
                          "${doctorDetails.rating ?? ""}",
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
          TodaysDoctorAvailableSlots(
            pageSource: pageSource,
            doctorDetails: doctorDetails,
            consultType: consultType,
            bookType: bookType,
            isReschedule: isReschedule,
            prevSessionDoctorId: prevSessionDoctorId,
            prevSessionId: prevSessionId,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                DoctorController doctorController = Get.find();
                EventsService().sendClickNextEvent(
                    "BookDoctorSession", "Check Slots", "DoctorSlots");
                if (consultType == "GOT QUERY" &&
                    bookType == "PAID" &&
                    isReschedule == false) {
                  EventsService().sendEvent("Single_Doctor_Payment_Selection", {
                    "doctor_id": doctorDetails.coachId,
                    "doctor_name": doctorDetails.coachName,
                    "single_session_price":
                        doctorController.singleSessionPrice.value
                  });
                }

                Get.to(
                  DoctorSlots(
                    pageSource: pageSource,
                    consultType: consultType,
                    doctorId: doctorDetails.coachId!,
                    bookType: bookType,
                    isReschedule: isReschedule,
                    prevSessionId: prevSessionId,
                    prevSessionDoctorId: prevSessionDoctorId,
                  ),
                )!
                    .then((value) {
                  EventsService().sendClickBackEvent(
                    "DoctorSlots",
                    "Back",
                    "BookDoctorSession",
                  );
                });
              },
              child: Container(
                height: 36.h,
                width: double.infinity,
                padding: pageHorizontalPadding(),
                color: const Color(0xFFE5E5E5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: showSessionPrice,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Per Session:",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: const Color(0xFF7A8A98),
                              fontFamily: 'Circular Std',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.h,
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            "$currency ${getFormattedNumber(singleSessionPrice)}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: const Color(0xFF7A8A98),
                              fontFamily: 'Circular Std',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: showSessionPrice, child: const Spacer()),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.calenderSVG,
                          width: 16.w,
                          height: 16.h,
                          color: AppColors.primaryLabelColor,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "CHECK_SLOTS".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primaryLabelColor,
                            fontFamily: 'Circular Std',
                            fontSize: 11.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w700,
                            height: 1.h,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
