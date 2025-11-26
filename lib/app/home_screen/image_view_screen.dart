import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class ImageViewScreen extends StatelessWidget {
  final String? imageUrl;
  const ImageViewScreen({super.key,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CustomScaffold(
      appBar: AppBar(
       backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
        centerTitle: false,
        titleSpacing: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
              child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
            height: 4.0,
          ),
        ),
      ),
      body: Center(
        child: NetworkImageWidget(
          width: Responsive.width(100, context),
          height: Responsive.height(80, context),
          imageUrl: imageUrl.toString(),
        ),
      ),
    );
  }
}
