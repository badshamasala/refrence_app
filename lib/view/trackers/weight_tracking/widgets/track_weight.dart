import 'package:aayu/controller/daily_records/weight_tracker/weight_tracker_controller.dart';
import 'package:aayu/controller/daily_records/weight_tracker/weight_details_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrackWeight extends StatelessWidget {
  const TrackWeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeightDetailsController weightDetailsController = Get.find();
    WeightTrackerController weightTrackerController =
        Get.put(WeightTrackerController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Weight",
          style: TextStyle(
            color: const Color(0xFFFF8B8B),
            fontSize: 32.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "BaskerVille",
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(
          "Set Goals. Track Weight",
          style: TextStyle(
            color: const Color(0xFF768897),
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 26.h,
        ),
        Container(
          padding: pagePadding(),
          margin: pageHorizontalPadding(),
          width: 322.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19.w),
            color: const Color(0xffF7F7F7),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Log Weight",
                style: TextStyle(
                  color: const Color(0xFFF39D9D),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              buildCheckInDateSelection(),
              SizedBox(
                height: 26.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GetBuilder<WeightDetailsController>(
                    id: "WeightInputDetails",
                    builder: (controller) {
                      return Text(
                        "${controller.weightOfDate.toStringAsFixed(1)} ${toTitleCase(controller.defaultWeightUnit.toLowerCase())}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF768897),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      weightTrackerController.setFixedExtentScrollController(
                          weightDetailsController.defaultWeightUnit,
                          weightDetailsController.weightOfDate.toString());
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
                          return showModalPopup("WEIGHT",
                              weightDetailsController, weightTrackerController);
                        },
                      );
                    },
                    child: SizedBox(
                      width: 60.w,
                      height: 30.h,
                      child: mainButton("Add"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildCheckInDateSelection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFFBEBA)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: GetBuilder<WeightDetailsController>(
          id: "WeightCheckInDate",
          builder: (controller) {
            int daysDifference =
                controller.checkInDate.difference(DateTime.now()).inDays;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (daysDifference > -3)
                      ? () {
                          controller.setCheckInDate("BACK");
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: (daysDifference > -3)
                          ? const Color(0xffFF8B8B)
                          : const Color(0xFF768897),
                      size: 24,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_month,
                  color: Color(0xFFFFBEBA),
                  size: 20,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  //DateFormat('dd MMM').format(controller.checkInDate),
                  formatSelectedDate(controller.checkInDate),
                  style: TextStyle(
                    color: const Color(0xFF768897),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: (daysDifference < 0)
                      ? () {
                          controller.setCheckInDate("NEXT");
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: (daysDifference < 0)
                          ? const Color(0xffFF8B8B)
                          : const Color(0xFF768897),
                      size: 24,
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  formatSelectedDate(DateTime date) {
    String tempDate = DateFormat('dd MMM').format(date);
    if (tempDate == DateFormat('dd MMM').format(DateTime.now())) {
      return "Today";
    } else if (tempDate ==
        DateFormat('dd MMM')
            .format(DateTime.now().subtract(const Duration(days: 1)))) {
      return "Yesterday";
    }
    return tempDate;
  }

  showModalPopup(String type, WeightDetailsController weightDetailsController,
      WeightTrackerController weightTrackerController) {
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
            child: GetBuilder<WeightTrackerController>(
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
              if (weightTrackerController.selectedPopUpValue.isNotEmpty) {
                weightDetailsController.defaultWeightUnit =
                    weightTrackerController.selectedPopUpUnit;
                weightDetailsController.addUpdateWeight(
                    double.parse(weightTrackerController.selectedPopUpValue),
                    weightTrackerController.selectedPopUpUnit);
                weightDetailsController.update(["WeightInputDetails"]);
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
        child: GetBuilder<WeightTrackerController>(
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
