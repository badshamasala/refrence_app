import 'package:aayu/controller/home/home_controller.dart';
import 'package:aayu/controller/home/home_top_section_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SleepSection extends StatelessWidget {
  final HomePageTopSectionResponseDetailsSleep? sleepContent;
  const SleepSection({Key? key, required this.sleepContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return GetBuilder<HomeTopSectionController>(
      builder: (homeTopSectionController) {
        if (homeTopSectionController.countDownTimer.value <= 0) {
          if (homeController.userDetails.value!.userDetails!.gender ==
              "Female") {
            return postTimerFemaleContent(homeController);
          }

          return postTimerContent(homeController);
        }

        return timerContent(homeTopSectionController);
      },
    );
  }

  timerContent(HomeTopSectionController homeTopSectionController) {
    return Container(
      height: 470.h,
      width: double.infinity,
      padding: EdgeInsets.only(top: 73.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A93),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(188.0.w),
          bottomRight: Radius.circular(188.0.w),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'BEDTIME_IS_APPROACHING_TEXT'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.1666666666666667.h,
            ),
          ),
          SizedBox(
            height: 52.38.h,
          ),
          Stack(
            children: [
              Image(
                image: const AssetImage(Images.sleepTimerImage),
                height: 88.25.h,
                width: 157.59.w,
                fit: BoxFit.contain,
              ),
              Positioned(
                bottom: 16.21.h,
                left: 12.w,
                top: 48.h,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: 'Digital Numbers',
                      fontSize: 34.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 0.5882352941176471,
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: homeTopSectionController.countDownTimer.value < 10
                            ? "0${homeTopSectionController.countDownTimer.value.toString()}"
                            : homeTopSectionController.countDownTimer.value
                                .toString(),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.bottom,
                        child: Text(
                          'MIN'.tr,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: 'Digital Numbers',
                            fontSize: 18.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 0.5882352941176471,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 13.17.h,
          ),
          Image(
            image: const AssetImage(Images.sleepEllipseImage),
            width: 111.66.h,
            height: 7.2.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 36.h),
          SizedBox(
            width: 250.w,
            child: Text(
              'SLEEP_INSTRUCTIONS'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.375.h,
              ),
            ),
          )
        ],
      ),
    );
  }

  postTimerFemaleContent(HomeController homeController) {
    return Container(
      height: 470.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A93),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(188.0.w),
          bottomRight: Radius.circular(188.0.w),
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 136.h,
            child: Image(
              image: const AssetImage(
                Images.postSleepTimerFemaleImage,
              ),
              width: 186.w,
              height: 186.h,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 31.h,
            child: SvgPicture.asset(
              AppIcons.infoSVG,
              color: AppColors.whiteColor,
              width: 20.w,
              height: 20.h,
            ),
          ),
          randomEllipse(143, 43),
          randomEllipse(42, 114),
          randomEllipse(42, 314),
          randomEllipse(318, 261),
          randomEllipse(314, 162),
          randomEllipse(290, 71),
          Positioned(
            top: 73.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey ${homeController.userDetails.value?.userDetails!.firstName ?? ""},\nIt’s past your bedtime!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1.1666666666666667.h,
                  ),
                ),
                SizedBox(
                  height: 205.h,
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    'SLEEP_INSTRUCTIONS2'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.4285714285714286.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  randomEllipse(double leftPosition, double topPosition) {
    return Positioned(
      left: leftPosition.w,
      top: topPosition.h,
      child: Container(
        width: 5.w,
        height: 5.w,
        decoration: const BoxDecoration(
          color: Color(0xFF4B56DE),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  postTimerContent(HomeController homeController) {
    return Container(
      height: 470.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF3E3A93),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(188.0.w),
          bottomRight: Radius.circular(188.0.w),
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 20.h,
            child: Image(
              image: const AssetImage(
                Images.postSleepTimerMaleImage,
              ),
              width: 271.w,
              height: 387.h,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 31.h,
            child: Text(
              'KNOW_MORE'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.whiteColor,
                decoration: TextDecoration.underline,
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.4285714285714286.h,
              ),
            ),
          ),
          Positioned(
            top: 73.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey ${homeController.userDetails.value?.userDetails!.firstName ?? ""},\nIt’s past your bedtime!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1.1666666666666667.h,
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                SizedBox(
                  width: 315.w,
                  child: Text(
                    'SLEEP_INSTRUCTIONS2'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.4285714285714286.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
