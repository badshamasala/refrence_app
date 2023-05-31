import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MoodCheckInDetails extends StatelessWidget {
  final MoodCheckInModel? checkInDetails;
  const MoodCheckInDetails({Key? key, required this.checkInDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime;
    if (checkInDetails?.checkInTime != null) {
      dateTime =
          DateTime.fromMillisecondsSinceEpoch(checkInDetails!.checkInTime!);
    }

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 25.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFFF7F7F7),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 31.h,
              ),
              Text(
                checkInDetails?.mood?.mood ?? "",
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontSize: 16.sp,
                  // letterSpacing: 0.4,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Circular Std",
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Divider(
                color: Colors.white,
                thickness: 1.5.h,
              ),
              SizedBox(
                height: 18.h,
              ),
              Text(
                "YOU ARE",
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 13.35.h,
              ),
              if (checkInDetails?.feelings != null)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      checkInDetails!.feelings!.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          padding: EdgeInsets.symmetric(
                            vertical: 11.h,
                            horizontal: 19.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            checkInDetails!.feelings![index]!.feeling ?? "",
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Circular Std",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(
                height: 20.65.h,
              ),
              Divider(
                color: Colors.white,
                thickness: 1.5.h,
              ),
              SizedBox(
                height: 17.h,
              ),
              Text(
                "BECAUSE OF",
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 13.35.h,
              ),
              if (checkInDetails?.identifications != null)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      checkInDetails!.identifications!.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 11.h, horizontal: 19.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            checkInDetails
                                    ?.identifications?[index]?.identification ??
                                "",
                            style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Circular Std",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Visibility(
                visible: checkInDetails?.note != null &&
                    checkInDetails!.note!.isNotEmpty,
                child: InkWell(
                  onTap: () {
                    showBottomText(
                        (checkInDetails?.note ?? "").trim(), context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 19.65.h,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1.5.h,
                      ),
                      SizedBox(
                        height: 18.35.h,
                      ),
                      SizedBox(
                        width: 279.w,
                        child: Text(
                          checkInDetails?.note ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Circular Std",
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 22.65.h,
              ),
              if (dateTime != null)
                SizedBox(
                  width: 279.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat('dd MMM, yyyy hh:mm a').format(dateTime),
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor
                            ..withOpacity(0.5),
                          fontSize: 11.sp,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Circular Std"),
                    ),
                  ),
                ),
              SizedBox(
                height: 9.h,
              ),
            ],
          ),
        ),
        if (checkInDetails?.mood?.icon != null)
          Positioned(
            top: -28.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56.w,
                  height: 49.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-4, 4),
                        blurRadius: 8,
                        color: Color.fromRGBO(0, 0, 0, 0.04),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                      bottomLeft: Radius.circular(31),
                      bottomRight: Radius.circular(31),
                    ),
                  ),
                ),
                Image.asset(
                  checkInDetails?.mood?.icon ?? "",
                  width: 56.w,
                  color: const Color(0xFFFFE488),
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),
      ],
    );
  }

  showBottomText(String string, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackLabelColor,
                  size: 25,
                )),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                string,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: const Color(0xFF5B7081)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
