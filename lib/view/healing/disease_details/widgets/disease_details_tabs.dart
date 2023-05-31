import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiseaseDetailsTabs extends StatefulWidget {
  final List<DiseaseDetailsResponseDetailsTabs?>? tabs;
  const DiseaseDetailsTabs({Key? key, required this.tabs}) : super(key: key);

  @override
  State<DiseaseDetailsTabs> createState() => _DiseaseDetailsTabsState();
}

class _DiseaseDetailsTabsState extends State<DiseaseDetailsTabs>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: widget.tabs!.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: pageHorizontalPadding(),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: tabController,
              indicatorColor: AppColors.primaryColor,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.only(right: 20.w),
              indicatorWeight: 5,
              isScrollable: true,
              labelColor: AppColors.secondaryLabelColor,
              unselectedLabelColor:
                  AppColors.secondaryLabelColor.withOpacity(0.5),
              labelStyle: selectedTabTextStyle(),
              unselectedLabelStyle: unSelectedTabTextStyle(),
              onTap: (index) {
                setState(() {
                  tabController.index = index;
                });
              },
              tabs: List.generate(
                widget.tabs!.length,
                (index) => Tab(
                  text: widget.tabs![index]!.tabName!,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 0, left: 26.w, right: 26.w),
          width: double.infinity,
          padding: pagePadding(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.w),
              bottomRight: Radius.circular(16.w),
            ),
            color: AppColors.whiteColor,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(91, 112, 129, 0.08),
                offset: Offset(1, 8),
                blurRadius: 16,
                spreadRadius: 0,
              )
            ],
          ),
          child: IndexedStack(
            index: tabController.index,
            children: List.generate(
              widget.tabs!.length,
              (index) {
                return Visibility(
                  visible: tabController.index == index,
                  child: (widget.tabs![index]!.content == null)
                      ? const Offstage()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            widget.tabs![index]!.content!.length,
                            (contentIndex) {
                              return buildHealingTabRow(
                                widget.tabs![index]!.content![contentIndex]!
                                    .icon!,
                                widget.tabs![index]!.content![contentIndex]!
                                    .text!,
                              );
                            },
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
