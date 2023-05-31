import 'package:aayu/model/model.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoseCorrectionBanner extends StatelessWidget {
  final HomePageTopSectionResponseDetailsPoseCorrection poseCorrection;
  const PoseCorrectionBanner({Key? key, required this.poseCorrection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: EdgeInsets.zero,
        height: 540.h,
        width: double.infinity,
        child: ShowNetworkImage(
          imgPath: poseCorrection.bannerImage!,
          imgWidth: double.infinity.w,
          imgHeight: 540.h,
          boxFit: BoxFit.cover,
          placeholderImage: "assets/images/placeholder/default_home.jpg",
        ),
      ),
    );
  }
}
