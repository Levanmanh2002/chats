import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';

class BorderTitleIconWidget extends StatelessWidget {
  const BorderTitleIconWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.child,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: padding(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1.w, color: appTheme.allSidesColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageAssetCustom(imagePath: icon, size: 24.w, color: appTheme.blackColor),
                SizedBox(width: 12.w),
                Text(title, style: StyleThemeData.size14Weight400()),
              ],
            ),
            child ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
