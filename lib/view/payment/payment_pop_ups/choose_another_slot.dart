import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/services/third-party/events.service.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChooseAnotherSlot extends StatelessWidget {
  final bool isDoctor;
  final String doctorId;
  final String consultName;
  final String consultType;
  final String bookType;
  final String orderId;
  const ChooseAnotherSlot(
      {Key? key,
      required this.doctorId,
      required this.consultName,
      required this.consultType,
      required this.bookType,
      required this.orderId,
      required this.isDoctor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Wrap(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40.h),
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
                  children: [
                    SizedBox(
                      height: 68.h,
                    ),
                    Text(
                      'Your payment is done!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontFamily: 'Baskerville',
                        fontSize: 22.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.2727272727272727.h,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      width: 286.w,
                      child: Text(
                        'Hey, the booking took longer than usual. The slot is currently unavailable. Please choose a different slot.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.2727272727272727.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36.h,
                    ),
                    SizedBox(
                      width: 218.w,
                      child: InkWell(
                        onTap: () {
                          EventsService().sendEvent(
                              "Single_Doctor_Payment_Another_Slot_Now", {
                            "doctor_id": doctorId,
                            "consult_name": consultName,
                            "consult_type": consultType,
                            "book_type": bookType,
                            "order_id": orderId
                          });
                          Navigator.pop(context);
                          if (isDoctor) {
                            Navigator.pop(context);
                          }
                        },
                        child: mainButton("Choose Another Slot"),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (isDoctor) {
                          EventsService().sendEvent(
                              "Single_Doctor_Payment_Another_Slot_DoItLater", {
                            "doctor_id": doctorId,
                            "consult_name": consultName,
                            "consult_type": consultType,
                            "book_type": bookType,
                            "order_id": orderId
                          });
                        } else {
                          EventsService().sendEvent(
                              "Single_Therapist_Payment_Another_Slot_DoItLater",
                              {
                                "trainer_id": doctorId,
                                "consult_name": consultName,
                                "consult_type": consultType,
                                "book_type": bookType,
                                "order_id": orderId
                              });
                        }

                        HealingListController healingListController =
                            Get.find();
                        healingListController.resetSelection();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        if (isDoctor) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Do it Later',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryLabelColor,
                          fontSize: 14.sp,
                          letterSpacing: 0,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                          height: 1.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0.w,
                right: 0,
                child: Image(
                  width: 113.33.w,
                  height: 104.h,
                  image: const AssetImage(Images.paymentSuccessImage),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
