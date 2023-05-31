import 'package:aayu/controller/you/you_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';

class EditProfileController extends GetxController {
  Rx<UserDetailsResponse?> userDetails = UserDetailsResponse().obs;

  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController birthdateTextEditingController =
      TextEditingController();
  

  Rx<PhoneNumber> userPhoneNumber =
      PhoneNumber(countryCode: "+91", countryISOCode: "IN", number: "").obs;

  Rx<String?> gender = (null as String).obs;
  List<String> genderList = ['Female', 'Male', 'Non-Binary'];

  Rx<DateTime?> birthDate = (null as DateTime).obs;


  DateTime todaysDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  DateTime? selectedDate;

  @override
  void onInit() {
    DateTime tempDate = todaysDate.add(const Duration(days: (-365 * 100)));
    firstDate = DateTime(tempDate.year, 1, 1);

    lastDate = todaysDate.add(const Duration(days: ((-365 * 13) - 4)));
    initialDate = lastDate;
    super.onInit();
  }

  setUserDetails() async {
    userDetails.value = await HiveService().getUserDetails();

    if (userDetails.value != null && userDetails.value!.userDetails != null) {
      firstNameTextEditingController.text =
          userDetails.value!.userDetails!.firstName!;

      phoneNumberTextEditingController.text =
          userDetails.value!.userDetails!.mobileNumber!;
      emailTextEditingController.text =
          userDetails.value!.userDetails!.emailId!;

      if (userDetails.value!.userDetails!.dob!.isNotEmpty) {
        String tempDOB = userDetails.value!.userDetails!.dob!;
        DateTime tempBirthDate = DateTime(int.parse(tempDOB.split("-")[2]),
            int.parse(tempDOB.split("-")[1]), int.parse(tempDOB.split("-")[0]));

        birthDate.value = tempBirthDate;
        selectedDate = tempBirthDate;
        birthdateTextEditingController.text =
            DateFormat('dd-MM-yyyy').format(tempBirthDate);
      }
      if (selectedDate != null) {
        initialDate = selectedDate!;
      }

      if (userDetails.value!.userDetails!.gender!.isNotEmpty) {
        switch (userDetails.value!.userDetails!.gender!.toUpperCase()) {
          case "MALE":
            gender.value = "Male";
            break;
          case "FEMALE":
            gender.value = "Female";
            break;
          case "NON-BINARY":
            gender.value = "Non-Binary";
            break;
        }
      }

      userPhoneNumber.value = PhoneNumber(
          countryISOCode: (userDetails.value!.userDetails!.location != null &&
                  userDetails.value!.userDetails!.location!.isNotEmpty)
              ? userDetails.value!.userDetails!.location![0]!.country ?? ""
              : "IN",
          countryCode: (userDetails.value!.userDetails!.location != null &&
                  userDetails.value!.userDetails!.location!.isNotEmpty)
              ? userDetails.value!.userDetails!.location![0]!.country ?? ""
              : "IN",
          number: userDetails.value!.userDetails!.mobileNumber!);

      update();
    }
  }

  setBirthdate(DateTime dateTime) {
    birthDate.value = dateTime;
    birthdateTextEditingController.text =
        DateFormat('dd-MM-yyyy').format(dateTime);
    update();
  }


  setGender(String val) {
    gender.value = val;
    update();
  }

  updateUserProfile() async {
    OnbardingRequest request = OnbardingRequest();
    request.firebaseUId = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser?.uid
        : "";
    request.firstName = firstNameTextEditingController.text.trim();
    request.lastName = "";
    request.emailId = emailTextEditingController.text.trim();
    request.gender = gender.value;
    request.dob = DateFormat('dd-MM-yyyy').format(birthDate.value!);

    request.socialNetwork = [];
    if (userDetails.value!.userDetails!.socialNetwork != null &&
        userDetails.value!.userDetails!.socialNetwork!.isNotEmpty) {
      for (var element in userDetails.value!.userDetails!.socialNetwork!) {
        request.socialNetwork!
            .add(OnbardingRequestSocialNetwork.fromJson(element!.toJson()));
      }
    }
    request.location = [];
    request.location!.add(OnbardingRequestLocation.fromJson({
      "country": userPhoneNumber.value.countryISOCode,
      "state": "",
      "city": "",
      "pinCode": ""
    }));

    UpdateProfileResponse? updateProfileResponse = await ProfileService()
        .updateProfile(userDetails.value!.userDetails!.userId!, request);
    if (updateProfileResponse != null &&
        updateProfileResponse.userId != null &&
        updateProfileResponse.userId!.isNotEmpty) {
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(firstNameTextEditingController.text.trim());

      MoengageService().setUserName(firstNameTextEditingController.text.trim());
      MoengageService().setGender(gender.value!);

      UserDetailsResponse? userDetailsResponse =
          await ProfileService().getUserDetails(updateProfileResponse.userId!);

      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        if (userDetailsResponse.userDetails!.userId!.isNotEmpty &&
            userDetailsResponse.userDetails!.userId! ==
                updateProfileResponse.userId!) {
          await HiveService()
              .saveDetails("userDetails", userDetailsResponse.toJson());

          MoengageService().setGender(userDetailsResponse.userDetails!.gender!);
        }
      }
      YouController youController = Get.find();
      youController.userDetails.value = userDetailsResponse;
      youController.update();
      return true;
    }

    return false;
  }
}
