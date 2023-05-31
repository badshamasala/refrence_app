import 'package:aayu/view/new_deeplinks/widgets/free_doctor_consult_floating_widget.dart';
import 'package:aayu/view/new_deeplinks/widgets/view_more_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/deeplinks/deeplink.disease.details.model.dart';
import '../../../model/healing/disease.details.requset.model.dart';
import '../../../theme/app_colors.dart';
import '../../healing/disease_details/widgets/testimonial/testimonial.dart';
import '../../shared/network_image.dart';

class AboutDisease extends StatelessWidget {
  final DeeplinkDiseaseDetailModel deeplinkDiseaseDetailModel;
  final Function freeDoctorConsultFunction;

  const AboutDisease(
      {Key? key,
      required this.deeplinkDiseaseDetailModel,
      required this.freeDoctorConsultFunction})
      : super(key: key);

  Widget contentWidget(String type, String data) {
    switch (type) {
      case "text":
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Text(
            data,
            style: TextStyle(
                color: AppColors.secondaryLabelColor.withOpacity(0.8),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
          ),
        );
      case "bold_text":
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Text(
            data,
            style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700),
          ),
        );
      case "image":
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: ShowNetworkImage(
              imgPath: data,
              imgWidth: double.infinity,
              imgHeight: 300,
              boxFit: BoxFit.contain,
            ));

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (var element in deeplinkDiseaseDetailModel.about!) {
      children.add(contentWidget(element!.type!, element.data!));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FC),
      floatingActionButton: FreeDoctorConsultFloating(
        freeDoctorConsultFunction: freeDoctorConsultFunction,
        key: FreeDoctorConsultFloating.globalKey,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            FreeDoctorConsultFloating.globalKey.currentState!.start();

            print("Scroll start");
          } else if (scrollNotification is ScrollUpdateNotification) {
          } else if (scrollNotification is ScrollEndNotification) {
            FreeDoctorConsultFloating.globalKey.currentState!.end();

            print('Scroll end');
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ViewMoreCard(children: children),
              Testimonial(
                  diseaseIds: DiseaseDetailsRequest(disease: [
                DiseaseDetailsRequestDisease(
                    diseaseId: 'a721f7a0-c20c-11ec-8195-fb3d9a5f7244')
              ])),
              SizedBox(
                height: 120.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
