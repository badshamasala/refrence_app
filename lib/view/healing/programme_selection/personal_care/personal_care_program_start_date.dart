// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/healing/post_assessment_controller.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../../../../services/services.dart';
import '../post_program_loading.dart';

class PersonalCareProgramStartDate extends StatelessWidget {
  final PageController pageController;
  final bool startProgram;
  const PersonalCareProgramStartDate({
    Key? key,
    required this.pageController,
    required this.startProgram
  }) : super(key: key);
  format(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("d'$suffix' MMM, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    PostAssessmentController postAssessmentController = Get.find();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.pageBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.w),
          topRight: Radius.circular(30.w),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 26.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: personalCareDurationHeader(
                context, "Personalised Care Program", showBackButton: true,
                onBackPressed: () {
              pageController.previousPage(
                  duration:
                      Duration(milliseconds: defaultAnimateToPageDuration),
                  curve: Curves.easeOut);
            }),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: Text(
              "When do you wish to start?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackLabelColor,
                fontFamily: 'Baskerville',
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                height: 1.h,
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.h),
            child: Text(
              "Choose the date you want to start your program on. Do remember, your subscription ends on ${format(returnDate(subscriptionCheckResponse!.subscriptionDetails!.expiryDate ?? ""))}. Any early start will help you see maximum health benefits.",
              textAlign: TextAlign.center,
              style: primaryFontSecondaryLabelSmallTextStyle(),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ),
            width: 322.w,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.w),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(125, 130, 138, 0.08),
                  offset: Offset(0, 10),
                  blurRadius: 20,
                )
              ],
            ),
            child: DateTimeField(
              format: DateFormat("dd MMMM yyyy"),
              readOnly: true,
              decoration: InputDecoration(
                errorStyle:
                    const TextStyle(fontSize: 14.0, color: Colors.redAccent),
                fillColor: AppColors.whiteColor,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                hintText: "",
                hintStyle: AppTheme.hintTextStyle,
                prefixStyle: AppTheme.hintTextStyle,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                ),
              ),
              controller: postAssessmentController.programStartDateController,
              onChanged: (dt) {
                if (dt != null) {
                  postAssessmentController.updateProgramStartDate(dt);
                }
              },
              style: AppTheme.inputTextStyle,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  currentDate: postAssessmentController.programStartDate,
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 7)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          background: AppColors.whiteColor,
                          primary:
                              AppColors.primaryColor, // header background color
                          onPrimary: AppColors.blackColor, // header text color
                          onSurface: AppColors.blackColor, // body text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            primary: AppColors.blackColor, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
              },
            ),
          ),
          InkWell(
            onTap: () async {
              if (startProgram == true) {
                buildShowDialog(context);
                SubscriptionController subscriptionController = Get.find();
                bool isUpdated =
                    await subscriptionController.startRecommendedProgram();
                Navigator.pop(context);
                if (isUpdated == true) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgramPostLoading(),
                    ),
                  );
                }
              } else {
                buildShowDialog(context);
                SubscriptionCheckResponse? response =
                    await SubscriptionService().updateStartDate(
                        globalUserIdDetails!.userId!,
                        subscriptionCheckResponse!
                            .subscriptionDetails!.subscriptionId!,
                        postAssessmentController.programStartDate.toString());

                Navigator.pop(context);
                if (response != null) {
                  subscriptionCheckResponse = response;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgramPostLoading(),
                    ),
                  );
                }
              }
            },
            child: SizedBox(
              width: 302.w,
              child: mainButton("Submit"),
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
        ],
      ),
    );
  }
}
