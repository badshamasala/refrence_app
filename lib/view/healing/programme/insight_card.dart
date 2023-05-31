import 'package:aayu/controller/healing/insight_card_controller.dart';
import 'package:aayu/model/healing/weekly.health.card.model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/health_card_percentage_bar.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InsightCardController insightCardController =
        Get.put(InsightCardController());

    double crossAxisSpacing = 24;
    double mainAxisSpacing = 18;
    int crossAxisCount = 2;
    double cellHeight = 365;

    var screenWidth = MediaQuery.of(context).size.width;
    var width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    var aspectRatio = width / cellHeight;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F5),
      body: CustomScrollView(
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
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackLabelColor,
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: const AssetImage(Images.planSummaryBGImage),
                fit: BoxFit.cover,
                height: (92 - kToolbarHeight).h,
              ),
              collapseMode: CollapseMode.parallax,
            ),
            expandedHeight: (92 - kToolbarHeight).h,
            backgroundColor: AppColors.pageBackgroundColor,
            leading: const Offstage(),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 23.h),
                      Padding(
                        padding: pageHorizontalPadding(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: GetBuilder<InsightCardController>(
                              builder: (controller) {
                            return controller.isLoading.value
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: List.generate(
                                        controller
                                            .weeklyHealthCardDetails
                                            .value!
                                            .healthCardList!
                                            .weeks!
                                            .length, (index) {
                                      return InkWell(
                                        onTap: () {
                                          controller.setDaysList(index);
                                          // controller
                                          //     .getInsightCardDetails();
                                        },
                                        child: Container(
                                          width: 35.w,
                                          height: 35.h,
                                          margin: (index ==
                                                  controller
                                                          .weeklyHealthCardDetails
                                                          .value!
                                                          .healthCardList!
                                                          .weeks!
                                                          .length -
                                                      1)
                                              ? EdgeInsets.zero
                                              : EdgeInsets.only(right: 16.h),
                                          decoration: (index ==
                                                  controller
                                                      .selectedDateIndex.value)
                                              ? const BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  shape: BoxShape.circle,
                                                )
                                              : null,
                                          child: Center(
                                            child: Text(
                                              "W${controller.weeklyHealthCardDetails.value!.healthCardList!.weeks![index]!.week ?? ""}",
                                              style: TextStyle(
                                                color:
                                                    AppColors.blackLabelColor,
                                                fontFamily: 'Circular Std',
                                                fontSize: 12.sp,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<InsightCardController>(builder: (cardController) {
                  if (cardController.isLoading.value == true) {
                    return showLoading();
                  } else if (cardController.weeklyHealthCardDetails.value ==
                      null) {
                    return showLoading();
                  } else if (cardController
                          .weeklyHealthCardDetails.value!.healthCardList ==
                      null) {
                    return showLoading();
                  } else if (cardController.weeklyHealthCardDetails.value!
                          .healthCardList!.weeks ==
                      null) {
                    return showLoading();
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                            )),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 32.h,
                            ),
                            if (cardController
                                    .weeklyHealthCardDetails
                                    .value!
                                    .healthCardList!
                                    .weeks![
                                        cardController.selectedDateIndex.value]!
                                    .startDate!
                                    .isNotEmpty &&
                                cardController
                                    .weeklyHealthCardDetails
                                    .value!
                                    .healthCardList!
                                    .weeks![
                                        cardController.selectedDateIndex.value]!
                                    .endDate!
                                    .isNotEmpty)
                              Text(
                                "${DateFormat('dd MMM').format(DateTime.parse(cardController.weeklyHealthCardDetails.value!.healthCardList!.weeks![cardController.selectedDateIndex.value]!.startDate!)).toUpperCase()} - ${DateFormat('dd MMM').format(DateTime.parse(cardController.weeklyHealthCardDetails.value!.healthCardList!.weeks![cardController.selectedDateIndex.value]!.endDate!)).toUpperCase()}",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    letterSpacing: 1.5.w,
                                    color:
                                        const Color.fromRGBO(91, 112, 129, 0.8),
                                    fontWeight: FontWeight.w400),
                              ),
                            SizedBox(
                              height: 32.h,
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
                                        "${cardController.weeklyHealthCardDetails.value!.healthCardList!.weeks![cardController.selectedDateIndex.value]!.totalPercentage ?? ""}",
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
                                Positioned(
                                    bottom: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        cardController
                                                    .weeklyHealthCardDetails
                                                    .value!
                                                    .healthCardList!
                                                    .weeks![cardController
                                                        .selectedDateIndex
                                                        .value]!
                                                    .progressPercent! <
                                                0
                                            ? const Icon(
                                                Icons.arrow_drop_down_rounded,
                                                size: 30,
                                                color: Color(0xFFDC5850),
                                              )
                                            : const Icon(
                                                Icons.arrow_drop_up_rounded,
                                                size: 30,
                                                color: Color(0xFF54B0B3),
                                              ),
                                        Text(
                                          "${cardController.weeklyHealthCardDetails.value!.healthCardList!.weeks![cardController.selectedDateIndex.value]!.progressPercent ?? ""}%",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: cardController
                                                          .weeklyHealthCardDetails
                                                          .value!
                                                          .healthCardList!
                                                          .weeks![cardController
                                                              .selectedDateIndex
                                                              .value]!
                                                          .progressPercent! <
                                                      0
                                                  ? const Color(0xFFDC5850)
                                                  : const Color(0xFF54B0B3)),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 19.h,
                            ),
                            Text(
                              cardController
                                      .weeklyHealthCardDetails
                                      .value!
                                      .healthCardList!
                                      .weeks![cardController
                                          .selectedDateIndex.value]!
                                      .title ??
                                  "",
                              style: TextStyle(
                                  color: AppColors.blackLabelColor,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Baskerville'),
                            ),
                            SizedBox(
                              height: 17.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 80.w),
                              child: Text(
                                '${cardController.weeklyHealthCardDetails.value!.healthCardList!.weeks![cardController.selectedDateIndex.value]!.desc}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.secondaryLabelColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 75.h,
                            )
                          ],
                        ),
                      ),
                      // Stack(
                      //   alignment: Alignment.center,
                      //   children: [
                      //     Image(
                      //       image: const AssetImage(Images.insightCardImage),
                      //       width: 211.w,
                      //       height: 129.h,
                      //       fit: BoxFit.fill,
                      //     ),
                      //     Wrap(
                      //       alignment: WrapAlignment.center,
                      //       crossAxisAlignment: WrapCrossAlignment.center,
                      //       runAlignment: WrapAlignment.center,
                      //       children: [
                      //         Text(
                      //           "${cardController.insightDetails.value!.details!.overallPercentage!}",
                      //           style: TextStyle(
                      //             color: AppColors.blackLabelColor,
                      //             fontFamily: 'Circular Std',
                      //             fontSize: 50.sp,
                      //             letterSpacing: 0,
                      //             fontWeight: FontWeight.w700,
                      //             height: 1.h,
                      //           ),
                      //         ),
                      //         Text(
                      //           "%",
                      //           style: TextStyle(
                      //             color: AppColors.blackLabelColor,
                      //             fontFamily: 'Circular Std',
                      //             fontSize: 20.sp,
                      //             letterSpacing: 0,
                      //             fontWeight: FontWeight.normal,
                      //             height: 1.h,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 41.h),
                      // Text(
                      //   "Overall health score based on days insight message",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: AppColors.secondaryLabelColor,
                      //     fontFamily: 'Circular Std',
                      //     fontSize: 14.sp,
                      //     letterSpacing: 0,
                      //     fontWeight: FontWeight.normal,
                      //     height: 1.5714285714285714.h,
                      //   ),
                      // ),
                      /* GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: aspectRatio,
                          mainAxisSpacing: mainAxisSpacing,
                          crossAxisSpacing: crossAxisSpacing,
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(
                            cardController
                                .insightDetails.value!.insight!.length,
                            (index) {
                              return buildHealingList(cardController, index);
                            },
                          ),
                        ), */
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: StaggeredGridView.countBuilder(
                          crossAxisSpacing: 26.w,
                          mainAxisSpacing: 36.h,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          itemCount: cardController
                              .weeklyHealthCardDetails
                              .value!
                              .healthCardList!
                              .weeks![cardController.selectedDateIndex.value]!
                              .percentage!
                              .length,
                          itemBuilder: (context, index2) {
                            return buildHealingList(
                                "W${cardController.weeklyHealthCardDetails.value!.healthCardList!.weeks![cardController.selectedDateIndex.value]!.week!}",
                                cardController
                                    .weeklyHealthCardDetails
                                    .value!
                                    .healthCardList!
                                    .weeks![
                                        cardController.selectedDateIndex.value]!
                                    .percentage![index2]!);
                          },
                          staggeredTileBuilder: (index) {
                            return const StaggeredTile.fit(
                              1,
                            );
                          },
                        ),
                      )
                      // GridView.builder(
                      //   shrinkWrap: true,
                      //   primary: false,
                      //   itemCount: cardController
                      //       .insightDetails.value!.details!.insight!.length,
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 2,
                      //       mainAxisExtent: 272.h,
                      //       mainAxisSpacing: mainAxisSpacing.w,
                      //       crossAxisSpacing: crossAxisSpacing.h),
                      //   itemBuilder: (_, index) =>
                      //       buildHealingList(cardController, index),
                      // ),
                    ],
                  );
                }),
                pageBottomHeight()
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildHealingList(String week,
      WeeklyHealthCardModelHealthCardListWeeksPercentage percentage) {
    return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: 191.h,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurStyle: BlurStyle.solid,
                    offset: const Offset(0, 3),
                    color: Color(
                      int.parse(
                          "0xFF${percentage.percentageColor!.replaceAll("#", "")}"),
                    ).withOpacity(0.4))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 121.h,
                ),
                Text(
                  percentage.categoryName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Baskerville',
                      color: AppColors.blackLabelColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400),
                ),
                const Spacer()
              ],
            ),
          ),
          Positioned(
              top: 58.h,
              child: PercentageBar(
                startedAt: percentage.startedAt!.ceil().toInt(),
                percentage: percentage.percentage!.ceil().toInt(),
                color: Color(
                  int.parse(
                    "0xFF${percentage.percentageColor!.replaceAll("#", "")}",
                  ),
                ),
                head: week,
              )
              // Stack(alignment: Alignment.center, children: [
              //   Container(
              //     height: 63.h,
              //     child: Image.asset(
              //       Images.healthCardOval,
              //       fit: BoxFit.fitHeight,
              // color: Color(
              //   int.parse(
              //     "0xFF${cardController.insightDetails.value!.details!.insight![index]!.bgColor!.replaceAll("#", "")}",
              //   ),
              //       ),
              //     ),
              //   ),
              //   Wrap(
              //     alignment: WrapAlignment.center,
              //     crossAxisAlignment: WrapCrossAlignment.center,
              //     runAlignment: WrapAlignment.center,
              //     children: [
              //       Text(
              //         "${cardController.insightDetails.value!.details!.insight![index]!.nowAt!.ceil().toInt()}",
              //         style: TextStyle(
              //           color: AppColors.blackLabelColor,
              //           fontFamily: 'Circular Std',
              //           fontSize: 26.sp,
              //           letterSpacing: 0,
              //           fontWeight: FontWeight.w700,
              //           height: 1.h,
              //         ),
              //       ),
              //       Text(
              //         "%",
              //         style: TextStyle(
              //           color: AppColors.blackLabelColor,
              //           fontFamily: 'Circular Std',
              //           fontSize: 14.sp,
              //           letterSpacing: 0,
              //           fontWeight: FontWeight.normal,
              //           height: 1.h,
              //         ),
              //       )
              //     ],
              //   ),
              // ]),
              )
        ]);

    // return SizedBox(
    //   width: 152.w,
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(16.w),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           height: 70.h,
    //           width: double.infinity,
    //           alignment: Alignment.centerLeft,
    //           padding: EdgeInsets.symmetric(horizontal: 10.w),
    //           color: Color(
    //             int.parse(
    //               "0xFF${cardController.insightDetails.value!.details!.insight![index]!.bgColor!.replaceAll("#", "")}",
    //             ),
    //           ),
    //           child: Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               cardController
    //                   .insightDetails.value!.details!.insight![index]!.title!,
    //               textAlign: TextAlign.left,
    //               style: TextStyle(
    //                 color: AppColors.blackLabelColor,
    //                 fontFamily: 'Circular Std',
    //                 fontSize: 12.sp,
    //                 letterSpacing: 1.5.w,
    //                 fontWeight: FontWeight.normal,
    //                 height: 1.1666666666666667.h,
    //               ),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           color: const Color(0xFFEFF3F7),
    //           height: 202.h,
    //           child: Container(
    //             margin: EdgeInsets.only(top: 16.h),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 /* Image(
    //                   image: AssetImage(cardController
    //                       .insightDetails.value!.details!.insight![index]!.image!),
    //                   width: cardController
    //                       .insightDetails.value!.details!.insight![index]!.width!.w,
    //                   height: cardController
    //                       .insightDetails.value!.details!.insight![index]!.height!.h,
    //                   fit: BoxFit.fill,
    //                 ), */
    //                 ShowNetworkImage(
    //                   imgPath: cardController.insightDetails.value!.details!
    //                       .insight![index]!.image!,
    //                   imgWidth: cardController.insightDetails.value!.details!
    //                       .insight![index]!.width!,
    //                   imgHeight: cardController.insightDetails.value!.details!
    //                       .insight![index]!.height!,
    //                   boxFit: BoxFit.fill,
    //                 ),
    //                 SizedBox(
    //                   height: 16.h,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Text(
    //                             "STARTED",
    //                             style: TextStyle(
    //                               color: const Color(0xFF768897),
    //                               fontFamily: 'Circular Std',
    //                               fontSize: 9.sp,
    //                               letterSpacing: 0.30000001192092896.w,
    //                               fontWeight: FontWeight.normal,
    //                               height: 1.5555555555555556.h,
    //                             ),
    //                           ),
    //                           Text(
    //                             "${cardController.insightDetails.value!.details!.insight![index]!.started!.ceil().toInt()}%",
    //                             style: TextStyle(
    //                               color: Color(
    //                                 int.parse(
    //                                   "0xFF${cardController.insightDetails.value!.details!.insight![index]!.bgColor!.replaceAll("#", "")}",
    //                                 ),
    //                               ),
    //                               fontFamily: 'Circular Std',
    //                               fontSize: 18.sp,
    //                               letterSpacing: 0.20000000298023224.w,
    //                               fontWeight: FontWeight.w700,
    //                               height: 1.6666666666666667.h,
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Text(
    //                             "NOW AT",
    //                             style: TextStyle(
    //                               color: const Color(0xFF768897),
    //                               fontFamily: 'Circular Std',
    //                               fontSize: 9.sp,
    //                               letterSpacing: 0.30000001192092896.w,
    //                               fontWeight: FontWeight.normal,
    //                               height: 1.5555555555555556.h,
    //                             ),
    //                           ),
    //                           Text(
    //                             "${cardController.insightDetails.value!.details!.insight![index]!.nowAt!.ceil().toInt()}%",
    //                             style: TextStyle(
    //                               color: Color(
    //                                 int.parse(
    //                                   "0xFF${cardController.insightDetails.value!.details!.insight![index]!.bgColor!.replaceAll("#", "")}",
    //                                 ),
    //                               ),
    //                               fontFamily: 'Circular Std',
    //                               fontSize: 18.sp,
    //                               letterSpacing: 0.20000000298023224.w,
    //                               fontWeight: FontWeight.w700,
    //                               height: 1.6666666666666667.h,
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 8.h,
    //                 ),
    //                 Text(
    //                   cardController.insightDetails.value!.details!
    //                       .insight![index]!.status!,
    //                   style: TextStyle(
    //                     color: AppColors.blackLabelColor,
    //                     fontFamily: 'Circular Std',
    //                     fontSize: 12.sp,
    //                     letterSpacing: 1.5.w,
    //                     fontWeight: FontWeight.normal,
    //                     height: 1.1666666666666667.h,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 20.h,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
