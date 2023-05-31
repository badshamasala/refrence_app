import 'package:aayu/controller/consultant/psychologist/psychology_recommened_content_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'breath_work.dart';
import 'recommended_psychologist_content.dart';

class PraticeForToday extends StatelessWidget {
  const PraticeForToday({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyRecommendedContentController
        psychologyRecommendedContentController =
        Get.put(PsychologyRecommendedContentController());
    psychologyRecommendedContentController.getContent();
    return Container(
      color: const Color(0xFFD9D9D9).withOpacity(0.2),
      padding: pageHorizontalPadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 26.h,
          ),
          Text(
            'Your practice for today',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.blackLabelColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              fontFamily: "Circular Std",
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          const BreathWorkWidget(),
          const RecommendedPsychologistContent()
        ],
      ),
    );
  }
}
