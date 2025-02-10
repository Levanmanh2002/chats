import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/main.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
    this.imageUrl = '',
    this.size = 24,
    this.borderRadius = 1000,
    this.width,
    this.height,
    this.showBoder = false,
    this.colorBoder,
    this.color,
    this.fit,
    this.noImage = true,
    this.sizeBorder,
  });

  final String imageUrl;
  final double size;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool showBoder;
  final Color? colorBoder;
  final Color? color;
  final BoxFit? fit;
  final bool noImage;
  final double? sizeBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBoder ? Border.all(width: sizeBorder ?? 1.w, color: colorBoder ?? appTheme.grayColor) : null,
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.cover,
          placeholder: (context, url) => noImage == true
              ? ImageAssetCustom(
                  imagePath: ImagesAssets.placeholder,
                  boxFit: BoxFit.cover,
                  size: size,
                )
              : ImageAssetCustom(
                  imagePath: ImagesAssets.noProfileImage,
                  boxFit: BoxFit.cover,
                  size: size,
                ),
          errorWidget: (context, url, error) => noImage == true
              ? ImageAssetCustom(
                  imagePath: ImagesAssets.placeholder,
                  boxFit: BoxFit.cover,
                  size: size,
                )
              : ImageAssetCustom(
                  imagePath: ImagesAssets.noProfileImage,
                  size: size,
                  boxFit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
