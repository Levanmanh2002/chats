import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/message_text_view.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showReactionPopup(String message, {required bool isCurrentUser, VoidCallback? onRevoke, VoidCallback? onHeart}) {
  showModalBottomSheet(
    context: Get.context!,
    barrierColor: Colors.black.withOpacity(0.7),
    backgroundColor: appTheme.transparentColor,
    builder: (context) {
      return Padding(
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
              if (onRevoke != null) ...[
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () {
                    onRevoke();
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: padding(all: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: appTheme.whiteColor,
                    ),
                    child: Column(
                      children: [
                        ImageAssetCustom(imagePath: IconsAssets.trashBinIcon, color: appTheme.errorColor),
                        SizedBox(height: 4.h),
                        Text('revoke'.tr, style: StyleThemeData.size12Weight400()),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
