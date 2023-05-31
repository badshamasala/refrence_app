import 'package:aayu/controller/healing/healing_list_controller.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/healing/healing.list.response.model.dart';
import '../../../theme/app_colors.dart';
import '../../healing/disease_details/disease_details.dart';

class ThankYourDiseaseCard extends StatelessWidget {
  final HealingListResponseDiseases disease;
  final HealingListController healingListController;
  const ThankYourDiseaseCard(
      {Key? key, required this.disease, required this.healingListController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await healingListController.setDiseaseFromDeepLink(disease.diseaseId!);
        Get.close(1);
        Get.to(
          const DiseaseDetails(fromThankYou: false),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                blurRadius: 28,
                offset: Offset(0, 2),
                color: Color.fromRGBO(0, 0, 0, 0.06),
              )
            ]),
        width: 104.h,
        padding:
            EdgeInsets.only(top: 22.h, bottom: 12.h, left: 9.2.w, right: 9.2.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 67.h,
                    width: 86.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF9F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    top: -13.h,
                    child: ShowNetworkImage(
                      imgPath: disease.image!.imageUrl ?? "",
                      imgHeight: 64.h,
                      boxFit: BoxFit.fitHeight,
                    ),
                  ),
                ]),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                disease.disease ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.blueGreyAssessmentColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
