import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../shared/ui_helper/icons.dart';

class SearchRecommendation extends StatelessWidget {
  const SearchRecommendation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(builder: (searchController) {
      Widget buildRecentSearches() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RECENT_SEARCHES'.tr,
              style: AppTheme.contentTextStyle,
            ),
            SizedBox(
              height: 14.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: List.generate(
                    searchController.recentSearchList.value.length <= 5
                        ? searchController.recentSearchList.value.length
                        : 5,
                    (index) => InkWell(
                          onTap: () {
                            searchController.setSearchText(
                                searchController.recentSearchList.value[index]);
                          },
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 4.w),
                              height: 38.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 9.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        searchController
                                            .recentSearchList.value[index],
                                        style: TextStyle(
                                            color: const Color.fromRGBO(
                                                42, 55, 59, 0.6),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Circular Std'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      searchController
                                          .removeFromRecentSearchList(index);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.blueGreyAssessmentColor,
                                      size: 15.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color.fromRGBO(196, 196, 196, 0.3),
                              thickness: 1,
                              height: 0,
                            )
                          ]),
                        )),
              ),
            ),
            SizedBox(
              height: 44.h,
            )
          ],
        );
      }

      String returnImageFromContentType(String contentType) {
        switch (contentType) {
          case "AUDIO":
            return AppIcons.searchAudioSVG;

          case "VIDEO":
            return AppIcons.searchVideoSVG;
          case "MUSIC":
            return AppIcons.searchMusicSVG;
          case "LIVE_EVENT":
            return AppIcons.searchLiveEventsSVG;

          default:
            return AppIcons.searchVideoSVG;
        }
      }

      Widget buildTypes() {
        if (searchController.searchRecommendation.value!.contentTypes == null ||
            searchController
                    .searchRecommendation.value!.contentTypes!.enabled ==
                false ||
            searchController.searchRecommendation.value!.contentTypes!.items ==
                null ||
            searchController
                .searchRecommendation.value!.contentTypes!.items!.isEmpty) {
          return const Offstage();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  searchController
                          .searchRecommendation.value!.contentTypes!.title ??
                      "",
                  style: AppTheme.contentTextStyle,
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      searchController.clearAllFilters();
                    },
                    child: Text(
                      'CLEAR_ALL'.tr,
                      style: TextStyle(
                          color: const Color(0xFF94E79F),
                          fontFamily: 'Circular Std',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline),
                    ))
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              height: 97.h,
              width: double.infinity,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: searchController
                      .searchRecommendation.value!.contentTypes!.items!.length,
                  itemBuilder: (context, index) {
                    int index2 = searchController.selectedTypes.indexWhere(
                        (element) =>
                            element.contentType ==
                            searchController.searchRecommendation.value!
                                .contentTypes!.items![index]!.contentType);
                    bool contains = index2 != -1;

                    return InkWell(
                      onTap: () {
                        searchController.setTypes(searchController
                            .searchRecommendation
                            .value!
                            .contentTypes!
                            .items![index]!);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            height: 72.h,
                            width: 72.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: contains
                                  ? const Color(0xFF9AE3A4)
                                  : const Color(0xFFF8FAFC),
                            ),
                            child: SvgPicture.asset(
                              returnImageFromContentType(searchController
                                      .searchRecommendation
                                      .value!
                                      .contentTypes!
                                      .items![index]!
                                      .contentType ??
                                  ""),
                              color: contains
                                  ? Colors.white
                                  : const Color(0xFF9AE3A4),
                              height: 26.h,
                              width: 26.h,
                            ),
                          ),
                          SizedBox(
                            height: 9.h,
                          ),
                          Text(
                            searchController.searchRecommendation.value!
                                    .contentTypes!.items![index]!.displayText ??
                                "",
                            style: TextStyle(
                                color: const Color.fromRGBO(42, 55, 59, 0.6),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Circular Std'),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 44.h,
            ),
          ],
        );
      }

      Widget buildDuration() {
        if (searchController.searchRecommendation.value!.contentDuration ==
                null ||
            searchController
                    .searchRecommendation.value!.contentDuration!.enabled ==
                false ||
            searchController
                    .searchRecommendation.value!.contentDuration!.items ==
                null ||
            searchController
                .searchRecommendation.value!.contentDuration!.items!.isEmpty) {
          return const Offstage();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              searchController
                      .searchRecommendation.value!.contentDuration!.title ??
                  "",
              style: AppTheme.contentTextStyle,
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              height: 50.h,
              width: double.infinity,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: searchController.searchRecommendation.value!
                      .contentDuration!.items!.length,
                  itemBuilder: (context, index) {
                    int index2 = searchController.selectedDuration.indexWhere(
                        (element) =>
                            element.duration ==
                                searchController.searchRecommendation.value!
                                    .contentDuration!.items![index]!.duration &&
                            element.compare ==
                                searchController.searchRecommendation.value!
                                    .contentDuration!.items![index]!.compare &&
                            element.type ==
                                searchController.searchRecommendation.value!
                                    .contentDuration!.items![index]!.type);

                    bool contains = index2 != -1;

                    return InkWell(
                      onTap: () {
                        searchController.setDurations(searchController
                            .searchRecommendation
                            .value!
                            .contentDuration!
                            .items![index]!);
                      },
                      child: Container(
                        height: 50.h,
                        width: 50.h,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 7.w, right: 7.w),
                        decoration: contains
                            ? BoxDecoration(
                                color: const Color(0xFF9AE3A4),
                                borderRadius: BorderRadius.circular(150))
                            : null,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (searchController
                                              .searchRecommendation
                                              .value!
                                              .contentDuration!
                                              .items![index]!
                                              .duration ??
                                          0)
                                      .toString() +
                                  (searchController
                                              .searchRecommendation
                                              .value!
                                              .contentDuration!
                                              .items![index]!
                                              .compare ==
                                          'MORE'
                                      ? "+"
                                      : ""),
                              style: TextStyle(
                                  color: contains
                                      ? const Color(0xFFF8FAFC)
                                      : const Color.fromRGBO(42, 55, 59, 0.6),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp,
                                  fontFamily: 'Circular Std'),
                            ),
                            Text(
                              searchController.searchRecommendation.value!
                                  .contentDuration!.items![index]!.type!
                                  .toLowerCase(),
                              style: TextStyle(
                                  color: contains
                                      ? const Color(0xFFF8FAFC)
                                      : const Color.fromRGBO(42, 55, 59, 0.6),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  fontFamily: 'Circular Std'),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 52.5.h,
            ),
          ],
        );
      }

      Widget buildTags() {
        if (searchController.searchRecommendation.value!.tags == null ||
            searchController.searchRecommendation.value!.tags!.enabled ==
                false ||
            searchController.searchRecommendation.value!.tags!.items == null ||
            searchController.searchRecommendation.value!.tags!.items!.isEmpty) {
          return const Offstage();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              searchController.searchRecommendation.value!.tags!.title ?? "",
              style: AppTheme.contentTextStyle,
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: List.generate(
                    searchController.searchRecommendation.value!.tags!.items!
                        .length, (index) {
                  int index2 = searchController.selectedTags.indexWhere(
                      (element) =>
                          element.displayTagId ==
                              searchController.searchRecommendation.value!.tags!
                                  .items![index]!.displayTagId &&
                          element.displayTag ==
                              searchController.searchRecommendation.value!.tags!
                                  .items![index]!.displayTag);
                  bool contains = index2 != -1;
                  return InkWell(
                    onTap: () {
                      searchController.setTags(searchController
                          .searchRecommendation.value!.tags!.items![index]!);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
                      height: 38.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                      decoration: BoxDecoration(
                        color: contains
                            ? const Color(0xFF9AE3A4)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        searchController.searchRecommendation.value!.tags!
                                .items![index]!.displayTag ??
                            "",
                        style: TextStyle(
                            color: contains
                                ? const Color(0xFFF8FAFC)
                                : const Color.fromRGBO(42, 55, 59, 0.6),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Circular Std'),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 40.5.h,
            ),
          ],
        );
      }

      return Obx(() {
        if (searchController.searchRecommendation.value == null) {
          return showLoading();
        }
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                if (searchController.recentSearchList.value.isNotEmpty)
                  buildRecentSearches(),
                buildTypes(),
                buildDuration(),
                buildTags()
              ],
            ),
          ),
        );
      });
    });
  }
}
