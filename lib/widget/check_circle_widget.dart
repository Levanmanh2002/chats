import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:flutter/material.dart';

class CheckCircleWidget extends StatelessWidget {
  const CheckCircleWidget({
    super.key,
    this.isSelect = false,
    this.onTap,
  });

  final bool isSelect;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ImageAssetCustom(
        imagePath: isSelect ? IconsAssets.checkActiveCircleIcon : IconsAssets.checkCircleIcon,
        size: 24,
      ),
    );
  }
}
