// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_first_checkin_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/trackers/weight_tracking/intro/your_bmi.dart';
import 'package:aayu/view/trackers/weight_tracking/weight_details.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightFirstCheckIn extends StatelessWidget {
  const WeightFirstCheckIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeightFirstCheckInController weightFirstCheckInController =
        Get.put(WeightFirstCheckInController());
    return Scaffold(
      appBar: appBarWithOnlyLeading(Icons.arrow_back, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Container(
          padding: pageHorizontalPadding(),
          margin: pageHorizontalPadding(),
          width: 322.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19.w),
            color: const Color(0xffF7F7F7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60.h,
              ),
              Text(
                "My Weight:\nEasy Health Tracking",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFF39D9D),
                  fontFamily: "Baskerville",
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              SizedBox(
                width: 235.w,
                child: Text(
                  "Regular weight tracking and BMI monitoring are essential for maintaining good overall health and well-being.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF768897),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              // Center(
              //   child: buildLabel("Gender"),
              // ),
              // SizedBox(
              //   height: 8.h,
              // ),
              // buildGenderList(),
              // SizedBox(
              //   height: 26.h,
              // ),
              buildLabel('Height'),
              SizedBox(
                height: 8.h,
              ),
              buildHeightInfo(),
              SizedBox(
                height: 26.h,
              ),
              buildLabel('Weight'),
              SizedBox(
                height: 8.h,
              ),
              buildWeightInfo(),
              SizedBox(
                height: 60.h,
              ),
              Text(
                "Track BMI for healthy weight management.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              InkWell(
                onTap: () async {
                  if (weightFirstCheckInController.selectedHeight.isEmpty) {
                    showGetSnackBar("Please provide the height details!",
                        SnackBarMessageTypes.Info);
                  } else if (weightFirstCheckInController
                      .selectedWeight.isEmpty) {
                    showGetSnackBar("Please provide the weight details!",
                        SnackBarMessageTypes.Info);
                  } else {
                    weightFirstCheckInController.calculateBMI();
                    buildShowDialog(context);
                    bool isUpdated = await weightFirstCheckInController
                        .submitFirstCheckInDetails();
                    Navigator.pop(context);
                    if (isUpdated == true) {
                      WeightDetailsController weightDetailsController =
                          Get.find();
                      weightDetailsController.targetWeight = double.parse(
                          weightFirstCheckInController.selectedWeight);
                      weightDetailsController.weightGoalUnit =
                          weightFirstCheckInController.selectedWeightUnit;
                      Get.to(const YourBMI());
                    }
                  }
                },
                child: mainButton("Calculate"),
              ),
              SizedBox(
                height: 44.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showBMIDetails() {
    return GetBuilder<WeightFirstCheckInController>(
        id: "BMIDetails",
        builder: (controller) {
          if (controller.bmiCalculated == false) {
            return const Offstage();
          }

          String userName = "";
          if (controller.userDetails.value != null &&
              controller.userDetails.value?.userDetails != null) {
            userName =
                controller.userDetails.value?.userDetails?.firstName ?? "";
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 44.h,
                ),
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
                    "${userName.isEmpty ? "" : "$userName,"} your BMI indicates that you are ${controller.weightRange}. Keep in mind that this is not an exact representation of your health",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    "For more information see our details page",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4.h,
                    ),
                  ),
                ),
                SizedBox(
                  height: 44.h,
                ),
                InkWell(
                  onTap: () async {
                    buildShowDialog(Get.context!);
                    bool isUpdated =
                        await controller.submitFirstCheckInDetails();
                    if (isUpdated == true) {
                      WeightDetailsController weightDetailsController =
                          Get.find();
                      weightDetailsController.getUserDetails();
                      await weightDetailsController.getTodaysWeightDetails();
                      Navigator.pop(Get.context!);
                      Navigator.of(Get.context!).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const WeightDetails(),
                        ),
                      );
                    } else {
                      Navigator.pop(Get.context!);
                    }
                  },
                  child: mainButton("Continue"),
                ),
              ],
            ),
          );
        });
  }

  buildLabel(labelText) {
    return Align(
      alignment:
          (labelText == "Gender") ? Alignment.center : Alignment.centerLeft,
      child: Text(
        labelText,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: const Color(0xFF768897),
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  buildGenderList() {
    return GetBuilder<WeightFirstCheckInController>(
      id: "GenderList",
      builder: (controller) {
        return Center(
          child: SizedBox(
            height: 30.h,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xffFCAFAF),
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.genderList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectedGender =
                            controller.genderList[index];
                        controller.update(["GenderList"]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: controller.selectedGender ==
                                  controller.genderList[index]
                              ? Colors.white
                              : const Color(0xFFFCAFAF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            controller.genderList[index],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: controller.selectedGender ==
                                      controller.genderList[index]
                                  ? const Color(0xFFFCAFAF)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  buildHeightInfo() {
    return GetBuilder<WeightFirstCheckInController>(
      id: "HeightInfo",
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.setUnitsForPopup("HEIGHT");
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.sp),
                        topRight: Radius.circular(20.sp),
                      ),
                    ),
                    context: Get.context!,
                    isDismissible: false,
                    isScrollControlled: false,
                    enableDrag: false,
                    builder: (BuildContext context) {
                      return showModalPopup("HEIGHT", controller);
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xffFFBEBA),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 7.sp, horizontal: 15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.selectedHeight.isEmpty
                              ? "Select Height"
                              : controller.selectedHeight,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: const Color(0xff768897),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff768897),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            SizedBox(
              height: 30.h,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xffFCAFAF),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.heightUnitList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          String previousUnit = controller.selectedHeightUnit;
                          controller.selectedHeightUnit =
                              controller.heightUnitList[index];
                          controller.convertHeight(
                              previousUnit, controller.heightUnitList[index]);
                          controller.update(["HeightInfo"]);
                        },
                        child: Container(
                          width: 50.w,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            color: controller.selectedHeightUnit ==
                                    controller.heightUnitList[index]
                                ? Colors.white
                                : const Color(0xFFFCAFAF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              toTitleCase(controller.heightUnitList[index]
                                  .toLowerCase()),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: controller.selectedHeightUnit ==
                                        controller.heightUnitList[index]
                                    ? const Color(0xFFFCAFAF)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        );
      },
    );
  }

  showModalPopup(
      String type, WeightFirstCheckInController weightFirstCheckInController) {
    return Container(
      padding: pagePadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select ${type == "HEIGHT" ? "Height" : "Weight"}",
                style: TextStyle(
                  color: AppColors.blackLabelColor,
                  fontSize: 20.sp,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(Get.context!);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.blackLabelColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 26.h,
          ),
          buildUnitsForPopup(type),
          SizedBox(
            height: 26.h,
          ),
          Expanded(
            child: GetBuilder<WeightFirstCheckInController>(
                id: "ModalPopupScrollValues",
                builder: (controller) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 75.w,
                            height: 300.h,
                            child: ListWheelScrollView.useDelegate(
                              magnification: 1.5,
                              useMagnifier: true,
                              controller:
                                  controller.fixedExtentScrollControllerFirst,
                              itemExtent: 40,
                              physics: const FixedExtentScrollPhysics(),
                              childDelegate: ListWheelChildListDelegate(
                                children: List.generate(
                                  controller.firstScrollValues.length,
                                  (index) => buildListWheelItem(controller
                                      .firstScrollValues[index]
                                      .toString()),
                                ),
                              ),
                              onSelectedItemChanged: (int index) async {
                                controller.setSelectedPopUpValue(
                                    index,
                                    controller.fixedExtentScrollControllerSecond
                                        .selectedItem);
                              },
                            ),
                          ),
                          Text(
                            ".",
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: const Color(0xFF768897),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 75.w,
                            height: 300.h,
                            child: ListWheelScrollView.useDelegate(
                              magnification: 1.5,
                              useMagnifier: true,
                              controller:
                                  controller.fixedExtentScrollControllerSecond,
                              itemExtent: 40,
                              physics: const FixedExtentScrollPhysics(),
                              childDelegate: ListWheelChildListDelegate(
                                children: List.generate(
                                  controller.secondScrollValues.length,
                                  (index) => buildListWheelItem(controller
                                      .secondScrollValues[index]
                                      .toString()),
                                ),
                              ),
                              onSelectedItemChanged: (int index) async {
                                controller.setSelectedPopUpValue(
                                    controller.fixedExtentScrollControllerFirst
                                        .selectedItem,
                                    index);
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      )
                    ],
                  );
                }),
          ),
          SizedBox(
            height: 26.h,
          ),
          InkWell(
            onTap: () {
              weightFirstCheckInController.setValues(
                  type, weightFirstCheckInController.selectedPopUpUnit);
              Navigator.pop(Get.context!);
            },
            child: mainButton("Done"),
          )
        ],
      ),
    );
  }

  Widget buildListWheelItem(String value) {
    return Center(
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          color: Color(0xFF768897),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  buildUnitsForPopup(String type) {
    return SizedBox(
      height: 30.h,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color(0xffFCAFAF),
        ),
        child: GetBuilder<WeightFirstCheckInController>(
          id: "UnitInfoForPopUp",
          builder: (controller) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.popUpUnitList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    String previousUnit = controller.selectedPopUpUnit;
                    controller.selectedPopUpUnit =
                        controller.popUpUnitList[index];
                    controller.convertPoupUpValues(
                        type, previousUnit, controller.popUpUnitList[index]);
                    controller.update(["UnitInfoForPopUp"]);
                    Navigator.pop(Get.context!);
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.sp),
                          topRight: Radius.circular(20.sp),
                        ),
                      ),
                      context: Get.context!,
                      isDismissible: false,
                      isScrollControlled: false,
                      enableDrag: false,
                      builder: (BuildContext context) {
                        return showModalPopup(type, controller);
                      },
                    );
                  },
                  child: Container(
                    width: 50.w,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: controller.selectedPopUpUnit ==
                              controller.popUpUnitList[index]
                          ? Colors.white
                          : const Color(0xFFFCAFAF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        toTitleCase(
                            controller.popUpUnitList[index].toLowerCase()),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: controller.selectedPopUpUnit ==
                                  controller.popUpUnitList[index]
                              ? const Color(0xFFFCAFAF)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  buildWeightInfo() {
    return GetBuilder<WeightFirstCheckInController>(
      id: "WeightInfo",
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.setUnitsForPopup("WEIGHT");
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.sp),
                        topRight: Radius.circular(20.sp),
                      ),
                    ),
                    context: Get.context!,
                    isDismissible: false,
                    isScrollControlled: false,
                    enableDrag: false,
                    builder: (BuildContext context) {
                      return showModalPopup("WEIGHT", controller);
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xffFFBEBA),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 7.sp, horizontal: 15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.selectedWeight.isEmpty
                              ? "Select Weight"
                              : controller.selectedWeight,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: const Color(0xff768897),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff768897),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            SizedBox(
              height: 30.h,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xffFCAFAF),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.weightUnitList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          String previousUnit = controller.selectedWeightUnit;
                          controller.selectedWeightUnit =
                              controller.weightUnitList[index];
                          controller.convertWeight(
                              previousUnit, controller.weightUnitList[index]);
                          controller.update(["WeightInfo"]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: controller.selectedWeightUnit ==
                                    controller.weightUnitList[index]
                                ? Colors.white
                                : const Color(0xFFFCAFAF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              toTitleCase(controller.weightUnitList[index]
                                  .toLowerCase()),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: controller.selectedWeightUnit ==
                                        controller.weightUnitList[index]
                                    ? const Color(0xFFFCAFAF)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        );
      },
    );
  }
}
