import 'package:aayu/controller/content/content_details_controller.dart';
import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/search/artist_details.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/search/search_controller.dart';

class ContentArtistSection extends StatelessWidget {
  final String source;
  final ContentDetailsController contentController;
  final bool isPremium;
  final bool isSubscribed;
  const ContentArtistSection(
      {Key? key,
      required this.contentController,
      required this.source,
      required this.isPremium,
      required this.isSubscribed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingularDeepLinkController singularDeepLinkController = Get.find();
    return InkWell(
      onTap: () async {
        buildShowDialog(context);
        SearchController searchController = Get.put(SearchController());
        searchController.nullSearchResults();
        await searchController.getAuthorDetails(
            contentController.contentDetails.value!.content!.artist!.artistId!);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ArtistDetails(),
        ));
      },
      child: Padding(
        padding: pageHorizontalPadding(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40.w),
              child: ShowNetworkImage(
                imgWidth: 40.w,
                imgHeight: 40.h,
                imgPath: contentController
                    .contentDetails.value!.content!.artist!.artistImage!,
                boxFit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toTitleCase(contentController
                        .contentDetails.value!.content!.artist!.artistName!
                        .trim()),
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
                    height: 5.h,
                  ),
                  GetBuilder<ContentDetailsController>(
                      id: "FollowArtistCount",
                      tag: contentController
                          .contentDetails.value!.content!.contentId,
                      builder: (artistFollowController) {
                        return Text(
                          '${contentController.contentDetails.value!.content!.artist!.followers!} Followers',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontFamily: 'Circular Std',
                            fontSize: 12.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                            height: 1.1428571428571428.h,
                          ),
                        );
                      }),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            GetBuilder<ContentDetailsController>(
                id: "FollowArtist",
                tag: contentController.contentDetails.value!.content!.contentId,
                builder: (artistFollowController) {
                  return InkWell(
                    onTap: () {
                      if (source == "DEEPLINK") {
                        singularDeepLinkController
                            .handleClickOnContentDetailsBeforeReg(
                                contentController.contentDetails.value!.content!
                                        .contentId ??
                                    "");
                      } else {
                        EventsService().sendEvent(
                            artistFollowController.contentDetails.value!.content!
                                        .artist!.isFollowed ==
                                    false
                                ? "Artist_Followed"
                                : "Artist_Unfollowed",
                            {
                              "artist_id": artistFollowController.contentDetails
                                  .value!.content!.artist!.artistId!,
                              "artist_name": artistFollowController.contentDetails
                                  .value!.content!.artist!.artistName!,
                              "followers": artistFollowController.contentDetails
                                  .value!.content!.artist!.followers!,
                            });

                        artistFollowController.followArtist(
                            artistFollowController
                                .contentDetails.value!.content!.artist!.artistId!,
                            !artistFollowController.contentDetails.value!.content!
                                .artist!.isFollowed!,
                            artistFollowController
                                .contentDetails.value!.content!.contentId!);
                      }
                    },
                    child: Container(
                      height: 34,
                      width: (artistFollowController.contentDetails.value!
                                  .content!.artist!.isFollowed ==
                              true)
                          ? 100.w
                          : 82.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.w),
                        color: const Color(0xFF88EF95),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Visibility(
                            visible: artistFollowController.contentDetails.value!
                                    .content!.artist!.isFollowed ==
                                true,
                            child: const Icon(
                              Icons.done,
                              color: Color(0xFF5C7F6B),
                              size: 18,
                            ),
                          ),
                          Visibility(
                            visible: artistFollowController.contentDetails.value!
                                    .content!.artist!.isFollowed ==
                                true,
                            child: SizedBox(
                              width: 3.w,
                            ),
                          ),
                          Text(
                            artistFollowController.contentDetails.value!.content!
                                        .artist!.isFollowed ==
                                    true
                                ? "FOLLOWING".tr
                                : "FOLLOW".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF5C7F6B),
                              fontFamily: 'Circular Std',
                              fontSize: 14.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
