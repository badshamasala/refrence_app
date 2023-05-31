import 'package:aayu/services/consultant.service.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatAgoraController extends GetxController {
  String appKey = "61706639#957604";
  String userId = "";

  int pageSize = 20;
  String convId = '';
  RxList<ChatMessage?> messages = <ChatMessage>[].obs;
  late ScrollController scrollController;
  TextEditingController chatTextEditingContoller = TextEditingController();

  RxBool isPageLoading = false.obs;
  RxBool isLoading = false.obs;
  bool _paginate = true;

  Future<void> initSDK() async {
    isLoading(true);
    userId = (globalUserIdDetails?.userId ?? "").replaceAll("-", "");
    ChatOptions options = ChatOptions(
        appKey: appKey, autoLogin: false, isAutoDownloadThumbnail: true);
    await ChatClient.getInstance.init(options);
    // Notify the SDK that the UI is ready. After the following method is executed, callbacks within `ChatRoomEventHandler`, ` ChatContactEventHandler`, and `ChatGroupEventHandler` can be triggered.

    await ChatClient.getInstance.startCallback();
    isLoading(false);
  }

  Future<void> signIn() async {
    try {
      String? token = await ConsultantService().getAgoraChatToken(userId);
      if (token != null) {
        await ChatClient.getInstance.loginWithAgoraToken(
          userId,
          token,
        );
        print("login succeed, userId: $userId");
      }
    } on ChatError catch (e) {
      print("login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  Future<void> signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      print("sign out succeed");
    } on ChatError catch (e) {
      print("sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  Future<void> getOldChat() async {
    _paginate = true;
    try {
      ChatConversationType convType = ChatConversationType.Chat;

      ChatCursorResult<ChatMessage?> cursor =
          await ChatClient.getInstance.chatManager.fetchHistoryMessages(
        conversationId: convId,
        type: convType,
        pageSize: pageSize,
      );
      messages.value = cursor.data.reversed.toList();
    } on ChatError {}
  }

  Future<void> getPaginatedData() async {
    if (_paginate && isPageLoading.value == false) {
      isPageLoading(true);
      update();
      try {
        ChatConversationType convType = ChatConversationType.Chat;

        ChatCursorResult<ChatMessage?> cursor =
            await ChatClient.getInstance.chatManager.fetchHistoryMessages(
                conversationId: convId,
                type: convType,
                pageSize: pageSize,
                startMsgId: messages.last?.msgId ?? "");
        List<ChatMessage?> list = cursor.data.reversed.toList();
        print("CHAT MESSAGES ========");
        print(list.length);
        if (list.length < 20) {
          _paginate = false;
        }

        messages.addAll(list);
      } catch (err) {
        rethrow;
      } finally {
        isPageLoading(false);
        update();
      }
    }
  }

  void addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      userId,
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void removeChatListener() {
    ChatClient.getInstance.chatManager.removeEventHandler(userId);
  }

  void onMessagesReceived(List<ChatMessage> message) {
    for (var msg in message) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            if (messages.indexWhere((element) => element?.msgId == msg.msgId) ==
                -1) {
              messages.insert(0, msg);
              scrollDown();
            }
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            print(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
          }
          break;
        case MessageType.IMAGE:
          {
            if (messages.indexWhere((element) => element?.msgId == msg.msgId) ==
                -1) {
              messages.insert(0, msg);
              scrollDown();
            }

            print(
              "receive image",
            );
          }
          break;

        case MessageType.FILE:
          {
            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {
            // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
          }
          break;
      }
    }
  }

  Future<void> sendMessage() async {
    if (chatTextEditingContoller.text.trim().isNotEmpty) {
      ChatMessage txtMsg = ChatMessage.createTxtSendMessage(
        targetId: convId,
        content: chatTextEditingContoller.text.trim(),
      );
      await ChatClient.getInstance.chatManager
          .sendMessage(txtMsg)
          .then((value) {
        messages.insert(0, value);
        scrollDown();
      });
      chatTextEditingContoller.clear();
    }
  }

  Future<void> selectAndSendImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
    );
    if (image != null) {
      ChatMessage imgMessage = ChatMessage.createImageSendMessage(
          targetId: convId, filePath: image.path, sendOriginalImage: false);
      await ChatClient.getInstance.chatManager
          .sendMessage(imgMessage)
          .then((value) {
        messages.insert(0, value);
        scrollDown();
      });
    }
  }

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  void addScrollListener() {
    scrollController.addListener(_scrollListener);
  }

  void removeScrollListener() {
    scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (!_paginate) {
      return;
    }
    // // print(scrollController.position.extentBefore);
    // print(scrollController.position.userScrollDirection);

    if (scrollController.position.extentAfter <= 0 &&
        scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        isPageLoading.value == false) {
      getPaginatedData();
    }
  }

  void setConvId(String id) {
    convId = id.replaceAll("-", "");
  }
}
