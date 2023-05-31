import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestimonialUser extends StatelessWidget {
  final String profilePic;
  final String userName;
  final String age;
  final String city;
  final bool applyTopPadding;
  const TestimonialUser({
    Key? key,
    required this.profilePic,
    required this.userName,
    required this.age,
    required this.city,
    this.applyTopPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (profilePic.isEmpty)
            ? Container(
                width: 83.w,
                height: 83.w,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Image(
                  width: 83.w,
                  height: 83.h,
                  image: const AssetImage(Images.userImage),
                  fit: BoxFit.contain,
                ),
              )
            : Container(
                width: 83.w,
                height: 83.w,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ShowNetworkImage(
                    imgPath: profilePic,
                    imgWidth: 83,
                    imgHeight: 83,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
        Expanded(
          child: Container(
            margin:
                EdgeInsets.only(left: 10.w, top: applyTopPadding ? 20.h : 0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  style: selectedTabTextStyle(),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Text(
                  "$age, $city",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        const Color.fromRGBO(91, 112, 129, 0.800000011920929),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    height: 1.h,
                    fontFamily: "Circular Std",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
