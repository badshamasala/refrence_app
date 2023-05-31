import 'package:aayu/controller/cross_promotions/cross_promotions_cotroller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CrossPromotions extends StatefulWidget {
  final String moduleName;

  const CrossPromotions({
    Key? key,
    required this.moduleName,
  }) : super(key: key);

  @override
  State<CrossPromotions> createState() => _CrossPromotionsState();
}

class _CrossPromotionsState extends State<CrossPromotions> {
  late CrossPromotionsController crossPromotionsController;
  @override
  void initState() {
    super.initState();
    crossPromotionsController = Get.put(CrossPromotionsController());
    crossPromotionsController.getCrossPromotion(moduleName: widget.moduleName);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (crossPromotionsController.isLoading.value == true) {
        return const Offstage();
      }
      if (crossPromotionsController.crossPromotionDetails.value == null) {
        return const Offstage();
      }
      return Container(
        padding: pagePadding(),
        width: 322.w,
        margin: pagePadding(),
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                crossPromotionsController
                        .crossPromotionDetails.value?.bgImage ??
                    Images.crossPromoBlueBG,
              )),
          // borderRadius: BorderRadius.circular(19.w),
          // color: const Color(0xFFF7F7F7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Text(
              crossPromotionsController.crossPromotionDetails.value?.title ??
                  "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: "Baskerville",
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 18.h,
            ),
            Image.asset(
              crossPromotionsController.crossPromotionDetails.value?.icon ??
                  Images.aayuImage,
              height: 115.h,
              fit: BoxFit.fitHeight,
            ),
            // SizedBox(
            //   height: 15.h,
            // ),
            // Text(
            //   crossPromotionsController.crossPromotionDetails.value?.subTitle ??
            //       "",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     color: const Color(0xFFFF8B8B),
            //     fontSize: 20.sp,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              crossPromotionsController.crossPromotionDetails.value?.desc ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF768897),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            InkWell(
                onTap: () {
                  crossPromotionsController.handleNavigation();
                },
                child: Container(
                  height: 54.h,
                  width: 181.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color(0xFFAAFDB4),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                          offset: Offset(-5, 10),
                          blurRadius: 20),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      crossPromotionsController
                              .crossPromotionDetails.value?.ctaText ??
                          "Explore Now",
                      textAlign: TextAlign.center,
                      style: mainButtonTextStyle(),
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }
}
