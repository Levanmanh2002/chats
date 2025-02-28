import 'package:chats/main.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_option/group_option_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/group_avatar_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMessageHeaderView extends GetView<GroupMessageController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          const ImageAssetCustom(imagePath: ImagesAssets.topBgChatImage),
          SafeArea(
            child: Padding(
              padding: padding(all: 16),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size.zero,
                      fixedSize: Size(36.w, 36.w),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      maximumSize: Size(36.w, 36.w),
                    ),
                    icon: ImageAssetCustom(imagePath: IconsAssets.arrowLeftIcon, color: appTheme.whiteColor),
                    onPressed: Get.back,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Obx(
                      () => InkWell(
                        onTap: controller.messageModel.value != null
                            ? () => Get.toNamed(
                                  Routes.GROUP_OPTION,
                                  arguments: GroupOptionParameter(
                                    chat: controller.messageModel.value?.chat,
                                    isHideMessage: controller.messageModel.value?.chat?.isHide ?? false,
                                  ),
                                )
                            : null,
                        child: Row(
                          children: [
                            GroupAvatarWidget(
                              imageUrls:
                                  controller.messageModel.value?.chat?.users?.map((e) => e.avatar ?? '').toList() ?? [],
                              size: 46.w,
                              showBoder: true,
                              colorBoder: appTheme.allSidesColor,
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.messageModel.value?.chat?.name ?? 'not_updated_yet'.tr,
                                    style: StyleThemeData.size14Weight600(color: appTheme.whiteColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'field_members'.trParams(
                                      {'field': controller.messageModel.value?.chat?.users?.length.toString() ?? '0'},
                                    ),
                                    style: StyleThemeData.size10Weight400(color: appTheme.whiteColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size.zero,
                      fixedSize: Size(36.w, 36.w),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      maximumSize: Size(36.w, 36.w),
                    ),
                    icon: ImageAssetCustom(imagePath: IconsAssets.searchIcon, color: appTheme.whiteColor),
                    onPressed: () {},
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size.zero,
                      fixedSize: Size(36.w, 36.w),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      maximumSize: Size(36.w, 36.w),
                    ),
                    icon: ImageAssetCustom(imagePath: IconsAssets.phoneIcon, color: appTheme.whiteColor),
                    onPressed: () {},
                  ),
                  // IconButton(
                  //   style: IconButton.styleFrom(
                  //     minimumSize: Size.zero,
                  //     fixedSize: Size(36.w, 36.w),
                  //     padding: EdgeInsets.zero,
                  //     alignment: Alignment.center,
                  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //     maximumSize: Size(36.w, 36.w),
                  //   ),
                  //   icon: ImageAssetCustom(imagePath: IconsAssets.listIcon, color: appTheme.whiteColor),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
