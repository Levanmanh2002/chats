import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnderDevWidget extends StatelessWidget {
  const UnderDevWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: title),
      body: Padding(
        padding: padding(all: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageAssetCustom(imagePath: ImagesAssets.underDevelopmentImage),
            SizedBox(height: 12.h),
            Text(
              'under_dev_title'.tr,
              style: StyleThemeData.size20Weight600(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              'under_dev_content'.tr,
              style: StyleThemeData.size12Weight400(color: appTheme.oldSilverColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
