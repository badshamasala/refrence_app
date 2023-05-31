import 'package:aayu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingBottomBar extends StatelessWidget {
  var onTap;
  OnboardingBottomBar({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {},
              child: Text(
                "SKIP_FOR_NOW".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              )),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.blackColor,
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.whiteColor,
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
