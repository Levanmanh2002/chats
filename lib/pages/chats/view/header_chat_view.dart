import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/popup/popup.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderChatView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ImageAssetCustom(imagePath: ImagesAssets.topBgChatImage),
        Positioned(
          bottom: 12,
          left: 16,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('chat'.tr, style: StyleThemeData.size30Weight600(color: appTheme.whiteColor)),
              CustomPopup(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.ADD_FRIEND);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageAssetCustom(imagePath: IconsAssets.userPlusRoundedIcon, size: 24.w),
                          SizedBox(width: 12.w),
                          Text('add_friend'.tr, style: StyleThemeData.size14Weight400()),
                          SizedBox(width: 24.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.toNamed(
                          Routes.CREATE_GROUP,
                          arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageAssetCustom(imagePath: IconsAssets.addGroupIcon, size: 24.w),
                          SizedBox(width: 12.w),
                          Text('create_group'.tr, style: StyleThemeData.size14Weight400()),
                          SizedBox(width: 24.w),
                        ],
                      ),
                    ),
                  ],
                ),
                child: const ImageAssetCustom(imagePath: IconsAssets.addIcon),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
