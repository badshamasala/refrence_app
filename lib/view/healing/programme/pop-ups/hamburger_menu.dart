import 'package:aayu/controller/program/programme_controller.dart';
import 'package:aayu/data/healing_data.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/programme/insight_card.dart';
import 'package:aayu/view/healing/programme/set_reminder.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions.dart';
import 'package:aayu/view/healing/consultant/sessions/trainer_sessions.dart';
import 'package:aayu/view/player/audio_player.dart';
import 'package:aayu/view/player/video_player.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: Padding(
        padding: pageVerticalPadding(),
        child: Wrap(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        width: 138.w,
                        height: 120.h,
                        fit: BoxFit.contain,
                        image: const AssetImage(Images.aayuHealingImage),
                      ),
                      Positioned(
                        top: 0,
                        right: 20,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      List.generate(hamburgerOptions["data"].length, (index) {
                    if (hamburgerOptions["data"][index]["title"] ==
                            "Your Monthly Assessment" ||
                        hamburgerOptions["data"][index]["title"] ==
                            "Your Aayu Score") {
                      return const Offstage();
                    }

                    return HamburgerOptions(
                        options: hamburgerOptions["data"][index],
                        showDivider:
                            (index == hamburgerOptions["data"].length - 1)
                                ? false
                                : true);
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HamburgerOptions extends StatelessWidget {
  final dynamic options;
  final bool showDivider;
  const HamburgerOptions(
      {Key? key, required this.options, required this.showDivider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pageHorizontalPadding(),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              switch (options["navigation"]) {
                case "Set Reminder":
                  Navigator.pop(context);
                  EventsService().sendClickNextEvent("DaywiseProgarmHamburger",
                      "Daily Practice Time", "Set Reminder");
                  Get.to(const SetReminder())!.then((value) {
                    EventsService().sendClickBackEvent(
                        "Set Reminder", "Back", "DaywiseProgarm");
                  });

                  break;
                case "Doctor Sessions":
                  Navigator.pop(context);
                  EventsService().sendClickNextEvent("DaywiseProgarmHamburger",
                      "Doctor Sessions", "DoctorSessions");
                  Get.to(const DoctorSessions())!.then((value) {
                    EventsService().sendClickBackEvent(
                        "DoctorSessions", "Back", "DaywiseProgarm");
                  });
                  break;
                case "Trainer Sessions":
                  Navigator.pop(context);
                  EventsService().sendClickNextEvent("DaywiseProgarmHamburger",
                      "Trainer Sessions", "TrainerSessions");
                  Get.to(const TrainerSessions())!.then((value) {
                    EventsService().sendClickBackEvent(
                        "TrainerSessions", "Back", "DaywiseProgarm");
                  });
                  break;
                case "Insight":
                case "Monthly Assessment":
                  Navigator.pop(context);
                  Get.to(const InsightCard());
                  break;
                // showGetSnackBar(
                //     "Thank you for showing interest, this Feature is Coming Soon",
                //     SnackBarMessageTypes.Info);

                // case "Healing Programs":
                //   Navigator.pop(context);
                //   EventsService().sendClickNextEvent("DaywiseProgarmHamburger",
                //       "Explore all Healing Programs", "HealingList");
                //   Get.to(const HealingList(pageSource: "HAMBURGERMENU"))!
                //       .then((value) {
                //     EventsService().sendClickBackEvent(
                //         "HealingList", "Back", "DaywiseProgarm");
                //   });
                //   break;
                case "Day Zero Content":
                  handlePlayContent(context);
                  break;
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      options["title"],
                      style: TextStyle(
                        color: options["title"] == "Your Monthly Assessment" ||
                                options["title"] == "Your Aayu Score"
                            ? const Color(0xFFC4C4C4)
                            : AppColors.secondaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        height: 1.h,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: options["notifications"] > 0,
                    child: SizedBox(
                      width: 10.w,
                    ),
                  ),
                  Visibility(
                    visible: options["notifications"] > 0,
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        options["notifications"].toString(),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: 'Circular Std',
                          fontSize: 14.sp,
                          letterSpacing: 1.5.w,
                          fontWeight: FontWeight.normal,
                          height: 1.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showDivider == true,
            child: Container(
              height: 1.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color.fromRGBO(164, 177, 185, 0.30000001192092896),
              ),
            ),
          ),
        ],
      ),
    );
  }

  handlePlayContent(BuildContext context) async {
    ProgrammeController programmeController = Get.find();
    HealingProgramContentResponseProgramDetailsDaysContent? dayZeroContent =
        programmeController
            .healingProgrammeContent.value!.programDetails!.days![0]!.content;

    if (dayZeroContent!.metaData!.multiSeries == false) {
      if (dayZeroContent.contentType == "Video") {
        if (dayZeroContent.contentPath != null &&
            dayZeroContent.contentPath!.isNotEmpty) {
          Navigator.pop(context);
          EventsService().sendClickNextEvent("DaywiseProgarmHamburger",
              "How to Make the Most of Your Program", "Video Player");
          dynamic popReason = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayer(
                  content: Content.fromJson(dayZeroContent.toJson()), day: 0),
            ),
          );

          EventsService()
              .sendClickBackEvent("Video Player", "Back", "DaywiseProgarm");

          if (popReason != null && popReason["videoFinished"] != null) {
            if (popReason["videoFinished"] == true) {
              programmeController.updateContentViewStatus(
                  subscriptionCheckResponse!.subscriptionDetails!.programId!);
            }
          }
        } else {
          showGetSnackBar("Content not avaialble!", SnackBarMessageTypes.Info);
        }
      } else if (dayZeroContent.contentType == "Audio" ||
          dayZeroContent.contentType == "Music") {
        if (dayZeroContent.contentPath != null &&
            dayZeroContent.contentPath!.isNotEmpty) {
          Navigator.pop(context);
          EventsService().sendClickNextEvent("DaywiseProgarmHamburger",
              "How to Make the Most of Your Program", "Audio Player");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlayer(
                  heroTag: "DayWiseProgram_0_${dayZeroContent.contentId}",
                  content: Content.fromJson(dayZeroContent.toJson()),
                  day: 0),
            ),
          ).then((value) {
            EventsService()
                .sendClickBackEvent("Audio", "Back", "DaywiseProgarm");
          });
        } else {
          showGetSnackBar("Content not avaialble!", SnackBarMessageTypes.Info);
        }
      }
    }
  }
}
