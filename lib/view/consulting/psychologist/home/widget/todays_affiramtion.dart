// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/todays_affirmation_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/affirmation_section.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TodaysAffirmation extends StatelessWidget {
  const TodaysAffirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodaysAffirmationController todaysAffirmationController =
        Get.put(TodaysAffirmationController());
    Future.delayed(Duration.zero, () async {
      await todaysAffirmationController.getRandomAffirmation();
      if (todaysAffirmationController.todaysAffirmation.value != null &&
          todaysAffirmationController.todaysAffirmation.value!.content !=
              null &&
          todaysAffirmationController
              .todaysAffirmation.value!.content!.isNotEmpty) {
        showAffirmationDialog(
            todaysAffirmationController
                .todaysAffirmation.value!.content!.first!,
            context);
      }
    });

    return Obx(() {
      if (todaysAffirmationController.isLoading.value == true) {
        return const Offstage();
      } else if (todaysAffirmationController.todaysAffirmation.value == null) {
        return const Offstage();
      } else if (todaysAffirmationController.todaysAffirmation.value!.content ==
          null) {
        return const Offstage();
      } else if (todaysAffirmationController
          .todaysAffirmation.value!.content!.isEmpty) {
        return const Offstage();
      }
      return Container(
        color: const Color(0xFFFFF3F3),
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppIcons.affirmationSVG,
                width: 38.w,
                height: 42.h,
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Text(
                  "“${todaysAffirmationController.todaysAffirmation.value?.content?.first?.contentName ?? ""}”",
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 12.sp,
                    height: 1.3.h,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  showAffirmationDialog(Content content, BuildContext context) {
    return Get.defaultDialog(
      barrierDismissible: true,
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Start Your Day On a\nPositive Note",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff374957),
              fontFamily: "BaskerVille",
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          GetBuilder<TodaysAffirmationController>(
              id: "Affirmation",
              builder: (controller) {
                return AffirmationSection(
                  content: content,
                  favouriteAction: controller.favouriteAffirmation,
                );
              }),
              SizedBox(height: 26.h,),
          SizedBox(
            width: 240.w,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: mainButton("Okay"),
            ),
          )
        ],
      ),
    );
  }
}
