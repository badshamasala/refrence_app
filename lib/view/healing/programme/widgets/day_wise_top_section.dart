import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/healing/programme/widgets/day_wise_calender.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/program/programme_controller.dart';
import '../../../../model/model.dart';
import '../../../../services/third-party/events.service.dart';
import '../../../player/video_player.dart';

class DayWiseTopSection extends StatelessWidget {
  final Function handleCasting;
  final bool isDaywise;
  const DayWiseTopSection(
      {Key? key, required this.handleCasting, required this.isDaywise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProgrammeController programmeController = Get.find();

    if (programmeController.todaysContent.value != null &&
        programmeController.todaysContent.value!.content != null &&
        isDaywise == true) {
      return Obx(() {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (programmeController.todaysContent.value!.day! > 0)
                      ? "Day ${programmeController.todaysContent.value?.day ?? "0"}"
                      : "${programmeController.todaysContent.value!.content!.contentName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Baskerville',
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackLabelColor,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Stack(alignment: Alignment.center, children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Hero(
                        tag:
                            "DayWiseProgram_${programmeController.todaysContent.value?.day}_${programmeController.todaysContent.value!.content!.contentId}",
                        child: ShowNetworkImage(
                          imgPath: programmeController.healingProgrammeContent
                                  .value!.programDetails!.sliverAppBar!.image ??
                              programmeController
                                  .todaysContent.value!.content!.contentImage!,
                          imgWidth: 322.w,
                          imgHeight: 292.h,
                          boxFit: BoxFit.cover,
                          placeholderImage:
                              "assets/images/placeholder/default_home.jpg",
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                          width: 322.w,
                          height: 80.h,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFF191D1F),
                                    Color.fromRGBO(0, 0, 0, 0)
                                  ]),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                        )),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.cast,
                            color: AppColors.primaryColor),
                        onPressed: () {
                          handleCasting();
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 17.h,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${subscriptionCheckResponse!.subscriptionDetails!.diseaseName!.isEmpty ? subscriptionCheckResponse!.subscriptionDetails!.disease![0]!.diseaseName : subscriptionCheckResponse!.subscriptionDetails!.diseaseName} Care Program'
                                .toUpperCase(),
                            style: TextStyle(
                                color: const Color(0xFFF39D9D),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (programmeController.todaysContent.value!.content!
                                  .metaData!.multiSeries ==
                              false) {
                            if (programmeController.todaysContent.value!
                                    .content!.contentType ==
                                "Video") {
                              if (programmeController.todaysContent.value!
                                          .content!.contentPath !=
                                      null &&
                                  programmeController.todaysContent.value!
                                      .content!.contentPath!.isNotEmpty) {
                                EventsService().sendClickNextEvent(
                                    "DayWiseProgram", "Play", "VideoPlayer");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayer(
                                      source: "Healing Program",
                                      content: Content.fromJson(
                                          programmeController
                                              .todaysContent.value!.content!
                                              .toJson()),
                                      day: programmeController
                                          .todaysContent.value?.day,
                                    ),
                                  ),
                                );
                              } else {
                                showGetSnackBar("Content not avaialble!",
                                    SnackBarMessageTypes.Info);
                              }
                            }
                          }
                        },
                        child: SvgPicture.asset(
                          AppIcons.playSVG,
                          width: 54.w,
                          height: 54.h,
                          color: const Color(0xFFFCAFAF),
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  height: 20.h,
                ),
                programmeController.todaysContent.value != null &&
                        programmeController.todaysContent.value!.content !=
                            null &&
                        programmeController
                                .todaysContent.value!.content!.contentDesc !=
                            null &&
                        programmeController.todaysContent.value!.content!
                            .contentDesc!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: SizedBox(
                          width: 320.w,
                          child: Text(
                            programmeController.todaysContent.value!.content!
                                    .contentDesc ??
                                "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontFamily: 'Circular Std',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              height: 1.16.h,
                            ),
                          ),
                        ),
                      )
                    : const Offstage(),
              ],
            ));
      });
    }
    if (programmeController.dayZeroContent.value != null &&
        programmeController.dayZeroContent.value!.content != null &&
        isDaywise == false) {
      return Obx(() {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your ${subscriptionCheckResponse!.subscriptionDetails!.disease!.length == 1 ? subscriptionCheckResponse!.subscriptionDetails!.disease![0]!.diseaseName : 'Personalised'} Care\nProgram begins on ${DateFormat('dd MMM, yyyy').format(dateFromTimestamp(int.tryParse(subscriptionCheckResponse!.subscriptionDetails!.epochTimes!.startDate!)!))}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Baskerville',
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackLabelColor,
                    height: 1.3.h,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Stack(alignment: Alignment.center, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Hero(
                      tag:
                          "DayZeroContent_${programmeController.dayZeroContent.value!.content!.contentId}",
                      child: ShowNetworkImage(
                        imgPath: programmeController
                            .dayZeroContent.value!.content!.contentImage!,
                        imgWidth: 322.w,
                        imgHeight: 292.h,
                        boxFit: BoxFit.cover,
                        placeholderImage:
                            "assets/images/placeholder/default_home.jpg",
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (programmeController
                                  .dayZeroContent.value!.content!.contentType ==
                              "Video") {
                            if (programmeController.dayZeroContent.value!
                                        .content!.contentPath !=
                                    null &&
                                programmeController.dayZeroContent.value!
                                    .content!.contentPath!.isNotEmpty) {
                              EventsService().sendClickNextEvent(
                                  "DayZero", "Play", "VideoPlayer");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayer(
                                    source: "Healing Program",
                                    content: Content.fromJson(
                                        programmeController
                                            .dayZeroContent.value!.content!
                                            .toJson()),
                                    day: 0,
                                  ),
                                ),
                              );
                            } else {
                              showGetSnackBar("Content not avaialble!",
                                  SnackBarMessageTypes.Info);
                            }
                          }
                        },
                        child: SvgPicture.asset(
                          AppIcons.playSVG,
                          width: 54.w,
                          height: 54.h,
                          color: const Color(0xFFFCAFAF),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 208.w,
                        child: Text(
                          "${programmeController.dayZeroContent.value!.content!.contentName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 24.sp,
                              fontFamily: 'Baskerville'),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon:
                          const Icon(Icons.cast, color: AppColors.primaryColor),
                      onPressed: () {
                        handleCasting();
                      },
                    ),
                  ),
                ]),
              ],
            ));
      });
    }

    return const Offstage();
  }
}
