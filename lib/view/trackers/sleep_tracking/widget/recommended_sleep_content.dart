import 'package:aayu/controller/daily_records/sleep_tracker/sleep_tracker_summary_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/content/category_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecommendedSleepContent extends StatelessWidget {
  const RecommendedSleepContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SleepTrackerSummaryController>(
        id: "recommendedContent",
        builder: (controller) {
          if (controller.recommendedContent.value == null) {
            return const Offstage();
          } else if (controller.recommendedContent.value?.content == null) {
            return const Offstage();
          } else if (controller.recommendedContent.value!.content!.isEmpty) {
            return const Offstage();
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 38.h),
            color: const Color(0xFF3E3A93),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppTheme.pageHorizontalPadding,
                  child: Text(
                    "Handpicked for you",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
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
                SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      controller.recommendedContent.value!.content!.length,
                      (index) => Container(
                        margin: EdgeInsets.only(
                            right: 23.8.w, left: (index == 0) ? 26.w : 0),
                        child: CategoryContent(
                          source: "SLEEP_CONTENT",
                          categoryId:
                              controller.recommendedContent.value!.categoryId!,
                          categoryName: controller
                              .recommendedContent.value!.categoryName!,
                          categoryContent:
                              controller.recommendedContent.value!.content!,
                          medaDataBgColor: "#5550B6",
                          content: controller
                              .recommendedContent.value!.content![index]!,
                          width: 274,
                          height: 154,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
