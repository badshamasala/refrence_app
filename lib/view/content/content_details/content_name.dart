import 'package:aayu/controller/content/content_details_controller.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ContentName extends StatelessWidget {
  final ContentDetailsController contentController;
  final String contentId;
  final String source;

  final bool isPremium;
  final bool isSubscribed;

  const ContentName(
      {Key? key,
      required this.source,
      required this.contentController,
      required this.contentId,
      required this.isPremium,
      required this.isSubscribed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingularDeepLinkController singularDeepLinkController = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            toTitleCase(contentController
                .contentDetails.value!.content!.contentName!
                .trim()),
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Baskerville',
              fontSize: 24.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 4.w,
        ),
        GetBuilder<ContentDetailsController>(
            tag: contentId,
            builder: (favouriteController) {
              return InkWell(
                onTap: () {
                  if (source == "DEEPLINK") {
                    singularDeepLinkController
                        .handleClickOnContentDetailsBeforeReg(contentId);
                  } else {
                    EventsService().sendEvent(
                        favouriteController.contentDetails.value!.content!
                                    .isFavourite! ==
                                true
                            ? "Grow_Content_Unfavourite"
                            : "Grow_Content_Favourite",
                        {
                          "content_id": contentController
                              .contentDetails.value!.content!.contentId!,
                          "content_name": contentController
                              .contentDetails.value!.content!.contentName!,
                          "artist_name": contentController.contentDetails.value!
                              .content!.artist!.artistName!,
                          "content_type": contentController
                              .contentDetails.value!.content!.contentType!,
                        });

                    favouriteController.favouriteContent(
                        favouriteController
                            .contentDetails.value!.content!.contentId!,
                        !favouriteController
                            .contentDetails.value!.content!.isFavourite!);
                  }
                },
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                        offset: const Offset(-5, 10),
                        blurRadius: 20.h,
                      )
                    ],
                  ),
                  child: SvgPicture.asset(
                    AppIcons.favouriteFillSVG,
                    width: 16.w,
                    height: 16.h,
                    fit: BoxFit.contain,
                    color: (favouriteController
                                .contentDetails.value!.content!.isFavourite! ==
                            true)
                        ? const Color(0xFF88EF95)
                        : const Color(0xFF9C9EB9),
                  ),
                ),
              );
            }),
        SizedBox(
          width: 8.w,
        ),
        Container(
          height: 32.h,
          width: 32.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                offset: const Offset(-5, 10),
                blurRadius: 20.h,
              )
            ],
          ),
          child: InkWell(
            onTap: () async {
              if (source == "DEEPLINK") {
                singularDeepLinkController
                    .handleClickOnContentDetailsBeforeReg(contentId);
              } else {
                buildShowDialog(context);
                await ShareService().shareContent(
                    contentController.contentDetails.value!.content!.contentId!,
                    contentController
                        .contentDetails.value!.content!.contentImage!);
                EventsService().sendEvent("Grow_Content_Share", {
                  "content_id": contentController
                      .contentDetails.value!.content!.contentId!,
                  "content_name": contentController
                      .contentDetails.value!.content!.contentName!,
                  "artist_name": contentController
                      .contentDetails.value!.content!.artist!.artistName!,
                  "content_type": contentController
                      .contentDetails.value!.content!.contentType!,
                });
                Navigator.pop(context);
              }
            },
            child: SvgPicture.asset(
              AppIcons.shareSVG,
              width: 12.6.w,
              height: 14.7.h,
              color: const Color(0xFF9C9EB9),
            ),
          ),
        )
      ],
    );
  }
}
