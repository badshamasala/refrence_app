import 'package:aayu/controller/consultant/program_recommendation_controller.dart';
import 'package:aayu/controller/healing/health_card_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/ghost_screens/ghost_screen.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../persoanlised_care/widgets/recommended_program_ready.dart';

class PostCallScoreCard extends StatelessWidget {
  final String sessionId;
  const PostCallScoreCard({Key? key, required this.sessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HealthCardController healthCardController = Get.put(HealthCardController());

    Future.delayed(
      Duration.zero,
      () {
        healthCardController.getInitialHealthCardDetails();
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
                  "YOUR_AAYU_SCORE".tr,
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.blackLabelColor,
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
                                  top: 30.h,
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
                              "AWESOME".tr,
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
                            SizedBox(
                              width: 270.w,
                              child: Text(
                                "FIRST_STEP_TEXT".tr,
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
                                healthCardController: healthCardController);
                          },
                          staggeredTileBuilder: (index) {
                            return const StaggeredTile.fit(
                              1,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
        child: InkWell(
          onTap: () async {
            ProgramRecommendationController recommendationController =
                Get.find();
            await recommendationController
                .getProgramRecommendationForSessionId(sessionId);

            if (recommendationController.recommendation.value == null) {
              showCustomSnackBar(
                  context, "PROGRAM_RECOMMENDATION_NOT_AVAILABLE".tr);
              return;
            } else if (recommendationController
                    .recommendation.value!.recommendation ==
                null) {
              showCustomSnackBar(
                  context, "PROGRAM_RECOMMENDATION_NOT_AVAILABLE".tr);
              return;
            }
            Get.bottomSheet(
              const RecommendedProgramReady(),
              isScrollControlled: true,
              isDismissible: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            );
          },
          child: mainButton("VIEW_DOCTOR_RECOMMENDATION".tr),
        ),
      ),
    );
  }
}

class HealthCardIndividualCard extends StatelessWidget {
  final InitialHealthCardResponseHealthcardPercentage? cardDetails;
  final HealthCardController healthCardController;
  const HealthCardIndividualCard({
    Key? key,
    required this.cardDetails,
    required this.healthCardController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}
