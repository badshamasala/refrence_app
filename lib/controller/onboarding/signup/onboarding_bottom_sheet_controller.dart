import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OnboardingBottomSheetController extends GetxController {
  DateTime todaysDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  RxInt selectedPage = 0.obs;

  PageController pageController = PageController(initialPage: 0);

  Rx<PhoneNumber> userPhoneNumber =
      PhoneNumber(countryCode: "+91", countryISOCode: "IN", number: "").obs;
  RxBool isValidPhoneNumber = false.obs;
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController userNameController = TextEditingController();
  TextEditingController userBirthDateController = TextEditingController();

  String emailId = "";
  String userGender = "";

  String buildNumber = '';

  bool isSocialSignUp = false;

  Rx<int> genderSelected = 0.obs;
  List<Map<String, String>> genderList = [
    {"gender": "Female", "image": Images.femaleImage},
    {"gender": "Male", "image": Images.maleImage},
    {"gender": "Non-Binary", "image": Images.nonBinaryImage}
  ];

  Rx<bool> isRegistered = false.obs;

  OnboardingBottomSheetController(bool showPersonalisingYourSpace) {
    if (showPersonalisingYourSpace == false) {
      pageController = PageController(initialPage: 3);
    } else {
      pageController = PageController(initialPage: 0);
    }
  }

  @override
  void onInit() {
    todaysDate = DateTime.now();
    DateTime tempDate = todaysDate.add(const Duration(days: (-365 * 100)));
    firstDate = DateTime(tempDate.year, 1, 1);

    lastDate = todaysDate.add(const Duration(days: ((-365 * 13) - 4)));
    initialDate = lastDate;
    getVersionName();
    super.onInit();
  }

  setSocialSignUp(bool isSocial) {
    isSocialSignUp = isSocial;
    update();
  }

  getVersionName() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    buildNumber = "${info.version}+${info.buildNumber}";
  }

  setSelectedPage(int index) {
    selectedPage.value = index;
    update();
  }

  updateMobileNumber(PhoneNumber inputPhoneNumber) {
    userPhoneNumber.value = inputPhoneNumber;
  }

  updateIsValidPhoneNumber(bool isValid) {
    isValidPhoneNumber.value = isValid;
  }

  Future<bool?> checkIfRegistered() async {
    String? userEmailId = FirebaseAuth.instance.currentUser?.email;
    CheckRegistrationResponseModel? checkRegistrationResponse =
        await OnboardingService().checkIfRegistered(
            userPhoneNumber.value.completeNumber.replaceAll("+", ""),
            userEmailId ?? "");

    if (checkRegistrationResponse != null) {
      isRegistered.value = checkRegistrationResponse.isRegister!;
      update();
    }

    return isRegistered.value;
  }

  updateProfile() async {
    OnbardingRequest request = OnbardingRequest();
    request.firebaseUId = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser?.uid
        : "";
    request.firstName = userNameController.text.trim();
    request.lastName = "";
    request.gender = userGender;
    request.dob = userBirthDateController.text.trim();
    request.emailId = emailId.isNotEmpty
        ? emailId
        : FirebaseAuth.instance.currentUser!.email ?? "";

    request.socialNetwork = [];
    if (isSocialSignUp == true) {
      request.socialNetwork!.add(OnbardingRequestSocialNetwork.fromJson(
          {"network": "", "socialId": "", "profilePic": ""}));
    }
    request.location = [];
    request.location!.add(OnbardingRequestLocation.fromJson({
      "country": userPhoneNumber.value.countryISOCode,
      "state": "",
      "city": "",
      "pinCode": ""
    }));

    UserRegistrationResponse? userRegistrationResponse =
        await HiveService().getUserIdDetails();

    if (userRegistrationResponse != null &&
        userRegistrationResponse.userId!.isNotEmpty) {
      UpdateProfileResponse? updateProfileResponse = await ProfileService()
          .updateProfile(userRegistrationResponse.userId!, request);
      if (updateProfileResponse != null &&
          updateProfileResponse.userId != null &&
          updateProfileResponse.userId!.isNotEmpty) {
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(userNameController.text.trim());

        MoengageService().setUserName(userNameController.text.trim());

        UserDetailsResponse? userDetailsResponse = await ProfileService()
            .getUserDetails(updateProfileResponse.userId!);

        if (userDetailsResponse != null &&
            userDetailsResponse.userDetails != null) {
          if (userDetailsResponse.userDetails!.userId!.isNotEmpty &&
              userDetailsResponse.userDetails!.userId! ==
                  updateProfileResponse.userId!) {
            await HiveService()
                .saveDetails("userDetails", userDetailsResponse.toJson());

            MoengageService()
                .setGender(userDetailsResponse.userDetails!.gender!);
          }
        }
        return true;
      }
    }

    return false;
  }

  registerUser() async {
    String mobileNumber = FirebaseAuth.instance.currentUser?.phoneNumber ?? "";
    String userEmailId = emailId.isNotEmpty
        ? emailId
        : FirebaseAuth.instance.currentUser?.email ?? "";

    if (mobileNumber.isNotEmpty) {
      mobileNumber = mobileNumber.replaceAll("+", "");
    }

    UserRegistrationResponse? userRegistrationResponse =
        await OnboardingService().registerUser(
            mobileNumber,
            userEmailId,
            buildNumber,
            OnbardingRequestLocation.fromJson({
              "country": userPhoneNumber.value.countryISOCode,
              "state": "",
              "city": "",
              "pinCode": ""
            }));

    if (userRegistrationResponse != null &&
        userRegistrationResponse.userId != null &&
        userRegistrationResponse.userId!.isNotEmpty) {
      await HiveService()
          .saveDetails("userIdDetails", userRegistrationResponse.toJson());
      globalUserIdDetails = userRegistrationResponse;
      FlurryService().setUserId(userRegistrationResponse.userId!);
      MoengageService().setUserId(userRegistrationResponse.userId!);

      EventsService().sendEvent("Aayu_Registration_Complete", {
        "user_id": userRegistrationResponse.userId!,
        "build_number": buildNumber,
        "country": userPhoneNumber.value.countryISOCode,
        "mobile_number": mobileNumber,
      });
      //Send Firebase Notification Token to Backend
      FirebaseMessaging.instance.getToken().then((token) {
        OnboardingService()
            .sendFirebaseToken(userRegistrationResponse.userId!, token!);
      });
      return true;
    } else {
      EventsService().sendEvent(
          "Aayu_Registration_Failed", {"mobile_number": mobileNumber});
      return false;
    }
  }

  checkNameProvided() {
    if (userNameController.text.trim().isNotEmpty) {
      return true;
    }

    return false;
  }

  getAndSetUserProfile() async {
    UserRegistrationResponse? userRegistrationResponse =
        await HiveService().getUserIdDetails();

    if (userRegistrationResponse != null &&
        userRegistrationResponse.userId!.isNotEmpty) {
      UserDetailsResponse? userDetailsResponse = await ProfileService()
          .getUserDetails(userRegistrationResponse.userId!);

      if (userDetailsResponse != null &&
          userDetailsResponse.userDetails != null) {
        globalUserIdDetails = userRegistrationResponse;
        await HiveService()
            .saveDetails("userDetails", userDetailsResponse.toJson());
      }
    }
  }
}
