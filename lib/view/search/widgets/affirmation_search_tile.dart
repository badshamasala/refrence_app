import 'package:aayu/model/grow/grow.page.content.model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/search/affirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/search/search_controller.dart';
import '../../../services/grow.service.dart';
import '../../shared/constants.dart';
import '../../shared/ui_helper/icons.dart';

class AffirmationSearchTile extends StatefulWidget {
  final Content content;
  const AffirmationSearchTile({Key? key, required this.content})
      : super(key: key);

  @override
  State<AffirmationSearchTile> createState() => _AffirmationSearchTileState();
}

class _AffirmationSearchTileState extends State<AffirmationSearchTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAffirmationBottomSheet();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 33.h,
        ),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.content.contentName ?? "",
                  maxLines: null,
                  style: TextStyle(
                      color: AppColors.blueGreyAssessmentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.sp,
                      fontFamily: 'Baskerville'),
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            InkWell(
              onTap: () {
                favouriteAffirmation();
              },
              child: SvgPicture.asset(
                AppIcons.favouriteFillSVG,
                width: 24.w,
                height: 24.h,
                color: (widget.content.isFavourite == true)
                    ? const Color(0xFF88EF95)
                    : const Color(0xFF9C9EB9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> favouriteAffirmation() async {
    try {
      bool isFavourite = widget.content.isFavourite!;
      bool isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!,
          widget.content.contentId!,
          !isFavourite,
          "affirmations");
      if (isSuccess == true) {
        setState(() {
          widget.content.isFavourite = !isFavourite;
        });
        return !isFavourite;
      }
    } catch (err) {
      rethrow;
    }
    return false;
  }

  changeisFav() {
    setState(() {
      widget.content.isFavourite = !widget.content.isFavourite!;
    });
  }

  showAffirmationBottomSheet() {
    SearchController searchController = Get.find();
    ContentCategories? moreAffirmations = searchController
        .searchResults.value!.categories!
        .firstWhereOrNull((element) {
      return (element!.categoryName!.toUpperCase() == "AFFIRMATION" ||
          element.categoryName!.toUpperCase() == "AFFIRMATIONS");
    });
    if (moreAffirmations != null &&
        moreAffirmations.content != null &&
        moreAffirmations.content!.isNotEmpty) {
      moreAffirmations.content!.remove(widget.content);
    }
    Get.to(
      AffirmationScreen(
        content: widget.content,
        favouriteAction: changeisFav,
        moreAffirmations: moreAffirmations,
      ),
    );
  }
}
