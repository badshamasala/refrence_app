// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:aayu/controller/consultant/feedback_controller.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LiveEventFeedback extends StatelessWidget {
  final String liveEventId;
  final String liveEventPreview;
  const LiveEventFeedback({
    Key? key,
    required this.liveEventId,
    required this.liveEventPreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FeedbackController feedbackController = Get.put(FeedbackController());

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8.0,
              sigmaY: 8.0,
            ),
            child: ShowNetworkImage(
              imgWidth: MediaQuery.of(context).size.width.w,
              imgHeight: MediaQuery.of(context).size.height.h,
              imgPath: liveEventPreview,
              boxFit: BoxFit.cover,
            ),
          ),
          Container(
            color: AppColors.blackColor.withOpacity(0.75),
            width: MediaQuery.of(context).size.width.w,
            height: MediaQuery.of(context).size.height.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 253.w,
                child: Text(
                  "HOW_WAS_YOUR_EXPERIENCE".tr,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Baskerville',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              GetBuilder<FeedbackController>(builder: (ratingController) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) {
                      return InkWell(
                        onTap: () async {
                          ratingController.updateRating(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 18),
                          child: SvgPicture.asset(
                            (index <= ratingController.rating)
                                ? AppIcons.ratingFilledSVG
                                : AppIcons.ratingUnfilledSVG,
                            width: 40,
                            height: 40,
                            color: const Color(0xFFD78CB5),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(
                height: 26.h,
              ),
              SizedBox(
                width: 320.w,
                child: TextField(
                  controller: feedbackController.textController,
                  maxLength: 500,
                  maxLines: null,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {},
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: const Color(0xFF5B7081),
                  ),
                  decoration: InputDecoration(
                    counterStyle: TextStyle(
                      color: const Color.fromRGBO(143, 157, 168, 0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.whiteColor.withOpacity(0.7),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Baskerville',
                    ),
                    hintText: 'LEAVE_REVIEW_TEXT'.tr,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFFFFFFF).withOpacity(0.6),
                    focusColor: const Color.fromRGBO(247, 247, 247, 0),
                    hoverColor: const Color.fromRGBO(247, 247, 247, 0),
                  ),
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              GetBuilder<FeedbackController>(builder: (buttonController) {
                if (buttonController.rating >= 0) {
                  return InkWell(
                    onTap: () async {
                      await buttonController.postLiveEventFeedBack(liveEventId);
                      showCustomSnackBar(context, "FEEDBACK_TEXT".tr);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: SizedBox(
                      width: 322.w,
                      child: Container(
                        height: 54.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color(0xFFD78CB5),
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
                            "SUBMIT".tr,
                            textAlign: TextAlign.center,
                            style: mainButtonTextStyle(),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: 322.w,
                    child: Container(
                      height: 54.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFD78CB5).withOpacity(0.4),
                        boxShadow: const [
                          BoxShadow(
                              color:
                                  Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                              offset: Offset(-5, 10),
                              blurRadius: 20),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "SUBMIT".tr,
                          textAlign: TextAlign.center,
                          style: mainButtonTextStyle(),
                        ),
                      ),
                    ),
                  );
                }
              }),
              SizedBox(
                height: 16.h,
              ),
              InkWell(
                onTap: () {
                  EventsService().sendEvent("Live_Event_Feedback_Skip", {
                    "live_event_id": liveEventId,
                  });
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  "SKIP".tr,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    fontFamily: "Circular Std",
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
