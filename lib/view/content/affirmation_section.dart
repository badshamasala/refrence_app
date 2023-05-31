import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AffirmationSection extends StatelessWidget {
  final Content content;
  final Function favouriteAction;

  const AffirmationSection(
      {Key? key, required this.content, required this.favouriteAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          ShowNetworkImage(
            imgPath: content.contentImage!,
            imgWidth: 321.w,
            imgHeight: 326.h,
            boxFit: BoxFit.contain,
            placeholderImage:
                "assets/images/placeholder/affirmation_default_placeholder.png",
          ),
          Positioned(
            bottom: 15.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    EventsService().sendEvent(
                        content.isFavourite == false
                            ? "Aayu_Affirmation_Favourite"
                            : "Aayu_Affirmation_Unfavourite",
                        {
                          "content_id": content.contentId!,
                          "content_name": content.contentName!,
                          "content_image": content.contentImage!,
                        });

                    favouriteAction();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(
                              0, 0, 0, 0.07000000029802322),
                          offset: const Offset(-5, 10),
                          blurRadius: 20.h,
                        )
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcons.likeAffirmationSVG,
                      color: (content.isFavourite == true)
                          ? const Color(0xFF9AE3A4)
                          : const Color(0xFFBEBFCB),
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    buildShowDialog(context);
                    await ShareService().shareAffirmation(
                        content.contentId!, content.contentPath!);
                    Navigator.pop(context);
                    EventsService().sendEvent("Aayu_Affirmation_Share", {
                      "content_id": content.contentId!,
                      "content_name": content.contentName!,
                      "content_image": content.contentImage!,
                    });
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(
                              0, 0, 0, 0.07000000029802322),
                          offset: const Offset(-5, 10),
                          blurRadius: 20.h,
                        )
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcons.shareSVG,
                      color: const Color(0xFFBEBFCD),
                      height: 20,
                      width: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
