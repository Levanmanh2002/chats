import 'dart:io';

import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CustomFileImage extends StatelessWidget {
  const CustomFileImage({
    super.key,
    this.file,
    this.byte,
    this.boxFit,
    this.height,
    this.width,
    this.size,
  });

  final XFile? file;
  final Uint8List? byte;
  final double? size;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Image.file(
        File(file!.path),
        height: size ?? height,
        width: size ?? width,
        fit: boxFit,
        errorBuilder: (context, error, stackTrace) => const ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage),
      );
    } else if (byte != null) {
      return Image.memory(
        byte!,
        height: size ?? height,
        width: size ?? width,
        fit: boxFit,
        errorBuilder: (context, error, stackTrace) => const ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage),
      );
    }

    return const SizedBox();
  }
}
