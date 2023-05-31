import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions_summary.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions_summary.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/doctors_recommendation_card.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/personal_care_card.dart';
import 'package:aayu/view/healing/programme/pop-ups/hamburger_menu.dart';
import 'package:aayu/view/healing/programme/pop-ups/on_that_day_calender.dart';
import 'package:aayu/view/healing/programme/pop-ups/thank_you_progress_better.dart';
import 'package:aayu/view/healing/programme/switch_disease.dart';
import 'package:aayu/view/healing/programme/todays_tips.dart';
import 'package:aayu/view/healing/programme/widgets/day_wise_top_section.dart';
import 'package:aayu/view/player/video_player.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/casting/cast_controller.dart';
import 'followup_assessment.dart';

class DayWiseProgramme extends StatefulWidget {
  const DayWiseProgramme({Key? key}) : super(key: key);

  @override
  State<DayWiseProgramme> createState() => _DayWiseProgrammeState();
}

class _DayWiseProgrammeState extends State<DayWiseProgramme> {
  ProgrammeController programmeController = Get.find();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    initScrollController();
    HealingListController healingListController =
        Get.put(HealingListController());
    if (healingListController.showThankYou.value == true) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.bottomSheet(
          const ThankYouProgressBetter(),
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: false,
        );
        Future.delayed(Duration.zero, () {
          healingListController.setShowThankYou(false);
        });
      });
    }

    //programmeController.getDayWiseProgramContent();
    super.initState();
  }

  initScrollController() {
    scrollController = ScrollController()
      ..addListener(() {
        programmeController.appBarTextColor = isSliverAppBarExpanded
            ? AppColors.blackLabelColor
            : Colors.transparent;
        programmeController.update();
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (538 - kToolbarHeight).h;
  }

  @override
  Widget build(BuildContext context) {
    CastController castController = Get.put(CastController());
    return Obx(() {
      if (programmeController.isContentLoading.value == true) {
        return showAayuHealing();
      }
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: isSliverAppBarExpanded
                    ? AppColors.blackLabelColor
                    : AppColors.primaryColor,
              ),
              onPressed: () {
                Get.bottomSheet(
                  const OnThatDayCalender(),
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: false,
                );
              },
            ),
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
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DayWiseTopSection(
                        handleCasting: () {
                          handleCasting(castController);
                        },
                        isDaywise: true),
                    SizedBox(
                      height: 40.h,
                    ),
                    const DoctorsRecommendationCard(),
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
                    SizedBox(
                      height: 60.h,
                    ),
                    const FollowupAssessment(),
                    const TodaysTips(),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }

  handleCasting(CastController castController) {
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
                                    backgroundColor: AppColors.primaryColor,
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

  handlePlayContent() async {
    if (programmeController
            .todaysContent.value!.content!.metaData!.multiSeries ==
        false) {
      if (programmeController.todaysContent.value!.content!.contentType ==
          "Video") {
        if (programmeController.todaysContent.value!.content!.contentPath !=
                null &&
            programmeController
                .todaysContent.value!.content!.contentPath!.isNotEmpty) {
          EventsService()
              .sendClickNextEvent("DayWiseProgram", "Play", "VideoPlayer");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayer(
                source: "Healing Program",
                content: Content.fromJson(
                    programmeController.todaysContent.value!.content!.toJson()),
                day: programmeController.todaysContent.value?.day,
              ),
            ),
          );
        } else {
          showGetSnackBar("Content not avaialble!", SnackBarMessageTypes.Info);
        }
      }
    }
  }
}
