import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChooseDuration extends StatelessWidget {
  final bool isProgramSwitch;
  final String programName;
  final PageController pageController;
  const ChooseDuration(
      {Key? key,
      required this.isProgramSwitch,
      required this.programName,
      required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 26.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: postAssessmentHeader(
                context, programName.isEmpty ? "Duration" : programName,
                showBackButton: true, onBackPressed: () {
              Navigator.pop(context);
            }),
          ),
          /* Padding(
            padding: EdgeInsets.only(top: 26.h, bottom: 10.h),
            child: LinearPercentIndicator(
              animation: true,
              width: 100.w,
              lineHeight: 10.0.h,
              animationDuration: 200,
              percent: (1 / 2),
              center: const Offstage(),
              alignment: MainAxisAlignment.center,
              trailing: const Offstage(),
              barRadius: Radius.circular(16.w),
              backgroundColor: const Color(0xFFC1C1C1),
              progressColor: const Color(0xFFA5ECD1),
            ),
          ),
          Text(
            '1/2',
            style: TextStyle(
              color: AppColors.blueGreyAssessmentColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.h,
            ),
          ), */
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: Text(
              "Choose Duration",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Baskerville',
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                height: 1.h,
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: Text(
              "CHOOSE_A_DURATION_FOR_EACH_SESSION"
                  .tr
                  .replaceAll("[PROGRAM_NAME]", programName),
              textAlign: TextAlign.center,
              style: primaryFontSecondaryLabelSmallTextStyle(),
            ),
          ),
          SizedBox(
            height: 42.h,
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GetBuilder<PostAssessmentController>(
                  builder: (postAssessmentController) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    postAssessmentController
                        .programDurationDetails.value!.duration!.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          postAssessmentController.setProgramDuration(index);
                          Future.delayed(const Duration(milliseconds: 200), () {
                            pageController.nextPage(
                                duration: Duration(
                                    milliseconds: defaultAnimateToPageDuration),
                                curve: Curves.easeIn);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 41.h,
                            left: 18.w,
                            right: (index ==
                                    postAssessmentController
                                            .programDurationDetails
                                            .value!
                                            .duration!
                                            .length -
                                        1)
                                ? 18.w
                                : 0.w,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                  width: 154.w,
                                  height: 143.h,
                                  margin: EdgeInsets.only(
                                      top: 30.h,
                                      bottom: 12
                                          .h //margin applied for bottom radio button
                                      ),
                                  decoration: postAssessmentController
                                              .programDurationDetails
                                              .value!
                                              .duration![index]!
                                              .isSelected ==
                                          true
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24.w),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  64, 117, 205, 0.15),
                                              offset: Offset(0, 12),
                                              blurRadius: 28,
                                              spreadRadius: 0,
                                            )
                                          ],
                                          color: AppColors.whiteColor,
                                        )
                                      : BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  64, 117, 205, 0.15),
                                              offset: Offset(0, 12),
                                              blurRadius: 28,
                                              spreadRadius: 0,
                                            )
                                          ],
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(24.w),
                                        ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24.w),
                                        color: postAssessmentController
                                                    .programDurationDetails
                                                    .value!
                                                    .duration![index]!
                                                    .isSelected ==
                                                true
                                            ? const Color(0xFFF5F9FF)
                                            : Colors.white),
                                    child: (postAssessmentController
                                                .programDurationDetails
                                                .value!
                                                .duration![index]!
                                                .isRecommended ==
                                            true)
                                        ? Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Spacer(),
                                              Text(
                                                "RECOMMENDED".tr,
                                                textAlign: TextAlign.center,
                                                style: recommendedTextStyle(),
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                              ),
                                            ],
                                          )
                                        : const Offstage(),
                                  )),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image(
                                      width: 104.w,
                                      height: 130.h,
                                      image: const AssetImage(
                                          Images.durationClockImage),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          postAssessmentController
                                              .programDurationDetails
                                              .value!
                                              .duration![index]!
                                              .duration!,
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontFamily: 'Circular Std',
                                            fontSize: 36.sp,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          "MINS".tr,
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontFamily: 'Circular Std',
                                            fontSize: 14.sp,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              CircleCheckbox(
                                activeColor: AppColors.primaryColor,
                                inactiveColor: AppColors.whiteColor,
                                value: postAssessmentController
                                    .programDurationDetails
                                    .value!
                                    .duration![index]!
                                    .isSelected!,
                                onChanged: (value) {
                                  postAssessmentController
                                      .setProgramDuration(index);
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    pageController.nextPage(
                                        duration: Duration(
                                            milliseconds:
                                                defaultAnimateToPageDuration),
                                        curve: Curves.easeIn);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 20.h),
            child: Text(
              "Make sure you choose the session duration wisely. There will be no change to the program's schedule later.",
              textAlign: TextAlign.center,
              style: primaryFontSecondaryLabelSmallTextStyle(),
            ),
          )
        ],
      ),
    );
  }
}
