import 'package:aayu/services/services.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/consulting/nutrition/help_us_with_info.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({Key? key}) : super(key: key);

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
                const Image(
                  image: AssetImage(Images.planSummaryBGImage),
                  fit: BoxFit.cover,
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
            expandedHeight: 180.h,
            backgroundColor: AppColors.whiteColor,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size(180.w, 180.h),
              child: Image(
                width: 180.w,
                height: 180.h,
                fit: BoxFit.contain,
                image: const AssetImage(Images.howItWorksNutritionImage),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Healing Nutrition",
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
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          "Aayu's nutrition program aids in healing by providing essential nutrients, supporting immune function, reducing inflammation, and promoting overall wellness.",
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor.withOpacity(0.8),
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                buildWhatYouGet(),
                SizedBox(
                  height: 26.h,
                ),
                buildHowItWorks(),
                SizedBox(
                  height: 26.h,
                ),
                Text(
                  "“Eating nutritious food is the foundation of a healthy body, mind and soul.”",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryLabelColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
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
            onPressed: () async {
              EventsService().sendClickNextEvent(
                  "HowItWorks", "Get Started", "HelpUsWithInfo");
              Navigator.push(
                navState.currentState!.context,
                MaterialPageRoute(
                  builder: (context) => const HelpUsWithInfo(),
                ),
              );
            },
            style: AppTheme.mainButtonStyle,
            child: const Text(
              "Get Started",
            ),
          ),
        ),
      ),
    );
  }
}

buildWhatYouGet() {
  List whatYouGetList = [
    {
      "icon": "assets/images/nutrition/call1.png",
      "desc": "1:1 Online Consultation with Nutritionist"
    },
    {
      "icon": "assets/images/nutrition/food-plan.png",
      "desc": "Curated Food plan just for you."
    },
    {
      "icon": "assets/images/nutrition/chaticon.png",
      "desc": "Active\nchat support"
    },
    {
      "icon": "assets/images/nutrition/grow.png",
      "desc": "Track\nyour progress"
    },
  ];

  return Column(
    children: [
      Text(
        "WHAT YOU GET",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFFF7979).withOpacity(0.6),
          fontSize: 16.sp,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          height: 1.18.h,
        ),
      ),
      SizedBox(
        height: 30.h,
      ),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.start,
        runSpacing: 36.h,
        spacing: 12.w,
        children: List.generate(whatYouGetList.length, (index){
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 110.h,
                width: 130.w,
                padding: EdgeInsets.only(top: 40.h, left: 12.w, right: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.sp),
                  shape: BoxShape.rectangle,
                  color: const Color(0xffF1F4F8),
                ),
                child: Text(
                  whatYouGetList[index]["desc"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF7B8C99),
                    fontSize: 14.sp,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    height: 1.18.h,
                  ),
                ),
              ),
              Positioned(
                top: -22.h,
                child: Image(
                  image: AssetImage(whatYouGetList[index]["icon"]),
                  width: 40.w,
                  height: 50.h,
                ),
              )
            ],
          );
        }),
      ),
    ],
  );
}

buildHowItWorks() {
  List howItWorksList = [
    "Complete your assessment about food habits, health goals & lifestyle ",
    "Select your\nnutritionist.",
    "Purchase the pack that best suits you",
    "Schedule online video consultation",
    "Get personalised food plan curated by your nutritionist",
    "Track\nyour progress",
  ];
  return Column(
    children: [
      Text(
        "HOW IT WORKS",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xffFF7979),
          fontSize: 16.sp,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          height: 1.18.h,
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Container(
        color: const Color(0xffF7F7F7),
        height: 180.h,
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  width: 15.w,
                ),
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 30.h, bottom: 20.h),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: howItWorksList.length,
            itemBuilder: (_, index) {
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 180.w,
                    height: 125.h,
                    margin: EdgeInsets.only(top: 12.h),
                    padding:
                        EdgeInsets.only(top: 42.h, left: 13.w, right: 13.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.sp),
                      shape: BoxShape.rectangle,
                      color: const Color(0xffFFFFFF),
                    ),
                    child: Text(
                      howItWorksList[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackLabelColor,
                        fontSize: 14.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                        height: 1.18.h,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -12.h,
                    child: Container(
                      padding: EdgeInsets.all(20.sp),
                      decoration: const BoxDecoration(
                          color: Color(0xffC4E6DD), shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff7B8C99),
                            fontSize: 20.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                            height: 1.18.h,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    ],
  );
}

buildHeader(String header) {
  return Text(
    header,
    textAlign: TextAlign.left,
    style: TextStyle(
      color: AppColors.secondaryLabelColor,
      fontFamily: 'Circular Std',
      fontSize: 13.sp,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
      height: 1.5384615384615385.h,
    ),
  );
}
