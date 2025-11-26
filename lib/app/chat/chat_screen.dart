import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/chat/model/chat_model.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/chat_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ChatController>(
      init: ChatController(),
      builder: (controller) {
        return CustomScaffold(
          backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.chevron_left_outlined,
                color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: NetworkImageWidget(
                    imageUrl: controller.receiverUserModel.value.profilePic.toString(),
                    height: Responsive.width(10, context),
                    width: Responsive.width(10, context),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.receiverUserModel.value.fullName().toString(),
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 14),
                    ),
                    Text(
                      controller.receiverUserModel.value.email.toString(),
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Column(
                  children: [
                    Expanded(
                      child: PaginateFirestore(
                        scrollDirection: Axis.vertical,
                        query: FireStoreUtils.fireStore
                            .collection(CollectionName.chat)
                            .doc(controller.senderUserModel.value.id)
                            .collection(controller.receiverUserModel.value.id.toString())
                            .orderBy("timestamp", descending: true),
                        itemBuilderType: PaginateBuilderType.listView,
                        isLive: true,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        reverse: true,
                        onEmpty: Constant.showEmptyView(message: "No conversion found".tr, isDarkMode: themeChange.getThem()),
                        onError: (error) {
                          return ErrorWidget(error);
                        },
                        itemBuilder: (context, documentSnapshots, index) {
                          ChatModel chatModel = ChatModel.fromJson(documentSnapshots[index].data() as Map<String, dynamic>);
                          return Container(
                              padding: const EdgeInsets.only(left: 14, right: 14, top: 06, bottom: 06),
                              child: chatBubbles(chatModel.senderId == controller.senderUserModel.value.id ? true : false, chatModel, themeChange));
                        },
                      ),
                    ),
                    Container(
                      color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                                controller: controller.messageTextEditorController.value,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                textInputAction: TextInputAction.done,
                                style:
                                    TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(color: Colors.red),
                                    isDense: true,
                                    filled: true,
                                    enabled: true,
                                    fillColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, width: 1),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, width: 1),
                                    ),
                                    hintText: "Type Message".tr,
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey600 : AppThemeData.grey700, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium)),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  if (controller.messageTextEditorController.value.text.isNotEmpty) {
                                    controller.sendMessage(controller.messageTextEditorController.value.text.trim());
                                  } else {
                                    ShowToastDialog.showToast("Please enter message".tr);
                                  }
                                },
                                child: SvgPicture.asset("assets/icons/ic_chat_send.svg"))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  chatBubbles(bool isMe, ChatModel chatModel, themeChange) {
    return isMe
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                      color: AppThemeData.grey200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        chatModel.message.toString(),
                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    Constant.timestampToDateTime(chatModel.timestamp!),
                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, fontFamily: AppThemeData.regular, fontSize: 12),
                  )
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      color: AppThemeData.primary300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        chatModel.message.toString(),
                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50, fontFamily: AppThemeData.regular, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    Constant.timestampToDateTime(chatModel.timestamp!),
                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, fontFamily: AppThemeData.regular, fontSize: 12),
                  )
                ],
              ),
            ],
          );
  }
}
