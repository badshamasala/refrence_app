import 'package:aayu/controller/consultant/psychologist/psychology_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/psychologist/home/widget/journal_entry.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class JournalEntries extends StatelessWidget {
  const JournalEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PsychologyController psychologyController;
    if (PsychologyController().initialized == false) {
      psychologyController = Get.put(PsychologyController());
    } else {
      psychologyController = Get.find();
    }
    Future.delayed(Duration.zero, () {
      psychologyController.getJournalEntries();
    });
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
                id: "JournalEntries",
                builder: (controller) {
                  if (controller.isLoading.value == true) {
                    return showLoading();
                  } else if (controller.journalEntries == null) {
                    return const Offstage();
                  } else if (controller.journalEntries!.journalLogs == null) {
                    return const Offstage();
                  } else if (controller.journalEntries!.journalLogs!.isEmpty) {
                    return const Offstage();
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.journalEntries!.journalLogs!.length,
                    itemBuilder: (context, index) {
                      DateTime answeredOn = dateFromTimestamp(
                        controller
                            .journalEntries!.journalLogs![index]!.answeredOn!,
                      );
                      return InkWell(
                        onTap: () {
                          showJorunalDetails(
                              context,
                              answeredOn,
                              controller.journalEntries!.journalLogs![index]!
                                      .journal ??
                                  "",
                              controller.journalEntries!.journalLogs![index]!
                                      .answer ??
                                  "");
                        },
                        child: Container(
                          padding: pageHorizontalPadding(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat('dd MMMM, yyyy,')
                                        .format(answeredOn),
                                    style: TextStyle(
                                      color: const Color(0xFF768897),
                                      fontFamily: 'Circular Std',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Text(
                                    DateFormat('hh: mm a').format(answeredOn),
                                    style: TextStyle(
                                      color: const Color(0xFF768897),
                                      fontFamily: 'Circular Std',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                controller.journalEntries!.journalLogs![index]!
                                        .journal ??
                                    "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF768897),
                                  fontFamily: 'Circular Std',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2.h,
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                controller.journalEntries!.journalLogs![index]!
                                        .answer ??
                                    "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFFD9D9D9),
                                  fontFamily: 'Circular Std',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2.h,
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: const Color(0xFFD9D9D9).withOpacity(0.5),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const JournalEntry(),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 4.h,
                  )
                ],
              ),
            ),
            const Icon(
              Icons.add,
              size: 30,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  showJorunalDetails(BuildContext context, answeredOn, journal, answer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: pagePadding(),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height / 3,
            maxHeight: MediaQuery.of(context).size.height / 2,
          ),
          decoration: const BoxDecoration(
            color: AppColors.pageBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd MMMM, yyyy,').format(answeredOn),
                    style: TextStyle(
                      color: const Color(0xFF768897),
                      fontFamily: 'Circular Std',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(
                    DateFormat('hh: mm a').format(answeredOn),
                    style: TextStyle(
                      color: const Color(0xFF768897),
                      fontFamily: 'Circular Std',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                journal,
                style: TextStyle(
                  color: const Color(0xFF768897),
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.2.h,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                answer,
                style: TextStyle(
                  color: AppColors.secondaryLabelColor,
                  fontFamily: 'Circular Std',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2.h,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
