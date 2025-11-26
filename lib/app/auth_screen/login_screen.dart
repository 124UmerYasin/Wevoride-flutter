import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/login_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LoginController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: true,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                  )),
              title: Text(
                controller.isLogin.value ? "Login".tr : "Sign up".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
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
                              onChanged: (value) {
                                controller.countryCodeController.value.text = value.dialCode.toString();
                              },
                              dialogTextStyle: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                              dialogBackgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                              initialSelection: controller.countryCodeController.value.text,
                              comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                              alignLeft: true,
                              flagDecoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                              textStyle: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                              searchDecoration: InputDecoration(iconColor: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900),
                              searchStyle: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
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
                      controller: controller.phoneNumber.value,
                      textInputType: TextInputType.number,
                    ),
                    RoundedButtonFill(
                      title: "Next".tr,
                      color: AppThemeData.primary300,
                      textColor: AppThemeData.grey50,
                      onPress: () {
                        if (controller.phoneNumber.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter mobile number".tr);
                        } else {
                          controller.sendCode();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                            child: Text(
                              "OR".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                fontSize: 12,
                                fontFamily: AppThemeData.medium,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.loginWithGoogle();
                      },
                      child: Container(
                        width: Responsive.width(100, context),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/ic_google.svg", height: 24, width: 24),
                            const SizedBox(width: 25),
                            Text(
                              'Continue with Google'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                fontSize: 14,
                                fontFamily: AppThemeData.semiBold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Platform.isIOS
                        ? InkWell(
                            onTap: () {
                              controller.loginWithApple();
                            },
                            child: Container(
                              width: Responsive.width(100, context),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/ic_apple.svg", height: 24, width: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Continue with apple'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                      fontSize: 14,
                                      fontFamily: AppThemeData.semiBold,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.isLogin.value == false ? 'Already a member? '.tr : 'Not a member yet? '.tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium, fontSize: 14),
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.isLogin.value == true) {
                                controller.isLogin.value = false;
                              } else {
                                controller.isLogin.value = true;
                              }
                            },
                            child: Text(
                              controller.isLogin.value == false ? 'Log in'.tr : 'Sign up'.tr,
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, fontFamily: AppThemeData.medium, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    controller.isLogin.value == false
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'By signing up, you accept our '.tr,
                                          style: const TextStyle(
                                            color: AppThemeData.grey600,
                                            fontSize: 12,
                                            fontFamily: AppThemeData.medium,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.to(
                                                const TermsAndConditionScreen(
                                                  type: "terms",
                                                ),
                                              );
                                            },
                                          text: 'T&Cs'.tr,
                                          style: TextStyle(
                                            color: AppThemeData.primary300,
                                            fontSize: 12,
                                            fontFamily: AppThemeData.bold,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      TextSpan(
                                          text: ' and '.tr,
                                          style: const TextStyle(
                                            color: AppThemeData.grey600,
                                            fontSize: 12,
                                            fontFamily: AppThemeData.medium,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      TextSpan(
                                          text: ' Privacy Policy '.tr,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.to(
                                                const TermsAndConditionScreen(
                                                  type: "privacy",
                                                ),
                                              );
                                            },
                                          style: TextStyle(
                                            color: AppThemeData.primary300,
                                            fontSize: 12,
                                            fontFamily: AppThemeData.bold,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    'This Information is collected by WevoRide for the purpose of creating your account, managing your booking, using and improving our service and ensuring the security if our platform'
                                        .tr,
                                    style: const TextStyle(
                                      color: AppThemeData.grey600,
                                      fontSize: 12,
                                      fontFamily: AppThemeData.medium,
                                      fontWeight: FontWeight.w500,
                                    ))
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
