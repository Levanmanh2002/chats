import 'dart:io';

import 'package:chats/main.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:flutter/material.dart';

class SelectableImageView extends StatelessWidget {
  final String fileUrl;
  final double size;
  final double borderRadius;
  final bool isLocal;

  const SelectableImageView({
    super.key,
    required this.fileUrl,
    required this.size,
    this.borderRadius = 8.0,
    this.isLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLocal == true
        ? ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.file(
              File(fileUrl),
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          )
        : CustomImageWidget(
            imageUrl: fileUrl,
            size: size,
            borderRadius: borderRadius,
            placeholder: Center(child: CircularProgressIndicator(color: appTheme.appColor)),
          );
  }
}
