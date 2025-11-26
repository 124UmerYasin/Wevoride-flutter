import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/information_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: InformationController(),
      builder: (controller) {
        return CustomScaffold(
          backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
          appBar: AppBar(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
            centerTitle: true,
            leading: InkWell(
                onTap: () {
                  if (controller.currentPage.value == 1) {
                    Get.back();
                  } else {
                    controller.currentPage.value -= 1;
                  }
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                )),
            title: Text(
              "Finishing Sign up".tr,
              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Step ${controller.currentPage.value} of 4",
                        style: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, fontFamily: AppThemeData.medium),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LinearProgressIndicator(
                        backgroundColor: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                        valueColor: AlwaysStoppedAnimation<Color>(AppThemeData.primary300),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        value: controller.currentPage.value / 4,
                      ),
                      const SizedBox(
                        height: 42,
                      ),
                      controller.currentPage.value == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What’s your name?".tr,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                    fontFamily: AppThemeData.semiBold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFieldWidget(
                                  hintText: 'Enter your first name'.tr,
                                  controller: controller.firstNameController.value,
                                ),
                                TextFieldWidget(
                                  hintText: 'Enter your last name'.tr,
                                  controller: controller.lastNameController.value,
                                ),
                                Text(
                                  "Enter the same as on your government ID.".tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                    fontFamily: AppThemeData.regular,
                                  ),
                                ),
                              ],
                            )
                          : controller.currentPage.value == 2
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "What’s your ${controller.loginType.value != Constant.phoneLoginType ? "phone number?" : "email address?"}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                        fontFamily: AppThemeData.semiBold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    controller.loginType.value != Constant.phoneLoginType
                                        ? Column(
                                            children: [
                                              Container(
                                                width: Responsive.width(100, context),
                                                decoration: BoxDecoration(
                                                  color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: CountryCodePicker(
                                                        onChanged: (value) {},
                                                        dialogTextStyle: TextStyle(
                                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                                                        dialogBackgroundColor: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                                                        initialSelection: controller.countryCode.value.text,
                                                        comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                                        alignLeft: true,
                                                        flagDecoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(2)),
                                                        ),
                                                        textStyle: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                                        searchDecoration: InputDecoration(iconColor: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900),
                                                        searchStyle: TextStyle(
                                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                                      child: Icon(Icons.keyboard_arrow_down),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFieldWidget(
                                                hintText: 'Enter phone number'.tr,
                                                controller: controller.phoneNumberController.value,
                                                textInputType: TextInputType.number,
                                              ),
                                            ],
                                          )
                                        : TextFieldWidget(
                                            hintText: 'Enter your email address'.tr,
                                            controller: controller.emailController.value,
                                          ),
                                  ],
                                )
                              : controller.currentPage.value == 3
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "What’s your date of birth?".tr,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontFamily: AppThemeData.semiBold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                            hintText: 'MMMM dd,yyyy',
                                            controller: controller.dateOfBirthController.value,
                                            enable: false,
                                          ),
                                        ),
                                        Text(
                                          "Enter the same DOB  as on your government ID.".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                            fontFamily: AppThemeData.regular,
                                          ),
                                        ),
                                      ],
                                    )
                                  : controller.currentPage.value == 4
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "How would you like to be addressed?".tr,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                fontFamily: AppThemeData.semiBold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, borderRadius: BorderRadius.circular(10)),
                                              child: Column(
                                                children: [
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
                                            ),
                                          ],
                                        )
                                      : const SizedBox()
                    ],
                  ),
                ),
                RoundedButtonFill(
                  title: "Next".tr,
                  color: AppThemeData.primary300,
                  textColor: AppThemeData.grey50,
                  onPress: () {
                    if (controller.currentPage.value != 4) {
                      if (controller.currentPage.value == 1) {
                        if (controller.firstNameController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter first name".tr);
                        } else if (controller.lastNameController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter last name".tr);
                        } else {
                          controller.currentPage.value += 1;
                        }
                      } else if (controller.currentPage.value == 2) {
                        if (controller.loginType.value != Constant.phoneLoginType) {
                          if (controller.phoneNumberController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter phone number".tr);
                          } else {
                            controller.currentPage.value += 1;
                          }
                        } else {
                          if (controller.emailController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter email adders".tr);
                          } else if (Constant.validateEmail(controller.emailController.value.text) == false) {
                            ShowToastDialog.showToast("Please enter valid email address".tr);
                          } else {
                            controller.currentPage.value += 1;
                          }
                        }
                      } else if (controller.currentPage.value == 3) {
                        if (controller.dateOfBirthController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please select date of birth".tr);
                        } else {
                          controller.currentPage.value += 1;
                        }
                      }
                    } else {
                      controller.createAccount();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
