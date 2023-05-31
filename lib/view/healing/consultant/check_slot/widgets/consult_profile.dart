import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultProfile extends StatelessWidget {
final String consultType;
  final String profilePic;
  final String consultName;

  const ConsultProfile(
      {Key? key,
      required this.consultType,
      required this.profilePic,
      required this.consultName,})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 151.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.planSummaryBGImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.blackLabelColor,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 52.h,
            child: circularConsultImage(
                consultType, profilePic, 134, 134),
          ),
        ],
      ),
      SizedBox(
        height: 41.h,
      ),
      SingleChildScrollView(
         padding: pageHorizontalPadding(),
        scrollDirection: Axis.horizontal,
        child: Text(
          consultName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.blackLabelColor,
            fontSize: 24.sp,
            fontFamily: "Baskerville",
            fontWeight: FontWeight.w400,
            height: 1.5.h,
          ),
        ),
      ),
    ]);
  }
}
