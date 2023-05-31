import 'package:aayu/controller/daily_records/mood_tracker/mood_tracker_summary_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/category_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecommendedMoodContent extends StatelessWidget {
  const RecommendedMoodContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodTrackerSummaryController>(
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
            padding: EdgeInsets.symmetric(vertical: 26.h),
            color: AppColors.whiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppTheme.pageHorizontalPadding,
                  child: Text(
                    "Based on your mood",
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
                          source: "MOOD_CONTENT",
                          categoryId:
                              controller.recommendedContent.value!.categoryId!,
                          categoryName: controller
                              .recommendedContent.value!.categoryName!,
                          categoryContent:
                              controller.recommendedContent.value!.content!,
                          medaDataBgColor: "#F1F1F1",
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
