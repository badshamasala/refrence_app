import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PercentageBar extends StatelessWidget {
  final int percentage;
  final Color color;
  final String head;
  final int? startedAt;
  const PercentageBar(
      {Key? key,
      required this.percentage,
      required this.color,
      required this.head,
      this.startedAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 21.h,
          alignment: Alignment.centerLeft,
          width: 105.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(28),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        Images.bubbleBar,
                        color: color,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    height: 19.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  Positioned(
                    top: -68.h,
                    right: -(30 - percentage / 10).w,
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        height: 63.h,
                        child: Image.asset(
                          Images.healthCardOval,
                          fit: BoxFit.fitHeight,
                          color: color,
                        ),
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: [
                                Text(
                                  "$percentage",
                                  style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontFamily: 'Circular Std',
                                    fontSize: 26.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    height: 1.h,
                                  ),
                                ),
                                Text(
                                  "%".tr,
                                  style: TextStyle(
                                    color: AppColors.blackLabelColor,
                                    fontFamily: 'Circular Std',
                                    fontSize: 14.sp,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    height: 1.h,
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              top: -10,
                              child: Text(
                                head,
                                style: TextStyle(
                                    color: AppColors.secondaryLabelColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ]),
                  ),
                ]),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        if (startedAt != null)
          Text(
            'Started at $startedAt%',
            style: TextStyle(
                color: AppColors.secondaryLabelColor.withOpacity(0.8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400),
          )
      ],
    );
  }
}
