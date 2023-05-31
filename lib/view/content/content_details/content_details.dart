// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/casting/cast_controller.dart';
import 'package:aayu/controller/content/content_details_controller.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/category_section.dart';
import 'package:aayu/view/content/content_details/content_artist_section.dart';
import 'package:aayu/view/content/content_details/content_desc.dart';
import 'package:aayu/view/content/content_details/content_name.dart';
import 'package:aayu/view/content/content_details/content_reviews.dart';
import 'package:aayu/view/content/content_details/content_tags.dart';
import 'package:aayu/view/content/content_details/content_view.dart';
import 'package:aayu/view/player/audio_play_list.dart';
import 'package:aayu/view/player/video_player.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:expandable/expandable.dart';
import '../../../controller/you/you_controller.dart';
import '../../onboarding/get_started.dart';

class ContentDetails extends StatefulWidget {
  final String source;
  final String heroTag;
  final String contentId;
  final List<Content?> categoryContent;
  final String? growCategoryName;
  final bool autoPlayContent;
  const ContentDetails({
    Key? key,
    required this.heroTag,
    required this.contentId,
    required this.source,
    required this.categoryContent,
    this.growCategoryName,
    this.autoPlayContent = false,
  }) : super(key: key);

  @override
  State<ContentDetails> createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  late ContentDetailsController contentController;
  ScrollController scrollController = ScrollController();
  double top = 0.0;
  bool isSubscribed = false;
  @override
  void initState() {
    contentController =
        Get.put(ContentDetailsController(), tag: widget.contentId);
    Future.delayed(Duration.zero, () {
      contentController
          .getContentDetails(widget.contentId, widget.source == "DEEPLINK")
          .then((value) {
        if (widget.source == "THANKYOU") {
          Future.delayed(const Duration(milliseconds: 200), () {
            showThankYouBottomSheet();
          });
        } else {
          if (widget.autoPlayContent == true) {
            handlePlayContent();
          }
        }
      });
    });

    if (subscriptionCheckResponse != null &&
        subscriptionCheckResponse!.subscriptionDetails != null &&
        subscriptionCheckResponse!
            .subscriptionDetails!.subscriptionId!.isNotEmpty) {
      isSubscribed = true;
    }

    super.initState();
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  initScrollController() {
    scrollController = ScrollController()
      ..addListener(() {
        contentController.appBarTextColor = isSliverAppBarExpanded
            ? AppColors.blackLabelColor
            : Colors.transparent;
        contentController.update();
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (200 - kToolbarHeight).h;
  }

  showPaymentScreen() async {
    buildShowDialog(context);
    SubscriptionController subscriptionController = Get.find();
    await subscriptionController.getPreviousSubscriptionDetails();
    Navigator.pop(context);
    if (subscriptionController.previousSubscriptionDetails.value != null &&
        subscriptionController
                .previousSubscriptionDetails.value!.subscriptionDetails !=
            null) {
      EventsService()
          .sendClickNextEvent("Content", "Play", "PreviousSubscription");
      Get.bottomSheet(
        const PreviousSubscription(),
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
      ).then((value) {
        if (subscriptionCheckResponse != null &&
            subscriptionCheckResponse!.subscriptionDetails != null &&
            subscriptionCheckResponse!
                .subscriptionDetails!.subscriptionId!.isNotEmpty) {
          setState(() {
            isSubscribed = true;
          });
        }
      });
    } else {
      bool isAllowed = await checkIsPaymentAllowed("GROW");
      if (isAllowed == true) {
        EventsService()
            .sendClickNextEvent("Content", "Play", "SubscribeToAayu");
        Get.bottomSheet(
          SubscribeToAayu(
              subscribeVia: "CONTENT",
              content: contentController.contentDetails.value!.content),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
        ).then((value) {
          if (subscriptionCheckResponse != null &&
              subscriptionCheckResponse!.subscriptionDetails != null &&
              subscriptionCheckResponse!
                  .subscriptionDetails!.subscriptionId!.isNotEmpty) {
            setState(() {
              isSubscribed = true;
            });
          }
        });
      }
    }
  }

  showThankYouBottomSheet() {
    YouController youController = Get.put(YouController());
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (context) {
          return Obx(() {
            if (youController.isLoading.value) {
              return showLoading();
            } else if (youController.userDetails.value == null) {
              return showLoading();
            }
            return Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 138.h, bottom: 40.h, left: 48.h, right: 48.h),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      (youController.userDetails.value != null &&
                              youController.userDetails.value!.userDetails !=
                                  null)
                          ? Text(
                              'HEY ${youController.userDetails.value!.userDetails!.firstName ?? ""}!'
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.blueGreyAssessmentColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700),
                            )
                          : Text(
                              'HEY!'.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.blueGreyAssessmentColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Text(
                        'Thank you for registering with us. Now you can watch unlimited content and view your health progress periodically.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 29.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 22.w),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.07),
                                    offset: Offset(-5, 10),
                                    blurRadius: 20)
                              ]),
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Positioned(
                    top: -29.h,
                    child: Image.asset(
                      Images.flowerThankYouDeeplinkImage,
                      height: 156.h,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    SingularDeepLinkController singularDeepLinkController = Get.find();
    CastController castController = Get.put(CastController());

    return WillPopScope(
      onWillPop: () async {
        if (widget.source == "DEEPLINK") {
          Get.close(2);
          Get.to(const GetStarted());
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() {
          if (contentController.isLoading.value == true) {
            return showLoading();
          } else if (contentController.contentDetails.value == null) {
            return showLoading();
          } else if (contentController.contentDetails.value!.content == null) {
            return showLoading();
          } else if (contentController
                  .contentDetails.value!.content!.contentId ==
              null) {
            return showLoading();
          } else if (contentController
              .contentDetails.value!.content!.contentId!.isEmpty) {
            return showLoading();
          }

          return NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    title: const Offstage(),
                    leading: const Offstage(),
                    pinned: true,
                    stretch: true,
                    snap: false,
                    floating: false,
                    expandedHeight: 278.h,
                    elevation: 0,
                    centerTitle: true,
                    forceElevated: innerBoxIsScrolled,
                    iconTheme: IconThemeData(
                        color: isSliverAppBarExpanded
                            ? contentController.appBarTextColor
                            : Colors.transparent),
                    flexibleSpace:
                        LayoutBuilder(builder: (context, constraints) {
                      top = constraints.biggest.height;
                      return FlexibleSpaceBar(
                        stretchModes: const [StretchMode.zoomBackground],
                        centerTitle: true,
                        title: top.floor() ==
                                (MediaQuery.of(context).padding.top +
                                        kToolbarHeight +
                                        15.0)
                                    .floor()
                            ? AppBar(
                                elevation: 0,
                                centerTitle: true,
                                iconTheme: const IconThemeData(
                                    color: AppColors.blackLabelColor),
                                backgroundColor: const Color(0xFFF1F8F6),
                                title: Text(
                                  contentController.contentDetails.value!
                                      .content!.contentName!,
                                  style: TextStyle(
                                      color: AppColors.blackLabelColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                                actions: [
                                  GetBuilder<ContentDetailsController>(
                                      tag: widget.contentId,
                                      builder: (favouriteController) {
                                        return InkWell(
                                          onTap: () {
                                            if (widget.source == "DEEPLINK") {
                                              singularDeepLinkController
                                                  .handleClickOnContentDetailsBeforeReg(
                                                      widget.contentId);
                                            } else {
                                              EventsService().sendEvent(
                                                  favouriteController
                                                              .contentDetails
                                                              .value!
                                                              .content!
                                                              .isFavourite! ==
                                                          true
                                                      ? "Grow_Content_Unfavourite"
                                                      : "Grow_Content_Favourite",
                                                  {
                                                    "content_id":
                                                        contentController
                                                            .contentDetails
                                                            .value!
                                                            .content!
                                                            .contentId!,
                                                    "content_name":
                                                        contentController
                                                            .contentDetails
                                                            .value!
                                                            .content!
                                                            .contentName!,
                                                    "artist_name":
                                                        contentController
                                                            .contentDetails
                                                            .value!
                                                            .content!
                                                            .artist!
                                                            .artistName!,
                                                    "content_type":
                                                        contentController
                                                            .contentDetails
                                                            .value!
                                                            .content!
                                                            .contentType!,
                                                  });

                                              favouriteController
                                                  .favouriteContent(
                                                      favouriteController
                                                          .contentDetails
                                                          .value!
                                                          .content!
                                                          .contentId!,
                                                      !favouriteController
                                                          .contentDetails
                                                          .value!
                                                          .content!
                                                          .isFavourite!);
                                            }
                                          },
                                          child: Container(
                                            width: 32.w,
                                            height: 32.h,
                                            padding: EdgeInsets.all(8.w),
                                            decoration: const BoxDecoration(
                                              color: AppColors.whiteColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              AppIcons.favouriteFillSVG,
                                              width: 16.w,
                                              height: 16.h,
                                              fit: BoxFit.contain,
                                              color: (favouriteController
                                                          .contentDetails
                                                          .value!
                                                          .content!
                                                          .isFavourite! ==
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
                                    margin: EdgeInsets.only(right: 20.w),
                                    padding: EdgeInsets.all(8.w),
                                    decoration: const BoxDecoration(
                                      color: AppColors.whiteColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if (widget.source == "DEEPLINK") {
                                          singularDeepLinkController
                                              .handleClickOnContentDetailsBeforeReg(
                                                  widget.contentId);
                                        } else {
                                          buildShowDialog(context);
                                          await ShareService().shareContent(
                                              contentController.contentDetails
                                                  .value!.content!.contentId!,
                                              contentController
                                                  .contentDetails
                                                  .value!
                                                  .content!
                                                  .contentImage!);
                                          EventsService()
                                              .sendEvent("Grow_Content_Share", {
                                            "content_id": contentController
                                                .contentDetails
                                                .value!
                                                .content!
                                                .contentId!,
                                            "content_name": contentController
                                                .contentDetails
                                                .value!
                                                .content!
                                                .contentName!,
                                            "artist_name": contentController
                                                .contentDetails
                                                .value!
                                                .content!
                                                .artist!
                                                .artistName!,
                                            "content_type": contentController
                                                .contentDetails
                                                .value!
                                                .content!
                                                .contentType!,
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
                              )
                            : const SizedBox(),
                        background: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Hero(
                              tag: widget.heroTag,
                              child: ShowNetworkImage(
                                imgPath: contentController.contentDetails.value!
                                    .content!.contentImage!,
                                imgHeight: (278 + kToolbarHeight).h,
                                imgWidth: double.infinity,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: (278 + kToolbarHeight).h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    const Color.fromRGBO(0, 0, 0, 1)
                                        .withOpacity(0.4),
                                    const Color.fromRGBO(0, 0, 0, 0)
                                        .withOpacity(0.4),
                                  ],
                                ),
                              ),
                            ),
                            (contentController.contentDetails.value!.content!
                                        .metaData!.multiSeries ==
                                    false)
                                ? Center(
                                    child: InkWell(
                                      onTap: () {
                                        handlePlayContent();
                                      },
                                      child: SvgPicture.asset(
                                        AppIcons.playSVG,
                                        width: 54.w,
                                        height: 54.h,
                                        color: const Color(0xFF88EF95),
                                      ),
                                    ),
                                  )
                                : const Offstage(),
                            Positioned(
                              top: 30.h,
                              left: 7.w,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (widget.source == "DEEPLINK") {
                                    Get.close(2);
                                    Get.to(const GetStarted());
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              top: 30.h,
                              right: 15.w,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cast,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  handleCasting(castController);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    backgroundColor: const Color(0xFFF1F8F6),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(15),
                      child: Container(
                        height: 15,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F6),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          border: Border.all(
                              color: const Color(0xFFF1F8F6), width: 0),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                buildContentSection(),
                (contentController.contentDetails.value!.content!.metaData!
                            .multiSeries ==
                        false)
                    ? buildCategorySection()
                    : buildContentEpisodes(),
                SizedBox(
                  height: 34.h,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  handlePlayContent() {
    if (widget.source == "DEEPLINK") {
      SingularDeepLinkController singularDeepLinkController = Get.find();
      singularDeepLinkController
          .handleClickOnContentDetailsBeforeReg(widget.contentId);
    } else {
      if (contentController
                  .contentDetails.value!.content!.metaData!.isPremium ==
              true &&
          isSubscribed == false) {
        EventsService()
            .sendClickBackEvent("Content", "Play", "SubscribeToAayu");
        showPaymentScreen();
      } else {
        if (contentController
                .contentDetails.value!.content!.metaData!.multiSeries ==
            false) {
          EventsService().sendEvent("Grow_Content_Play_Clicked", {
            "content_id":
                contentController.contentDetails.value!.content!.contentId!,
            "content_name":
                contentController.contentDetails.value!.content!.contentName!,
            "artist_name": contentController
                .contentDetails.value!.content!.artist!.artistName!,
            "content_type":
                contentController.contentDetails.value!.content!.contentType!,
          });

          if (contentController.contentDetails.value!.content!.contentType ==
              "Video") {
            if (contentController.contentDetails.value!.content!.contentPath !=
                    null &&
                contentController
                    .contentDetails.value!.content!.contentPath!.isNotEmpty) {
              EventsService()
                  .sendClickNextEvent("ContentDetails", "Play", "VideoPlayer");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayer(
                    growCategoryName: widget.growCategoryName,
                    content: Content.fromJson(contentController
                        .contentDetails.value!.content!
                        .toJson()),
                  ),
                ),
              ).then((value) {
                EventsService().sendClickBackEvent(
                    "VideoPlayer", "Back", "ContentDetails");
              });
            } else {
              showGetSnackBar(
                  "Content not avaialble!", SnackBarMessageTypes.Info);
            }
          } else if (contentController
                      .contentDetails.value!.content!.contentType ==
                  "Audio" ||
              contentController.contentDetails.value!.content!.contentType ==
                  "Music") {
            if (contentController.contentDetails.value!.content!.contentPath !=
                    null &&
                contentController
                    .contentDetails.value!.content!.contentPath!.isNotEmpty) {
              List<Content?> audioPlayList = [];
              if (subscriptionCheckResponse != null &&
                  subscriptionCheckResponse!.subscriptionDetails != null) {
                audioPlayList = widget.categoryContent
                    .where(
                      (element) => (element!.contentType == "Audio" ||
                          element.contentType == "Music"),
                    )
                    .toList();
              } else {
                audioPlayList = widget.categoryContent
                    .where(
                      (element) =>
                          (element!.contentType == "Audio" ||
                              element.contentType == "Music") &&
                          element.metaData!.isPremium == false,
                    )
                    .toList();
              }

              if (audioPlayList.isEmpty) {
                audioPlayList = [
                  contentController.contentDetails.value!.content
                ];
              }

              EventsService()
                  .sendClickNextEvent("ContentDetails", "Play", "AudioPlayer");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayList(
                    growCategoryName: widget.growCategoryName,
                    heroTag: widget.heroTag,
                    playContentId: widget.contentId,
                    categoryContent: audioPlayList,
                  ),
                ),
              ).then((value) {
                EventsService().sendClickBackEvent(
                    "AudioPlayList", "Back", "ContentDetails");
              });
            } else {
              showGetSnackBar(
                  "Content not avaialble!", SnackBarMessageTypes.Info);
            }
          }
        }
      }
    }
  }

  buildContentSection() {
    return Container(
      padding: EdgeInsets.only(
        top: 90.h,
        bottom: 23.h,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F8F6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 26.w,
              right: 26.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 26.h),
                  width: double.infinity,
                  clipBehavior: Clip.none,
                  decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F6),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border:
                          Border.all(color: const Color(0xFFF1F8F6), width: 0)),
                  child: ContentName(
                    source: widget.source,
                    contentController: contentController,
                    contentId: widget.contentId,
                    isPremium: contentController
                        .contentDetails.value!.content!.metaData!.isPremium!,
                    isSubscribed: isSubscribed,
                  ),
                ),
                if (contentController
                        .contentDetails.value!.content!.metaData!.multiSeries ==
                    true)
                  Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    child: Text(
                      "Total ${contentController.contentDetails.value!.episodes?.length} episodes",
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ContentViews(
                    metaData: contentController
                        .contentDetails.value!.content!.metaData!),
                SizedBox(
                  height: 16.h,
                ),
                ContentDesc(
                  description: contentController
                      .contentDetails.value!.content!.contentDesc!
                      .trim(),
                ),
                SizedBox(
                  height: 16.h,
                ),
                ContentTags(
                    tags: contentController
                        .contentDetails.value!.content!.metaData!.tags!),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: 322.w,
                  child: const Divider(
                    height: 0,
                    color: Color(0xFFE4ECEA),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
          ContentReviws(contentId: widget.contentId),
          ContentArtistSection(
            source: widget.source,
            contentController: contentController,
            isPremium: contentController
                .contentDetails.value!.content!.metaData!.isPremium!,
            isSubscribed: isSubscribed,
          ),
        ],
      ),
    );
  }

  handleCasting(CastController castController) {
    if (contentController.contentDetails.value!.content!.metaData!.isPremium ==
            true &&
        isSubscribed == false) {
      EventsService()
          .sendClickBackEvent("Content", "Casting", "SubscribeToAayu");
      showPaymentScreen();
    } else {
      castController.switchShowControls(false);
      castController.searchCastDevices();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Obx(() {
            if (castController.isSearching.value == true) {
              return Container(
                height: 100,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Finding Nearby Devices',
                      style: TextStyle(
                          color: AppColors.blueGreyAssessmentColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const LinearProgressIndicator(),
                  ],
                ),
              );
            }
            if (castController.showControls.value == true) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            castController.minus10();
                          },
                          icon: const Icon(Icons.replay_10, size: 30)),
                      IconButton(
                          onPressed: () {
                            castController.pauseVideo();
                          },
                          icon: Icon(
                            castController.playerState.value ==
                                    PlayerState.PLAYING
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {
                            castController.plus10();
                          },
                          icon: const Icon(Icons.forward_10, size: 30)),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // CupertinoSlider(
                  //   max: 100,
                  //   min: 0,
                  //   value: castController.volume.value * 100,
                  //   onChanged: (value) {
                  //     castController.setVolume(value / 100);
                  //   },
                  // ),
                ],
              );
            }
            return Stack(children: [
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                child: castController.listCastdDevices!.isEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            'No Devices Found',
                            style: TextStyle(
                              color: AppColors.blueGreyAssessmentColor,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 9.h)),
                                  onPressed: () async {
                                    castController.switchShowControls(false);
                                    castController.searchCastDevices();
                                  },
                                  child: Text(
                                    'Scan Again',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Circular Std"),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            castController.listCastdDevices!.map((device) {
                          return ListTile(
                            title: Text(device.name),
                            onTap: () {
                              castController
                                  .connectAndPlayMedia(
                                      context,
                                      device,
                                      contentController
                                          .contentDetails.value!.content!,
                                      null)
                                  .then((value) {
                                castController.switchShowControls(true);
                              });
                            },
                          );
                        }).toList()),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    constraints:
                        const BoxConstraints(minHeight: 0, minWidth: 0),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.blackAssessmentColor,
                      size: 25,
                    )),
              )
            ]);
          }),
        ),
      ).then((value) {
        castController.closeSession();
      });
    }
  }

  buildCategorySection() {
    if (contentController.isCategoryLoading.value == true) {
      return showLoading();
    } else if (contentController.contentCategoryDetails.value == null) {
      return const Offstage();
    } else if (contentController.contentCategoryDetails.value!.categories ==
        null) {
      return const Offstage();
    } else if (contentController
        .contentCategoryDetails.value!.categories!.isEmpty) {
      return const Offstage();
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount:
          contentController.contentCategoryDetails.value!.categories!.length,
      itemBuilder: (context, index) {
        return CategorySection(
            source: widget.source,
            categoryDetails: contentController
                .contentCategoryDetails.value!.categories![index]!);
      },
    );
  }

  buildContentEpisodes() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      child: Column(
        children: List.generate(
          contentController.contentDetails.value!.episodes!.length,
          (index) {
            return Container(
              width: 322.w,
              decoration: BoxDecoration(
                color: (contentController
                            .contentDetails.value!.episodes![index]!.enabled! ==
                        true)
                    ? const Color(0xFFF1F8F6)
                    : const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.w),
                  bottomRight: Radius.circular(16.w),
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
              ),
              margin: EdgeInsets.only(bottom: 16.h),
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Padding(
                  padding: EdgeInsets.all(18.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Episode ${index + 1}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: AppColors.secondaryLabelColor,
                                    fontFamily: 'Circular Std',
                                    fontSize: 14.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1428571428571428.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Container(
                                  height: 20.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.w),
                                    color: AppColors.whiteColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      contentController
                                          .contentDetails
                                          .value!
                                          .episodes![index]!
                                          .metaData!
                                          .duration!,
                                      style: TextStyle(
                                        color: const Color(0xFF5C7F6B),
                                        fontFamily: 'Circular Std',
                                        fontSize: 12.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700,
                                        height: 1.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              contentController.contentDetails.value!
                                  .episodes![index]!.contentName!,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: 'Circular Std',
                                  fontSize: 14.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.14.h),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      SvgPicture.asset(
                        AppIcons.downloadSVG,
                        width: 28.w,
                        height: 28.h,
                        color: (contentController.contentDetails.value!
                                    .episodes![index]!.enabled! ==
                                true)
                            ? const Color(0xFF88EF95)
                            : const Color(0xFFC4C4C4),
                      ),
                      SizedBox(
                        width: 13.w,
                      ),
                      SvgPicture.asset(
                        AppIcons.playSVG,
                        width: 28.w,
                        height: 28.h,
                        color: (contentController.contentDetails.value!
                                    .episodes![index]!.enabled! ==
                                true)
                            ? const Color(0xFF88EF95)
                            : const Color(0xFFC4C4C4),
                      )
                    ],
                  ),
                ),
                collapsed: const Offstage(),
                expanded: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShowNetworkImage(
                      imgPath: contentController.contentDetails.value!
                          .episodes![index]!.contentImage!,
                      imgHeight: 180,
                      imgWidth: double.infinity,
                      boxFit: BoxFit.fill,
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.w),
                      child: Text(
                        contentController.contentDetails.value!
                            .episodes![index]!.contentDesc!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontFamily: 'Circular Std',
                            fontSize: 14.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                            height: 1.5714285714285714.h),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
