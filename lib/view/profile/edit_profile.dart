import 'package:aayu/controller/you/edit_profile_controller.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/theme/app_theme.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:aayu/view/shared/ui_helper/new_cupertino_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    EditProfileController editProfileController =
        Get.put(EditProfileController());
    Future.delayed(Duration.zero, () {
      editProfileController.setUserDetails();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 248, 248, 0.8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'EDIT_PROFILE'.tr,
          style: AppTheme.secondarySmallFontTitleTextStyle,
        ),
        iconTheme: const IconThemeData(color: AppColors.blackLabelColor),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        width: double.infinity,
        color: const Color.fromRGBO(255, 248, 248, 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: GetBuilder<EditProfileController>(
                  builder: (controller) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 26.h,
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(64, 117, 205, 0.08),
                              offset: Offset(0, 10),
                              blurRadius: 20,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: controller.firstNameTextEditingController,
                          style: AppTheme.inputEditProfileTextStyle,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z ]")),
                          ],
                          decoration: const InputDecoration(
                            hintStyle: AppTheme.hintTextStyle,
                            errorStyle: AppTheme.errorTextStyle,
                            hintText: 'Name',
                            labelText: 'Name',
                            labelStyle: AppTheme.hintTextStyle,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            focusColor: AppColors.whiteColor,
                            hoverColor: AppColors.whiteColor,
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.errorColor, width: 3),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val == null) {
                              'Please enter your name.';
                            }
                            if (val!.trim().isEmpty) {
                              return 'Please enter your name.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 26.h,
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(64, 117, 205, 0.08),
                              offset: Offset(0, 10),
                              blurRadius: 20,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: controller.emailTextEditingController,
                          style: AppTheme.inputEditProfileTextStyle,
                          decoration: InputDecoration(
                            hintStyle: AppTheme.hintTextStyle,
                            errorStyle: AppTheme.errorTextStyle,
                            hintText: 'EMAIL_ID'.tr,
                            labelText: 'EMAIL_ID'.tr,
                            labelStyle: AppTheme.hintTextStyle,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            focusColor: AppColors.whiteColor,
                            hoverColor: AppColors.whiteColor,
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.errorColor, width: 3),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return null; //'Please enter your email id';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val.trim());
                            if (!emailValid) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 26.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(64, 117, 205, 0.08),
                              offset: Offset(0, 10),
                              blurRadius: 20,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: controller.phoneNumberTextEditingController,
                          style: AppTheme.inputEditProfileTextStyle,
                          enabled: false,
                          decoration: InputDecoration(
                            hintStyle: AppTheme.hintTextStyle,
                            errorStyle: AppTheme.errorTextStyle,
                            hintText: 'MOBILE_NUMBER'.tr,
                            labelText: 'MOBILE_NUMBER'.tr,
                            labelStyle: AppTheme.hintTextStyle,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            focusColor: AppColors.whiteColor,
                            hoverColor: AppColors.whiteColor,
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.errorColor, width: 3),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 26.h,
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(64, 117, 205, 0.08),
                              offset: Offset(0, 10),
                              blurRadius: 20,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonFormField<String>(
                          onChanged: (val) {
                            controller.setGender(val!);
                          },
                          iconEnabledColor: const Color(0xFF9C9EB9),
                          value: controller.gender.value,
                          items: controller.genderList
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: AppTheme.inputEditProfileTextStyle,
                                  ),
                                ),
                              )
                              .toList(),
                          decoration: InputDecoration(
                            hintStyle: AppTheme.hintTextStyle,
                            errorStyle: AppTheme.errorTextStyle,
                            hintText: 'GENDER'.tr,
                            labelText: 'GENDER'.tr,
                            labelStyle: AppTheme.hintTextStyle,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            focusColor: AppColors.whiteColor,
                            hoverColor: AppColors.whiteColor,
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.errorColor, width: 3),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (controller.gender.value == null) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 26.h,
                      ),
                      InkWell(
                        onTap: () {
                          selectBirthDate(context, editProfileController);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 15.w, top: 5.h, bottom: 5.h),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(64, 117, 205, 0.08),
                                offset: Offset(0, 10),
                                blurRadius: 20,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max, children: [
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                readOnly: true,
                                controller:
                                    controller.birthdateTextEditingController,
                                style: AppTheme.inputEditProfileTextStyle,
                                decoration: InputDecoration(
                                  hintStyle: AppTheme.hintTextStyle,
                                  errorStyle: AppTheme.errorTextStyle,
                                  hintText: 'BIRTHDATE'.tr,
                                  labelText: 'BIRTHDATE'.tr,
                                  labelStyle: AppTheme.hintTextStyle,
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  isDense: true,
                                  filled: true,
                                  fillColor: AppColors.whiteColor,
                                  focusColor: AppColors.whiteColor,
                                  hoverColor: AppColors.whiteColor,
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.errorColor, width: 3),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if (controller
                                      .birthdateTextEditingController.text
                                      .trim()
                                      .isEmpty) {
                                    return 'Please select your birthdate';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            InkWell(
              onTap: () async {
                FocusScope.of(context).unfocus();
                bool isValid = _formKey.currentState!.validate();
                if (isValid == true) {
                  buildShowDialog(context);
                  bool isUpdated =
                      await editProfileController.updateUserProfile();
                  Navigator.of(context).pop();
                  if (isUpdated == true) {
                    Navigator.of(context).pop("updated");
                  } else {
                    showGetSnackBar("FAILED_TO_UPDATE_PROFILE".tr,
                        SnackBarMessageTypes.Error);
                  }
                }
              },
              child: mainButton('SAVE'.tr),
            ),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPicker(BuildContext context, Widget picker,
      EditProfileController editProfileController) {
    return Container(
      height: 438.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      )),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: AppColors.blackLabelColor,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: Padding(
              padding: pagePadding(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blackLabelColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(child: picker),
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (editProfileController.selectedDate != null) {
                        editProfileController
                            .setBirthdate(editProfileController.selectedDate!);
                      }
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 158.w,
                      child: mainButton("SELECT".tr),
                    ),
                  ),
                  pageBottomHeight()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectBirthDate(
      BuildContext context, EditProfileController editProfileController) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return _buildBottomPicker(
            context,
            StatefulBuilder(
              builder: (context, setState) => NewCupertinoDatePicker(
                textColor: AppColors.blackLabelColor,
                overlayColor: const Color.fromRGBO(252, 175, 175, 0.2),
                dateOrder: DatePickerDateOrder.dmy,
                mode: NewCupertinoDatePickerMode.date,
                backgroundColor: Colors.white,
                initialDateTime: editProfileController.initialDate,
                minimumYear: editProfileController.firstDate.year,
                maximumYear: editProfileController.lastDate.year,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    editProfileController.selectedDate = newDateTime;
                    editProfileController.initialDate = newDateTime;
                  });
                },
              ),
            ),
            editProfileController);
      },
    );
  }

  void saveForm(context) {}
}
