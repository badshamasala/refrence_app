import 'package:aayu/controller/you/help_and_support_controller.dart';
import 'package:aayu/services/profile.service.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HelpAndSupportController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HELP_SUPPORT'.tr,
              style: AppTheme.secondarySmallFontTitleTextStyle,
            ),
            SizedBox(
              height: 7.h,
            ),
            Text(
              "GOT_SOMETHING_TO_TELL_US_TXT".tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: const Color(0xFF7F8785),
                fontFamily: 'Circular Std',
                fontSize: 16.sp,
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 38.h,
            ),
            const Expanded(child: ConcernContent()),
          ],
        ),
      ),
    );
  }
}

class ConcernContent extends StatelessWidget {
  const ConcernContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpAndSupportController>(
        id: "Concern",
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select the category',
                        style: TextStyle(
                            color: AppColors.blueGreyAssessmentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(
                            controller.listCategories.length,
                            (index) => InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    controller.concernCatergoryTextController
                                            .text =
                                        controller.listCategories[index];
                                    controller.update(["Concern", true]);

                                    controller.concernIssueTextController.text =
                                        '';
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 10.h, bottom: 14.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: controller
                                                  .concernCatergoryTextController
                                                  .text ==
                                              controller.listCategories[index]
                                          ? const Color(0xFFAAFDB4)
                                          : const Color(0xFFF8FAFC),
                                    ),
                                    child: Text(
                                      controller.listCategories[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          fontFamily: 'Circular Std',
                                          color: AppColors
                                              .blueGreyAssessmentColor),
                                    ),
                                  ),
                                )),
                      ),
                      if (controller
                          .concernCatergoryTextController.text.isNotEmpty)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller
                                    .concernCatergoryTextController.text !=
                                'Others')
                              SizedBox(
                                height: 26.h,
                              ),
                            if (controller
                                    .concernCatergoryTextController.text !=
                                'Others')
                              InkWell(
                                onTap: () {
                                  showBottomSheet(
                                      context,
                                      controller,
                                      'Select the issue',
                                      controller.concernIssueTextController,
                                      controller.listIssuesFromCategories[
                                              controller
                                                  .concernCatergoryTextController
                                                  .text
                                                  .trim()] ??
                                          [],
                                      null);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 15.w, top: 5.h, bottom: 5.h),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFF4F4F4),
                                        width: 1),
                                    color: AppColors.whiteColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(125, 130, 138, 0.08),
                                        offset: Offset(0, 10),
                                        blurRadius: 20,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            readOnly: true,
                                            enabled: false,
                                            maxLines: null,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: controller
                                                .concernIssueTextController,
                                            style: AppTheme
                                                .inputEditProfileTextStyle,
                                            decoration: const InputDecoration(
                                              hintStyle: AppTheme.hintTextStyle,
                                              errorStyle:
                                                  AppTheme.errorTextStyle,
                                              hintText: 'Select the issue',
                                              labelText: 'Select the issue',
                                              labelStyle:
                                                  AppTheme.hintTextStyle,
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(16),
                                                  bottomRight:
                                                      Radius.circular(16),
                                                ),
                                              ),
                                              isDense: true,
                                              filled: true,
                                              fillColor: AppColors.whiteColor,
                                              focusColor: AppColors.whiteColor,
                                              hoverColor: AppColors.whiteColor,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_drop_down_rounded,
                                          size: 40,
                                          color: Color(0xFF9C9EB9),
                                        ),
                                        SizedBox(
                                          width: 17.w,
                                        ),
                                      ]),
                                ),
                              ),
                            SizedBox(
                              height: 26.h,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color.fromRGBO(247, 247, 247, 0.7),
                              ),
                              child: TextField(
                                controller:
                                    controller.concernDescriptionController,
                                maxLength: 500,
                                maxLines: null,
                                onSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                                onChanged: (vslue) {
                                  controller.update(["Concern", true]);
                                  //Added for enable disable button
                                },
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: const Color(0xFF5B7081)),
                                decoration: InputDecoration(
                                  counterStyle: TextStyle(
                                    color: const Color.fromRGBO(
                                        143, 157, 168, 0.5),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  hintMaxLines: null,
                                  hintStyle: TextStyle(
                                      color: const Color.fromRGBO(
                                          140, 140, 140, 0.4),
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Baskerville'),
                                  hintText:
                                      '\n\n\n           Type here to describe...\n\n',
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(247, 247, 247, 0),
                                  focusColor:
                                      const Color.fromRGBO(247, 247, 247, 0),
                                  hoverColor:
                                      const Color.fromRGBO(247, 247, 247, 0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                          ],
                        ),
                      (controller.concernCatergoryTextController.text.isEmpty)
                          ? SizedBox(
                              height: 316.h,
                            )
                          : InkWell(
                              onTap: (controller.concernCatergoryTextController
                                          .text.isNotEmpty &&
                                      (controller.concernCatergoryTextController
                                                  .text ==
                                              'Others' ||
                                          controller.concernIssueTextController
                                              .text.isNotEmpty) &&
                                      controller
                                          .concernDescriptionController.text
                                          .trim()
                                          .isNotEmpty)
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      buildShowDialog(context);
                                      bool? isSubmitted = await ProfileService()
                                          .postHelpSupport(
                                              globalUserIdDetails?.userId ?? "",
                                              "Feedback",
                                              controller
                                                  .concernCatergoryTextController
                                                  .text,
                                              controller
                                                  .concernIssueTextController
                                                  .text,
                                              controller
                                                  .concernDescriptionController
                                                  .text);
                                      Navigator.pop(context);

                                      if (isSubmitted == true) {
                                        controller
                                            .concernCatergoryTextController
                                            .text = "";
                                        controller.concernIssueTextController
                                            .text = "";
                                        controller.concernDescriptionController
                                            .text = "";
                                        controller.update(["Concern", true]);
                                        showCustomSnackBar(
                                            context, "RESPONSE_TIME".tr);
                                      } else {
                                        showCustomSnackBar(context,
                                            "FAILED_TO_SUBMIT_YOUR_REQUEST".tr);
                                      }
                                    }
                                  : null,
                              child: (controller.concernCatergoryTextController
                                          .text.isNotEmpty &&
                                      (controller.concernCatergoryTextController
                                                  .text ==
                                              'Others' ||
                                          controller.concernIssueTextController
                                              .text.isNotEmpty) &&
                                      controller
                                          .concernDescriptionController.text
                                          .trim()
                                          .isNotEmpty)
                                  ? mainButton('SUBMIT'.tr)
                                  : disabledButton('SUBMIT'.tr),
                            ),
                      SizedBox(
                        height: 14.h,
                      ),
                      if ((controller
                              .concernCatergoryTextController.text.isNotEmpty &&
                          (controller.concernCatergoryTextController.text ==
                                  'Others' ||
                              controller.concernIssueTextController.text
                                  .isNotEmpty) &&
                          controller.concernDescriptionController.text
                              .trim()
                              .isNotEmpty))
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (appProperties.whatsApp != null &&
                                appProperties.whatsApp!.enabled != null &&
                                appProperties.whatsApp!.enabled == true &&
                                appProperties.whatsApp!.number != null &&
                                appProperties.whatsApp!.number!.isNotEmpty)
                              Expanded(
                                  child: ElevatedButton(
                                onPressed: () {
                                  controller.sendWhatsappText(
                                      appProperties.whatsApp?.number ?? "");
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFF00D95F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.h),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 53.h,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        AppIcons.whatsappIconSVG,
                                        height: 40.h,
                                      ),
                                      Text(
                                        'Chat with us',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14.sp),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                            if (appProperties.whatsApp != null &&
                                appProperties.whatsApp!.enabled != null &&
                                appProperties.whatsApp!.enabled == true &&
                                appProperties.whatsApp!.number != null &&
                                appProperties.whatsApp!.number!.isNotEmpty)
                              SizedBox(
                                width: 10.w,
                              ),
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                buildShowDialog(context);
                                bool? isSubmitted = await ProfileService()
                                    .postHelpSupport(
                                        globalUserIdDetails?.userId ?? "",
                                        "Concern",
                                        controller
                                            .concernCatergoryTextController
                                            .text,
                                        controller
                                            .concernIssueTextController.text,
                                        controller
                                            .concernDescriptionController.text);
                                Navigator.pop(context);

                                if (isSubmitted == true) {
                                  controller
                                      .concernCatergoryTextController.text = "";
                                  controller.concernIssueTextController.text =
                                      "";
                                  controller.concernDescriptionController.text =
                                      "";
                                  controller.update(["Concern", true]);
                                  showCustomSnackBar(
                                      context, "RESPONSE_TIME".tr);
                                } else {
                                  showCustomSnackBar(context,
                                      "FAILED_TO_SUBMIT_YOUR_REQUEST".tr);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.h))),
                              child: SizedBox(
                                height: 53.h,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 30.h,
                                    ),
                                    SizedBox(
                                      width: 8.5.h,
                                    ),
                                    Text(
                                      'Request a Call',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp),
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  showBottomSheet(
    BuildContext context,
    HelpAndSupportController controller,
    String title,
    TextEditingController textEditingController,
    List<String> list,
    TextEditingController? issueTextEditingController,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 37.h,
            ),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF344553),
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: "Circular Std",
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    textEditingController.text = list[index];
                    controller.update(["Concern", true]);
                    if (issueTextEditingController != null) {
                      issueTextEditingController.text = '';
                    }
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    title: Text(
                      list[index],
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          fontFamily: 'Circular Std',
                          color: const Color(0xFF5B7081)),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
