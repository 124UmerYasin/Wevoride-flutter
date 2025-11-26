import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/verification_details_upload_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class VerificationDetailsUploadScreen extends StatelessWidget {
  const VerificationDetailsUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DetailsUploadController>(
        init: DetailsUploadController(),
        builder: (controller) {
          return CustomScaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              title: Text(
                "${controller.documentModel.value.title}",
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
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: TextFieldWidget(
                            hintText: '${controller.documentModel.value.title.toString()} Number',
                            controller: controller.documentNumberController.value,
                          ),
                        ),
                        Visibility(
                          visible: controller.documentModel.value.frontSide == true ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Front Side of ${controller.documentModel.value.title.toString()}",
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                controller.frontImage.value.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          if (controller.documents.value.status == "rejected") {
                                            buildBottomSheet(context, controller, "front");
                                          }
                                        },
                                        child: SizedBox(
                                          height: Responsive.height(20, context),
                                          width: Responsive.width(90, context),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Constant().hasValidUrl(controller.frontImage.value) == false
                                                ? Image.file(
                                                    File(controller.frontImage.value),
                                                    height: Responsive.height(20, context),
                                                    width: Responsive.width(80, context),
                                                    fit: BoxFit.fill,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: controller.frontImage.value.toString(),
                                                    fit: BoxFit.fill,
                                                    height: Responsive.height(20, context),
                                                    width: Responsive.width(80, context),
                                                    placeholder: (context, url) => Constant.loader(),
                                                    errorWidget: (context, url, error) => Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/goride-1a752.appspot.com/o/placeholderImages%2Fuser-placeholder.jpeg?alt=media&token=34a73d67-ba1d-4fe4-a29f-271d3e3ca115'),
                                                  ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          buildBottomSheet(context, controller, "front");
                                        },
                                        child: DottedBorder(
                                          options: RectDottedBorderOptions(
                                            dashPattern: const [6, 6],
                                            color: AppThemeData.grey600,
                                            strokeWidth: 1.5,
                                          ),
                                          child: Container(
                                            height: Responsive.height(20, context),
                                            width: Responsive.width(90, context),
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: Responsive.height(8, context),
                                                  width: Responsive.width(20, context),
                                                  decoration: const BoxDecoration(
                                                    color: AppThemeData.grey500,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  padding: const EdgeInsets.all(10),
                                                  child: SvgPicture.asset('assets/icons/ic_document.svg'),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Add photo".tr,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily: AppThemeData.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.documentModel.value.backSide == true ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Back side of ${controller.documentModel.value.title.toString()}",
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                controller.backImage.value.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          if (controller.documents.value.status == "rejected") {
                                            buildBottomSheet(context, controller, "back");
                                          }
                                        },
                                        child: SizedBox(
                                          height: Responsive.height(20, context),
                                          width: Responsive.width(90, context),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Constant().hasValidUrl(controller.backImage.value) == false
                                                ? Image.file(
                                                    File(controller.backImage.value),
                                                    height: Responsive.height(20, context),
                                                    width: Responsive.width(80, context),
                                                    fit: BoxFit.fill,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: controller.backImage.value.toString(),
                                                    fit: BoxFit.fill,
                                                    height: Responsive.height(20, context),
                                                    width: Responsive.width(80, context),
                                                    placeholder: (context, url) => Constant.loader(),
                                                    errorWidget: (context, url, error) => Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/goride-1a752.appspot.com/o/placeholderImages%2Fuser-placeholder.jpeg?alt=media&token=34a73d67-ba1d-4fe4-a29f-271d3e3ca115'),
                                                  ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          buildBottomSheet(context, controller, "back");
                                        },
                                        child: DottedBorder(
                                          options: RectDottedBorderOptions(
                                            dashPattern: const [6, 6],
                                            color: AppThemeData.grey600,
                                            strokeWidth: 1.5,
                                          ),
                                          child: SizedBox(
                                              height: Responsive.height(20, context),
                                              width: Responsive.width(90, context),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: Responsive.height(8, context),
                                                    width: Responsive.width(20, context),
                                                    decoration: const BoxDecoration(color: AppThemeData.grey500, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/ic_document.svg',
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Add photo".tr,
                                                    style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: controller.documents.value.status == "approved" || controller.documents.value.status == "uploaded" ? false : true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: RoundedButtonFill(
                              title: "Upload Document",
                              color: AppThemeData.primary300,
                              textColor: AppThemeData.grey50,
                              onPress: () {
                                if (controller.documentNumberController.value.text.isEmpty) {
                                  ShowToastDialog.showToast("Please enter document number".tr);
                                } else {
                                  if (controller.documentModel.value.frontSide == true && controller.frontImage.value.isEmpty) {
                                    ShowToastDialog.showToast("Please upload front side of document.".tr);
                                  } else if (controller.documentModel.value.backSide == true && controller.backImage.value.isEmpty) {
                                    ShowToastDialog.showToast("Please upload back side of document.".tr);
                                  } else {
                                    ShowToastDialog.showLoader("Please wait..".tr);
                                    controller.uploadDocument();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  buildBottomSheet(BuildContext context, DetailsUploadController controller, String type) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.camera, type: type),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Camera".tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.gallery, type: type),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Gallery".tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }
}
