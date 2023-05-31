import 'package:aayu/view/content/affirmation_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/grow/grow.page.content.model.dart';
import '../../services/grow.service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../shared/constants.dart';

class AffirmationScreen extends StatefulWidget {
  final Content content;
  final Function favouriteAction;
  final ContentCategories? moreAffirmations;
  const AffirmationScreen(
      {Key? key,
      required this.content,
      required this.favouriteAction,
      required this.moreAffirmations})
      : super(key: key);

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 22.w, top: 8.h),
              child: Text(
                (widget.moreAffirmations != null &&
                        widget.moreAffirmations!.content != null &&
                        widget.moreAffirmations!.content!.isNotEmpty)
                    ? "Affirmations"
                    : "Affirmation",
                style: AppTheme.secondarySmallFontTitleTextStyle,
              ),
            ),
            AffirmationSection(
              content: widget.content,
              favouriteAction: () async {
                bool isSuccess = await favouriteAffirmation(
                    widget.content.contentId!, widget.content.isFavourite!);
                widget.favouriteAction();
                if (isSuccess == true) {
                  setState(() {
                    widget.content.isFavourite = !widget.content.isFavourite!;
                  });
                }
              },
            ),
            SizedBox(
              height: 30.h,
            ),
            (widget.moreAffirmations != null &&
                    widget.moreAffirmations!.content != null &&
                    widget.moreAffirmations!.content!.isNotEmpty)
                ? MoreAffirmations(
                    moreAffirmations: widget.moreAffirmations,
                  )
                : const Offstage(),
          ],
        ),
      ),
    );
  }

  Future<bool> favouriteAffirmation(String contentId, bool isFavourite) async {
    bool isSuccess = false;
    try {
      isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!,
          contentId,
          !isFavourite,
          "affirmations");
    } catch (err) {
      rethrow;
    }
    return isSuccess;
  }
}

class MoreAffirmations extends StatefulWidget {
  final ContentCategories? moreAffirmations;
  const MoreAffirmations({Key? key, required this.moreAffirmations})
      : super(key: key);

  @override
  State<MoreAffirmations> createState() => _MoreAffirmationsState();
}

class _MoreAffirmationsState extends State<MoreAffirmations> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 22.w, top: 8.h),
          child: Text(
            'More ${widget.moreAffirmations!.content!.length > 1 ? 'affirmations' : 'affirmation'}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.blackLabelColor,
              fontSize: 16.sp,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.moreAffirmations!.content!.length <= 20
              ? widget.moreAffirmations!.content!.length
              : 20,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: (index == 0)
                  ? EdgeInsets.symmetric(vertical: 36.h)
                  : EdgeInsets.only(bottom: 36.h),
              child: AffirmationSection(
                content: widget.moreAffirmations!.content![index]!,
                favouriteAction: () async {
                  bool isSuccess = await favouriteAffirmation(
                      widget.moreAffirmations!.content![index]!.contentId!,
                      widget.moreAffirmations!.content![index]!.isFavourite!);
                  if (isSuccess == true) {
                    setState(() {
                      widget.moreAffirmations!.content![index]!.isFavourite =
                          !widget
                              .moreAffirmations!.content![index]!.isFavourite!;
                    });
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<bool> favouriteAffirmation(String contentId, bool isFavourite) async {
    bool isSuccess = false;
    try {
      isSuccess = await GrowService().favouriteContent(
          globalUserIdDetails!.userId!,
          contentId,
          !isFavourite,
          "affirmations");
    } catch (err) {
      rethrow;
    }
    return isSuccess;
  }
}
