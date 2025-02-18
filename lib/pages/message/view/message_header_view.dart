import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/options/options_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageHeaderView extends GetView<MessageController> {
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
                    child: InkWell(
                      onTap: controller.parameter.chatId != null
                          ? () => Get.toNamed(
                                Routes.OPTIONS,
                                arguments: OptionsParameter(
                                  user: controller.parameter.contact,
                                  chatId: controller.parameter.chatId!,
                                ),
                              )
                          : null,
                      child: Row(
                        children: [
                          CustomImageWidget(
                            imageUrl: controller.parameter.contact?.avatar ?? '',
                            size: 46.w,
                            colorBoder: appTheme.appColor,
                            showBoder: true,
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.parameter.contact?.name ?? 'not_updated_yet'.tr,
                                  style: StyleThemeData.size14Weight600(color: appTheme.whiteColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  controller.parameter.contact?.lastOnline?.timeAgo ?? '',
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
