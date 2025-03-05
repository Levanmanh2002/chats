import 'package:chats/main.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInfoMemeberBottomBottomSheet(
  UserModel user, {
  required int? chatId,
  String? title,
  VoidCallback? onDelete,
  VoidCallback? onSendChat,
}) {
  showModalBottomSheet(
    context: Get.context!,
    backgroundColor: appTheme.whiteColor,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: Get.back, icon: const SizedBox()),
                Text(title ?? 'member_information'.tr, style: StyleThemeData.size16Weight600()),
                IconButton(onPressed: Get.back, icon: const Icon(Icons.clear)),
              ],
            ),
            Padding(
              padding: padding(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  CustomImageWidget(
                    imageUrl: user.avatar ?? '',
                    size: 54,
                    showBoder: true,
                    colorBoder: appTheme.allSidesColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      user.name ?? '',
                      style: StyleThemeData.size16Weight600(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      if (chatId != null) {
                        Get.toNamed(
                          Routes.CALL,
                          arguments: CallCallParameter(
                            id: user.id ?? DateTime.now().millisecondsSinceEpoch,
                            messageId: chatId,
                            callId: null,
                            name: user.name ?? '',
                            avatar: user.avatar ?? '',
                            channel: 'channel',
                            type: CallType.call,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: padding(all: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.blueFFColor,
                      ),
                      child: ImageAssetCustom(imagePath: IconsAssets.phoneRoundedIcon, size: 22.w),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  InkWell(
                    onTap: onSendChat,
                    child: Container(
                      padding: padding(all: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.blueFFColor,
                      ),
                      child: ImageAssetCustom(imagePath: IconsAssets.chatsIcon, size: 22.w),
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              InkWell(
                onTap: () {
                  Get.back();
                  onDelete.call();
                },
                child: Padding(
                  padding: padding(vertical: 12, horizontal: 16),
                  child:
                      Text('remove_from_group'.tr, style: StyleThemeData.size14Weight600(color: appTheme.errorColor)),
                ),
              ),
            SizedBox(height: 24.h),
          ],
        ),
      );
    },
  );
}
