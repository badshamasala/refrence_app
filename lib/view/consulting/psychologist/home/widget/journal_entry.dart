// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class JournalEntry extends StatefulWidget {
  const JournalEntry({Key? key}) : super(key: key);

  @override
  State<JournalEntry> createState() => _JournalEntryState();
}

class _JournalEntryState extends State<JournalEntry> {
  late PsychologyController psychologyController;
  TextEditingController journalAnswerTextController = TextEditingController();

  @override
  initState() {
    if (PsychologyController().initialized == false) {
      psychologyController = Get.put(PsychologyController());
    } else {
      psychologyController = Get.find();
    }
    psychologyController.getRandomJournal();
    super.initState();
  }

  @override
  void dispose() {
    journalAnswerTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 95.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  Images.planSummaryBGImage,
                ),
              ),
            ),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              title: Text(
                "Your Journal Entry",
                style: appBarTextStyle(),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 20.w,
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackLabelColor,
                ),
              ),
            ),
          ),
          Expanded(
              child: GetBuilder<PsychologyController>(
                  id: "JournalEntry",
                  builder: (controller) {
                    if (controller.isLoading.value == true) {
                      return showLoading();
                    } else if (controller.randomJournal == null) {
                      return const Offstage();
                    } else if (controller.randomJournal!.journal == null) {
                      return const Offstage();
                    }
                    return Padding(
                      padding: pageVerticalPadding(),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            padding: pagePadding(),
                            margin: EdgeInsets.only(top: 67.h),
                            width: 322.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F3F7).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16.sp),
                            ),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.zero,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 60.h,
                                  ),
                                  Text(
                                    controller
                                            .randomJournal!.journal!.journal ??
                                        "",
                                    style: TextStyle(
                                      color: const Color(0xFF768897),
                                      fontFamily: 'Circular Std',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2.h,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 13.h,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      buildShowDialog(context);
                                      await controller.getRandomJournal();
                                      Navigator.pop(context);
                                      setState(() {
                                        journalAnswerTextController.text = "";
                                      });
                                    },
                                    child: Text(
                                      "I don’t want to answer this question",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontFamily: 'Circular Std',
                                        decoration: TextDecoration.underline,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 13.h,
                                  ),
                                  TextField(
                                    maxLines: 12,
                                    textInputAction: TextInputAction.done,
                                    controller: journalAnswerTextController,
                                    style: AppTheme.inputEditProfileTextStyle,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        color: const Color(0xFFE0E7EE),
                                        fontSize: 12.sp,
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Circular Std",
                                      ),
                                      errorStyle: AppTheme.errorTextStyle,
                                      hintText:
                                          'This space is for your eyes only. Fill it up, without fear of judgement. ',
                                      labelStyle: AppTheme.hintTextStyle,
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                      ),
                                      isDense: true,
                                      filled: true,
                                      fillColor: AppColors.whiteColor,
                                      focusColor: AppColors.whiteColor,
                                      hoverColor: AppColors.whiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 26.h,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (journalAnswerTextController.text
                                          .trim()
                                          .isEmpty) {
                                        showCustomSnackBar(context,
                                            "Please provide your answer!");
                                      } else {
                                        buildShowDialog(context);
                                        bool isSubmitted = await controller
                                            .submitJournalAnswer(
                                                journalAnswerTextController.text
                                                    .trim());
                                        Navigator.pop(context);
                                        if (isSubmitted == true) {
                                          Navigator.pop(context);
                                        } else {
                                          showCustomSnackBar(context,
                                              "Failed to submit answer. Please try again!");
                                        }
                                      }
                                    },
                                    child: mainButton("Check In"),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            Images.journalImage,
                            width: 114.w,
                            height: 123.h,
                          ),
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
