import 'package:aayu/model/model.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/category_content.dart';
import 'package:aayu/view/content/view_all_content.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategorySection extends StatelessWidget {
  final ContentCategories? categoryDetails;
  final String categoryImage;
  final String source;
  const CategorySection(
      {Key? key,
      required this.categoryDetails,
      this.categoryImage = "",
      required this.source})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 35.h),
      decoration: BoxDecoration(
        color: categoryDetails!.bgColor == null
            ? AppColors.whiteColor
            : Color(
                int.parse(
                  "0xFF${categoryDetails!.bgColor!.replaceAll("#", "")}",
                ),
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: pageHorizontalPadding(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    categoryDetails!.categoryName!.isNotEmpty
                        ? categoryDetails!.categoryName!.trim()
                        : "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(
                  width: 26.w,
                ),
                Visibility(
                  visible: categoryDetails!.showMore == true,
                  child: InkWell(
                    onTap: () {
                      EventsService().sendClickNextEvent(
                          "CategorySection", "View All", "ViewAllContent");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAllContent(
                            source: source,
                            categoryId: categoryDetails!.categoryId!,
                            categoryName: categoryDetails!.categoryName!,
                            categoryImage: categoryImage,
                          ),
                        ),
                      ).then((value) {
                        EventsService().sendClickBackEvent(
                            "ViewAllContent", "Back", "CategorySection");
                      });
                    },
                    child: Text(
                      "VIEW_ALL".tr,
                      style: TextStyle(
                        color: const Color(0xFF94E79F),
                        fontFamily: 'Circular Std',
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          SizedBox(
            height: 247.h,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: categoryDetails!.content!.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                if (categoryDetails!.content == null) {
                  return const Offstage();
                } else if (categoryDetails!.content![index] == null) {
                  return const Offstage();
                }

                return Container(
                  margin: EdgeInsets.only(
                      right: 20.w, left: (index == 0) ? 26.w : 0),
                  child: CategoryContent(
                    source: source,
                    categoryId: categoryDetails!.categoryId!,
                    categoryName: categoryDetails!.categoryName!,
                    categoryContent: categoryDetails!.content!,
                    medaDataBgColor:
                        categoryDetails!.medaDataBgColor ?? "#F1F1F1",
                    content: categoryDetails!.content![index]!,
                    width: 274,
                    height: 154,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
