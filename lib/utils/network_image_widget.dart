import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/themes/responsive.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;
  final FilterQuality filterQuality;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
    this.filterQuality = FilterQuality.low,
  });

  @override
  Widget build(BuildContext context) {
    // Check if imageUrl is empty, null, or "null" string to prevent "No host specified in URI" error
    final trimmedUrl = imageUrl.trim();
    if (trimmedUrl.isEmpty || trimmedUrl == "null") {
      return errorWidget ??
          Image.asset(
            Constant.userPlaceHolder,
            fit: fit ?? BoxFit.fitWidth,
            height: height ?? Responsive.height(8, context),
            width: width ?? Responsive.width(15, context),
          );
    }
    
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      height: height ?? Responsive.height(8, context),
      width: width ?? Responsive.width(15, context),
      color: color,
      filterQuality: filterQuality,
      progressIndicatorBuilder: (context, url, downloadProgress) => Constant.loader(),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Image.asset(
            Constant.userPlaceHolder,
            fit: fit ?? BoxFit.fitWidth,
            height: height ?? Responsive.height(8, context),
            width: width ?? Responsive.width(15, context),
          ),
    );
  }
}
