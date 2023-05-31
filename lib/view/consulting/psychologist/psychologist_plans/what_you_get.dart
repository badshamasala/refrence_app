import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhatYouGet extends StatelessWidget {
  const WhatYouGet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> listofData = [
      {
        "title": "Online Video\nConsultation at ease",
        "image": Images.personalisedCareLogo
      },
      {"title": "Human Counsellors", "image": Images.eventsAayu},
      {
        "title": "Confidentiality\nGuaranteed",
        "image": Images.personalisedCareLogo
      },
      {"title": "Self Help Program", "image": Images.selfHelpProgramImage},
      {"title": "Constant Support", "image": Images.customerSupportImage},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Here’s what you get",
          style: TextStyle(
            color: const Color(0xffFF7979),
            fontFamily: "Circular Std",
            fontSize: 20.sp,
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16.w,
          runSpacing: 40.h,
          children: List.generate(
            listofData.length,
            (index) {
              return Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: 120.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF1F5FC),
                  borderRadius: BorderRadius.circular(
                    16.sp,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -30.h,
                      child: Image(
                        image: AssetImage(listofData[index]["image"]!),
                        height: 60.h,
                        width: 100.w,
                      ),
                    ),
                    Positioned(
                      top: 40.h,
                      child: Text(
                        listofData[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.bottomNavigationLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "Don't suffer in silence. Reach out for help and\nstart your journey towards a happier, healthier\nyou.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.bottomNavigationLabelColor,
            fontFamily: 'Circular Std',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.5.h,
          ),
        ),
      ],
    );
  }
}
