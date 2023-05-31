import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/controller/you/favourites_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/affirmation_section.dart';
import 'package:aayu/view/content/content_details/content_details.dart';
import 'package:aayu/view/ghost_screens/affirmation_ghost_screen.dart';
import 'package:aayu/view/ghost_screens/ghost_screen.dart';
import 'package:aayu/view/grow/grow.dart';
import 'package:aayu/view/player/audio_play_list.dart';
import 'package:aayu/view/player/video_player.dart';
import 'package:aayu/view/search/widgets/content_search_tile.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/previous_subscription.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavouritesController favouritesController = Get.put(FavouritesController());

    Future.delayed(Duration.zero, () {
      favouritesController.getFavouritesContent();
    });

    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      body: Obx(() {
        if (favouritesController.isLoading.value == true) {
          return showLoading();
        }

        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
            ),
            Row(
              children: [
                SizedBox(
                  width: 25.w,
                ),
                Text(
                  'MY_FAVOURITES'.tr,
                  style: AppTheme.secondarySmallFontTitleTextStyle,
                ),
                const Spacer(),
                SizedBox(
                  width: 10.w,
                ),
                Image.asset(
                  Images.favouriteShortcutImage,
                  width: 30.w,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  width: 25.w,
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            TabBar(
              controller: favouritesController.tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFFC0F9C7),
              indicatorWeight: 5,
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              indicatorPadding: EdgeInsets.zero,
              labelColor: AppColors.secondaryLabelColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.only(
                  top: 12.h, bottom: 12.h, right: 17.w, left: 17.w),
              unselectedLabelColor:
                  AppColors.secondaryLabelColor.withOpacity(0.5),
              labelStyle: TextStyle(
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                height: 1.5.h,
              ),
              tabs: List.generate(
                favouritesController.tabs.length,
                (index) => Text(
                  favouritesController.tabs[index],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: favouritesController.tabController,
                children: List.generate(
                  favouritesController.tabs.length,
                  (index) {
                    if (favouritesController.isLoading.value == true &&
                        favouritesController.tabs[index] == 'Grow') {
                      return const GhostScreen(
                          image: Images.growFavoritesGhostScreenLottie);
                    } else if (favouritesController.isLoading.value == true &&
                        favouritesController.tabs[index] == 'Affirmations') {
                      return const AffirmationGhostScreen();
                    } else if (favouritesController.isLoading.value == true) {
                      return showLoading();
                    } else if (favouritesController.favouritesContent.value ==
                        null) {
                      return NoFavourites(
                          tabName: favouritesController.tabs[index]);
                    } else if (favouritesController
                            .favouritesContent.value!.content ==
                        null) {
                      return NoFavourites(
                          tabName: favouritesController.tabs[index]);
                    }

                    switch (favouritesController.tabs[index]) {
                      case "Grow":
                        return FavouriteGrowContent(
                            tabName: favouritesController.tabs[index]);
                      case "Tips":
                        return FavouriteTips(
                          tabName: favouritesController.tabs[index],
                        );
                      case "Affirmations":
                        return FavouriteAffirmations(
                            tabName: favouritesController.tabs[index]);
                      default:
                        return const Offstage();
                    }
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class FavouriteGrowContent extends StatelessWidget {
  final String tabName;
  const FavouriteGrowContent({Key? key, required this.tabName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavouritesController>(
        builder: (favGrowContentController) {
      if (favGrowContentController.favouritesContent.value!.content!.grow ==
          null) {
        return NoFavourites(tabName: tabName);
      } else if (favGrowContentController
          .favouritesContent.value!.content!.grow!.isEmpty) {
        return NoFavourites(tabName: tabName);
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        shrinkWrap: true,
        itemCount: favGrowContentController
            .favouritesContent.value!.content!.grow!.length,
        itemBuilder: (BuildContext context, index) {
          if (favGrowContentController
                  .favouritesContent.value!.content!.grow![index] ==
              null) {
            return const Offstage();
          }
          return ContentSearchTile(
              onTapFunction: () {
                if (!(subscriptionCheckResponse != null &&
                        subscriptionCheckResponse!.subscriptionDetails !=
                            null &&
                        subscriptionCheckResponse!
                            .subscriptionDetails!.subscriptionId!.isNotEmpty) &&
                    favGrowContentController.favouritesContent.value!.content!
                            .grow![index]!.metaData!.isPremium ==
                        true) {
                  handleSubscriptionFlow(
                      context,
                      favGrowContentController
                          .favouritesContent.value!.content!.grow![index]!);
                } else {
                  EventsService().sendClickNextEvent(
                      "Favourites", "Content", "ContentDetails");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentDetails(
                        source: "",
                        heroTag:
                            "Favourite_${favGrowContentController.favouritesContent.value!.content!.grow![index]!.contentId!}",
                        contentId: favGrowContentController.favouritesContent
                            .value!.content!.grow![index]!.contentId!,
                        categoryContent: favGrowContentController
                            .favouritesContent.value!.content!.grow!,
                      ),
                    ),
                  ).then((value) {
                    EventsService().sendClickBackEvent(
                        "ContentDetails", "Back", "Favourites");
                  });
                }
              },
              content: favGrowContentController
                  .favouritesContent.value!.content!.grow![index]!,
              favouriteAction: () {
                favGrowContentController.favouriteContent(
                    "grow",
                    favGrowContentController.favouritesContent.value!.content!
                        .grow![index]!.contentId!,
                    index,
                    !favGrowContentController.favouritesContent.value!.content!
                        .grow![index]!.isFavourite!);
              },
              playAction: () {
                bool isSubscribed = false;
                if (subscriptionCheckResponse != null &&
                    subscriptionCheckResponse!.subscriptionDetails != null &&
                    subscriptionCheckResponse!
                        .subscriptionDetails!.subscriptionId!.isNotEmpty) {
                  isSubscribed = true;
                }

                if (favGrowContentController.favouritesContent.value!.content!
                            .grow![index]!.metaData!.isPremium ==
                        true &&
                    isSubscribed == false) {
                  handleSubscriptionFlow(
                      context,
                      favGrowContentController
                          .favouritesContent.value!.content!.grow![index]!);
                } else {
                  if (favGrowContentController.favouritesContent.value!.content!
                          .grow![index]!.contentType ==
                      "Video") {
                    if (favGrowContentController.favouritesContent.value!
                                .content!.grow![index]!.contentPath !=
                            null &&
                        favGrowContentController.favouritesContent.value!
                            .content!.grow![index]!.contentPath!.isNotEmpty) {
                      EventsService().sendClickNextEvent(
                          "Favourites", "Play", "VideoPlayer");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayer(
                            content: favGrowContentController.favouritesContent
                                .value!.content!.grow![index]!,
                          ),
                        ),
                      ).then((value) {
                        EventsService().sendClickBackEvent(
                            "VideoPlayer", "Back", "Favourites");
                      });
                    } else {
                      showGetSnackBar("CONTENT_NOT_AVAIALBLE".tr,
                          SnackBarMessageTypes.Info);
                    }
                  } else if (favGrowContentController.favouritesContent.value!
                              .content!.grow![index]!.contentType ==
                          "Audio" ||
                      favGrowContentController.favouritesContent.value!.content!
                              .grow![index]!.contentType ==
                          "Music") {
                    if (favGrowContentController.favouritesContent.value!
                                .content!.grow![index]!.contentPath !=
                            null &&
                        favGrowContentController.favouritesContent.value!
                            .content!.grow![index]!.contentPath!.isNotEmpty) {
                      EventsService().sendClickNextEvent(
                          "Favourites", "Play", "AudioPlayer");

                      List<Content?> audioPlayList = [];
                      if (subscriptionCheckResponse != null &&
                          subscriptionCheckResponse!.subscriptionDetails !=
                              null) {
                        audioPlayList = favGrowContentController
                            .favouritesContent.value!.content!.grow!
                            .where(
                              (element) => (element!.contentType == "Audio" ||
                                  element.contentType == "Music"),
                            )
                            .toList();
                      } else {
                        audioPlayList = favGrowContentController
                            .favouritesContent.value!.content!.grow!
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
                            heroTag:
                                "Favourite_Audio_${favGrowContentController.favouritesContent.value!.content!.grow![index]!.contentId}",
                            playContentId: favGrowContentController
                                .favouritesContent
                                .value!
                                .content!
                                .grow![index]!
                                .contentId!,
                            categoryContent: audioPlayList,
                          ),
                        ),
                      ).then((value) {
                        EventsService().sendClickBackEvent(
                            "AudioPlayList", "Back", "Favourites");
                      });
                    } else {
                      showGetSnackBar("CONTENT_NOT_AVAIALBLE".tr,
                          SnackBarMessageTypes.Info);
                    }
                  }
                }
              });
        },
        separatorBuilder: (BuildContext context, index) {
          return const Divider(
            thickness: 1,
            height: 0,
            color: Color.fromRGBO(196, 196, 196, 0.3),
          );
        },
      );
    });
  }

  handleSubscriptionFlow(BuildContext context, Content content) async {
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
      );
    } else {
      bool isAllowed = await checkIsPaymentAllowed("GROW");
      if (isAllowed == true) {
        EventsService()
            .sendClickNextEvent("Content", "Play", "SubscribeToAayu");
        Get.bottomSheet(
          SubscribeToAayu(subscribeVia: "CONTENT", content: content),
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
        );
      }
    }
  }
}

class FavouriteTips extends StatelessWidget {
  final String tabName;
  const FavouriteTips({Key? key, required this.tabName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavouritesController>(
        builder: (favGrowContentController) {
      if (favGrowContentController.favouritesContent.value!.content!.tips ==
          null) {
        return NoFavourites(tabName: tabName);
      } else if (favGrowContentController
          .favouritesContent.value!.content!.tips!.isEmpty) {
        return NoFavourites(tabName: tabName);
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            favGrowContentController
                .favouritesContent.value!.content!.tips!.length,
            (index) {
              if (index == 0) {
                return Container(
                  margin: EdgeInsets.only(top: 53.2.h),
                  child: SizedBox(
                    width: 322.w,
                    height: (161.03 + 165 + 40 - 31.23).h,
                    //imageHeight + contentHeight + contentBottomMargin - contentTopPosition
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Image(
                          image: const AssetImage(
                            Images.tipsImage,
                          ),
                          width: 156.51.w,
                          height: 161.03.h,
                        ),
                        Positioned(
                          top: 129.8.h,
                          child: tipsContent(
                            favGrowContentController,
                            index,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return tipsContent(
                favGrowContentController,
                index,
              );
            },
          ),
        ),
      );
    });
  }

  tipsContent(FavouritesController favGrowContentController, int index) {
    return Center(
      child: Container(
        width: 322.w,
        height: 165.h,
        margin: EdgeInsets.only(bottom: 40.h),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F2),
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              offset: Offset(-3, 10),
              blurRadius: 15,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              favGrowContentController
                  .favouritesContent.value!.content!.tips![index]!.contentDesc!,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                color: AppColors.blackLabelColor.withOpacity(0.8),
                fontFamily: 'Baskerville',
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                height: 1.3333333333333333.h,
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    favGrowContentController.favouriteContent(
                        "tips",
                        favGrowContentController.favouritesContent.value!
                            .content!.tips![index]!.contentId!,
                        index,
                        !favGrowContentController.favouritesContent.value!
                            .content!.tips![index]!.isFavourite!);
                  },
                  child: SvgPicture.asset(
                    AppIcons.favouriteFillSVG,
                    width: 24.w,
                    height: 24.h,
                    color: favGrowContentController.favouritesContent.value!
                                .content!.tips![index]!.isFavourite ==
                            true
                        ? AppColors.primaryColor
                        : const Color(0xFF9C9EB9),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                SvgPicture.asset(
                  AppIcons.shareSVG,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FavouriteAffirmations extends StatelessWidget {
  final String tabName;
  const FavouriteAffirmations({Key? key, required this.tabName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavouritesController>(
        builder: (favGrowContentController) {
      if (favGrowContentController
              .favouritesContent.value!.content!.affirmations ==
          null) {
        return NoFavourites(tabName: tabName);
      } else if (favGrowContentController
          .favouritesContent.value!.content!.affirmations!.isEmpty) {
        return NoFavourites(tabName: tabName);
      }
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        itemCount: favGrowContentController
            .favouritesContent.value!.content!.affirmations!.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 36.h, top: (index == 0) ? 36.h : 0),
            child: AffirmationSection(
              content: favGrowContentController
                  .favouritesContent.value!.content!.affirmations![index]!,
              favouriteAction: () {
                favGrowContentController.favouriteContent(
                    "affirmations",
                    favGrowContentController.favouritesContent.value!.content!
                        .affirmations![index]!.contentId!,
                    index,
                    !favGrowContentController.favouritesContent.value!.content!
                        .affirmations![index]!.isFavourite!);
              },
            ),
          );
        },
      );
    });
  }
}

class NoFavourites extends StatelessWidget {
  final String tabName;
  const NoFavourites({Key? key, required this.tabName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIcons.aayuFavouritesSVG,
          width: 110.w,
          height: 124.44.h,
        ),
        SizedBox(
          height: 29.54.h,
        ),
        SizedBox(
          width: 246.w,
          child: Text(
            "YOU_HAVE_NO_FAVOURITES_ADDED_YET_TEXT".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blackLabelColor.withOpacity(0.5),
              fontSize: 16.sp,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
              height: 1.1428571428571428.h,
            ),
          ),
        ),
        SizedBox(
          height: 33.h,
        ),
        InkWell(
          onTap: () {
            EventsService()
                .sendClickNextEvent("Favourites", "Explore Aayu", "GrowPage");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GrowPage(
                    selectedTab:
                        tabName == "Affirmations" ? "Affirmation" : ""),
              ),
            );
          },
          child: SizedBox(
            width: 240.w,
            child: mainButton("EXPLORE_AAYU".tr),
          ),
        )
      ],
    );
  }
}
