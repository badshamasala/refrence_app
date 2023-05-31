import 'package:aayu/controller/grow/grow_content_controller.dart';
import 'package:aayu/view/content/affirmation_section.dart';
import 'package:aayu/view/content/category_content.dart';
import 'package:aayu/view/content/category_section.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GrowTabContent extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  const GrowTabContent(
      {Key? key,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GrowContentController>(
        init: GrowContentController(categoryId),
        tag: categoryId,
        autoRemove: false,
        builder: (growController) {
          if (growController.isContentLoading.value == true) {
            return showLoading();
          } else if (growController.growPageCategoryContent.value == null) {
            return const Offstage();
          } else if (growController.growPageCategoryContent.value!.details ==
              null) {
            return const Offstage();
          }

          switch (growController
              .growPageCategoryContent.value!.details!.displayType) {
            case "Affirmation":
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: growController
                    .growPageCategoryContent.value!.details!.content!.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: (index == 0)
                        ? EdgeInsets.symmetric(vertical: 36.h)
                        : EdgeInsets.only(bottom: 36.h),
                    child: AffirmationSection(
                        content: growController.growPageCategoryContent.value!
                            .details!.content![index]!,
                        favouriteAction: () {
                          growController.favouriteAffirmation(index);
                        }),
                  );
                },
              );
            case "Content":
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: growController
                    .growPageCategoryContent.value!.details!.content!.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 22.h),
                    alignment: Alignment.center,
                    child: CategoryContent(
                      source: "",
                      categoryId: categoryId,
                      categoryName: categoryName,
                      categoryContent: growController
                          .growPageCategoryContent.value!.details!.content!,
                      medaDataBgColor: "#F1F1F1",
                      content: growController.growPageCategoryContent.value!
                          .details!.content![index]!,
                      width: 322,
                      height: 182,
                    ),
                  );
                },
              );
            case "Category":
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: growController
                    .growPageCategoryContent.value!.details!.categories!.length,
                itemBuilder: (BuildContext context, index) {
                  return CategorySection(
                    source: "",
                    categoryDetails: growController.growPageCategoryContent
                        .value!.details!.categories![index]!,
                    categoryImage: categoryImage,
                  );
                },
              );

            default:
              return Container();
          }
        });
  }
}
