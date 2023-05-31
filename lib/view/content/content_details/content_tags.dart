import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/view/search/search_results.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContentTags extends StatelessWidget {
  final List<ContentMetaDataTags?>? tags;
  const ContentTags({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8.w,
      runSpacing: 10.h,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(
        tags!.length,
        (index) {
          return Visibility(
            visible: tags![index]!.displayTag!.trim().isNotEmpty,
            child: InkWell(
              onTap: () async{
                buildShowDialog(context);
                SearchController searchController = Get.put(SearchController());
                await searchController.getSearchResultsFromTag(tags![index]!);
                Navigator.pop(context);
                Get.to(SearchResults(tagName: tags![index]!.displayTag ?? ""));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.w),
                  color: const Color(0xFFDDE8E5),
                ),
                child: Text(
                  tags![index]!.displayTag!.trim(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF2A373B).withOpacity(0.6),
                    fontFamily: 'Circular Std',
                    fontSize: 12.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
