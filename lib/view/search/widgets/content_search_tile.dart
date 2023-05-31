import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/grow/grow.page.content.model.dart';
import '../../../theme/theme.dart';
import '../../shared/constants.dart';
import '../../shared/network_image.dart';
import '../../shared/ui_helper/icons.dart';

class ContentSearchTile extends StatelessWidget {
  final Function onTapFunction;
  final Content content;
  final Function? favouriteAction;
  final Function playAction;
  const ContentSearchTile(
      {Key? key,
      required this.onTapFunction,
      required this.content,
      required this.favouriteAction,
      required this.playAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: InkWell(
        onTap: () {
          onTapFunction();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.w),
                  child: ShowNetworkImage(
                    imgPath: content.contentImage!,
                    imgWidth: 87.w,
                    imgHeight: 64.h,
                    boxFit: BoxFit.fill,
                  ),
                ),
                Visibility(
                  visible: content.metaData!.isPremium!,
                  child: Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: SvgPicture.asset(
                      AppIcons.premiumIconSVG,
                      width: 12.h,
                      fit: BoxFit.fitWidth,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: (content.contentType == "Music"),
                              child: SvgPicture.asset(
                                AppIcons.musicSVG,
                                width: 9.w,
                                height: 9.h,
                                color: AppColors.secondaryLabelColor,
                              ),
                            ),
                            Visibility(
                              visible: (content.contentType == "Audio"),
                              child: SvgPicture.asset(
                                AppIcons.audioSmallSVG,
                                width: 9.w,
                                height: 9.h,
                                color: AppColors.secondaryLabelColor,
                              ),
                            ),
                            Visibility(
                              visible: (content.contentType == "Video"),
                              child: SvgPicture.asset(
                                AppIcons.playSmallSVG,
                                width: 9.w,
                                height: 9.h,
                                color: AppColors.secondaryLabelColor,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              content.metaData!.duration ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.secondaryLabelColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: appProperties.content!.display!.rating == true,
                        child: SizedBox(
                          width: 8.w,
                        ),
                      ),
                      Visibility(
                        visible: appProperties.content!.display!.rating == true,
                        child: Container(
                          width: 44.w,
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 6.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppIcons.contentRatingSVG,
                                width: 9.w,
                                height: 9.h,
                                color: AppColors.secondaryLabelColor,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                content.metaData!.rating!.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    content.contentName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 14.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1.1428571428571428.h,
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    content.metaData!.contentTag ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 12.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.1428571428571428.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            if (favouriteAction != null)
              InkWell(
                onTap: () {
                  favouriteAction!();
                },
                child: SvgPicture.asset(
                  AppIcons.favouriteFillSVG,
                  width: 24.w,
                  height: 24.h,
                  color: (content.isFavourite == true)
                      ? const Color(0xFF88EF95)
                      : const Color(0xFF9C9EB9),
                ),
              ),
            SizedBox(
              width: 12.w,
            ),
            InkWell(
              onTap: () {
                playAction();
              },
              child: SvgPicture.asset(
                AppIcons.playSVG,
                width: 24.w,
                height: 24.h,
                color: const Color(0xFF88EF95),
              ),
            )
          ],
        ),
      ),
    );
  }
}
