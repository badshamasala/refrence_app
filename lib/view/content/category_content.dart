// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/player/content_preview_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/content_audio_preview.dart';
import 'package:aayu/view/content/content_details/content_details.dart';
import 'package:aayu/view/content/content_video_preview.dart';
import 'package:aayu/view/player/audio_play_list.dart';
import 'package:aayu/view/player/video_player.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import 'widgets/premium_content.dart';

class CategoryContent extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String medaDataBgColor;
  final Content content;
  final List<Content?> categoryContent;
  final double width;
  final double height;
  final String source;
  const CategoryContent(
      {Key? key,
      required this.source,
      required this.categoryId,
      required this.categoryName,
      required this.medaDataBgColor,
      required this.content,
      required this.categoryContent,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (width).w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 10,
                child: Container(
                  width: (width - 40).w,
                  height: (height).h,
                  decoration: BoxDecoration(
                    color: (content.metaData != null &&
                            content.metaData!.multiSeries == true)
                        ? const Color(0xFFE8E8E8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                child: Container(
                  width: (width - 20).w,
                  height: (height).h,
                  decoration: BoxDecoration(
                    color: (content.metaData != null &&
                            content.metaData!.multiSeries == true)
                        ? const Color(0xFFD0D0D0)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14.w),
                  ),
                ),
              ),
              GetBuilder<ContentPreviewController>(
                  builder: (contentPreviewController) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16.w),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (content.contentId != null) {
                            EventsService()
                                .sendEvent("Grow_Content_Details_Clicked", {
                              "content_category": categoryName,
                              "content_id": content.contentId!,
                              "content_name": content.contentName!,
                              "artist_name": content.artist!.artistName!,
                              "content_type": content.contentType!,
                              "content_duration": content.metaData!.duration!,
                              "multi_series": content.metaData!.multiSeries,
                            });
                            EventsService().sendClickNextEvent(
                                "ContentSection", "Content", "ContentDetails");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentDetails(
                                  growCategoryName: categoryName,
                                  source: source,
                                  heroTag:
                                      "Details_${categoryId}_${content.contentId}",
                                  contentId: content.contentId!,
                                  categoryContent: categoryContent,
                                ),
                              ),
                            ).then((value) {
                              EventsService().sendClickBackEvent(
                                  "ContentDetails", "Back", "ContentSection");
                            });
                          }
                        },
                        child: Hero(
                          tag: "Details_${categoryId}_${content.contentId}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.w),
                            child: ShowNetworkImage(
                              imgWidth: width.w,
                              imgHeight: height.h,
                              boxFit: BoxFit.fill,
                              imgPath: content.contentImage!,
                              placeholderImage:
                                  "assets/images/placeholder/default_carousel.jpg",
                            ),
                          ),
                        ),
                      ),
                      (contentPreviewController.playContentPreview.value ==
                                  true &&
                              contentPreviewController
                                      .selectedContent.value?.contentId ==
                                  content.contentId)
                          ? (content.contentType == "Video")
                              ? ContentVideoPreview(content: content)
                              : ContentAudioPreview(
                                  content: content,
                                  width: width,
                                  height: height,
                                )
                          : const Offstage()
                    ],
                  ),
                );
              }),
              Positioned(
                top: 11.h,
                right: 16.w,
                child: GetBuilder<ContentPreviewController>(
                    builder: (contentPreviewController) {
                  return InkWell(
                    onTap: () {
                      if (contentPreviewController.playContentPreview.value ==
                              true &&
                          contentPreviewController
                                  .selectedContent.value?.contentId ==
                              content.contentId) {
                        contentPreviewController.stopContentPreview();
                      }
                    },
                    child: contentPreviewController.playContentPreview.value ==
                                true &&
                            contentPreviewController
                                    .selectedContent.value?.contentId ==
                                content.contentId
                        ? const Icon(
                            Icons.cancel_rounded,
                            color: Color(0xFF88EF95),
                          )
                        : const Offstage(),
                  );
                }),
              ),
              Positioned(
                bottom: 16.h,
                right: 16.w,
                child: GetBuilder<ContentPreviewController>(
                    builder: (contentPreviewController) {
                  return InkWell(
                    onTap: () {
                      if (content.metaData!.isPremium == false ||
                          subscriptionCheckResponse != null &&
                              subscriptionCheckResponse!.subscriptionDetails !=
                                  null &&
                              subscriptionCheckResponse!.subscriptionDetails!
                                  .subscriptionId!.isNotEmpty) {
                        playContent(context);
                      } else {
                        EventsService().sendEvent("Content_Preview_Clicked", {
                          "content_id": content.contentId,
                          "content_name": content.contentName,
                          "content_type": content.contentType
                        });
                        contentPreviewController.startContentPreview(content);
                      }
                    },
                    child: contentPreviewController.playContentPreview.value ==
                                true &&
                            contentPreviewController
                                    .selectedContent.value?.contentId ==
                                content.contentId
                        ? const Offstage()
                        : SvgPicture.asset(
                            AppIcons.playSVG,
                            width: 24.h,
                            fit: BoxFit.fitWidth,
                            color: const Color(0xFF88EF95),
                          ),
                  );
                }),
              ),
              Positioned(
                left: 16.w,
                top: 11.h,
                child: PremiumContent(
                  color: const Color(0xFFAAFDB4),
                  isPremiumContent: content.metaData!.isPremium!,
                ),
              ),
              Positioned(
                bottom: 0,
                child: GetBuilder<ContentPreviewController>(
                    builder: (contentPreviewController) {
                  return contentPreviewController.playContentPreview.value ==
                              true &&
                          contentPreviewController
                                  .selectedContent.value?.contentId ==
                              content.contentId &&
                          contentPreviewController
                                  .selectedContent.value?.contentType ==
                              "Video"
                      ? SizedBox(
                          width: width.w,
                          height: 26.h,
                          child: Marquee(
                            text:
                                "You’re watching a sneak peek of the Premium version",
                            velocity: 50,
                            blankSpace: 100.0,
                            pauseAfterRound: const Duration(seconds: 0),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            scrollAxis: Axis.horizontal,
                            accelerationDuration: const Duration(seconds: 0),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: const Duration(seconds: 0),
                            decelerationCurve: Curves.easeOut,
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 12.sp,
                                fontFamily: "Circular Std"),
                          ),
                        )
                      : const Offstage();
                }),
              )
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          SizedBox(
            width: (width).w,
            child: Text(
              toTitleCase(content.contentName!.isNotEmpty
                  ? content.contentName!.trim()
                  : ""),
              maxLines: 2,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: (source == "SLEEP_CONTENT")
                    ? Colors.white.withOpacity(.8)
                    : AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w700,
                height: 1.2.h,
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 18.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.w),
                  color: Color(
                    int.parse(
                      "0xFF${medaDataBgColor.replaceAll("#", "")}",
                    ),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: (content.contentType == "Music"),
                        child: SvgPicture.asset(
                          AppIcons.musicSVG,
                          width: 11.46.w,
                          height: 11.46.h,
                          color: (source == "SLEEP_CONTENT") ? const Color(0xFF908CE0):AppColors.secondaryLabelColor,
                        ),
                      ),
                      Visibility(
                        visible: (content.contentType == "Audio"),
                        child: SvgPicture.asset(
                          AppIcons.audioSmallSVG,
                          width: 11.46.w,
                          height: 11.46.h,
                          color: (source == "SLEEP_CONTENT") ? const Color(0xFF908CE0):AppColors.secondaryLabelColor,
                        ),
                      ),
                      Visibility(
                        visible: (content.contentType == "Video"),
                        child: SvgPicture.asset(
                          AppIcons.playSmallSVG,
                          width: 11.56.w,
                          height: 11.56.h,
                          color: (source == "SLEEP_CONTENT") ? const Color(0xFF908CE0):AppColors.secondaryLabelColor,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        (content.metaData != null)
                            ? content.metaData!.duration ?? ""
                            : "",
                        style: TextStyle(
                          color: (source == "SLEEP_CONTENT") ? const Color(0xFF908CE0):AppColors.secondaryLabelColor,
                          fontFamily: 'Circular Std',
                          fontSize: 11.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                          height: 1.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: (content.metaData != null &&
                    content.metaData!.language != null &&
                    content.metaData!.language!.isNotEmpty),
                child: Container(
                  height: 18.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  margin: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.w),
                    color: Color(
                      int.parse(
                        "0xFF${medaDataBgColor.replaceAll("#", "")}",
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      content.metaData != null
                          ? content.metaData!.language ?? ""
                          : "",
                      style: TextStyle(
                        color: (source == "SLEEP_CONTENT") ? const Color(0xFF908CE0):AppColors.secondaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 11.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                        height: 1.h,
                      ),
                    ),
                  ),
                ),
              ),
              appProperties.content!.display!.artistName == true
                  ? Visibility(
                      visible: content.artist != null &&
                          content.artist!.artistName!.isNotEmpty,
                      child: Expanded(
                        child: Container(
                          height: 18.h,
                          margin: EdgeInsets.only(left: 8.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (content.artist != null &&
                                      content.artist!.artistName!.isNotEmpty)
                                  ? content.artist!.artistName!.trim()
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                color: (source == "SLEEP_CONTENT")
                                    ? Colors.white.withOpacity(.8)
                                    : AppColors.secondaryLabelColor,
                                fontFamily: 'Circular Std',
                                fontSize: 11.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                height: 1.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Visibility(
                      visible:
                          appProperties.content!.display!.contentTag == true,
                      child: Expanded(
                        child: Container(
                          height: 18.h,
                          margin: EdgeInsets.only(left: 8.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              content.metaData!.contentTag ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                color: (source == "SLEEP_CONTENT") ? const Color(0xFF908CE0):AppColors.secondaryLabelColor,
                                fontFamily: 'Circular Std',
                                fontSize: 11.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                height: 1.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }

  playContent(context) {
    if (content.contentType == "Video") {
      if (content.contentPath != null && content.contentPath!.isNotEmpty) {
        EventsService()
            .sendClickNextEvent("ContentSection", "Content", "VideoPlayer");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayer(
              growCategoryName: categoryName,
              content: content,
            ),
          ),
        ).then((value) {
          EventsService()
              .sendClickBackEvent("VideoPlayer", "Back", "ContentSection");
        });
      } else {
        showGetSnackBar("Content not avaialble!", SnackBarMessageTypes.Info);
      }
    } else if (content.contentType == "Audio" ||
        content.contentType == "Music") {
      if (content.contentPath != null && content.contentPath!.isNotEmpty) {
        EventsService()
            .sendClickNextEvent("ContentSection", "Content", "AudioPlayer");
        List<Content?> audioPlayList = [];
        if (subscriptionCheckResponse != null &&
            subscriptionCheckResponse!.subscriptionDetails != null) {
          audioPlayList = categoryContent
              .where(
                (element) => (element!.contentType == "Audio" ||
                    element.contentType == "Music"),
              )
              .toList();
        } else {
          audioPlayList = categoryContent
              .where(
                (element) =>
                    (element!.contentType == "Audio" ||
                        element.contentType == "Music") &&
                    element.metaData!.isPremium == false,
              )
              .toList();
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioPlayList(
              growCategoryName: categoryName,
              heroTag: "Audio_${categoryId}_${content.contentId}",
              playContentId: content.contentId!,
              categoryContent: audioPlayList,
            ),
          ),
        ).then((value) {
          EventsService()
              .sendClickBackEvent("AudioPlayList", "Back", "ContentSection");
        });
      } else {
        showGetSnackBar("Content not avaialble!", SnackBarMessageTypes.Info);
      }
    }
  }
}
