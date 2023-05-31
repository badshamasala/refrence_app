import 'package:aayu/controller/daily_records/weight_tracker/weight_goal_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WeightGoal extends StatelessWidget {
  final bool callApi;
  final bool showToggle;
  const WeightGoal({Key? key, required this.callApi, required this.showToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeightDetailsController weightDetailsController = Get.find();
    WeightGoalController weightGoalController = Get.put(WeightGoalController());
    return Container(
      padding: pageVerticalPadding(),
      width: 322.w,
      margin: pageHorizontalPadding(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        color: const Color(0xffF7F7F7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "WEIGHT GOAL",
                style: TextStyle(
                  color: const Color(0xffFF8B8B),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Visibility(
                visible: showToggle,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.scale(
                    scale: 0.6,
                    transformHitTests: false,
                    child: GetBuilder<WeightDetailsController>(
                      id: "WeightGoalSwitch",
                      builder: (controller) {
                        return CupertinoSwitch(
                          value: controller.enableWeightGoal,
                          activeColor: const Color(0xFF94E79F),
                          trackColor: const Color(0xFF090B0F).withOpacity(0.5),
                          thumbColor: AppColors.whiteColor,
                          onChanged: (value) async {
                            if (callApi == true) {
                              await TrackerService().updateWeightGoal({
                                "isActive": !controller.enableWeightGoal,
                                "targetWeight": controller.targetWeight,
                                "unit": controller.defaultWeightUnit,
                              });
                            }
                            controller.enableWeightGoal =
                                !controller.enableWeightGoal;
                            controller.update(
                                ["WeightGoalSwitch", "WeightGoalInputDetails"]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          GetBuilder<WeightDetailsController>(
              id: "WeightGoalInputDetails",
              builder: (controller) {
                if (controller.enableWeightGoal == false) {
                  return const Offstage();
                }
                return Padding(
                  padding: pageHorizontalPadding(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.targetWeight.toStringAsFixed(1)} ${toTitleCase(controller.defaultWeightUnit.toLowerCase())}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF768897),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h,),
                      InkWell(
                        onTap: () {
                          weightGoalController.setFixedExtentScrollController(
                              weightDetailsController.defaultWeightUnit,
                              weightDetailsController.targetWeight.toString());
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
                              return showModalPopup(
                                  "WEIGHT",
                                  weightDetailsController,
                                  weightGoalController);
                            },
                          );
                        },
                        child: SizedBox(
                          width: 100.w,
                          height: 30.h,
                          child: mainButton("Set"),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  showModalPopup(String type, WeightDetailsController weightDetailsController,
      WeightGoalController weightGoalController) {
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
                "Select Weight",
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
          buildUnitsForPopup(type, weightDetailsController),
          SizedBox(
            height: 26.h,
          ),
          Expanded(
            child: GetBuilder<WeightGoalController>(
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
              if (weightGoalController.selectedPopUpValue.isNotEmpty) {
                weightDetailsController.defaultWeightUnit =
                    weightGoalController.selectedPopUpUnit;
                weightDetailsController.setWeightGoal(
                    double.parse(weightGoalController.selectedPopUpValue),
                    weightGoalController.selectedPopUpUnit,
                    callApi);
                weightDetailsController
                    .update(["WeightGoalInputDetails", "WeightGoalDetails"]);
              }
              Navigator.pop(Get.context!);
            },
            child: mainButton("Done"),
          )
        ],
      ),
    );
  }

  buildUnitsForPopup(
      String type, WeightDetailsController weightDetailsController) {
    return SizedBox(
      height: 30.h,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: const Color(0xffFCAFAF),
        ),
        child: GetBuilder<WeightGoalController>(
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
                    controller.convertWeight(
                        previousUnit, controller.popUpUnitList[index]);
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
                        return showModalPopup(
                            type, weightDetailsController, controller);
                      },
                    );
                  },
                  child: Container(
                    width: 50.w,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: controller.selectedPopUpUnit.toUpperCase() ==
                              controller.popUpUnitList[index].toUpperCase()
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
                          color: controller.selectedPopUpUnit.toUpperCase() ==
                                  controller.popUpUnitList[index].toUpperCase()
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
}
