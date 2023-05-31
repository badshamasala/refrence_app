import 'package:aayu/controller/daily_records/mood_tracker/mood_identify_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MoodIdentify extends StatelessWidget {
  final PageController pageController;
  final double appBarHeight;
  const MoodIdentify(
      {Key? key, required this.pageController, required this.appBarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double adjustAppBarHeight = appBarHeight + 30;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: (85 - adjustAppBarHeight).h,
            left: 0,
            right: 0,
            child: Text(
              "LET'S IDENTIFY...",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xFFF39D9D),
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.normal,
                  height: 1.5),
            ),
          ),
          Positioned(
            top: (111 - adjustAppBarHeight).h,
            left: 0,
            right: 0,
            child: Text(
              'Why are you feeling this way?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Baskerville',
                fontSize: 24.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.1666666666666667.h,
              ),
            ),
          ),
          Positioned(
            top: (725 - adjustAppBarHeight).h,
            child:
                GetBuilder<MoodIdentifyController>(builder: (buttonController) {
              if (buttonController.optionsSelected > 0) {
                return InkWell(
                  onTap: () {
                    pageController.animateToPage(3,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  child: SizedBox(
                    width: 154.w,
                    child: mainButton("Next"),
                  ),
                );
              }
              return SizedBox(
                width: 154.w,
                child: disabledButton("Next"),
              );
            }),
          ),
          GetBuilder<MoodIdentifyController>(
            builder: (controller) {
              if (controller.isLoading.value == true) {
                return showLoading();
              } else if (controller.pageContent.identifications == null) {
                return showLoading();
              } else if (controller.pageContent.identifications!.isEmpty) {
                return showLoading();
              }
              return Stack(
                alignment: Alignment.topCenter,
                children: List.generate(
                  controller.pageContent.identifications!.length,
                  (index) {
                    return Positioned(
                      top: (controller.pageContent.identifications![index]!
                                  .position!.top! -
                              adjustAppBarHeight)
                          .h,
                      left: controller.pageContent.identifications![index]!
                          .position!.left!.w,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          controller.changeOptionStatus(index);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              controller
                                  .pageContent.identifications![index]!.image!,
                              color: controller.pageContent
                                          .identifications![index]!.selected ==
                                      true
                                  ? const Color(0xFFFFE488)
                                  : const Color(0xFFF7F7F7),
                              width: controller.pageContent
                                  .identifications![index]!.size!.width!.w,
                              height: controller.pageContent
                                  .identifications![index]!.size!.height!.h,
                            ),
                            Text(
                              controller.pageContent.identifications![index]!
                                  .identification!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontFamily: 'Circular Std',
                                fontSize: 14.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
