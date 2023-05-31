import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReviewUser extends StatelessWidget {
  final String profilePic;
  final String userName;
  final int createdAt;
  const ReviewUser({
    Key? key,
    required this.profilePic,
    required this.userName,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (profilePic.isEmpty)
            ? Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Image(
                  width: 40.w,
                  height: 40.h,
                  image: const AssetImage(Images.userImage),
                  fit: BoxFit.contain,
                ),
              )
            : Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ShowNetworkImage(
                    imgPath: profilePic,
                    imgWidth: 40,
                    imgHeight: 40,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
        SizedBox(
          width: 13.w,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.isEmpty ? "Anonymous" : userName,
                maxLines: 1,
                style: selectedTabTextStyle(),
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                DateFormat('MMM dd yyyy, hh:mm aa')
                    .format(dateFromTimestamp(createdAt)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color.fromRGBO(91, 112, 129, 0.800000011920929),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 1.h,
                  fontFamily: "Circular Std",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}