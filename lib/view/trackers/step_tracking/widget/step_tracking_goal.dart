import 'package:aayu/controller/daily_records/weight_tracker/weight_goal_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/services/tracker.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:aayu/controller/daily_records/step_tracker/step_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StepGoal extends StatelessWidget {
  final bool callApi;
  final bool showToggle;
  const StepGoal({Key? key, required this.callApi, required this.showToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StepGoalController stepGoalController = Get.put(StepGoalController());
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
                "SET GOAL",
                style: TextStyle(
                  color: const Color(0xffFF8B8B),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          GetBuilder<StepGoalController>(
              id: "StepGoalInputDetails",
              builder: (controller) {
                // if (controller.enableWeightGoal == false) {
                //   return const Offstage();
                // }
                return Padding(
                  padding: pageHorizontalPadding(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.targetStep}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF768897),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      InkWell(
                        onTap: () {
                          stepGoalController.setFixedExtentScrollController(
                              stepGoalController.targetStep.toString());
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
                                 stepGoalController);
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

  showModalPopup(StepGoalController stepGoalController) {
    return Container(
      padding: pagePadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Set Goal",
            style: TextStyle(
                color: AppColors.blackLabelColor,
                fontSize: 24.sp,
                fontFamily: "BaskerVille"),
          ),
          SizedBox(
            height: 26.h,
          ),
          Expanded(
            child: GetBuilder<StepGoalController>(
                id: "ModalPopupScrollValues",
                builder: (controller) {
                  return Stack(
                    alignment: Alignment.center,
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
                                controller.fixedExtentScrollControllerFirst
                                    .selectedItem);
                          },
                        ),
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
              if (stepGoalController.selectedPopUpValue.isNotEmpty) {
                stepGoalController.setStepGoal(
                    int.parse(stepGoalController.selectedPopUpValue), callApi);
                stepGoalController
                    .update(["StepGoalInputDetails"]);
              }
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
        style: TextStyle(
          fontSize: 18.sp,
          color: Color(0xFF768897),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
