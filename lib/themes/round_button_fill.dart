import 'package:flutter/material.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';

class RoundedButtonFill extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double? fontSizes;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final bool? isRight;
  final Function()? onPress;

  const RoundedButtonFill({super.key, required this.title, this.height, required this.onPress, this.width, this.color, this.icon, this.fontSizes, this.textColor, this.isRight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPress!();
      },
      child: Container(
        width: Responsive.width(width ?? 100, context),
        height: Responsive.height(height ?? 6, context),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (isRight == false) ? Padding(padding: const EdgeInsets.only(right: 5), child: icon) : const SizedBox(),
            Text(
              title.toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontFamily: AppThemeData.semiBold,
                color: textColor ?? AppThemeData.grey800,
                fontSize: fontSizes ?? 14,
              ),
            ),
            (isRight == true) ? Padding(padding: const EdgeInsets.only(left: 5), child: icon) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class RoundedButtonFillAutoWidth extends StatelessWidget {
  final String title;
  final double? fontSizes;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final bool? isRight;
  final Function()? onPress;

  const RoundedButtonFillAutoWidth({super.key, required this.title, required this.onPress, this.color, this.icon, this.fontSizes, this.textColor, this.isRight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPress!();
      },
      child: Container(
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title.toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontFamily: AppThemeData.semiBold,
                color: textColor ?? AppThemeData.grey800,
                fontSize: fontSizes ?? 14,
              ),
            ),
          )),
    );
  }
}
