import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/message_text_view.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showReactionPopup(
  String message, {
  required bool isCurrentUser,
  VoidCallback? onRevoke,
  VoidCallback? onHeart,
  VoidCallback? onReply,
  VoidCallback? onForward,
}) {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    barrierColor: Colors.black.withOpacity(0.7),
    backgroundColor: appTheme.transparentColor,
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: padding(horizontal: 16, bottom: 45),
          child: Align(
            alignment: isCurrentUser ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 300.w),
                      padding: padding(all: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isCurrentUser ? appTheme.appColor : appTheme.whiteColor,
                      ),
                      child: MessageTextView(
                        message: message,
                        textStyle: StyleThemeData.size14Weight400(
                          color: isCurrentUser ? appTheme.whiteColor : appTheme.blackColor,
                        ),
                        color: isCurrentUser ? appTheme.whiteColor : appTheme.blackColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () {
                    onHeart!();
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: padding(all: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: appTheme.whiteColor,
                    ),
                    child: const ImageAssetCustom(imagePath: IconsAssets.heartColorIcon),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: appTheme.whiteColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onReply != null)
                        InkWell(
                          onTap: () {
                            onReply();
                            Get.back();
                          },
                          child: Padding(
                            padding: padding(all: 12),
                            child: Column(
                              children: [
                                ImageAssetCustom(imagePath: IconsAssets.replyLineIcon, size: 24.w),
                                SizedBox(height: 4.h),
                                Text('reply'.tr, style: StyleThemeData.size12Weight400()),
                              ],
                            ),
                          ),
                        ),
                      if (onForward != null)
                        InkWell(
                          onTap: () {
                            Get.back();
                            onForward();
                          },
                          child: Padding(
                            padding: padding(all: 12),
                            child: Column(
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                                  child: ImageAssetCustom(imagePath: IconsAssets.replyLineIcon, size: 24.w),
                                ),
                                SizedBox(height: 4.h),
                                Text('forward'.tr, style: StyleThemeData.size12Weight400()),
                              ],
                            ),
                          ),
                        ),
                      if (onRevoke != null)
                        InkWell(
                          onTap: () {
                            onRevoke();
                            Get.back();
                          },
                          child: Padding(
                            padding: padding(all: 12),
                            child: Column(
                              children: [
                                ImageAssetCustom(imagePath: IconsAssets.unreadIcon, size: 24.w),
                                SizedBox(height: 4.h),
                                Text('revoke'.tr, style: StyleThemeData.size12Weight400()),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
