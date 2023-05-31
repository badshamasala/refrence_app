import 'package:aayu/controller/you/reminders_controller.dart';
import 'package:aayu/model/you/reminders.model.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/profile/reminders/mood_reminder.dart';
import 'package:aayu/view/profile/reminders/program_reminder.dart';
import 'package:aayu/view/profile/widgets/change_anxiety_reminder_time.dart';
import 'package:aayu/view/profile/widgets/change_reminder_time.dart';
import 'package:aayu/view/shared/ui_helper/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Reminders extends StatelessWidget {
  const Reminders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RemindersController remindersController = Get.put(RemindersController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REMINDERS'.tr,
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
            SizedBox(
              height: 7.h,
            ),
            const ProgramReminder(),
            /* Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Obx(
                  () {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        remindersController.remindersContent.value.data!.length,
                        (index) => ReminderBlock(
                          data: remindersController
                              .remindersContent.value.data![index]!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

class ReminderBlock extends StatelessWidget {
  final RemindersModelData data;
  const ReminderBlock({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RemindersController>(
      builder: (controller) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 48.h),
            width: double.infinity,
            padding: EdgeInsets.all(18.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  data.title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.blackLabelColor,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Baskerville',
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                InkWell(
                  onTap: () {
                    if (data.time == null || data.time!.isEmpty) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32))),
                        builder: (context) {
                          if (data.title == "Anxiety Care Program") {
                            return const ChangeAnxietyReminderTime();
                          } else {
                            return ChangeReminderTime(data: data);
                          }
                        },
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFEFF1F2), width: 1)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        color:
                                            AppColors.blueGreyAssessmentColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                    children: [
                              TextSpan(
                                text: data.time != null && data.time!.isNotEmpty
                                    ? '${data.activeText} '
                                    : '${data.inactiveText} ',
                              ),
                              if (data.time != null && data.time!.isNotEmpty)
                                TextSpan(
                                  text: data.time,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32),
                                                topRight: Radius.circular(32))),
                                        builder: (context) {
                                          if (data.title ==
                                              "Anxiety Care Program") {
                                            return const ChangeAnxietyReminderTime();
                                          } else {
                                            return ChangeReminderTime(
                                                data: data);
                                          }
                                        },
                                      );
                                    },
                                  style: TextStyle(
                                      color: const Color(0xFF5B6381),
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700),
                                )
                            ]))),
                        SizedBox(
                          width: 11.w,
                        ),
                        CupertinoSwitch(
                            activeColor: Color(
                              int.parse(
                                "0xFF${data.color!.replaceAll("#", "")}",
                              ),
                            ),
                            value: data.active! &&
                                data.time != null &&
                                data.time!.isNotEmpty,
                            onChanged: (val) {
                              if (data.time == null || data.time!.isEmpty) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(32),
                                          topRight: Radius.circular(32))),
                                  builder: (context) {
                                    if (data.title == "Anxiety Care Program") {
                                      return const ChangeAnxietyReminderTime();
                                    } else {
                                      return ChangeReminderTime(data: data);
                                    }
                                  },
                                );
                              }
                              controller.changeSwitch(data);
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 22.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  data.image!,
                  height: 58.h,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 11.h,
                ),
                Image.asset(
                  Images.ellipseImage,
                  height: 7.h,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
