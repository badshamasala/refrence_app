import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/trackers/sleep_tracking/widget/pillow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepCard extends StatelessWidget {
  final String icon;
  final String howWasSleep;
  final String inTime;
  final String outTime;
  final double duration;
  final List<String?> listReasons;
  SleepCard(
      {Key? key,
      required this.howWasSleep,
      required this.inTime,
      required this.outTime,
      required this.listReasons,
      required this.duration,
      required this.icon})
      : super(key: key);

  TextStyle headingTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16.sp,
    fontFamily: 'Circular Std',
    fontWeight: FontWeight.w700,
  );
  final lightColor = const Color(0xFF5550B6);
  Widget buildTile(String image, String title, String time) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 26.h,
            fit: BoxFit.fitHeight,
            color: const Color(0xFF706CA7),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Circular Std',
              color: const Color(0xFF706CA7),
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            time,
            style: headingTextStyle,
          )
        ],
      ),
    );
  }

  Widget buildChip(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 38.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32), color: lightColor),
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.h),
      constraints: BoxConstraints(minWidth: 100.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            fontFamily: "Circular Std"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sleepTrackerSummaryBoxesbackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  howWasSleep,
                  style: headingTextStyle,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Divider(
                  thickness: 1,
                  height: 0,
                  color: lightColor,
                  indent: 24.w,
                  endIndent: 24.h,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    buildTile(Images.sleeptrackerMoon, 'BED TIME', inTime),
                    SizedBox(
                      height: 70.h,
                      child: VerticalDivider(
                        width: 0,
                        thickness: 1,
                        color: lightColor,
                      ),
                    ),
                    buildTile(Images.sleeptrackerSun, 'WAKE UP', outTime),
                    SizedBox(
                      height: 70.h,
                      child: VerticalDivider(
                        width: 0,
                        thickness: 1,
                        color: lightColor,
                      ),
                    ),
                    buildTile(Images.sleeptrackerSparkles, 'SLEEP HOURS',
                        "${duration.toStringAsFixed(2).replaceFirst(".", ":")} Hrs"),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (listReasons.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        thickness: 1,
                        height: 0,
                        color: lightColor,
                        indent: 24.w,
                        endIndent: 24.h,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      SizedBox(
                        height: 40.h,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                scrollDirection: Axis.horizontal,
                                itemCount: listReasons.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    buildChip(listReasons[index]!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      )
                    ],
                  )
              ],
            ),
          ),
          Positioned(
              top: -28.h,
              child: PillowImage(
                icon: icon,
                active: true,
                height: 48.h,
                fit: BoxFit.fitHeight,
              )

              // Image.asset(
              //   'assets/images/sleeptracker/${howWasSleep}_pillow_icon_active.png',
              //   height: 48.h,
              //   fit: BoxFit.fitHeight,
              // ),
              )
        ]);
  }

  String formatTime(int time) {
    if (time == 0 || time == 288) {
      return '00:00';
    }
    var hours = time ~/ 12;
    var minutes = (time % 12) * 5;
    return '$hours:${minutes < 10 ? '0$minutes' : minutes} ${hours <= 12 ? 'AM' : 'PM'}';
  }

  String formatIntervalTime(int init, int end) {
    var sleepTime = end > init ? end - init : 288 - init + end;
    var hours = sleepTime ~/ 12;
    var minutes = (sleepTime % 12) * 5;
    return '$hours:${minutes < 10 ? '0$minutes' : minutes}h';
  }
}
