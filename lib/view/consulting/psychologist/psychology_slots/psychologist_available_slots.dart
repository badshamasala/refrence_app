import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/healing/consultant/check_slot/widgets/no_slots_available.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/consultant/psychologist/pyschology_list_controller.dart';

class PsychologistAvailableSlots extends StatelessWidget {
  const PsychologistAvailableSlots({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<PsychologyListController>(
            id: "SlotCalender",
            builder: (calenderController) {
              return DatePicker(
                calenderController.minSelectedDate,
                controller: calenderController.datePickerController,
                height: 77.h,
                width: 50.w,
                initialSelectedDate: calenderController.initialSelectedDate,
                selectionColor: AppColors.primaryColor,
                selectedTextColor: Colors.white,
                daysCount: 10,
                dateTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w700,
                ),
                monthTextStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w400,
                ),
                dayTextStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryLabelColor,
                  fontWeight: FontWeight.w400,
                ),
                onDateChange: (selectedDate) {
                  calenderController.setSelectedDate(selectedDate);
                  calenderController.datePickerController
                      .animateToDate(selectedDate);
                },
              );
            }),
        SizedBox(
          height: 20.h,
        ),
        GetBuilder<PsychologyListController>(
          id: "AvailableSlots",
          builder: (slotController) {
            if (slotController.isSlotDetailsLoading.value == true) {
              return Padding(
                padding: pagePadding(),
                child: showLoading(),
              );
            } else if (slotController.selectedDateSlots.isEmpty) {
              return const NoSlotsAvailable(profession: "Psychologist");
            } else {
              return Column(
                children: [
                  Text(
                    "AVAILABLE_SLOTS".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryLabelColor,
                      fontFamily: 'Circular Std',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.16.h,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 14.w,
                    runSpacing: 14.w,
                    children: List.generate(
                      slotController.selectedDateSlots.length,
                      (slotIndex) {
                        return InkWell(
                          onTap: () {
                            slotController
                                .availableSlotsList.value!.availableSlots!
                                .forEach((element) {
                              element!.selected = false;
                            });
                            slotController
                                    .selectedDateSlots[slotIndex].selected =
                                !slotController
                                    .selectedDateSlots[slotIndex].selected!;
                            slotController.update(
                                ["AvailableSlots", "AvailableSlotAction"]);
                          },
                          child: Container(
                            height: 40.h,
                            width: 98.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32.w),
                              color: slotController.selectedDateSlots[slotIndex]
                                          .selected ==
                                      true
                                  ? AppColors.primaryColor
                                  : AppColors.lightSecondaryColor,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat.jm().format(dateFromTimestamp(
                                    slotController.selectedDateSlots[slotIndex]
                                        .fromTime!)),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: slotController
                                            .selectedDateSlots[slotIndex]
                                            .selected ==
                                        true
                                    ? AppTheme.optionSelectedTextStyle
                                    : AppTheme.optionNonSelectedTextStyle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
