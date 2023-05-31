import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/chat_agora/widgets/chat_tile_widget.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/chat_agora/chat_agora_controller.dart';

class ChatScreen extends StatefulWidget {
  final String? coachName;

  final String? profilePhoto;

  const ChatScreen({
    Key? key,
    this.coachName,
    this.profilePhoto,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void dispose() {
    ChatAgoraController chatAgoraController = Get.find();
    chatAgoraController.removeChatListener();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ChatAgoraController chatAgoraController = Get.find();
    chatAgoraController.scrollController = ScrollController();
    chatAgoraController.addScrollListener();
    Future.delayed(const Duration(milliseconds: 400), () {
      chatAgoraController.scrollDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatAgoraController chatAgoraController = Get.find();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 194, 210),
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(Images.planSummaryBGImage))),
          ),
          elevation: 0,
          iconTheme:
              const IconThemeData(color: AppColors.blueGreyAssessmentColor),
          backgroundColor: AppColors.primaryColor,
          titleSpacing: 0,
          title: Row(
            children: [
              circularConsultImage("DOCTOR", widget.profilePhoto, 50, 50),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.coachName ?? "",
                style: const TextStyle(
                    fontFamily: "Baskerville",
                    color: AppColors.blackLabelColor),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              Images.chatBackgroundImage,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            GestureDetector(onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            }, child: Obx(
              () {
                if (chatAgoraController.isLoading.value == true) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(children: [
                  Expanded(
                    child: ListView.builder(
                        controller: chatAgoraController.scrollController,
                        clipBehavior: Clip.none,
                        reverse: true,
                        itemCount: chatAgoraController.messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == chatAgoraController.messages.length) {
                            return GetBuilder<ChatAgoraController>(
                                builder: (controller) {
                              if (controller.isPageLoading.value) {
                                return Container(
                                  height: 50.h,
                                  alignment: Alignment.center,
                                  width: 50.h,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                );
                              }
                              return const Offstage();
                            });
                          }
                          return ChatTileWidget(
                            width: width,
                            chatMessage:
                                chatAgoraController.messages.value[index],
                            self: chatAgoraController
                                    .messages.value[index]!.from ==
                                chatAgoraController.userId,
                          );
                        }),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.h)),
                    margin:
                        EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    child:
                        GetBuilder<ChatAgoraController>(builder: (controller) {
                      return TextField(
                        maxLines: null,
                        controller: controller.chatTextEditingContoller,
                        style: TextStyle(
                          color: AppColors.blackLabelColor,
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15.h),
                          prefixIconConstraints: const BoxConstraints(),
                          suffixIconConstraints: const BoxConstraints(),
                          suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                controller.sendMessage();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: AppColors.primaryColor,
                              )),
                          prefixIcon: IconButton(
                              onPressed: () async {
                                chatAgoraController
                                    .selectAndSendImage(ImageSource.gallery);
                              },
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.primaryColor,
                              )),
                          hintText: "Enter Message",
                          hintStyle: TextStyle(
                              fontFamily: "CircularStd", fontSize: 14.sp),
                          border: InputBorder.none,
                        ),
                      );
                    }),
                  ),
                ]);
              },
            )),
          ],
        ));
  }
}
