import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wevoride/app/dashboard_screen.dart';
import 'package:wevoride/app/help_support_screen/FullScreenImageViewer.dart';
import 'package:wevoride/app/help_support_screen/FullScreenVideoViewer.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/help_support_controller.dart';
import 'package:wevoride/model/chat_video_container.dart';
import 'package:wevoride/model/conversation_admin_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class HelpSupportScreen extends StatelessWidget {
  HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        await Preferences.setBoolean(Preferences.isClickOnNotification, false);
        Get.offAll(DashBoardScreen());
        return false;
      },
      child: GetX(
          init: HelpSupportController(),
          builder: (controller) {
            return CustomScaffold(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey50,
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                centerTitle: false,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                leading: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await Preferences.setBoolean(Preferences.isClickOnNotification, false);
                    Get.offAll(DashBoardScreen());
                  },
                  child: Icon(
                    Icons.chevron_left_outlined,
                    color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                  ),
                ),
                title: Text(
                  "Help & Support".tr,
                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18),
                ),
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: Container(
                    color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                    height: 4.0,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: PaginateFirestore(
                          scrollDirection: Axis.vertical,
                          query: FireStoreUtils.fireStore.collection(CollectionName.adminChat).doc(FireStoreUtils.getCurrentUid()).collection("thread").orderBy('createdAt', descending: true),
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
                            ConversationAdminModel inboxModel = ConversationAdminModel.fromJson(documentSnapshots[index].data() as Map<String, dynamic>);
                            return chatItemView(isMe: inboxModel.senderId == FireStoreUtils.getCurrentUid(), data: inboxModel, context: context, controller: controller);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.primary50 : AppThemeData.secondary600, fontFamily: AppThemeData.medium, fontSize: 14),
                            textInputAction: TextInputAction.send,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.messageController.value,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              filled: true,
                              fillColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100,
                              disabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100, width: 1),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  if (controller.messageController.value.text.isNotEmpty) {
                                    controller.sendMessage(message: controller.messageController.value.text, url: null, videoThumbnail: '', messageType: 'text', controller: controller);
                                    controller.messageController.value.clear();
                                  } else {
                                    ShowToastDialog.showToast("Please enter text".tr);
                                  }
                                },
                                icon: Icon(Icons.send_rounded, color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey800),
                              ),
                              prefixIcon: IconButton(
                                onPressed: () async {
                                  _onCameraClick(themeChange: themeChange, controller: controller, context: context);
                                },
                                icon: Icon(Icons.camera_alt, color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey800),
                              ),
                              hintText: 'Start typing ...'.tr,
                              hintStyle: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                            ),
                            onSubmitted: (value) async {
                              if (controller.messageController.value.text.isNotEmpty) {
                                controller.sendMessage(message: controller.messageController.value.text, url: null, videoThumbnail: '', messageType: 'text', controller: controller);
                                // Timer(const Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.maxScrollExtent));
                                controller.messageController.value.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget chatItemView({required bool isMe, required ConversationAdminModel data, required BuildContext context, required HelpSupportController controller}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: isMe
          ? Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      data.messageType == "text"
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75, // prevent overflow
                              ),
                              decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.primary200 : AppThemeData.primary300,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Text(
                                data.message.toString(),
                                softWrap: true,
                                maxLines: null,
                                style: TextStyle(fontFamily: AppThemeData.semiBold, color: themeChange.getThem() ? Colors.black : Colors.white),
                              ),
                            )
                          : data.messageType == "image"
                              ? ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 50,
                                    maxWidth: 200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    child: Stack(alignment: Alignment.center, children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(FullScreenImageViewer(
                                            imageUrl: data.url!.url,
                                          ));
                                        },
                                        child: Hero(
                                          tag: data.url!.url,
                                          child: CachedNetworkImage(
                                            imageUrl: data.url!.url,
                                            placeholder: (context, url) => Constant.loader(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ))
                              : ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 50,
                                    maxWidth: 200,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(FullScreenVideoViewer(
                                        heroTag: data.id.toString(),
                                        videoUrl: data.url!.url,
                                      ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                      child: Stack(alignment: Alignment.center, children: [
                                        Hero(
                                          tag: data.url!.url,
                                          child: (data.videoThumbnail == null || data.videoThumbnail!.isEmpty)
                                              ? const Icon(Icons.error)
                                              : CachedNetworkImage(
                                                  imageUrl: data.videoThumbnail!,
                                                  placeholder: (context, url) => Constant.loader(),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                        ),
                                        Icon(Icons.play_arrow, size: 50)
                                      ]),
                                    ),
                                  )),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: (controller.userModel.value.profilePic == null || 
                                  controller.userModel.value.profilePic!.isEmpty)
                              ? Image.asset(
                                  Constant.userPlaceHolder,
                                  height: Responsive.width(5, context),
                                  width: Responsive.width(5, context),
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  height: Responsive.width(5, context),
                                  width: Responsive.width(5, context),
                                  imageUrl: controller.userModel.value.profilePic.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Constant.loader(),
                                  errorWidget: (context, url, error) => Image.asset(Constant.userPlaceHolder, fit: BoxFit.cover),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Constant.dateAndTimeFormatTimestamp(data.createdAt),
                          style: TextStyle(fontFamily: AppThemeData.regular, fontSize: 12, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800)),
                      data.seen == true
                          ? Text("✓✓", style: TextStyle(fontSize: 10, color: AppThemeData.primary200))
                          : Text("✓", style: TextStyle(fontSize: 10, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800))
                    ],
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    data.messageType == "text"
                        ? Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75, // prevent overflow
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                              color: themeChange.getThem() ? AppThemeData.grey900 : Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              data.message.toString(),
                              softWrap: true,
                              maxLines: null,
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14),
                            ),
                          )
                        : data.messageType == "image"
                            ? ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                  maxWidth: 200,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  child: Stack(alignment: Alignment.center, children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(FullScreenImageViewer(
                                          imageUrl: data.url!.url,
                                        ));
                                      },
                                      child: Hero(
                                        tag: data.url!.url,
                                        child: CachedNetworkImage(
                                          imageUrl: data.url!.url,
                                          placeholder: (context, url) => Constant.loader(),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ))
                            : ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                  maxWidth: 200,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(FullScreenVideoViewer(
                                      heroTag: data.id.toString(),
                                      videoUrl: data.url!.url,
                                    ));
                                  },
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                    child: Stack(alignment: Alignment.center, children: [
                                      Hero(
                                        tag: data.url!.url,
                                        child: CachedNetworkImage(
                                          imageUrl: data.videoThumbnail ?? '',
                                          placeholder: (context, url) => Constant.loader(),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                      Icon(Icons.play_arrow, size: 50)
                                    ]),
                                  ),
                                )),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin",
                        style: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                          fontFamily: AppThemeData.semiBold,
                          fontSize: 12,
                        )),
                    Text(Constant.dateAndTimeFormatTimestamp(data.createdAt),
                        style: TextStyle(fontFamily: AppThemeData.regular, fontSize: 12, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800)),
                  ],
                ),
              ],
            ),
    );
  }

  final ImagePicker _imagePicker = ImagePicker();

  void _onCameraClick({required DarkThemeProvider themeChange, required HelpSupportController controller, required BuildContext context}) {
    final action = CupertinoActionSheet(
      message: Text('Send Media'.tr,
          style: TextStyle(
            color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            fontFamily: AppThemeData.semiBold,
            fontSize: 12,
          )),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              Url url = await Constant().uploadChatImageToFireStorage(File(image.path));
              controller.sendMessage(message: '', url: url, videoThumbnail: '', messageType: 'image', controller: controller);
            }
          },
          child: Text("Choose image from gallery".tr),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? galleryVideo = await _imagePicker.pickVideo(source: ImageSource.gallery);
            if (galleryVideo != null) {
              ChatVideoContainer? videoContainer = await Constant().uploadChatVideoToFireStorage(File(galleryVideo.path));
              if (videoContainer != null) {
                controller.sendMessage(message: '', url: videoContainer.videoUrl, videoThumbnail: videoContainer.thumbnailUrl, messageType: 'video', controller: controller);
              } else {
                ShowToastDialog.showToast("Message sent failed");
              }
            }
          },
          child: Text("Choose video from gallery".tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              Url url = await Constant().uploadChatImageToFireStorage(File(image.path));
              controller.sendMessage(message: '', url: url, videoThumbnail: '', messageType: 'image', controller: controller);
            }
          },
          child: Text("Take a Photo".tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? recordedVideo = await _imagePicker.pickVideo(source: ImageSource.camera);
            if (recordedVideo != null) {
              ChatVideoContainer? videoContainer = await Constant().uploadChatVideoToFireStorage(File(recordedVideo.path));
              if (videoContainer != null) {
                controller.sendMessage(message: '', url: videoContainer.videoUrl, videoThumbnail: videoContainer.thumbnailUrl, messageType: 'video', controller: controller);
              } else {
                ShowToastDialog.showToast("Message sent failed");
              }
            }
          },
          child: Text("Record video".tr),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
