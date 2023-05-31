import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class WeightBMIDetails extends StatelessWidget {
  const WeightBMIDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeightDetailsController weightDetailsController = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26.h, horizontal: 13.w),
      margin: EdgeInsets.only(left: 26.w, right: 26.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.w),
        color: const Color(0xffF7F7F7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<WeightDetailsController>(
              id: "BMIDetails",
              builder: (controller) {
                String userName = "";
                if (controller.userDetails.value != null &&
                    controller.userDetails.value?.userDetails != null) {
                  userName =
                      controller.userDetails.value?.userDetails?.firstName ??
                          "";
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Your BMI is: ${controller.bmiValue.toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF39D9D),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 26.h,
                    ),
                    SizedBox(
                      width: 250.w,
                      child: Text(
                        "${userName.isEmpty ? "Hey" : userName}, your BMI indicates that you are ${controller.weightRange}. Seek healthcare professional’s advice to achieve healthy weight and prevent potential health issues.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4.h,
                        ),
                      ),
                    ),
                  ],
                );
              }),
          SizedBox(
            height: 26.h,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.w,
            runSpacing: 16.h,
            children:
                List.generate(weightDetailsController.bmiList.length, (index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 85.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: HexColor(
                          weightDetailsController.bmiList[index]["color"]),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: HexColor(
                              weightDetailsController.bmiList[index]["color"]),
                        ),
                        child: Center(
                          child: Text(
                            weightDetailsController.bmiList[index]["range"],
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        weightDetailsController.bmiList[index]["value"],
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF768897),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: 36.h,
          ),
          Text(
            "Body Mass Index (BMI) is an indicator of your body fat. It’s calculated from your height and weight, and can tell you whether you are underweight, normal, overweight or obese. It can also help you gauge your risk of disease that can occur with more body fat",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF768897),
              fontWeight: FontWeight.w400,
              height: 1.2.h,
            ),
          ),
        ],
      ),
    );
  }
}
