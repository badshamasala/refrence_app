// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/search/search_controller.dart';
import 'package:aayu/view/search/search_recommendation.dart';
import 'package:aayu/view/search/search_results.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GetBuilder<SearchController>(
            builder: (controller) => Container(
              padding: EdgeInsets.only(
                right: 24.w,
                left: 24.w,
                bottom: 18.h,
                top: 56.h,
              ),
              color: const Color(0xFFF8FAFC),
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 30,
                              color: Color.fromRGBO(112, 136, 210, 0.1))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFF9C9EB9),
                            size: 22,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Expanded(
                              child: TextFormField(
                            controller:
                                controller.searchTextEditingController.value,
                            autofocus: true,
                            onChanged: (val) {
                              controller.update();
                            },
                            style: TextStyle(
                              color: const Color.fromRGBO(42, 55, 59, 0.6),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Circular Std',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search topic',
                              hintStyle: TextStyle(
                                color: const Color(0xFF9C9EB9),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Circular Std',
                              ),
                            ),
                          )),
                          if (controller.searchTextEditingController.value.text
                              .trim()
                              .isNotEmpty)
                            InkWell(
                              onTap: () {
                                controller.searchTextEditingController.value
                                    .clear();
                                controller.update();
                              },
                              child: CircleAvatar(
                                radius: 8.h,
                                backgroundColor:
                                    const Color.fromRGBO(18, 18, 29, 0.1),
                                child: Icon(
                                  Icons.close,
                                  size: 10.h,
                                  color: Colors.black,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel',
                          style: TextStyle(
                            color: const Color(0xFF8FE39A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Circular Std',
                          )))
                ],
              ),
            ),
          ),
          const Expanded(child: SearchRecommendation())
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 27.w, right: 27.w, bottom: 30.h),
        child: GetBuilder<SearchController>(builder: (buttonCotroller) {
          if (buttonCotroller.checkIsValid() == true) {
            return InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                buildShowDialog(context);
                await buttonCotroller.getSearchResults();
                Navigator.pop(context);
                Get.to(const SearchResults(
                  tagName: "",
                ));
              },
              child: mainButton('Search'),
            );
          } else {
            return disabledButton('Search');
          }
        }),
      ),
    );
  }
}
