import 'package:aayu/controller/healing/disease_details_controller.dart';
import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/disease_details/disease_details.dart';
import 'package:aayu/view/search/widgets/affirmation_search_tile.dart';
import 'package:aayu/view/search/widgets/content_search_tile.dart';
import 'package:aayu/view/shared/constants.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/subscription/subscription_controller.dart';
import '../../model/grow/grow.page.content.model.dart';
import '../../services/third-party/events.service.dart';
import '../content/content_details/content_details.dart';
import '../player/audio_play_list.dart';
import '../player/video_player.dart';
import '../shared/network_image.dart';
import '../shared/ui_helper/images.dart';
import '../subscription/previous_subscription.dart';
import '../subscription/subscribe_to_aayu.dart';
import 'search_page.dart';

class SearchResults extends StatelessWidget {
  final String tagName;
  const SearchResults({Key? key, required this.tagName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
        title: const Text(
          'Search Results',
          style: AppTheme.secondarySmallFontTitleTextStyle,
        ),
        actions: [
          Visibility(
            visible: tagName.isNotEmpty,
            child: IconButton(
              onPressed: () {
                SearchController searchController = Get.put(SearchController());
                searchController.nullSearchResults();
                searchController.clearSearchText();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ));
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
          )
        ],
      ),
      body: (searchController.searchResults.value == null ||
              searchController.searchResults.value!.categories == null ||
              searchController.searchResults.value!.categories!.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sorry!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.sp,
                      color: AppColors.blackLabelColor,
                      fontFamily: "Baskerville",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Image.asset(
                    Images.noContentImage,
                    height: 168.h,
                    width: 168.h,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text(
                    "We couldn't find a match",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryLabelColor,
                    ),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  SizedBox(
                      width: 193.w,
                      child: InkWell(
                        onTap: () {
                          SearchController searchController =
                              Get.put(SearchController());
                          searchController.nullSearchResults();
                          searchController.clearSearchText();
                          Navigator.of(context).pop();
                          if (tagName.isEmpty) {
                            Navigator.of(context).pop();
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ));
                        },
                        child: mainButton("Try another search"),
                      ))
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: tagName.isNotEmpty,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                      margin: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.w),
                        color: const Color(0xFFDDE8E5),
                      ),
                      child: Text(
                        tagName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF2A373B).withOpacity(0.6),
                          fontFamily: 'Circular Std',
                          fontSize: 12.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SearchResultContent(
                    searchController: searchController,
                  ),
                ),
              ],
            ),
    );
  }
}

class SearchResultContent extends StatelessWidget {
  final SearchController searchController;
  const SearchResultContent({Key? key, required this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: searchController.tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFC0F9C7),
          indicatorWeight: 6,
          indicatorPadding: EdgeInsets.zero,
          labelColor: AppColors.secondaryLabelColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding:
              EdgeInsets.only(top: 16.h, bottom: 6.h, right: 8.w, left: 8.w),
          unselectedLabelColor: AppColors.secondaryLabelColor.withOpacity(0.5),
          labelStyle: TextStyle(
            fontFamily: 'Circular Std',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1.5.h,
          ),
          tabs: List.generate(
              searchController.searchResults.value!.categories!.length,
              (index) {
            return Text(
              searchController
                      .searchResults.value!.categories![index]!.categoryName ??
                  "",
            );
          }),
        ),
        Expanded(
          child: TabBarView(
            controller: searchController.tabController,
            children: List.generate(
                searchController.searchResults.value!.categories!.length,
                (index) {
              if (searchController
                      .searchResults.value!.categories![index]!.categoryName ==
                  'Healing') {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 26.h),
                  shrinkWrap: true,
                  itemCount: searchController
                      .searchResults.value!.categories![index]!.content!.length,
                  itemBuilder: (BuildContext context, index2) {
                    return InkWell(
                      onTap: () {
                        HealingListController healingListController =
                            Get.find();
                        healingListController.setDiseaseFromDeepLink(
                            searchController
                                    .searchResults
                                    .value!
                                    .categories![index]!
                                    .content![index2]!
                                    .contentId ??
                                "");

                        Get.put(DiseaseDetailsController());
                        if (subscriptionCheckResponse != null &&
                            subscriptionCheckResponse!.subscriptionDetails !=
                                null &&
                            subscriptionCheckResponse!
                                .subscriptionDetails!.programId!.isNotEmpty) {
                          Get.to(const DiseaseDetails(
                            fromThankYou: false,
                            pageSource: "EXPLORE_PROGRAM",
                          ));
                        } else {
                          Get.to(const DiseaseDetails(fromThankYou: false));
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ShowNetworkImage(
                                imgPath: searchController
                                        .searchResults
                                        .value!
                                        .categories![index]!
                                        .content![index2]!
                                        .contentImage ??
                                    "",
                                boxFit: BoxFit.cover,
                                imgHeight: 70.h,
                                imgWidth: 100.w,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text(
                              searchController
                                      .searchResults
                                      .value!
                                      .categories![index]!
                                      .content![index2]!
                                      .contentName ??
                                  "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blueGreyAssessmentColor,
                                  fontSize: 14.sp),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 18.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF88EF95),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'View',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF5C7F6B),
                                  fontSize: 11.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const Divider(
                      thickness: 1,
                      height: 0,
                      color: Color.fromRGBO(196, 196, 196, 0.3),
                    );
                  },
                );
              } else if (searchController
                      .searchResults.value!.categories![index]!.categoryName ==
                  'Affirmation') {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 26.h),
                  shrinkWrap: true,
                  itemCount: searchController
                      .searchResults.value!.categories![index]!.content!.length,
                  itemBuilder: (BuildContext context, affirmationIndex) {
                    return AffirmationSearchTile(
                      content: searchController.searchResults.value!
                          .categories![index]!.content![affirmationIndex]!,
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const Divider(
                      thickness: 1,
                      height: 0,
                      color: Color.fromRGBO(196, 196, 196, 0.3),
                    );
                  },
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 26.h),
                shrinkWrap: true,
                itemCount: searchController
                    .searchResults.value!.categories![index]!.content!.length,
                itemBuilder: (BuildContext context, index2) {
                  if (searchController.searchResults.value!.categories![index]!
                          .content![index2] ==
                      null) {
                    return const Offstage();
                  }
                  return ContentSearchTile(
                      onTapFunction: () {
                        if (!(subscriptionCheckResponse != null &&
                                subscriptionCheckResponse!
                                        .subscriptionDetails !=
                                    null &&
                                subscriptionCheckResponse!.subscriptionDetails!
                                    .subscriptionId!.isNotEmpty) &&
                            searchController
                                    .searchResults
                                    .value!
                                    .categories![index]!
                                    .content![index2]!
                                    .metaData!
                                    .isPremium ==
                                true) {
                          handleSubscriptionFlow(
                              context,
                              searchController.searchResults.value!
                                  .categories![index]!.content![index2]!);
                        } else {
                          EventsService().sendClickNextEvent(
                              "Favourites", "Content", "ContentDetails");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentDetails(
                                source: "",
                                heroTag:
                                    "SearchResult_${searchController.searchResults.value!.categories![index]!.content![index2]!.contentId!}",
                                contentId: searchController
                                    .searchResults
                                    .value!
                                    .categories![index]!
                                    .content![index2]!
                                    .contentId!,
                                categoryContent: searchController.searchResults
                                    .value!.categories![index]!.content!,
                              ),
                            ),
                          ).then((value) {
                            EventsService().sendClickBackEvent(
                                "ContentDetails", "Back", "Favourites");
                          });
                        }
                      },
                      content: searchController.searchResults.value!
                          .categories![index]!.content![index2]!,
                      favouriteAction: null,
                      playAction: () {
                        bool isSubscribed = false;
                        if (subscriptionCheckResponse != null &&
                            subscriptionCheckResponse!.subscriptionDetails !=
                                null &&
                            subscriptionCheckResponse!.subscriptionDetails!
                                .subscriptionId!.isNotEmpty) {
                          isSubscribed = true;
                        }

                        if (searchController
                                    .searchResults
                                    .value!
                                    .categories![index]!
                                    .content![index2]!
                                    .metaData!
                                    .isPremium ==
                                true &&
                            isSubscribed == false) {
                          handleSubscriptionFlow(
                              context,
                              searchController.searchResults.value!
                                  .categories![index]!.content![index2]!);
                        } else {
                          if (searchController
                                  .searchResults
                                  .value!
                                  .categories![index]!
                                  .content![index2]!
                                  .contentType ==
                              "Video") {
                            if (searchController
                                        .searchResults
                                        .value!
                                        .categories![index]!
                                        .content![index2]!
                                        .contentPath !=
                                    null &&
                                searchController
                                    .searchResults
                                    .value!
                                    .categories![index]!
                                    .content![index2]!
                                    .contentPath!
                                    .isNotEmpty) {
                              EventsService().sendClickNextEvent(
                                  "Favourites", "Play", "VideoPlayer");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayer(
                                    content: searchController
                                        .searchResults
                                        .value!
                                        .categories![index]!
                                        .content![index2]!,
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
                          } else if (searchController
                                      .searchResults
                                      .value!
                                      .categories![index]!
                                      .content![index2]!
                                      .contentType ==
                                  "Audio" ||
                              searchController
                                      .searchResults
                                      .value!
                                      .categories![index]!
                                      .content![index2]!
                                      .contentType ==
                                  "Music") {
                            if (searchController
                                        .searchResults
                                        .value!
                                        .categories![index]!
                                        .content![index2]!
                                        .contentPath !=
                                    null &&
                                searchController
                                    .searchResults
                                    .value!
                                    .categories![index]!
                                    .content![index2]!
                                    .contentPath!
                                    .isNotEmpty) {
                              EventsService().sendClickNextEvent(
                                  "Favourites", "Play", "AudioPlayer");

                              List<Content?> audioPlayList = [];
                              if (subscriptionCheckResponse != null &&
                                  subscriptionCheckResponse!
                                          .subscriptionDetails !=
                                      null) {
                                audioPlayList = searchController.searchResults
                                    .value!.categories![index]!.content!
                                    .where(
                                      (element) =>
                                          (element!.contentType == "Audio" ||
                                              element.contentType == "Music"),
                                    )
                                    .toList();
                              } else {
                                audioPlayList = searchController.searchResults
                                    .value!.categories![index]!.content!
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
                                        "SearchResult_${searchController.searchResults.value!.categories![index]!.content![index2]!.contentId}",
                                    playContentId: searchController
                                        .searchResults
                                        .value!
                                        .categories![index]!
                                        .content![index2]!
                                        .contentId!,
                                    categoryContent: audioPlayList,
                                  ),
                                ),
                              ).then((value) {
                                EventsService().sendClickBackEvent(
                                    "AudioPlayList", "Back", "SearchResult");
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
            }),
          ),
        )
      ],
    );
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
