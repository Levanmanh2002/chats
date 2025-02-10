import 'package:chats/main.dart';
import 'package:chats/pages/splash/splash_controller.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      body: Center(
        child: ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage, width: 185.w),
      ),
    );
  }
}
