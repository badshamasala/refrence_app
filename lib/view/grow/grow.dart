import 'package:aayu/controller/grow/grow_controller.dart';
import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/ghost_screens/ghost_screen.dart';
import 'package:aayu/view/grow/liveEventContent.dart';
import 'package:aayu/view/grow/widgets/grow_tab_content.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../search/search_page.dart';

class GrowPage extends StatefulWidget {
  final String selectedTab;
  const GrowPage({Key? key, required this.selectedTab}) : super(key: key);
  static final GlobalKey<_GrowPageState> globalKey = GlobalKey();

  @override
  State<GrowPage> createState() => _GrowPageState();
}

class _GrowPageState extends State<GrowPage>
    with AutomaticKeepAliveClientMixin<GrowPage>, TickerProviderStateMixin {
  // double top = 0.0;
  GrowController growController = Get.put(GrowController());
  ScrollController scrollController = ScrollController();
  TabController? tabController;
  int indexTab = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        growController.appBarTextColor = isSliverAppBarExpanded
            ? AppColors.blackLabelColor
            : Colors.transparent;
        growController.update();
      });
  }

  bool get isSliverAppBarExpanded {
    return scrollController.hasClients &&
        scrollController.offset > (100 - kToolbarHeight).h;
  }

  changeToTab(String tabName) {
    tabController!.animateTo(growController.getTabIndex(tabName));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (growController.isLoading.value == true) {
        return const GhostScreen(image: Images.growGhostScreenLottie);
      } else if (growController.growCategories.value == null) {
        return const Offstage();
      } else if (growController.growCategories.value!.categories == null) {
        return const Offstage();
      } else if (growController.growCategories.value!.categories!.isEmpty) {
        return const Offstage();
      }
      if (tabController == null) {
        tabController = TabController(
            length: growController.growCategories.value!.categories!.length,
            vsync: this);
        if (widget.selectedTab.isNotEmpty) {
          tabController!
              .animateTo(growController.getTabIndex(widget.selectedTab));
        }
        tabController!.animation!.addListener(() {
          setState(() {
            indexTab = tabController!.index;
          });
        });
      }

      return Scaffold(
        body: DefaultTabController(
          length: growController.growCategories.value!.categories!.length,
          initialIndex: (widget.selectedTab.isEmpty)
              ? 0
              : growController.getTabIndex(widget.selectedTab),
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    backgroundColor: Colors.white,
                    pinned: true,
                    snap: false,
                    floating: false,
                    expandedHeight: 322.h,
                    elevation: 0,
                    centerTitle: true,
                    forceElevated: innerBoxIsScrolled,
                    iconTheme: const IconThemeData(
                        color: AppColors.blueGreyAssessmentColor),
                    actions: [
                      IconButton(
                        onPressed: () {
                          SearchController searchController =
                              Get.put(SearchController());
                          searchController.nullSearchResults();
                          searchController.clearSearchText();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ));
                        },
                        icon: const Icon(
                          Icons.search,
                        ),
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 322.h,
                            width: double.infinity,
                            color: AppColors.whiteColor,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (growController.userDetails.value != null &&
                                        growController.userDetails.value!
                                                .userDetails !=
                                            null)
                                    ? Text(
                                        "Welcome ${growController.userDetails.value!.userDetails!.firstName ?? ""}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.blackLabelColor,
                                          fontFamily: 'Baskerville',
                                          fontSize: 24.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                          height: 0.75.h,
                                        ),
                                      )
                                    : Text(
                                        "Welcome",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.blackLabelColor,
                                          fontFamily: 'Baskerville',
                                          fontSize: 24.sp,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                          height: 0.75.h,
                                        ),
                                      ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 26.w),
                                  child: Text(
                                    'De-stress yourself with guided yoga, meditation, calming music, daily affirmations and a lot more to help you heal and grow.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.secondaryLabelColor,
                                      fontFamily: 'Circular Std',
                                      fontSize: 16.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(96.h),
                      child: Container(
                        color: AppColors.whiteColor,
                        width: double.infinity,
                        child: TabBar(
                          controller: tabController,
                          isScrollable: true,
                          indicatorColor: const Color(0xFFC0F9C7),
                          indicatorWeight: 6,
                          indicatorPadding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.label,
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.only(
                              top: 3.h, bottom: 3.h, right: 0.w, left: 0.w),
                          labelColor: AppColors.secondaryLabelColor,
                          unselectedLabelColor: AppColors.secondaryLabelColor,
                          onTap: (val) {
                            setState(() {
                              indexTab = val;
                            });
                          },
                          labelStyle: TextStyle(
                            fontFamily: 'Baskerville',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.33.h,
                          ),
                          tabs: List.generate(
                              growController.growCategories.value!.categories!
                                  .length, (index) {
                            return Container(
                              constraints: BoxConstraints(minWidth: 100.w),
                              padding: EdgeInsets.zero,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 70.h,
                                    width: 100.w,
                                    child: AnimatedContainer(
                                      width: 100.w,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      height: indexTab == index ? 70.h : 55.h,
                                      child: SvgPicture.network(
                                        growController.growCategories.value!
                                            .categories![index]!.categoryImage!,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    growController.growCategories.value!
                                        .categories![index]!.categoryName!,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                )
              ];
            },
            body: Container(
              margin: EdgeInsets.only(top: 190.h),
              color: AppColors.whiteColor,
              child: TabBarView(
                controller: tabController,
                children: List.generate(
                    growController.growCategories.value!.categories!.length,
                    (tabIndex) {
                  if (growController.growCategories.value!
                          .categories![tabIndex]!.categoryName!
                          .toUpperCase() ==
                      "EVENT") {
                    return const LiveEventContent();
                  }
                  return GrowTabContent(
                    categoryId: growController.growCategories.value!
                        .categories![tabIndex]!.categoryId!,
                    categoryName: growController.growCategories.value!
                        .categories![tabIndex]!.categoryName!,
                    categoryImage: growController.growCategories.value!
                        .categories![tabIndex]!.categoryImage!,
                  );
                }),
              ),
            ),
          ),
        ),
      );
    });
  }
}
