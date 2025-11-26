import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final int? maxLine;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  final ValueChanged<String>? onChanged;

  const TextFieldWidget(
      {super.key,
      this.textInputType,
      this.enable,
      this.prefix,
      this.suffix,
      this.title,
      required this.hintText,
      required this.controller,
      this.maxLine,
      this.inputFormatters,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        maxLines: maxLine ?? 1,
        textInputAction: TextInputAction.done,
        inputFormatters: inputFormatters,
        style: TextStyle(
            fontSize: 14,
            color: themeChange.getThem()
                ? AppThemeData.grey50
                : AppThemeData.grey900,
            fontFamily: AppThemeData.medium),
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red),
          filled: true,
          enabled: enable ?? true,
          contentPadding: EdgeInsets.symmetric(
              vertical: title == null ? 12 : 8, horizontal: 10),
          fillColor: themeChange.getThem()
              ? AppThemeData.grey800
              : AppThemeData.grey100,
          prefixIcon: prefix,
          suffixIcon: suffix,
          labelText: title,
          labelStyle: TextStyle(
              height: 1,
              fontFamily: AppThemeData.semiBold,
              fontSize: 14,
              color: themeChange.getThem()
                  ? AppThemeData.grey100
                  : AppThemeData.grey800),
          disabledBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: themeChange.getThem()
                    ? AppThemeData.grey800
                    : AppThemeData.grey100,
                width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: themeChange.getThem()
                    ? AppThemeData.primary300
                    : AppThemeData.primary300,
                width: 1),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: themeChange.getThem()
                    ? AppThemeData.grey800
                    : AppThemeData.grey100,
                width: 1),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: themeChange.getThem()
                    ? AppThemeData.grey800
                    : AppThemeData.grey100,
                width: 1),
          ),
          border: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: themeChange.getThem()
                    ? AppThemeData.grey800
                    : AppThemeData.grey100,
                width: 1),
          ),
          hintText: hintText.tr,
          hintStyle: TextStyle(
            fontSize: 14,
            color: themeChange.getThem()
                ? AppThemeData.grey200
                : AppThemeData.grey700,
            fontFamily: AppThemeData.regular,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
