import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ImageAssetCustom(imagePath: ImagesAssets.topBgChatImage),
            ],
          ),
        ],
      ),
    );
  }
}
