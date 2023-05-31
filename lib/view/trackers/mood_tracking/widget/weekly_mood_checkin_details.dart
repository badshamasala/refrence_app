import 'package:aayu/model/model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyMoodCheckInDetails extends StatelessWidget {
  final WeeklyMoodCheckInModelInsight insightData;
  const WeeklyMoodCheckInDetails({Key? key, required this.insightData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 165.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(180.h),
              topRight: Radius.circular(180.h),
              bottomLeft: Radius.circular(16.h),
              bottomRight: Radius.circular(16.h),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 54.h,
              ),
              Text(
                "MOOD OF THE WEEK",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Circular Std',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5.w,
                  color: AppColors.blackLabelColor,
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              if (insightData.moodOfDuration?.icon != null)
                Container(
                  width: 46.15.w,
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
                  child: Image.asset(
                    insightData.moodOfDuration?.icon ?? "",
                    width: 46.15.w,
                    color: const Color(0xFFFFE488),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                insightData.moodOfDuration?.mood ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 15.h,
              )
            ],
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        if (insightData.youMostlyFelt != null &&
            insightData.youMostlyFelt!.isNotEmpty)
          weeklyDetails('You mostly felt',
              insightData.youMostlyFelt!.map((e) => e?.feeling ?? "").toList()),
        if (insightData.youMostlyFelt != null &&
            insightData.youMostlyFelt!.isNotEmpty)
          SizedBox(
            height: 15.h,
          ),
        if (insightData.becauseOf != null && insightData.becauseOf!.isNotEmpty)
          weeklyDetails(
              'Because Of',
              insightData.becauseOf!
                  .map((e) => e?.identification ?? "")
                  .toList()),
        if (insightData.becauseOf != null && insightData.becauseOf!.isNotEmpty)
          SizedBox(
            height: 15.h,
          ),
        // weeklyDetails('What got you down', insightData.gotYouDown),
        SizedBox(
          height: 55.h,
        )
      ],
    );
  }

  weeklyDetails(String sectionTitle, List<String?>? list) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sectionTitle.toUpperCase(),
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Circular Std',
                fontWeight: FontWeight.w400,
                color: AppColors.blackLabelColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 13.h,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                list!.length,
                (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 11.h, horizontal: 19.w),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      list[index]!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryLabelColor,
                        fontFamily: 'Circular Std',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
