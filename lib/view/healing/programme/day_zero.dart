import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions_summary.dart';
import 'package:aayu/view/healing/initialAssessment/initial_health_card.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/doctors_recommendation_card.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/personal_care_card.dart';
import 'package:aayu/view/healing/programme/complete_assessment.dart';
import 'package:aayu/view/healing/programme/pop-ups/hamburger_menu.dart';
import 'package:aayu/view/healing/programme/set_reminder.dart';
import 'package:aayu/view/healing/programme/switch_disease.dart';
import 'package:aayu/view/healing/programme/widgets/day_wise_top_section.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/casting/cast_controller.dart';
import '../consultant/sessions/trainer_sessions_summary.dart';

class DayZero extends StatelessWidget {
  const DayZero({Key? key}) : super(key: key);
  format(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("d'$suffix' MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    ProgrammeController programmeController = Get.find();
    CastController castController = Get.put(CastController());
    Future.delayed(Duration.zero, () async {
      programmeController.getInitialAssessmentStatus();
      showInitialAssessmentPopup(programmeController, context);
      bool showSwitchSuccessfullypopup =
          await HiveService().showSwitchProgramSuccessfullyPopup();
      if (showSwitchSuccessfullypopup == true) {
        showSwitchToPersonalisedCarePopup(context);
      }
    });

    return Obx(() {
      if (programmeController.isContentLoading.value == true) {
        return showLoading();
      }
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  Get.bottomSheet(
                    const HamburgerMenu(),
                    isScrollControlled: true,
                    isDismissible: true,
                    enableDrag: false,
                  );
                },
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DayWiseTopSection(
                      isDaywise: false,
                      handleCasting: () {
                        handleCasting(
                            castController, context, programmeController);
                      },
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    const DoctorsRecommendationCard(),
                    CompleteAssessment(
                        programmeController: programmeController),
                    const DoctorSessionsSummary(),
                    SizedBox(
                      height: 30.h,
                    ),
                    const TrainerSessionsSummary(),
                    SizedBox(
                      height: 30.h,
                    ),
                    const SwitchDisease(),
                    const PersonalCareCard(fromSwitch: true),
                    subscriptionCheckResponse!
                                .subscriptionDetails!.canSwitchProgram ==
                            true
                        ? SizedBox(
                            height: 60.h,
                          )
                        : const Offstage(),
                    SizedBox(
                      height: 20.h,
                    ),
                    setReminderTime(context),
                    checkAayuScore(context, programmeController),
                  ],
                ),
              )
            ],
          ));
    });
  }

  handleCasting(CastController castController, BuildContext context,
      ProgrammeController programmeController) {
    castController.switchShowControls(false);
    castController.searchCastDevices();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Obx(() {
          if (castController.isSearching.value == true) {
            return Container(
              height: 100,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Finding Nearby Devices',
                    style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const LinearProgressIndicator(),
                ],
              ),
            );
          }
          if (castController.showControls.value == true) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          castController.minus10();
                        },
                        icon: const Icon(Icons.replay_10, size: 30)),
                    IconButton(
                        onPressed: () {
                          castController.pauseVideo();
                        },
                        icon: Icon(
                          castController.playerState.value ==
                                  PlayerState.PLAYING
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {
                          castController.plus10();
                        },
                        icon: const Icon(Icons.forward_10, size: 30)),
                  ],
                ),
              ],
            );
          }
          return Stack(children: [
            Container(
              constraints: const BoxConstraints(minHeight: 100),
              child: castController.listCastdDevices!.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'No Devices Found',
                          style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 9.h)),
                                onPressed: () async {
                                  castController.switchShowControls(false);
                                  castController.searchCastDevices();
                                },
                                child: Text(
                                  'Scan Again',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Circular Std"),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: castController.listCastdDevices!.map((device) {
                        return ListTile(
                          title: Text(device.name),
                          onTap: () {
                            castController
                                .connectAndPlayMedia(
                                    context,
                                    device,
                                    Content.fromJson(programmeController
                                        .todaysContent.value!.content!
                                        .toJson()),
                                    "${subscriptionCheckResponse!.subscriptionDetails!.diseaseName ?? ""} - Day ${programmeController.todaysContent.value?.day ?? 0}")
                                .then((value) {
                              castController.switchShowControls(true);
                            });
                          },
                        );
                      }).toList()),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.blackAssessmentColor,
                    size: 25,
                  )),
            )
          ]);
        }),
      ),
    ).then((value) {
      castController.closeSession();
    });
  }

  showSwitchToPersonalisedCarePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 58.h,
                    ),
                    Text(
                      "Superb!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackAssessmentColor,
                        fontFamily: 'Baskerville',
                        fontSize: 24.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    Text(
                      "You have successfully switched to",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontFamily: 'Circular Std',
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Personalised care program.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontFamily: 'Circular Std',
                        fontSize: 20.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Your practice starts from",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontFamily: 'Circular Std',
                        fontSize: 15.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      format(DateTime.parse(subscriptionCheckResponse!
                          .subscriptionDetails!.startDate!)),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blueGreyAssessmentColor,
                        fontFamily: 'Circular Std',
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.whiteColor,
                            ),
                            color: AppColors.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        height: 44.h,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Okay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontFamily: 'Circular Std',
                              fontSize: 14.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: -60.h,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.h,
                    child: Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Image.asset(
                        Images.personalisedCareLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ))
            ]),
      ),
    ).then((value) {
      HiveService().seenSwitchProgramToPersonalPopup();
    });
  }

  showInitialAssessmentPopup(
      ProgrammeController programmeController, BuildContext context) {
    if (programmeController.showPopupAssesmentComplete == true) {
      String diseaseName =
          subscriptionCheckResponse!.subscriptionDetails!.diseaseName!;
      if (diseaseName.isEmpty) {
        diseaseName = subscriptionCheckResponse!
            .subscriptionDetails!.disease![0]!.diseaseName!;
      }

      Future.delayed(const Duration(milliseconds: 800), () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Container(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 22.h,
                  ),
                  Text(
                    "Your $diseaseName Care program is booked!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 17.h,
                  ),
                  Image.asset(
                    Images.completeAssessmentMyRoutineIcon,
                    height: 75.h,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Next Steps:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Take a 15 min assessment so we can give you insights about your current health. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderAssessmentColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            height: 42,
                            width: 126,
                            child: Center(
                              child: Text(
                                'DO_IT_LATER'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(const InitialHealthCard(
                              action: "Initial Assessment",
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                ),
                                color: AppColors.primaryColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            height: 42,
                            width: 126,
                            child: Center(
                              child: Text(
                                'START_NOW'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
      programmeController.setShowPopupAssessment(false);
    }
  }

  setReminderTime(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 47.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36.w),
              topRight: Radius.circular(36.w),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 71.h,
              ),
              Text(
                'REMINDER_FOR_DAILY_PRACTICE'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 16.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  height: 1.75.h,
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              SizedBox(
                width: 266.w,
                child: Text(
                  "DAY_ZERO_MSG".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF8C98A5),
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    height: 1.5.h,
                  ),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              SizedBox(
                width: 267.w,
                child: InkWell(
                  onTap: () {
                    EventsService().sendClickNextEvent(
                        "DayZero", "Set a Time", "SetReminder");
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => const SetReminder(
                          popPage: false,
                        ),
                      ),
                    )
                        .then((value) {
                      EventsService()
                          .sendClickBackEvent("SetReminder", "Back", "DayZero");
                    });
                  },
                  child: mainButton("SET_A_TIME".tr),
                ),
              ),
              SizedBox(
                height: 54.h,
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Column(
            children: [
              Image(
                width: 136.w,
                height: 76.h,
                image: const AssetImage(Images.yogaClockImage),
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 17.h,
              ),
              Image(
                width: 86.w,
                height: 9.h,
                image: const AssetImage(Images.ellipseImage),
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ],
    );
  }

  checkAayuScore(
      BuildContext context, ProgrammeController programmeController) {
    return (programmeController.initialAssessmentCompleted.value == true)
        ? Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Container(
                width: 322.w,
                margin: EdgeInsets.only(top: 25.h, bottom: 28.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16.w),
                  boxShadow: const [
                    BoxShadow(
                        color:
                            Color.fromRGBO(91, 112, 129, 0.07999999821186066),
                        offset: Offset(1, -8),
                        blurRadius: 16),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 46.h,
                    ),
                    Text(
                      'HOW_ARE_YOU_TXT'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 16.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                        height: 1.75.h,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      width: 266.w,
                      child: Text(
                        "DAY_ZERO_STATUS".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF8C98A5),
                          fontFamily: 'Circular Std',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                    Padding(
                      padding: pageHorizontalPadding(),
                      child: InkWell(
                        onTap: () {
                          EventsService().sendClickNextEvent("DayZero",
                              "Check Your Aayu Score", "InitialHealthCard");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InitialHealthCard(
                                action: "",
                              ),
                            ),
                          ).then((value) {
                            EventsService().sendClickBackEvent(
                                "InitialHealthCard", "Back", "DayZero");
                          });
                        },
                        child: mainButton("CHECK_YOUR_AAYU_SCORE".tr),
                      ),
                    ),
                    SizedBox(
                      height: 44.h,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          )
        : const Offstage();
  }
}
