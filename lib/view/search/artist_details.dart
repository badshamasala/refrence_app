import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/view/search/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../shared/ui_helper/images.dart';
import '../shared/ui_helper/ui_helper.dart';

class ArtistDetails extends StatefulWidget {
  const ArtistDetails({Key? key}) : super(key: key);

  @override
  State<ArtistDetails> createState() => _ArtistDetailsState();
}

class _ArtistDetailsState extends State<ArtistDetails> {
  ScrollController scrollController = ScrollController();
  double top = 0.0;

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.find();

    return Scaffold(
      body: Obx(() {
        if (searchController.isLoading.value == true) {
          return showLoading();
        }
        if (searchController.authorDetails.value == null ||
            searchController.authorDetails.value!.details == null) {
          return const Offstage();
        }

        return NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.white,
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: searchController
                              .authorDetails.value!.details!.description !=
                          null
                      ? 580.h
                      : 500.h,
                  elevation: 0,
                  centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  iconTheme: const IconThemeData(color: AppColors.whiteColor),
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    top = constraints.biggest.height;

                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: top.floor() ==
                              (MediaQuery.of(context).padding.top +
                                      kToolbarHeight)
                                  .floor()
                          ? Text(
                              searchController.authorDetails.value!.details!
                                      .authorName ??
                                  "",
                              style: TextStyle(
                                  color: AppColors.blackLabelColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            )
                          : const Offstage(),
                      background: Stack(
                        children: [
                          SizedBox(
                            height: 363.h,
                            width: double.infinity,
                            child: Image.asset(
                              Images.planSummaryBGImage,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Positioned(
                            top: 216.h,
                            left: 0,
                            right: 0,
                            child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 27.w),
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 137.h,
                                        ),
                                        Text(
                                          searchController.authorDetails.value!
                                                  .details!.authorName ??
                                              "",
                                          style: TextStyle(
                                              color: AppColors
                                                  .blueGreyAssessmentColor,
                                              fontFamily: 'Baskerville',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 24.sp),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          '${searchController.authorDetails.value!.details!.follower ?? 0} FOLLOWERS',
                                          style: TextStyle(
                                              color: const Color(0xFF768897),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp),
                                        ),
                                        if (searchController.authorDetails
                                                .value!.details!.location !=
                                            null)
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                        if (searchController.authorDetails
                                                .value!.details!.location !=
                                            null)
                                          Text(
                                            searchController.authorDetails
                                                    .value!.details!.location ??
                                                "",
                                            style: TextStyle(
                                                color: AppColors
                                                    .blueGreyAssessmentColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp),
                                          ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            searchController.followArtist(
                                                searchController
                                                        .authorDetails
                                                        .value!
                                                        .details!
                                                        .authorId ??
                                                    "",
                                                !searchController
                                                    .authorDetails
                                                    .value!
                                                    .details!
                                                    .isFollowed!);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 22.w),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF88EF95),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (searchController
                                                          .authorDetails
                                                          .value!
                                                          .details!
                                                          .isFollowed ==
                                                      true)
                                                    const Icon(
                                                      Icons.done,
                                                      color: Color(0xFF5C7F6B),
                                                      size: 16,
                                                    ),
                                                  if (searchController
                                                          .authorDetails
                                                          .value!
                                                          .details!
                                                          .isFollowed ==
                                                      true)
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                  Text(
                                                    searchController
                                                                .authorDetails
                                                                .value!
                                                                .details!
                                                                .isFollowed ==
                                                            true
                                                        ? "FOLLOWING".tr
                                                        : "FOLLOW".tr,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                            0xFF5C7F6B),
                                                        fontSize: 11.sp),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        if (searchController.authorDetails
                                                .value!.details!.description !=
                                            null)
                                          SizedBox(
                                            height: 18.h,
                                          ),
                                        if (searchController.authorDetails
                                                .value!.details!.description !=
                                            null)
                                          Text(
                                            searchController
                                                    .authorDetails
                                                    .value!
                                                    .details!
                                                    .description ??
                                                "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: const Color(0xFF768897),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp),
                                          ),
                                        SizedBox(
                                          height: 150.h,
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -123.h,
                                    child: CircleAvatar(
                                        radius: 116.h,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(
                                          searchController.authorDetails.value!
                                                  .details!.image ??
                                              "",
                                        )),
                                  )
                                ]),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              )
            ];
          },
          body: Obx(() {
            if (searchController.searchResults.value == null) {
              return const Offstage();
            }
            if (searchController.searchResults.value!.categories == null ||
                searchController.searchResults.value!.categories!.isEmpty) {
              return const Offstage();
            }
            return const SearchResults(
              tagName: "",
            );
          }),
        );
      }),
    );
  }
}
