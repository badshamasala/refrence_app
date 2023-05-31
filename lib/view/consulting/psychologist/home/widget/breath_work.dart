import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/home/widgets/my_routine/breathing_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BreathWorkWidget extends StatefulWidget {
  const BreathWorkWidget({Key? key}) : super(key: key);

  @override
  State<BreathWorkWidget> createState() => _BreathWorkWidgetState();
}

class _BreathWorkWidgetState extends State<BreathWorkWidget> {
  final List<Map<String, dynamic>> listOfMins = [
    {"duration": "2 mins", "selected": true, "timer": 120},
    {"duration": "5 mins", "selected": false, "timer": 300},
    {"duration": "10 mins", "selected": false, "timer": 600},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Breathwork",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.bottomNavigationLabelColor,
                    fontFamily: 'BaskerVille',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5.h,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Start your day with the\nAffirmation.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: AppColors.bottomNavigationLabelColor,
                    fontFamily: 'Circular Std',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5.h,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 35.h,
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: listOfMins.length,
                      itemBuilder: (context, index) {
                        final duration = listOfMins[index]["duration"];
                        final selected = listOfMins[index]["selected"];
                        return InkWell(
                          onTap: () {
                            // Handle onTap functionality here
                            setState(() {
                              for (var item in listOfMins) {
                                item["selected"] = false;
                              }
                              listOfMins[index]["selected"] = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            constraints: BoxConstraints(minWidth: 80.w),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xffD9D9D9)
                                  : Colors.white,
                              border: Border.all(color: const Color(0xffD9D9D9)),
                              borderRadius: BorderRadius.circular(25.sp),
                            ),
                            child: Center(
                              child: Text(
                                duration,
                                style: TextStyle(
                                  color: AppColors.secondaryLabelColor,
                                  fontFamily: "Circular Std",
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 8.w);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: Size(130.w, 40.h),
                      elevation: 0,
                      backgroundColor: const Color(0xffAAFDB4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                    ),
                    onPressed: () {
                      Map<String, dynamic> selectedTimer = listOfMins
                          .firstWhere((element) => element["selected"] == true);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BreathingExercise(
                            timer: selectedTimer["timer"],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Relax Now!',
                      style: TextStyle(
                        color: AppColors.secondaryLabelColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Circular Std",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -25.h,
            right: 10.w,
            child: Image.asset(
              "assets/images/psycology/breath-work.png",
            ),
          ),
        ],
      ),
    );
  }
}
