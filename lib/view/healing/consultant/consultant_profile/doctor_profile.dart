import 'package:aayu/controller/consultant/doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorController doctorController = Get.find();
    return Obx(() {
      if (doctorController.isProfileLoading.value == true) {
        return Offstage();
      } else if (doctorController.doctorProfile.value == null) {
        return Offstage();
      } else if (doctorController.doctorProfile.value!.coachDetails == null) {
        return Offstage();
      }
      return Container();
    });
  }
}
