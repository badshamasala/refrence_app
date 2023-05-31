import 'package:aayu/view/cross_promotions/cross_promotions.dart';
import 'package:aayu/view/cross_promotions/did_you_know.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/water_intake/widgets/daily_target.dart';
import 'package:aayu/view/trackers/water_intake/widgets/recommended_water_content.dart';
import 'package:aayu/view/trackers/water_intake/widgets/water_intake_details.dart';
import 'package:aayu/view/trackers/water_intake/widgets/water_intake_summary.dart';
import 'package:aayu/view/trackers/water_intake/widgets/water_reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaterIntake extends StatelessWidget {
  const WaterIntake({Key? key}) : super(key: key);

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
          const WaterIntakeDetails(),
          const CrossPromotions(
            key: Key("WATER_INTAKE"),
            moduleName: "WATER_INTAKE",
          ),
          const WaterIntakeSummary(),
          const DidYouKnow(
            category: "WATER",
          ),
          const DailyTarget(
            callApi: true,
            showToggle: true,
          ),
          SizedBox(
            height: 26.h,
          ),
          const WaterReminder(
            showSaveButton: true,
          ),
          const RecommendedWaterContent()
        ],
      ),
    );
  }
}
