import 'package:aayu/model/model.dart';
import 'package:aayu/view/content/widgets/premium_content.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ContentViews extends StatelessWidget {
  final ContentMetaData? metaData;
  const ContentViews({Key? key, required this.metaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: appProperties.content!.display!.rating == true,
          child: Container(
            height: 20.h,
            width: 53.w,
            padding: EdgeInsets.all(2.w),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              color: const Color(0xFFDDE8E5),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.contentDetailsRatingSVG,
                    width: 12.w,
                    height: 12.h,
                    color: const Color(0xFF5C7F6B),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "${metaData!.rating!}",
                    style: TextStyle(
                      color: const Color(0xFF5C7F6B),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: appProperties.content!.display!.views == true,
          child: Container(
            height: 20.h,
            width: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              color: const Color(0xFFDDE8E5),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.contentViewsSVG,
                    width: 13.h,
                    height: 10.12.h,
                    color: const Color(0xFF5C7F6B),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    metaData!.views!,
                    style: TextStyle(
                      color: const Color(0xFF5C7F6B),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        PremiumContent(
          showFull: true,
          isPremiumContent: metaData!.isPremium!,
          color: const Color(0xFF5C7F6B),
        ),
      ],
    );
  }
}
