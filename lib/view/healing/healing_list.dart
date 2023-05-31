import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/ghost_screens/ghost_screen.dart';
import 'package:aayu/view/healing/consultant/sessions/doctor_sessions.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/doctors_recommendation_card.dart';
import 'package:aayu/view/healing/persoanlised_care/widgets/personal_care_card.dart';
import 'package:aayu/view/player/playAnyVideo.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HealingList extends StatefulWidget {
  final String pageSource;
  const HealingList({Key? key, this.pageSource = ""}) : super(key: key);

  @override
  State<HealingList> createState() => _HealingListState();
}

class _HealingListState extends State<HealingList> {
  HealingListController healingListController =
      Get.put(HealingListController());
  ScrollController scrollController = ScrollController();

  double crossAxisSpacing = 0;
  double mainAxisSpacing = 29;
  int crossAxisCount = 2;
  double cellHeight = 200;

  late double screenWidth;
  late double width;
  late double aspectRatio;

  @override
  void initState() {
    initScrollController();
    if (mounted) {
      Future.delayed(Duration.zero, () {
        healingListController.resetSelection();
        healingListController.noOfDiseaseSelected.value = 0;
      });
    }
    super.initState();
  }

  initScrollController() {
    scrollController = ScrollController()
      ..addListener(() {
        healingListController.appBarTextColor = isSliverAppBarExpanded
            ? AppColors.blackLabelColor
            : Colors.transparent;
        healingListController.update();
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (340 - kToolbarHeight).h;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    aspectRatio = width.w / cellHeight.h;

    return Scaffold(
      body: GetBuilder<HealingListController>(builder: (controller) {
        if (controller.isLoading.value == true) {
          return const GhostScreen(image: Images.healingGhostScreenLottie);
        } else if (controller.healingListResponse.value == null) {
          return const GhostScreen(image: Images.healingGhostScreenLottie);
        } else if (controller.healingListResponse.value!.diseases == null) {
          return const GhostScreen(image: Images.healingGhostScreenLottie);
        } else if (controller.healingListResponse.value!.diseases!.isEmpty) {
          return const GhostScreen(image: Images.healingGhostScreenLottie);
        } else {
          return Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  centerTitle: true,
                  title: isSliverAppBarExpanded == true
                      ? Text(
                          "HEALING_AND_YOU".tr,
                          style: TextStyle(
                            color: controller.appBarTextColor,
                            fontFamily: 'Circular Std',
                            fontSize: 16.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                  titleSpacing: 0,
                  elevation: 0,
                  titleTextStyle: AppTheme.bigTextStyle,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ShowNetworkImage(
                          imgPath: controller.healingListResponse.value!
                              .pageContent!.backgroundImage!,
                          imgHeight: 280.h,
                          boxFit: BoxFit.fill,
                          placeholderImage:
                              "assets/images/placeholder/default_home.jpg",
                        ),
                        (controller.healingListResponse.value!.pageContent!
                                    .playVideo ==
                                true)
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayAnyVideo(
                                        videoUrl: controller.healingListResponse
                                            .value!.pageContent!.videoURL!,
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.playSVG,
                                    width: 54.w,
                                    height: 54.h,
                                    color: const Color(0xFFAAFDB4),
                                  ),
                                ),
                              )
                            : const Offstage(),
                      ],
                    ),
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                  ),
                  actions: [
                    Visibility(
                      visible: widget.pageSource.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        color: AppColors.whiteColor,
                      ),
                    )
                  ],
                  expandedHeight: 280.h,
                  backgroundColor: AppColors.pageBackgroundColor,
                  leading: const Offstage(),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 12.h,
                      ),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.healingListResponse.value!.pageContent!
                                  .title!,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Baskerville',
                              ),
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Text(
                                controller.healingListResponse.value!
                                    .pageContent!.desc!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  height: 1.3.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18.h,
                            ),
                            const DoctorsRecommendationCard(),
                            SizedBox(
                              width: 250.w,
                              child: Text(
                                "Choose a healing program you’d like our help with.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      activeHealingList(),
                      SizedBox(
                        height: 40.h,
                      ),
                      const PersonalCareCard(
                        fromSwitch: false,
                      ),
                      inactiveHealingList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  activeHealingList() {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 19.w,
      runSpacing: 29.h,
      children: List.generate(healingListController.activeHealingList!.length,
          (index) {
        return InkWell(
          onTap: () {
            healingListController.setDiseaseSelected(
                index, widget.pageSource, context);
          },
          child: buildHealingList(
            healingListController.activeHealingList![index]!,
            () {
              healingListController.setDiseaseSelected(
                  index, widget.pageSource, context);
            },
          ),
        );
      }),
    );
  }

  inactiveHealingList() {
    return Visibility(
      visible: (healingListController.inActiveHealingList != null &&
          healingListController.inActiveHealingList!.isNotEmpty),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              healingListController.inActiveHealingList!.length == 1
                  ? "UPCOMING_PROGRAM".tr
                  : "UPCOMING_PROGRAMS".tr,
              textAlign: TextAlign.center,
              style: primaryFontSecondaryLabelSmallTextStyle()
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 28.h,
            ),
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 29.w,
              runSpacing: 29.h,
              children: List.generate(
                  healingListController.inActiveHealingList!.length, (index) {
                return buildHealingList(
                  healingListController.inActiveHealingList![index]!,
                  null,
                );
              }),
            ),
            pageBottomHeight()
          ],
        ),
      ),
    );
  }

  buildHealingList(HealingListResponseDiseases disease, Function? onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.h),
          boxShadow: [
            BoxShadow(
                color: disease.isSelected == true
                    ? const Color.fromRGBO(0, 0, 0, 0.2)
                    : const Color.fromRGBO(0, 0, 0, 0.07),
                blurRadius: 28.51,
                offset: const Offset(0, 1.68))
          ]),
      width: 147.w,
      height: 178.h,
      child: SizedBox(
        width: 120.w,
        height: 129.09.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 120.w,
                  height: 94.13.h,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(top: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.h),
                    ),
                    color: AppColors.lightSecondaryColor,
                  ),
                ),
                SizedBox(
                  height: 14.w,
                ),
                SizedBox(
                  width: 150.w,
                  child: Text(
                    disease.disease!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      height: 1.h,
                      fontFamily: "Circular Std",
                    ),
                  ),
                ),
              ],
            ),
            (disease.image == null)
                ? const Offstage()
                : Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: ShowNetworkImage(
                        imgPath: disease.image!.imageUrl!,
                        imgWidth: disease.image!.width!,
                        imgHeight: disease.image!.height!,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
