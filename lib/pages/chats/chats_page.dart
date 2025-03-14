import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/view/chat_all_view.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/popup/popup.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: SearchAppbar(
          isShowBack: true,
          isOffSearch: true,
          leftTitle: 16,
          backgroundColor: appTheme.appColor,
          title: 'chat'.tr,
          onSubmitted: controller.onSearchChat,
          action: Padding(
            padding: padding(vertical: 16, right: 16),
            child: CustomPopup(
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
          ),
        ),
        body: Column(
          children: [
            // HeaderChatView(),
            Expanded(child: ChatAllView()),
          ],
        ),
      ),
    );
  }
}
