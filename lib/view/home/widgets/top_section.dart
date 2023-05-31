import 'package:aayu/controller/home/home_top_section_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/view/healing/consultant/doctor_list.dart';
import 'package:aayu/view/healing/consultant/trainer_list.dart';
import 'package:aayu/view/home/widgets/top_section_widgets/dfi_web_view.dart';
import 'package:aayu/view/home/widgets/top_section_widgets/play_video.dart';
import 'package:aayu/view/home/widgets/top_section_widgets/show_web_view.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/subscription/subscribe_to_aayu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../content/view_all_content.dart';
import '../../main_page.dart';
import 'top_section_widgets/recommended_content.dart';
import 'top_section_widgets/recommended_program.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeTopSectionController homeTopSectionController =
        Get.put(HomeTopSectionController());

    return Obx(
      () {
        if (homeTopSectionController.isLoading.value == true) {
          return Container(
            color: const Color(0xFFF8F5F5),
            height: 420.h,
            width: double.infinity,
          );
        } else if (homeTopSectionController.topSectionContent.value == null) {
          return const Offstage();
        } else if (homeTopSectionController.topSectionContent.value!.details ==
            null) {
          return const Offstage();
        }

        return RecomendedTopSection(
            homeTopSectionController: homeTopSectionController);
      },
    );
  }
}

class RecomendedTopSection extends StatelessWidget {
  final HomeTopSectionController homeTopSectionController;
  const RecomendedTopSection({Key? key, required this.homeTopSectionController})
      : super(key: key);

  getWidgetList(context, List<Widget> widgetList) {
    for (var sequence in homeTopSectionController
        .topSectionContent.value!.details!.sequence!) {
      switch (sequence!.type!.toUpperCase()) {
        case "BANNER":
          if (homeTopSectionController
                      .topSectionContent.value!.details!.banner !=
                  null &&
              homeTopSectionController
                  .topSectionContent.value!.details!.banner!.isNotEmpty) {
            HomePageTopSectionResponseDetailsBanner? bannerDetails =
                homeTopSectionController
                    .topSectionContent.value!.details!.banner!
                    .firstWhereOrNull(
                        (banner) => banner!.bannerId == sequence.sequenceId);

            if (bannerDetails != null) {
              widgetList.add(
                InkWell(
                  onTap: () {
                    handleBannerNavigation(context, bannerDetails);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.w),
                    child: ShowNetworkImage(
                      imgPath: bannerDetails.bannerImage!,
                      imgWidth: double.infinity.w,
                      imgHeight: 360.h,
                      boxFit: BoxFit.cover,
                      placeholderImage:
                          "assets/images/placeholder/default_home.jpg",
                    ),
                  ),
                ),
              );
            }
          }
          break;
        case "PROGRAM":
          if (homeTopSectionController
                  .topSectionContent.value!.details!.program !=
              null) {
            widgetList.add(RecommendedProgram(
                programData: homeTopSectionController
                    .topSectionContent.value!.details!.program!));
          }
          break;
        case "CONTENT":
          if (homeTopSectionController
                      .topSectionContent.value!.details!.content !=
                  null &&
              homeTopSectionController
                  .topSectionContent.value!.details!.content!.isNotEmpty) {
            Content? contentDetails = homeTopSectionController
                .topSectionContent.value!.details!.content!
                .firstWhereOrNull(
                    (content) => content!.contentId == sequence.sequenceId);
            if (contentDetails != null) {
              widgetList.add(RecommendedContent(
                  contentData: contentDetails,
                  heroTag: "RecommendedContent_${contentDetails.contentId}"));
            }
          }
          break;
        case "INAPP":
          if (homeTopSectionController
                      .topSectionContent.value!.details!.inApp !=
                  null &&
              homeTopSectionController
                  .topSectionContent.value!.details!.inApp!.isNotEmpty) {
            HomePageTopSectionResponseDetailsInApp? bannerDetails =
                homeTopSectionController
                    .topSectionContent.value!.details!.inApp!
                    .firstWhereOrNull(
                        (details) => details!.bannerId == sequence.sequenceId);
            if (bannerDetails != null) {
              widgetList.add(
                InkWell(
                  onTap: () {
                    handleInAppNavigation(context, bannerDetails.type!, bannerDetails.referenceId!);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.w),
                    child: ShowNetworkImage(
                      imgPath: bannerDetails.bannerImage!,
                      imgWidth: double.infinity.w,
                      imgHeight: 360.h,
                      boxFit: BoxFit.cover,
                      placeholderImage:
                          "assets/images/placeholder/default_home.jpg",
                    ),
                  ),
                ),
              );
            }
          }
          break;
      }
    }

    return widgetList;
  }

  handleBannerNavigation(BuildContext context,
      HomePageTopSectionResponseDetailsBanner bannerDetails) {
    switch (bannerDetails.ctaType!.toUpperCase()) {
      case "VIDEO":
        if (bannerDetails.url != null && bannerDetails.url!.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayVideo(
                contentPath: bannerDetails.url!,
              ),
            ),
          );
        } else {
          showCustomSnackBar(context, "Url not avaialble!");
        }
        break;
      case "REDIRECTION":
        if (bannerDetails.url != null && bannerDetails.url!.isNotEmpty) {
          String pageUrl = bannerDetails.url!;
          if (bannerDetails.passUserId == true) {
            pageUrl =
                pageUrl.replaceAll("[USER_ID]", globalUserIdDetails!.userId!);
          }

          if (bannerDetails.bannerType == "DFI") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DFIWebView(
                  pageUrl: pageUrl,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowWebView(
                  pageUrl: pageUrl,
                ),
              ),
            );
          }
        } else {
          showCustomSnackBar(context, "URL_NOT_AVAIALBLE".tr);
        }
        break;
    }
  }

  handleInAppNavigation(BuildContext context, String bannerType, String referenceId) {
    switch (bannerType.toUpperCase()) {
      case "HEALING":
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MainPage(
                      selectedTab: 1,
                    )),
            (Route<dynamic> route) => false);
        break;
      case "GROW":
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MainPage(
                      selectedTab: 2,
                    )),
            (Route<dynamic> route) => false);
        break;
      case "GROW_CATEGORY":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewAllContent(
              categoryId: referenceId,
              source: "TOP_SECTION",
              categoryImage: "",
              categoryName: "",
            ),
          ),
        );
        break;
      case "SUBSCRIPTION":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscribeToAayu(
              content: null,
              subscribeVia: 'TOP_BANNER',
            ),
          ),
        );
        break;
      case "DOCTOR_CONSULTATION":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorList(
              pageSource: "MY_ROUTINE",
              consultType: "GOT QUERY",
              bookType: "PAID",
            ),
          ),
        );
        break;
      case "THERAPIST_CONSULTATION":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainerList(
              pageSource: "MY_ROUTINE",
              consultType: "GOT QUERY",
              bookType: "PAID",
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = getWidgetList(context, []);

    return Padding(
      padding: pageVerticalPadding(),
      child: CarouselSlider(
        options: CarouselOptions(
          initialPage: homeTopSectionController.currentContentPosition.value,
          height: 360.h,
          enlargeCenterPage: true,
          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
          viewportFraction: 0.8,
          autoPlay: true,
          reverse: false,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) {
            homeTopSectionController.currentContentPosition.value = index;
          },
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
          pauseAutoPlayOnTouch: true,
          scrollDirection: Axis.horizontal,
        ),
        items: widgetList,
      ),
    );
  }
}
