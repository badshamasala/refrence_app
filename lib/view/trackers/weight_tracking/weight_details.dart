import 'package:aayu/view/cross_promotions/cross_promotions.dart';
import 'package:aayu/view/cross_promotions/did_you_know.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/bmi_details.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/recommended_weight_content.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/track_weight.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/weight_goal.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/weight_reminder.dart';
import 'package:aayu/view/trackers/weight_tracking/widgets/weight_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeightDetails extends StatelessWidget {
  const WeightDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          const TrackWeight(),
          SizedBox(
            height: 26.h,
          ),
          const WeightBMIDetails(),
          const CrossPromotions(
            key: Key("WEIGHT_TRACKER"),
            moduleName: "WEIGHT_TRACKER",
          ),
          const WeightSummary(),
          const DidYouKnow(
            category: "WEIGHT",
          ),
          const WeightGoal(
            callApi: true,
            showToggle: true,
          ),
          SizedBox(
            height: 26.h,
          ),
          const WeightReminder(
            showSaveButton: true,
          ),
          SizedBox(
            height: 26.h,
          ),
          SizedBox(
            width: 284.w,
            child: Padding(
              padding: pageHorizontalPadding(),
              child: Text(
                "Try to set realistic and above all healthy goals. Consider that you need to burn around 7,000 kcal to lose 1 kg. So if you manage to burn 500 kcal per day more than you consume, it will take you roughly weeks to lose 1 Kg",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontSize: 12.sp,
                  height: 1.3.h,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          const RecommendedWeightContent()
        ],
      ),
    );
  }
}
