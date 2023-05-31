import 'package:aayu/model/model.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions_info.dart';
import 'package:aayu/view/healing/consultant/trainer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/consultant/trainer_session_controller.dart';
import '../../../../services/hive.service.dart';
import '../../../../services/third-party/events.service.dart';
import '../../../../theme/app_colors.dart';
import '../../../shared/constants.dart';
import '../../../shared/ui_helper/images.dart';
import '../../../shared/ui_helper/ui_helper.dart';

class TrainerSessionRoutineWidget extends StatelessWidget {
  const TrainerSessionRoutineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (globalUserIdDetails?.userId == null) {
          userLoginDialog({"screenName": "BOOK_TRAINER_CONSULT"});
          return;
        }
        HiveService().isFirstTimeTrainerSession().then((value) {
          if (value == true) {
            Get.bottomSheet(
              TrainerSessionsInfo(
                bookFunction: () {
                  Navigator.of(context).pop();
                  handleClick(context);
                },
              ),
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: false,
            ).then((value) {
              HiveService().initFirstTimeTrainerSession();
            });
          } else {
            handleClick(context);
          }
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 180.h,
            width: 155.w,
            decoration: const BoxDecoration(
                color: AppColors.shareAayuBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.only(top: 42.0, left: 16.0, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Online Therapist",
                    style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Circular Std"),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Text(
                    'Hire authentic yoga therapist who can guide you to reach your health goals.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Schedule Now',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xFF3E3A93),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11.h,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 14.w,
            top: -25,
            child: Image.asset(
              Images.personalTraining2Image,
              height: 60.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }

  handleClick(BuildContext context) {
    TrainerSessionController trainerSessionController = Get.find();

    if (trainerSessionController.upcomingSessionsList.value != null &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions != null &&
        trainerSessionController.upcomingSessionsList.value!.upcomingSessions!.isNotEmpty) {
      CoachUpcomingSessionsModelUpcomingSessions? pendingSession = trainerSessionController
          .upcomingSessionsList.value!.upcomingSessions!
          .firstWhereOrNull((element) => element!.status == 'PENDING');
      if (pendingSession != null) {
        EventsService().sendClickNextEvent(
            "TrainerConsultationInfo", "Select Trainer", "TrainerSessions");
        Get.to(const TrainerSessions());
      } else {
        redirectToTrainerList(context);
      }
    } else {
      redirectToTrainerList(context);
    }
  }

  redirectToTrainerList(BuildContext context) async {
    bool isAllowed = await checkIsPaymentAllowed("THERAPIST_CONSULTATION");
    if (isAllowed == true) {
      Get.to(TrainerList(
        pageSource: "MY_ROUTINE",
        consultType: "GOT QUERY",
        bookType: "PAID",
      ));
    }
  }
}
