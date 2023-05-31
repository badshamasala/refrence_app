// ignore_for_file: use_build_context_synchronously

import 'package:aayu/controller/home/my_routine_controller.dart';
import 'package:aayu/controller/payment/activationCodeController.dart';
import 'package:aayu/controller/subscription/subscription_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/profile/activation_code/activation_code_applied.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ActivateActivationCode extends StatelessWidget {
  final ActivationCodeVailidateModel activationCodeDetails;
  const ActivateActivationCode({
    Key? key,
    required this.activationCodeDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 19.h),
                  width: double.infinity,
                  child: Text(
                    "Activate Your Plan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontFamily: 'Baskerville',
                      fontSize: 22.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.h,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blackLabelColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 0,
              thickness: 1,
              color: Color(0xFFEBEBEB),
            ),
            Container(
              color: const Color(0xFFF9FBFE),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 26.h,
                  ),
                  Container(
                    width: 240.w,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5).withOpacity(0.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(64, 117, 205, 0.08),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                        activationCodeDetails.activationCode?.activationCode ??
                            "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.h,
                        )),
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text(
                    activationCodeDetails.activationCode?.whatYouGet?.title ??
                        "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(52, 69, 83, 0.5),
                      fontSize: 18.sp,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.h,
                    ),
                  ),
                  ListView.separated(
                    padding: pagePadding(),
                    shrinkWrap: true,
                    itemCount: activationCodeDetails
                            .activationCode?.whatYouGet?.desc?.length ??
                        0,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.5),
                            child: Text(
                              "●",
                              style: TextStyle(
                                color: const Color.fromRGBO(52, 69, 83, 0.5),
                                fontSize: 8.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Expanded(
                            child: Text(
                              activationCodeDetails.activationCode?.whatYouGet!
                                      .desc![index] ??
                                  "",
                              style: TextStyle(
                                color: const Color.fromRGBO(52, 69, 83, 0.5),
                                fontSize: 12.sp,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                                height: 1.h,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8.h,
                      );
                    },
                  ),
                  SizedBox(
                    width: 240.w,
                    child: InkWell(
                      onTap: () async {
                        buildShowDialog(context);
                        ActivationCodeController activationCodeController =
                            Get.find();
                        bool isActivated = await activationCodeController
                            .activateCode(activationCodeDetails
                                    .activationCode?.activationCode ??
                                "");
                        if (isActivated) {
                          MyRoutineController myRoutineController = Get.find();
                          SubscriptionController subscriptionController =
                              Get.find();
                          await Future.wait([
                            myRoutineController.getData(),
                            subscriptionController.checkSubscription()
                          ]);
                          Navigator.pop(context);
                          Navigator.of(Get.context!)
                              .popUntil((route) => route.isFirst);
                          Get.bottomSheet(const ActivationCodeApplied());
                        } else {
                          Navigator.pop(context);
                          showGetSnackBar("Failed to activate code!",
                              SnackBarMessageTypes.Success);
                        }
                      },
                      child: mainButton("Activate"),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  )
                ],
              ),
            )
          ]),
    );
  }
}
