import 'package:aayu/view/new_deeplinks/widgets/view_more_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/deeplinks/deeplink.disease.details.model.dart';
import '../../../model/healing/disease.details.requset.model.dart';
import '../../healing/disease_details/widgets/testimonial/testimonial.dart';
import '../../shared/network_image.dart';

class DiseaseBenefits extends StatelessWidget {
  final DeeplinkDiseaseDetailModel deeplinkDiseaseDetailModel;
  const DiseaseBenefits({Key? key, required this.deeplinkDiseaseDetailModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (var element in deeplinkDiseaseDetailModel.benefits!) {
      children.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ShowNetworkImage(
                imgPath: element!.icon!,
                imgHeight: 22.h,
                imgWidth: 22.h,
                boxFit: BoxFit.cover,
              ),
              SizedBox(
                width: 25.w,
              ),
              Expanded(
                child: Text(
                  element.text!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromRGBO(91, 112, 129, 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 80.h),
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 26.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(32.w),
              bottomLeft: Radius.circular(32.w)),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
