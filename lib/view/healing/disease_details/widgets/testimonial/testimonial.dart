import 'dart:core';

import 'package:aayu/controller/healing/testimonial_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/disease_details/widgets/testimonial/testimonial_user.dart';
import 'package:aayu/view/healing/disease_details/widgets/testimonial/testimonial_view_more.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Testimonial extends StatelessWidget {
  final DiseaseDetailsRequest diseaseIds;
  const Testimonial({Key? key, required this.diseaseIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TestimonialController testimonialController =
        Get.put(TestimonialController());

    Future.delayed(Duration.zero, () {
      testimonialController.getTestimonials(diseaseIds);
    });

    return Obx(() {
      if (testimonialController.isLoading.value == true) {
        return showLoading();
      } else if (testimonialController.testimonialResponse.value == null) {
        return showLoading();
      } else if (testimonialController
              .testimonialResponse.value!.testimonials ==
          null) {
        return const Offstage();
      } else if (testimonialController
          .testimonialResponse.value!.testimonials!.isEmpty) {
        return const Offstage();
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 27.h,
          ),
          Container(
            margin: const EdgeInsets.only(left: 26, right: 26, bottom: 15),
            child: Text(
              "TESTIMONIALS".tr,
              style: selectedTabTextStyle(),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: pageHorizontalPadding(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                testimonialController
                    .testimonialResponse.value!.testimonials!.length,
                (index) => InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Wrap(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.pageBackgroundColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: TestimonialViewMore(
                                details: testimonialController
                                    .testimonialResponse
                                    .value!
                                    .testimonials![index]!,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 275.w,
                    padding: EdgeInsets.zero,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 7.w,
                            top: 26.h,
                          ),
                          height: 163.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6EBF1).withOpacity(0.5),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              top: 77.h, left: 20.w, right: 20.w, bottom: 12.h),
                          child: Text(
                            testimonialController.testimonialResponse.value!
                                .testimonials![index]!.testimonial!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontFamily: 'Circular Std',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              height: 1.2.h,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, top: 10.h),
                          child: TestimonialUser(
                              profilePic: testimonialController
                                  .testimonialResponse
                                  .value!
                                  .testimonials![index]!
                                  .profileImage!,
                              userName: testimonialController
                                  .testimonialResponse
                                  .value!
                                  .testimonials![index]!
                                  .userName!,
                              age:
                                  "${testimonialController.testimonialResponse.value!.testimonials![index]!.age} Years",
                              city: testimonialController.testimonialResponse
                                  .value!.testimonials![index]!.city!,
                              applyTopPadding: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
