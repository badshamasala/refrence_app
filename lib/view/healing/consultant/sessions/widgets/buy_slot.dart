import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BuySlot extends StatelessWidget {
  final String sessionType;
  const BuySlot({Key? key, required this.sessionType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: pageHorizontalPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (sessionType == "Doctor")
                ? Image(
                    image: const AssetImage(Images.doctorConsultant2Image),
                    width: 76.w,
                    height: 96.h,
                    fit: BoxFit.contain,
                  )
                : Image(
                    image: const AssetImage(Images.personalTrainingImageBlue),
                    width: 154.w,
                    height: 108.h,
                    fit: BoxFit.contain,
                  ),
            SizedBox(
              height: 24.h,
            ),
            SizedBox(
              width: 266.w,
              child: Text(
                (sessionType == "Doctor")
                    ? "YOU_DONT_HAVE_ANY_DOCTOR_CONSULTS".tr
                    : "YOU_DONT_HAVE_ANY_YOGA_THERAPY_SESSIONS".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF8C98A5),
                  fontFamily: 'Circular Std',
                  fontSize: 14.sp,
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                  height: 1.4285714285714286.h,
                ),
              ),
            ),
            // SizedBox(
            //   height: 45.h,
            // ),
            // Visibility(
            //   visible: showBuyOption == true,
            //   child: InkWell(
            //     onTap: () async {
            //       buildShowDialog(context);
            //       PostAssessmentController postAssessmentController =
            //           Get.put(PostAssessmentController());
            //       await postAssessmentController.getConsultingPackageDetails();
            //       Navigator.pop(context);
            //       Get.bottomSheet(
            //         (sessionType == "Doctor")
            //             ? const GetDoctorSessions()
            //             : const GetTrainerSessions(),
            //         isScrollControlled: true,
            //         isDismissible: true,
            //         enableDrag: false,
            //       );
            //     },
            //     child: SizedBox(
            //       width: 270.w,
            //       child: mainButton("BUY_SESSIONS".tr),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
