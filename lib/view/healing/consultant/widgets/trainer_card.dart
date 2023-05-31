import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/widgets/todays_trainer_available_slots.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/personal_trainer_controller.dart';
import '../check_slot/personal_trainer_slot.dart';

class TrainerCard extends StatelessWidget {
  final String pageSource;
  final String consultType;
  final String bookType;
  final bool isReschedule;
  final String prevSessionId;
  final String prevSessionTrainerId;
  final bool showSessionPrice;
  final String currency;
  final double singleSessionPrice;
  final CoachListModelCoachList trainerDetails;
  const TrainerCard({
    Key? key,
    required this.showSessionPrice,
    required this.currency,
    required this.singleSessionPrice,
    required this.pageSource,
    required this.consultType,
    required this.bookType,
    required this.isReschedule,
    required this.prevSessionId,
    required this.prevSessionTrainerId,
    required this.trainerDetails,
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
                    "TRAINER", trainerDetails.profilePic ?? "", 64, 64),
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
                        trainerDetails.coachName ?? "",
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
                        "Speciality : ${trainerDetails.speciality!.join(", ")}",
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
                        "Speaks : ${trainerDetails.speaks!.join(", ")}",
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
                          "${trainerDetails.rating ?? ""}",
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
          TodaysTrainerAvailableSlots(
            pageSource: pageSource,
            trainerDetails: trainerDetails,
            consultType: consultType,
            bookType: bookType,
            isReschedule: isReschedule,
            prevSessionTrainerId: prevSessionTrainerId,
            prevSessionId: prevSessionId,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                PersonalTrainerController personalTrainerController =
                    Get.find();
                EventsService().sendClickNextEvent(
                    "BookTrainerSession", "Check Slots", "TrainerSlots");
                if (consultType == "GOT QUERY" &&
                    bookType == "PAID" &&
                    isReschedule == false) {
                  EventsService().sendEvent("Single_Trainer_Payment_Selected", {
                    "trainer_id": trainerDetails.coachId,
                    "trainer_name": trainerDetails.coachName,
                    "single_session_price":
                        personalTrainerController.singleSessionPrice.value,
                  });
                }

                Get.to(
                  PersonalTrainerSlots(
                    pageSource: pageSource,
                    consultType: consultType,
                    trainerId: trainerDetails.coachId!,
                    bookType: bookType,
                    isReschedule: isReschedule,
                    prevSessionId: prevSessionId,
                    prevSessionTrainerId: prevSessionTrainerId,
                  ),
                )!
                    .then((value) {
                  EventsService().sendClickBackEvent(
                    "TrainerSlots",
                    "Back",
                    "BookTrainerSession",
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
