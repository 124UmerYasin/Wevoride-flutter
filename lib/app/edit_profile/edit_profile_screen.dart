import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/edit_profile_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: EditProfileController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
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
                "Edit Profile".tr,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  controller.profileImage.isEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: Image.asset(
                                            Constant.userPlaceHolder,
                                            height: Responsive.width(24, context),
                                            width: Responsive.width(24, context),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Constant().hasValidUrl(controller.profileImage.value) == false
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: Image.file(
                                                File(controller.profileImage.value),
                                                height: Responsive.width(24, context),
                                                width: Responsive.width(24, context),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: NetworkImageWidget(
                                                fit: BoxFit.cover,
                                                imageUrl: controller.userModel.value.profilePic.toString(),
                                                height: Responsive.width(24, context),
                                                width: Responsive.width(24, context),
                                              ),
                                            ),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                          onTap: () {
                                            buildBottomSheet(context, controller);
                                          },
                                          child: SvgPicture.asset("assets/icons/ic_edit.svg")))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                hintText: 'Enter your first name'.tr,
                                controller: controller.firstNameController.value,
                                title: 'First name'.tr,
                              ),
                              TextFieldWidget(
                                hintText: 'Enter your last name'.tr,
                                controller: controller.lastNameController.value,
                                title: 'Last name'.tr,
                              ),
                              InkWell(
                                onTap: () async {
                                  await Constant.selectPastDate(context).then((value) {
                                    if (value != null) {
                                      controller.dateOfBirthController.value.text = DateFormat('MMMM dd,yyyy').format(value);
                                    }
                                  });
                                },
                                child: TextFieldWidget(
                                  hintText: 'Enter your date of Birth'.tr,
                                  controller: controller.dateOfBirthController.value,
                                  title: 'Date of birth'.tr,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SvgPicture.asset('assets/icons/ic_calender.svg'),
                                  ),
                                  enable: false,
                                ),
                              ),
                              TextFieldWidget(
                                hintText: 'Bio'.tr,
                                controller: controller.bioController.value,
                                title: 'Bio'.tr,
                                maxLine: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "How would you like to be addressed?".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                        fontFamily: AppThemeData.semiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.preAddressOfName.value = "Mr.";
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Mr.".tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          )),
                                          Radio(
                                            value: "Mr.",
                                            groupValue: controller.preAddressOfName.value,
                                            activeColor: AppThemeData.primary300,
                                            onChanged: (value) {
                                              controller.preAddressOfName.value = "Mr.";
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.preAddressOfName.value = "Ms./Mrs.";
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Ms./Mrs.".tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          )),
                                          Radio(
                                            value: "Ms./Mrs.",
                                            groupValue: controller.preAddressOfName.value,
                                            activeColor: AppThemeData.primary300,
                                            onChanged: (value) {
                                              controller.preAddressOfName.value = "Ms./Mrs.";
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.preAddressOfName.value = "I’d rather not say";
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "I’d rather not say".tr,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          )),
                                          Radio(
                                            value: "I’d rather not say",
                                            groupValue: controller.preAddressOfName.value,
                                            activeColor: AppThemeData.primary300,
                                            onChanged: (value) {
                                              controller.preAddressOfName.value = "I’d rather not say";
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        PreferredSize(
                          preferredSize: const Size.fromHeight(4.0),
                          child: Container(
                            color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                            height: 4.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contact Information".tr,
                                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                hintText: 'Email ID'.tr,
                                controller: controller.emailController.value,
                                title: 'Email ID'.tr,
                                enable: false,
                              ),
                              TextFieldWidget(
                                hintText: 'Region'.tr,
                                controller: controller.countryCodeController.value,
                                title: 'Region'.tr,
                                enable: false,
                              ),
                              // Container(
                              //   width: Responsive.width(100, context),
                              //   decoration: BoxDecoration(
                              //     color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                              //     borderRadius: const BorderRadius.all(
                              //       Radius.circular(10),
                              //     ),
                              //   ),
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: [
                              //       Expanded(
                              //         child: CountryCodePicker(
                              //           onChanged: (value) {
                              //             // controller.countryCodeController.value.text = value.dialCode.toString();
                              //           },
                              //           dialogTextStyle: TextStyle(
                              //               color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                              //               fontWeight: FontWeight.w500,
                              //               fontFamily: AppThemeData.medium),
                              //           dialogBackgroundColor: themeChange.getThem() ? AppThemeData.grey11 : AppThemeData.grey02,
                              //           initialSelection: controller.countryCodeController.value.text,
                              //           comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                              //           alignLeft: true,
                              //           flagDecoration: const BoxDecoration(
                              //             borderRadius: BorderRadius.all(Radius.circular(2)),
                              //           ),
                              //           textStyle:
                              //               TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                              //           searchDecoration: InputDecoration(iconColor: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900),
                              //           searchStyle: TextStyle(
                              //               color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                              //               fontWeight: FontWeight.w500,
                              //               fontFamily: AppThemeData.medium),
                              //         ),
                              //       ),
                              //       const Padding(
                              //         padding: EdgeInsets.symmetric(horizontal: 16),
                              //         child: Icon(Icons.keyboard_arrow_down),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              TextFieldWidget(
                                hintText: 'Phone number'.tr,
                                controller: controller.phoneNumberController.value,
                                title: 'Phone number'.tr,
                                enable: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: SafeBottomWidget(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PreferredSize(
                    preferredSize: const Size.fromHeight(4.0),
                    child: Container(
                      color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                      height: 4.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RoundedButtonFill(
                    title: "Save".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    onPress: () async {
                      controller.saveData();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildBottomSheet(BuildContext context, EditProfileController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("please select".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
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
                                onPressed: () => controller.pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "camera".tr,
                                style: const TextStyle(),
                              ),
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
                              onPressed: () => controller.pickFile(source: ImageSource.gallery),
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "gallery".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
