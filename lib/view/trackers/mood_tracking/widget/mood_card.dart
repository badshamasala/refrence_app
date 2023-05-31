import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MoodCard extends StatelessWidget {
  final String mood;
  final List<dynamic> selectedWhatYouFeel;
  final List<dynamic> listMoodIdentify;
  final String expressYourself;
  final DateTime submitTime;
  const MoodCard(
      {Key? key,
      required this.listMoodIdentify,
      required this.mood,
      required this.selectedWhatYouFeel,
      required this.expressYourself,
      required this.submitTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
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
                  mood,
                  style: AppTheme.tittleTextStyle,
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
                  'you are'.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    selectedWhatYouFeel.length,
                    (index) => Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
                      height: 40.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 11.h, horizontal: 19.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        selectedWhatYouFeel[index],
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  color: Colors.white,
                  thickness: 1.5.h,
                ),
                SizedBox(
                  height: 17.h,
                ),
                Text(
                  'because of'.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    listMoodIdentify.length,
                    (index) => Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
                      height: 40.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 11.h, horizontal: 19.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        listMoodIdentify[index],
                        style: TextStyle(
                            color: AppColors.secondaryLabelColor,
                            fontSize: 14.sp,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Circular Std"),
                      ),
                    ),
                  ),
                ),
                if (expressYourself.trim().isNotEmpty)
                  InkWell(
                    onTap: () {
                      showBottomText(expressYourself.trim(), context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5.h,
                        ),
                        SizedBox(
                          height: 17.h,
                        ),
                        Text(
                          expressYourself.trim(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.secondaryLabelColor,
                              fontSize: 14.sp,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Circular Std"),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 22.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(submitTime),
                      style: TextStyle(
                          color: AppColors.secondaryLabelColor
                            ..withOpacity(0.5),
                          fontSize: 11.sp,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Circular Std"),
                    ),
                  ],
                )
              ],
            ),
          ),
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
                  'assets/images/mood-tracker/${mood}_icon.png',
                  width: 56.w,
                  color: const Color(0xFFFFE488),
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),
        ]);
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
