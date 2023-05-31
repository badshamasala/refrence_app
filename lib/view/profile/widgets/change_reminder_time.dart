import 'package:aayu/controller/you/reminders_controller.dart';
import 'package:aayu/model/you/reminders.model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangeReminderTime extends StatefulWidget {
  final RemindersModelData data;

  const ChangeReminderTime({Key? key, required this.data}) : super(key: key);

  @override
  State<ChangeReminderTime> createState() => _ChangeReminderTimeState();
}

class _ChangeReminderTimeState extends State<ChangeReminderTime> {
  DateTime? time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                topLeft: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<RemindersController>(
                  builder: (controller) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 67.h,
                        ),
                        Text(
                          widget.data.title == 'Mood_Tracker'.tr
                              ? 'TRACK_MOOD'.tr
                              : 'TRACK_YOUR_SLEEP'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Baskerville',
                              color: AppColors.blackLabelColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 200.h,
                          child: NewCupertinoDatePicker(
                            textColor: AppColors.blackLabelColor,
                            initialDateTime: DateTime.now(),
                            mode: NewCupertinoDatePickerMode.time,
                            minuteInterval: 1,
                            overlayColor: widget.data.title == 'Mood Tracker'
                                ? AppColors.primaryColor.withOpacity(0.2)
                                : const Color.fromRGBO(148, 140, 239, 0.2),
                            onDateTimeChanged: (dateTime) {
                              time = dateTime;
                              // controller.changeTime(dateTime, widget.data);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        InkWell(
                          child: Container(
                            height: 54.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: widget.data.title ==
                                      'Mood_Tracker'.toUpperCase()
                                  ? AppColors.primaryColor
                                  : const Color.fromRGBO(148, 140, 239, 1),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.07000000029802322),
                                    offset: Offset(-5, 10),
                                    blurRadius: 20),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'SAVE'.tr,
                                textAlign: TextAlign.center,
                                style: mainButtonTextStyle(),
                              ),
                            ),
                          ),
                          onTap: () {
                            controller.changeTime(time!, widget.data);

                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
            top: -46.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  widget.data.image!,
                  height: 77.h,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 11.h,
                ),
                Image.asset(
                  Images.ellipseImage,
                  height: 9.h,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ]);
  }
}
