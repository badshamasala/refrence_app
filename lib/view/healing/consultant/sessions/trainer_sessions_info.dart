import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../new_deeplinks/book_freee_doctor.dart';

import '../../../../theme/theme.dart';
import '../../../shared/ui_helper/images.dart';

class TrainerSessionsInfo extends StatelessWidget {
  final Function bookFunction;
  const TrainerSessionsInfo({Key? key, required this.bookFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            floating: true,
            titleSpacing: 0,
            elevation: 0,
            centerTitle: true,
            leading: null,
            flexibleSpace: Stack(
              children: [
                Image(
                  image: const AssetImage(Images.planSummaryBGImage),
                  fit: BoxFit.cover,
                  height: 151.h,
                ),
                Positioned(
                  top: 26.h,
                  left: 10.w,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blackLabelColor,
                    ),
                  ),
                )
              ],
            ),
            expandedHeight: 256.h,
            backgroundColor: AppColors.whiteColor,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size(256.w, 256.h),
              child: Image(
                width: 256.w,
                height: 256.h,
                fit: BoxFit.contain,
                image: const AssetImage(Images.therapistSessionInfoImage),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 26.w, right: 26.w, bottom: 26.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Online Therapists",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackLabelColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Baskerville",
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  SizedBox(
                    width: 320.w,
                    child: Text(
                      "Personalised yoga activity sessions for lifestyle and therapeutic concerns with expert therapists who can provide focused guidance and enhance your practice. Live a disease free life with daily yoga therapy.",
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF3).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24.w),
                    ),
                    width: 322.w,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            "HOW IT WORKS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.blackLabelColor.withOpacity(0.6),
                              fontFamily: 'Circular Std',
                              fontSize: 12.sp,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              height: 1.h,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(24.w),
                              bottomLeft: Radius.circular(24.w),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildPreCall2(
                                  "Book an online session with a highly trained yoga therapist"),
                              buildPreCall2(
                                  "Select from a panel of yoga therapy experts"),
                              buildPreCall2(
                                  "Discuss your fitness and health objectives with our therapist"),
                              buildPreCall2(
                                  "Get personal guidance from an expert yoga therapist from the comfort of your home"),
                              buildPreCall2(
                                  "Perfect your Yoga poses, Meditation techniques, Breathing exercises and reach your health goals"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 26.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.07000000029802322),
                offset: Offset(-5, 10),
                blurRadius: 20,
              )
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              bookFunction();
            },
            style: AppTheme.mainButtonStyle,
            child: const Text(
              "Book Now",
            ),
          ),
        ),
      ),
    );
  }
}
