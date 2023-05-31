import 'package:aayu/controller/live_events/live_events_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/live_events/artist_wise_event/artist_wise_events.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveEventContent extends StatefulWidget {
  const LiveEventContent({Key? key}) : super(key: key);

  @override
  State<LiveEventContent> createState() => _LiveEventContentState();
}

class _LiveEventContentState extends State<LiveEventContent>
    with AutomaticKeepAliveClientMixin<LiveEventContent> {
  LiveEventsController liveEventsController = Get.find();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getTrainerList();
  }

  getTrainerList() async {
    await liveEventsController.getEventTrainerList();
    if (liveEventsController.eventTrainerList.value != null &&
        liveEventsController.eventTrainerList.value!.trainerList != null &&
        liveEventsController.eventTrainerList.value!.trainerList!.isNotEmpty) {
      liveEventsController.getArtistWiseLiveEvents(
          liveEventsController
              .eventTrainerList.value!.trainerList!.first!.trainerId!,
          true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: pageHorizontalPadding(),
            child: Text(
              'Our Coaches',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          GetBuilder<LiveEventsController>(
              id: "LiveEventTrainerList",
              builder: (liveEventsController) {
                if (liveEventsController.eventTrainerList.value == null) {
                  return const Offstage();
                } else if (liveEventsController
                        .eventTrainerList.value!.trainerList ==
                    null) {
                  return const Offstage();
                } else if (liveEventsController
                    .eventTrainerList.value!.trainerList!.isEmpty) {
                  return const Offstage();
                }
                return SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: liveEventsController
                        .eventTrainerList.value!.trainerList!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: (index == 0) ? 26.w : 12.w,
                            right: 12.w),
                        child: InkWell(
                          onTap: () {
                            liveEventsController.getArtistWiseLiveEvents(
                                liveEventsController.eventTrainerList.value!
                                    .trainerList![index]!.trainerId!,
                                true);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 38.w,
                                backgroundColor: liveEventsController
                                            .eventTrainerList
                                            .value!
                                            .trainerList![index]!
                                            .trainerId ==
                                        liveEventsController
                                            .selectedArtistId.value
                                    ? AppColors.primaryColor
                                    : AppColors.secondaryLabelColor
                                        .withOpacity(0.2),
                                child: CircleAvatar(
                                  radius: 35.w,
                                  backgroundColor: AppColors.whiteColor,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.w),
                                    child: ShowNetworkImage(
                                      imgPath: liveEventsController
                                              .eventTrainerList
                                              .value!
                                              .trainerList![index]!
                                              .photo ??
                                          "",
                                      imgWidth: 70,
                                      imgHeight: 70,
                                      boxFit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: Text(
                                  liveEventsController.eventTrainerList.value!
                                          .trainerList![index]!.name ??
                                      "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontFamily: 'Circular Std',
                                    fontSize: 12.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
          GetBuilder<LiveEventsController>(
              id: "TrainerWiseEventDetails",
              builder: (liveEventsController) {
                if (liveEventsController.eventTrainerList.value == null) {
                  return const Offstage();
                } else if (liveEventsController
                        .eventTrainerList.value!.trainerList ==
                    null) {
                  return const Offstage();
                } else if (liveEventsController
                    .eventTrainerList.value!.trainerList!.isEmpty) {
                  return const Offstage();
                }
                return ArtistWiseEvents(
                    key: Key(liveEventsController.selectedArtistId.value),
                    trainerId: liveEventsController.selectedArtistId.value);
              })
        ],
      ),
    );
  }
}
