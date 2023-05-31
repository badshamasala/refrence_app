import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/disease_details/widgets/testimonial/testimonial_user.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestimonialViewMore extends StatelessWidget {
  final TestimonialResponseTestimonials details;
  const TestimonialViewMore({Key? key, required this.details})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: pagePadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TestimonialUser(
            profilePic: details.profileImage!,
            userName: details.userName!,
            age: "${details.age} Years",
            city: details.city!,
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            details.testimonial!,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.2.h,
            ),
          )
        ],
      ),
    );
  }
}
