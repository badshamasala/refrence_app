import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/consultant/doctor_session_controller.dart';
import '../../../services/third-party/events.service.dart';
import '../../../theme/app_theme.dart';
import '../../healing/consultant/doctor_list.dart';
import '../../healing/consultant/sessions/doctor_sessions.dart';
import '../../shared/ui_helper/images.dart';

class ThankYouBookDoctorDeepLink extends StatelessWidget {
  final Map<String, dynamic> data;
  ThankYouBookDoctorDeepLink({
    Key? key,
    required this.data,
  }) : super(key: key);
  String diseaseName = "";

  @override
  Widget build(BuildContext context) {
    YouController youController = Get.put(YouController());
    return Scaffold(
        backgroundColor: AppColors.lightPrimaryColor,
        body: Obx(() {
          if (youController.isLoading.value) {
            return showLoading();
          } else if (youController.userDetails.value == null) {
            return showLoading();
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 127.h,
                      ),
                      Text(
                        'Thank you ${youController.userDetails.value!.userDetails!.firstName ?? ""} ${youController.userDetails.value!.userDetails!.lastName ?? ""}',
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "for taking the time out to register. ",
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 147.h,
                      ),
                      Stack(clipBehavior: Clip.none, children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              top: 114.h,
                              bottom: 74.h,
                              left: 21.w,
                              right: 21.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Book Doctor Consultation',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Baskerville',
                                    color: AppColors.blackLabelColor,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "You’re a few steps away from getting answers to your health queries.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.blueGreyAssessmentColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: -123.h,
                          left: 0,
                          right: 0,
                          child: Image.asset(
                            Images.doctorImageDeeplinkImsge,
                            height: 220.h,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Positioned(
                          bottom: -18.h,
                          left: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () async {
                              buildShowDialog(context);
                              DoctorSessionController doctorSessionController =
                                  Get.put(DoctorSessionController());
                              await doctorSessionController
                                  .getUpcomingSessions();
                              if (doctorSessionController
                                          .upcomingSessionsList.value !=
                                      null &&
                                  doctorSessionController.upcomingSessionsList
                                          .value!.upcomingSessions !=
                                      null &&
                                  doctorSessionController.upcomingSessionsList
                                      .value!.upcomingSessions!.isNotEmpty) {
                                CoachUpcomingSessionsModelUpcomingSessions?
                                    pendingSession = doctorSessionController
                                        .upcomingSessionsList
                                        .value!
                                        .upcomingSessions!
                                        .firstWhereOrNull((element) =>
                                            element!.status == 'PENDING');
                                if (pendingSession != null) {
                                  EventsService().sendClickNextEvent(
                                      "DoctorConsultationInfo",
                                      "Select Doctor",
                                      "DoctorSessions");

                                  Get.to(const DoctorSessions());
                                } else {
                                  redirectToDoctorList(context);
                                }
                              } else {
                                redirectToDoctorList(context);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 55.w),
                              height: 44.h,
                              decoration: AppTheme.mainButtonDecoration,
                              child: Center(
                                child: Text(
                                  "Start Now",
                                  textAlign: TextAlign.center,
                                  style: mainButtonTextStyle(),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  'De-stress yourself with guided yoga, meditation, calming music, daily affirmations and a lot more to help you heal and grow.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Explore Aayu',
                    style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        decoration: TextDecoration.underline),
                  )),
              SizedBox(
                height: 33.h,
              )
            ],
          );
        })

        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       child: const Text('Explore more'),
        //     ),
        //     ElevatedButton(
        //       onPressed: () {
        //         EventsService().sendClickNextEvent(
        //             "Healing List", "View Program", "Disease Details");
        //         Get.close(1);
        //         Get.to(const DiseaseDetails(
        //           fromThankYou: true,
        //         ))!
        //             .then((value) {
        //           EventsService().sendClickBackEvent(
        //               "Disease Details", "Back", "Healing List");
        //         });
        //       },
        //       child: Text('Start $diseaseName Program'),
        //     ),
        //   ],
        // ),
        );
  }

  redirectToDoctorList(BuildContext context) async {
    EventsService().sendClickNextEvent(
        "DoctorConsultationInfo", "Select Doctor", "DoctorList");
    Navigator.of(context).popUntil((route) => route.isFirst);
    Get.to(DoctorList(
      pageSource: "MY_ROUTINE",
      consultType: "GOT QUERY",
      bookType: "PAID",
    ));
  }
}
