import 'package:aayu/controller/you/experts_i_follow_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/search/search_controller.dart';
import '../search/artist_details.dart';

class ExpertsIFollow extends StatelessWidget {
  const ExpertsIFollow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExpertsIFollowController expertsIFollowController =
        Get.put(ExpertsIFollowController());

    Future.delayed(Duration.zero, () {
      expertsIFollowController.getExpertsIFollow();
    });

    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EXPERTS_I_FOLLOW'.tr,
                style: AppTheme.secondarySmallFontTitleTextStyle,
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: Obx(
                  () {
                    if (expertsIFollowController.isLoading.value == true) {
                      return showLoading();
                    } else if (expertsIFollowController.expertsIFollow.value ==
                        null) {
                      return noArtistFollowed();
                    } else if (expertsIFollowController
                            .expertsIFollow.value!.details ==
                        null) {
                      return noArtistFollowed();
                    } else if (expertsIFollowController
                        .expertsIFollow.value!.details!.isEmpty) {
                      return noArtistFollowed();
                    }

                    return expertsIFollowController
                            .expertsIFollow.value!.details!.isEmpty
                        ? Center(
                            child: Text(
                              'YOU_HAVE_NOT_FOLLOWED_ANY_EXPERT_YET_MSG'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(52, 69, 83, 0.5)),
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: expertsIFollowController
                                .expertsIFollow.value!.details!.length,
                            itemBuilder: (context, index) => Container(
                              height: 88.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child: InkWell(
                                onTap: () async {
                                  buildShowDialog(context);
                                  SearchController searchController =
                                      Get.put(SearchController());
                                  searchController.nullSearchResults();
                                  await searchController.getAuthorDetails(
                                      expertsIFollowController.expertsIFollow
                                          .value!.details![index]!.artistId!
                                          .trim());
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ArtistDetails(),
                                  ));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40.h,
                                      height: 40.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        child: ShowNetworkImage(
                                          imgPath: expertsIFollowController
                                              .expertsIFollow
                                              .value!
                                              .details![index]!
                                              .artistImage!,
                                          imgHeight: 40.h,
                                          imgWidth: 40.h,
                                          boxFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 13.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            expertsIFollowController
                                                .expertsIFollow
                                                .value!
                                                .details![index]!
                                                .artistName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  AppColors.secondaryLabelColor,
                                              fontSize: 14.sp,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            "${expertsIFollowController.expertsIFollow.value!.details![index]!.follower!} Followers",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  AppColors.secondaryLabelColor,
                                              fontSize: 12.sp,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 100.w,
                                      height: 34.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF88EF95),
                                        borderRadius:
                                            BorderRadius.circular(32.w),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.done,
                                              color: const Color(0xFF5C7F6B),
                                              size: 15.h,
                                            ),
                                            SizedBox(
                                              width: 4.2.w,
                                            ),
                                            Text(
                                              "FOLLOWING".tr,
                                              style: TextStyle(
                                                color: const Color(0xFF5C7F6B),
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => const Divider(
                              height: 0,
                              thickness: 1,
                              color: Color.fromRGBO(196, 196, 196, 0.3),
                            ),
                          );
                  },
                ),
              ),
            ]),
      ),
    );
  }

  noArtistFollowed() {
    return Center(
      child: SizedBox(
        width: 252.w,
        child: Text(
          "YOU_HAVE_NOT_FOLLOWED_ANY_EXPERT_YET_MSG".tr,
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
    );
  }
}
