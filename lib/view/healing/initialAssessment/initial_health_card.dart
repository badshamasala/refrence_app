import 'package:aayu/controller/healing/health_card_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/ghost_screens/ghost_screen.dart';
import 'package:aayu/view/healing/initialAssessment/assessment.dart';
import 'package:aayu/view/healing/initialAssessment/widgets/assessment_intro.dart';
import 'package:aayu/view/main_page.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class InitialHealthCard extends StatelessWidget {
  final String action;
  const InitialHealthCard({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthCardController healthCardController = Get.put(HealthCardController());
    Future.delayed(
      Duration.zero,
      () async {
        await healthCardController.getInitialHealthCardDetails();
        if (action == "Initial Assessment") {
        } else if (action == "Assessment Completed") {
          sendAssessmentEvent("Initial_Assessment_Completed");
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.pop(context);
            Navigator.of(context).popUntil((route) => route.isFirst);
            EventsService()
                .sendClickNextEvent("InitialHealthCard", "Automatic", "Home");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(
                  selectedTab: 1,
                ),
              ),
            );
          });
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F5),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: false,
                pinned: true,
                floating: true,
                titleSpacing: 0,
                elevation: 0,
                title: Text(
                  "AAYU_SCORE".tr,
                  textAlign: TextAlign.center,
                  style: secondaryFontTitleTextStyle(),
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image(
                    image: const AssetImage(Images.planSummaryBGImage),
                    fit: BoxFit.cover,
                    height: (90 - kToolbarHeight).h,
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
                expandedHeight: (90 - kToolbarHeight).h,
                backgroundColor: AppColors.pageBackgroundColor,
                automaticallyImplyLeading: false,
                actions: [
                  Visibility(
                    visible: (action != "Assessment Completed"),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blackLabelColor,
                      ),
                    ),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (healthCardController.isLoading.value == true) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.zero,
                      child: const GhostScreen(
                          image: Images.healingGhostScreenLottie),
                    );
                  } else if (healthCardController
                          .initialHealthCardResponse.value ==
                      null) {
                    return const Offstage();
                  } else if (healthCardController
                          .initialHealthCardResponse.value!.healthcard ==
                      null) {
                    return const Offstage();
                  } else if (healthCardController.initialHealthCardResponse
                      .value!.healthcard!.percentage!.isEmpty) {
                    return const Offstage();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(0),
                            topRight: const Radius.circular(0),
                            bottomLeft: Radius.circular(187.5.w),
                            bottomRight: Radius.circular(187.5.w),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 36.h,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  image:
                                      const AssetImage(Images.healthCardImage),
                                  width: 230.w,
                                  height: 150.h,
                                  fit: BoxFit.fill,
                                ),
                                Positioned(
                                  top: 40.h,
                                  right: 92.w,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        "${healthCardController.initialHealthCardResponse.value!.healthcard!.totalPercentage!}",
                                        style: TextStyle(
                                          color: AppColors.blackLabelColor,
                                          fontFamily: 'Circular Std',
                                          fontSize: 40.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w700,
                                          height: 1.h,
                                        ),
                                      ),
                                      Text(
                                        "%".tr,
                                        style: TextStyle(
                                          color: AppColors.blackLabelColor,
                                          fontFamily: 'Circular Std',
                                          fontSize: 20.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                          height: 1.h,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16.6.h,
                            ),
                            Text(
                              getTitle(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Baskerville",
                                fontSize: 24.sp,
                                color: AppColors.blackLabelColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 16.6.h,
                            ),
                            //"${healthCardController.initialHealthCardResponse.value!.healthcard!.description}",
                            SizedBox(
                              width: 270.w,
                              child: Text(
                                getDescription(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0XFF8C98A5),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 75.h,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: StaggeredGridView.countBuilder(
                          crossAxisSpacing: 26.w,
                          mainAxisSpacing: 36.h,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          itemCount: healthCardController
                              .initialHealthCardResponse
                              .value!
                              .healthcard!
                              .percentage!
                              .length,
                          itemBuilder: (context, index) {
                            return HealthCardIndividualCard(
                                cardDetails: healthCardController
                                    .initialHealthCardResponse
                                    .value!
                                    .healthcard!
                                    .percentage![index]!,
                                healthCardController: healthCardController,
                                action: action);
                          },
                          staggeredTileBuilder: (index) {
                            return const StaggeredTile.fit(
                              1,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          (action == "Do It Later" || action == "Initial Assessment")
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 146.h,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0),
                              Color.fromRGBO(255, 255, 255, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.w, vertical: 15.h),
                        child: InkWell(
                          onTap: () async {
                            Navigator.of(context).pop(false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Assessment(
                                  pageSource: "INITIAL HEALTH CARD",
                                ),
                              ),
                            );
                          },
                          child: mainButton(
                              healthCardController.isFirstTime.value
                                  ? "BEGIN_ASSESSMENT".tr
                                  : "RESUME_ASSESSMENT".tr),
                        ),
                      ),
                    ],
                  ))
              : const Offstage()
        ],
      ),
    );
  }

  getTitle() {
    if (action == "Initial Assessment") {
      return "Assess Yourself";
    } else if (action == "Do It Later") {
      return "Oops!";
    } else if (action == "Assessment Completed" || action == "") {
      return "Awesome!";
    }
  }

  getDescription() {
    if (action == "Initial Assessment") {
      return "Answer questions about your health honestly. Your Aayu Score is an insight into your current health.";
    } else if (action == "Do It Later") {
      return "Your assessment is incomplete. Answer all the questions to monitor your progress.";
    } else if (action == "Assessment Completed" || action == "") {
      return "You’ve taken the first step in owning your health. Now, follow your program and get, set, go!";
    }
  }
}

class HealthCardIndividualCard extends StatelessWidget {
  final InitialHealthCardResponseHealthcardPercentage? cardDetails;
  final HealthCardController healthCardController;
  final String action;
  const HealthCardIndividualCard(
      {Key? key,
      required this.cardDetails,
      required this.healthCardController,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (action.isEmpty || action == "Assessment Completed")
          ? null
          : () {
              if (healthCardController.assessmentIntroViewed.value == false) {
                healthCardController.assessmentIntroViewed.value = true;

                Navigator.pop(context);
                sendAssessmentEvent("Initial_Assessment_Intro");
                EventsService().sendClickNextEvent(
                    "InitialHealthCard", "Automatic", "AssessmentIntro");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssessmentIntro(
                      pageSource: "INITIAL HEALTH CARD",
                      userName: healthCardController
                          .userDetails.value!.userDetails!.firstName!,
                      categoryName: cardDetails!.title ?? "",
                    ),
                  ),
                );
              } else {
                sendAssessmentEvent("Initial_Assessment_Started");
                Navigator.pop(context);
                EventsService().sendClickNextEvent(
                    "InitialHealthCard", "Automatic", "Assessment");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Assessment(
                      pageSource: "INITIAL HEALTH CARD",
                      categoryName: cardDetails!.title ?? "",
                    ),
                  ),
                );
              }
            },
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 144.h,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.solid,
                  offset: const Offset(0, 3),
                  color: Color(
                    int.parse(
                      "0xFF${cardDetails!.percentageColor!.replaceAll("#", "")}",
                    ),
                  ).withOpacity(0.4),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 75.h,
                ),
                Text(
                  toTitleCase(cardDetails!.title ?? ""),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Baskerville',
                    color: AppColors.blackLabelColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (cardDetails!.isCompleted == true)
                        ? SvgPicture.asset(
                            AppIcons.completedSVG,
                            color: const Color(0xFF91CAB9),
                            width: 14,
                            height: 14,
                          )
                        : SvgPicture.asset(
                            AppIcons.helpIconSVG,
                            width: 14,
                            height: 14,
                          ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      toTitleCase(
                        cardDetails!.isCompleted == true
                            ? "COMPLETED".tr
                            : "PENDING".tr,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor.withOpacity(0.4),
                        decoration: (cardDetails!.isCompleted == false)
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer()
              ],
            ),
          ),
          Positioned(
            top: -11.h,
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: 63.h,
                padding: EdgeInsets.zero,
                child: Image.asset(
                  Images.healthCardOval,
                  fit: BoxFit.fitHeight,
                  color: Color(
                    int.parse(
                      "0xFF${cardDetails!.percentageColor!.replaceAll("#", "")}",
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  Text(
                    "${cardDetails!.percentage!}",
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 26.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.h,
                    ),
                  ),
                  Text(
                    "%".tr,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.h,
                    ),
                  )
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
