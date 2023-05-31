import 'package:aayu/controller/content/view_all_content_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/content/category_content.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ViewAllContent extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  final String source;
  const ViewAllContent(
      {Key? key,
      required this.source,
      required this.categoryId,
      required this.categoryName,
      required this.categoryImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ViewAllContentController viewAllContentController =
        Get.put(ViewAllContentController(), tag: categoryId);
    Future.delayed(Duration.zero, () {
      viewAllContentController.getAllContent(categoryId);
    });

    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: Obx(
        () {
          if (viewAllContentController.isLoading.value == true) {
            return showLoading();
          } else if (viewAllContentController.categoryDetails.value == null) {
            return const Offstage();
          } else if (viewAllContentController
                  .categoryDetails.value!.categoryId ==
              null) {
            return const Offstage();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: AppColors.whiteColor,
                padding: EdgeInsets.only(left: 26.w, right: 26.w, bottom: 26.w),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        categoryName.isEmpty
                            ? viewAllContentController
                                .categoryDetails.value!.categoryName!
                            : categoryName,
                        maxLines: 2,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontFamily: 'Baskerville',
                          fontSize: 24.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.1666666666666667.h,
                        ),
                      ),
                    ),
                    categoryImage.isEmpty
                        ? const Offstage()
                        : SvgPicture.network(
                            categoryImage,
                            width: 27.82.w,
                            height: 34.69.h,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemCount: viewAllContentController
                      .categoryDetails.value!.content!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 22.h),
                      alignment: Alignment.center,
                      child: CategoryContent(
                        source: source,
                        categoryId: viewAllContentController
                            .categoryDetails.value!.categoryId!,
                        categoryName: viewAllContentController
                            .categoryDetails.value!.categoryName!,
                        medaDataBgColor: viewAllContentController
                                .categoryDetails.value!.medaDataBgColor ??
                            "#F1F1F1",
                        content: viewAllContentController
                            .categoryDetails.value!.content![index]!,
                        categoryContent: viewAllContentController
                            .categoryDetails.value!.content!,
                        width: 322,
                        height: 182,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
