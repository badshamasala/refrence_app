import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AffirmationGhostScreen extends StatelessWidget {
  const AffirmationGhostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: AppColors.shimmerColorLight,
        highlightColor: Colors.white,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 33.h),
                child: CircleAvatar(
                  backgroundColor: AppColors.shimmerColorLight,
                  radius: 147.h,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
