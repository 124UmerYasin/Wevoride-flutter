import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/model/conversation_admin_model.dart';
import 'package:wevoride/model/inbox_admin_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpSupportController extends GetxController {
  Rx<TextEditingController> messageController = TextEditingController().obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    setSeen();
    setPref();
    super.onInit();
  }

  @override
  void onClose() {
    FireStoreUtils.stopSeenListener();
    super.onClose();
  }

  setPref() async {
    await Preferences.setBoolean(Preferences.isClickOnNotification, false);
  }

  Future<void> setSeen() async {
    FireStoreUtils.setSeen();
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value?.id != null) {
        userModel.value = value!;
      }
    });
  }

  Future<void> sendMessage({required String message, Url? url, required String videoThumbnail, required String messageType, required HelpSupportController controller}) async {
    InboxAdminModel inboxModel = InboxAdminModel(
      lastSenderId: controller.userModel.value.id,
      adminId: Constant.adminType,
      adminName: Constant.adminType,
      userId: controller.userModel.value.id,
      userName: controller.userModel.value.fullName(),
      userProfileImage: controller.userModel.value.profilePic,
      createdAt: Timestamp.now(),
      lastMessage: controller.messageController.value.text,
      chatType: messageType,
      type: 'user',
    );

    await FireStoreUtils.addInAdminBox(inboxModel);

    ConversationAdminModel conversationModel = ConversationAdminModel(
        id: const Uuid().v4(),
        message: message,
        senderId: FireStoreUtils.getCurrentUid(),
        receiverId: Constant.adminType,
        createdAt: Timestamp.now(),
        url: url,
        messageType: messageType,
        videoThumbnail: videoThumbnail,
        seen: false);

    if (url != null) {
      if (url.mime.contains('image')) {
        conversationModel.message = "sent an image";
      } else if (url.mime.contains('video')) {
        conversationModel.message = "sent an Video";
      } else if (url.mime.contains('audio')) {
        conversationModel.message = "Sent a voice message";
      }
    }

    await FireStoreUtils.addAdminChat(conversationModel);
  }
}
