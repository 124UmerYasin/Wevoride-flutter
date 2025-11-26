import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wevoride/app/on_boarding_screen/get_started_screen.dart';
import 'package:wevoride/app/terms_and_condition/terms_and_condition_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/accessibility_controller.dart';
import 'package:wevoride/model/language_model.dart';
import 'package:wevoride/services/localization_service.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/custom_dialog_box.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AccessibilityController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leading: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              title: Text(
                "Accessibility".tr,
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
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Dark Mode".tr,
                                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: controller.isDarkModeSwitch.value,
                                activeColor: AppThemeData.primary300,
                                onChanged: (value) {
                                  controller.isDarkModeSwitch.value = value;
                                  if (controller.isDarkModeSwitch.value == true) {
                                    Preferences.setString(Preferences.themKey, "Dark");
                                    themeChange.darkTheme = 0;
                                  } else if (controller.isDarkMode.value == "Light") {
                                    Preferences.setString(Preferences.themKey, "Light");
                                    themeChange.darkTheme = 1;
                                  } else {
                                    Preferences.setString(Preferences.themKey, "");
                                    themeChange.darkTheme = 2;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            languageBuildBottomSheet(context);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Language".tr,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                ),
                              ),
                              Text(
                                controller.selectedLanguage.value.name.toString(),
                                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                              ),
                              const Icon(Icons.chevron_right_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final InAppReview inAppReview = InAppReview.instance;
                            inAppReview.requestReview();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Rate the app".tr,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.chevron_right_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Get.to(
                              const TermsAndConditionScreen(
                                type: "privacy",
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Privacy Policy".tr,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.chevron_right_outlined)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Get.to(
                              const TermsAndConditionScreen(
                                type: "terms",
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Terms and Conditions".tr,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                ),
                              ),
                              const Icon(Icons.chevron_right_outlined)
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    title: "Delete Account".tr,
                                    descriptions: "This will permanently delete your account and all associated data. Are you sure?".tr,
                                    positiveString: "OK".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      ShowToastDialog.showLoader("Please wait".tr);
                                      await FireStoreUtils.deleteUser().then((value) {
                                        ShowToastDialog.closeLoader();
                                        if (value == true) {
                                          ShowToastDialog.showToast("Account deleted successfully".tr);
                                          Get.offAll(const GetStartedScreen());
                                        } else {
                                          ShowToastDialog.showToast("Contact Administrator".tr);
                                        }
                                      });
                                    },
                                    negativeClick: () {
                                      Get.back();
                                    },
                                    img: Image.asset(
                                      'assets/images/ic_delete.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Text(
                                "Delete Account".tr,
                                style: TextStyle(color: themeChange.getThem() ? AppThemeData.warning300 : AppThemeData.warning300, fontFamily: AppThemeData.medium, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  languageBuildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.50,
        minChildSize: 0.50,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return GetX(
              init: AccessibilityController(),
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Change language".tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontFamily: AppThemeData.bold),
                              ),
                            ),
                          ),
                          InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: controller.languageList.isEmpty
                            ? Constant.showEmptyView(message: "Language not found".tr, isDarkMode: themeChange.getThem())
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: controller.languageList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  LanguageModel languageModel = controller.languageList[index];
                                  return Obx(
                                    () => InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        controller.selectedLanguage.value = languageModel;
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  languageModel.name.toString(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium),
                                                ),
                                              ),
                                              Radio(
                                                value: languageModel,
                                                groupValue: controller.selectedLanguage.value,
                                                activeColor: AppThemeData.primary300,
                                                onChanged: (value) {
                                                  controller.selectedLanguage.value = value!;
                                                },
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedButtonFill(
                        title: "Change",
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        onPress: () {
                          LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                          Preferences.setString(
                            Preferences.languageCodeKey,
                            jsonEncode(
                              controller.selectedLanguage.value,
                            ),
                          );
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
