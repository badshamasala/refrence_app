import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/shared/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultDetails extends StatelessWidget {
  final String consultType;
  final String profilePic;
  final String consultName;
  final String speciality;
  final String speaks;
  final double? rating;
  final String desc;

  const ConsultDetails(
      {Key? key,
      required this.consultType,
      required this.profilePic,
      required this.consultName,
      required this.speciality,
      required this.speaks,
      required this.rating,
      required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          speciality,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFFA0ADB6).withOpacity(0.8),
            fontFamily: 'Circular Std',
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.5.h,
          ),
        ),
        Text(
          "Speaks : ${speaks.isNotEmpty ? speaks : ""}",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFFA0ADB6).withOpacity(0.8),
            fontFamily: 'Circular Std',
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.5.h,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "${rating ?? ""}",
              style: TextStyle(
                color: AppColors.secondaryLabelColor,
                fontFamily: 'Circular Std',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.5.h,
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            const Icon(
              Icons.star,
              color: AppColors.primaryColor,
              size: 14,
            ),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        Text(
          desc,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondaryLabelColor.withOpacity(0.8),
            fontFamily: 'Circular Std',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.ellipsis,
            height: 1.5.h,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Wrap(
                  children: [
                    Container(
                      padding: pagePadding(),
                      decoration: const BoxDecoration(
                        color: AppColors.pageBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: KnowMoreAboutConsult(
                        consultType: consultType,
                        profilePic: profilePic,
                        consultName: consultName,
                        speciality: speciality,
                        desc: desc,
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Text(
            "Know More",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLabelColor.withOpacity(0.8),
              fontFamily: 'Circular Std',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              height: 1.5.h,
            ),
          ),
        ),
      ],
    );
  }
}

class KnowMoreAboutConsult extends StatelessWidget {
  final String consultType;
  final String profilePic;
  final String consultName;
  final String speciality;
  final String desc;

  const KnowMoreAboutConsult(
      {Key? key,
      required this.consultType,
      required this.profilePic,
      required this.consultName,
      required this.speciality,
      required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              circularConsultImage(consultType, profilePic, 83, 83),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10.w, top: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultName,
                        maxLines: 1,
                        style: selectedTabTextStyle(),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          speciality,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color.fromRGBO(
                                91, 112, 129, 0.800000011920929),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            height: 1.h,
                            fontFamily: "Circular Std",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            desc,
            style: TextStyle(
              color: AppColors.secondaryLabelColor,
              fontFamily: 'Circular Std',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.2.h,
            ),
          )
        ]);
  }
}
