import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/report_help_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class ReportHelpScreen extends StatelessWidget {
  const ReportHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ReportHelpController(),
        builder: (controller) {
          return CustomScaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason'.tr, style: TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800)),
                        const SizedBox(
                          height: 5,
                        ),
                        controller.reportedBy.value == "publisher"
                            ? DropdownButtonFormField<dynamic>(
                                dropdownColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                hint: Text(
                                  'Select reason'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                    fontFamily: AppThemeData.regular,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(color: Colors.red),
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
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
                                ),
                                value: controller.selectedReasons.value.isEmpty ? null : controller.selectedReasons.value,
                                onChanged: (value) {
                                  controller.selectedReasons.value = value!;
                                  controller.update();
                                },
                                style: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                items: controller.publisherList.map((item) {
                                  return DropdownMenuItem<dynamic>(
                                    value: item.toString(),
                                    child: Text(item.toString()),
                                  );
                                }).toList())
                            : DropdownButtonFormField<dynamic>(
                                dropdownColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                hint: Text(
                                  'Select reason'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                    fontFamily: AppThemeData.regular,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(color: Colors.red),
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
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
                                ),
                                value: controller.selectedReasons.value.isEmpty ? null : controller.selectedReasons.value,
                                onChanged: (value) {
                                  controller.selectedReasons.value = value!;
                                  controller.update();
                                },
                                style: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                items: controller.customerList.map((item) {
                                  return DropdownMenuItem<dynamic>(
                                    value: item,
                                    child: Text(item.toString()),
                                  );
                                }).toList()),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          controller: controller.descriptionController.value,
                          title: 'Describe'.tr,
                          maxLine: 5,
                          hintText: '',
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RoundedButtonFill(
                          title: "Submit".tr,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          onPress: () {
                            if (controller.selectedReasons.isEmpty) {
                              ShowToastDialog.showToast("Please select reason".tr);
                            } else if (controller.descriptionController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter description".tr);
                            } else {
                              controller.publishReport();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
