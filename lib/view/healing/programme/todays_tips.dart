import 'package:aayu/controller/program/todays_tip_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TodaysTips extends StatelessWidget {
  const TodaysTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodaysProgrammeTipController todaysProgrammeTipController =
        Get.put(TodaysProgrammeTipController());
    return Obx(() {
      if (todaysProgrammeTipController.isTipLoading.value == true) {
        return const Offstage();
      } else if (todaysProgrammeTipController
              .healingTipResponse.value!.todaysTip ==
          null) {
        return const Offstage();
      } else if (todaysProgrammeTipController
              .healingTipResponse.value!.todaysTip!.tip ==
          null) {
        return const Offstage();
      } else {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 322.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(184.w),
                  bottomRight: Radius.circular(184.w),
                  topLeft: Radius.circular(24.w),
                  topRight: Radius.circular(24.w),
                ),
              ),
              margin: EdgeInsets.only(top: 92.h, bottom: 26.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 175.h,
                  ),
                  SizedBox(
                    width: 232.w,
                    child: Text(
                      todaysProgrammeTipController
                          .healingTipResponse.value!.todaysTip!.tip!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.blackLabelColor.withOpacity(0.8),
                          fontFamily: 'Baskerville',
                          fontSize: 22.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.16.h),
                    ),
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          buildShowDialog(context);
                          await ShareService().shareTip(
                              todaysProgrammeTipController
                                  .healingTipResponse.value!.todaysTip!.tip!);

                          EventsService().sendEvent("Program_Tip_Share", {
                            "tip_id": todaysProgrammeTipController
                                .healingTipResponse.value!.todaysTip!.tipId!,
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.07000000029802322),
                                  offset: Offset(-5, 10),
                                  blurRadius: 20,
                                )
                              ],
                              color: AppColors.whiteColor,
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.share,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 63.h,
                  ),
                ],
              ),
            ),
            Image(
              width: 225.w,
              height: 232.h,
              image: const AssetImage(Images.healingTipImage),
              fit: BoxFit.contain,
            ),
            Positioned(
              top: 52.h,
              left: 29.w,
              child: Container(
                width: 84.w,
                height: 84.h,
                decoration: const BoxDecoration(
                    color: Color(0xFF8EF29B), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "AAYU_TIPS".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF475F72),
                      fontFamily: 'Circular Std',
                      fontSize: 20.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.h,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }
    });
  }
}
