import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommitYourDuration extends StatelessWidget {
  final PageController pageController;
  const CommitYourDuration({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostAssessmentController postAssessmentController = Get.find();
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
            child: personalCareDurationHeader(
                context, "Personalised Care Program", showBackButton: true,
                onBackPressed: () {
              Navigator.pop(context);
            }),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: Text(
              " Recommended Duration",
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
              "The doctor recommends ${postAssessmentController.programDurationDetails.value!.duration![0]!.duration!} minutes of practice for you to see the best healing results. Confirm the duration and commit your mind and body to this healing routine.",
              textAlign: TextAlign.center,
              style: primaryFontSecondaryLabelSmallTextStyle(),
            ),
          ),
          SizedBox(
            height: 42.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 41.h,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 154.w,
                  height: 143.h,
                  margin: EdgeInsets.only(
                      top: 30.h,
                      bottom: 12.h //margin applied for bottom radio button
                      ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.w),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(64, 117, 205, 0.15),
                        offset: Offset(0, 12),
                        blurRadius: 28,
                        spreadRadius: 0,
                      )
                    ],
                    color: AppColors.whiteColor,
                  ),
                ),
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
                        image: const AssetImage(Images.durationClockImage),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            postAssessmentController.programDurationDetails
                                .value!.duration![0]!.duration!,
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
              ],
            ),
          ),
          InkWell(
            onTap: () {
              postAssessmentController.setProgramDuration(0);
              Future.delayed(const Duration(milliseconds: 200), () {
                pageController.nextPage(
                    duration:
                        Duration(milliseconds: defaultAnimateToPageDuration),
                    curve: Curves.easeIn);
              });
            },
            child: SizedBox(
              width: 302.w,
              child: mainButton("Next"),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
        ],
      ),
    );
  }
}
