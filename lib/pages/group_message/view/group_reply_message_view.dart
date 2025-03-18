import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/chats/attach_file_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupReplyMessageView extends GetView<GroupMessageController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(all: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        color: const Color(0xE5FFFFFF),
        border: Border(
          bottom: BorderSide(color: appTheme.allSidesColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          (controller.messageReply.value?.files ?? []).isNotEmpty
              ? Expanded(
                  child: Row(
                    children: [
                      if (controller.messageReply.value?.files?.first.fileType?.getFileCategory ==
                          FileCategory.DOCUMENT) ...[
                        ImageAssetCustom(imagePath: IconsAssets.paperclipIcon, size: 24.w),
                      ] else ...[
                        AttachFileWidget(
                          item: controller.messageReply.value!.files!.first,
                          size: 32.w,
                          borderRadius: 2,
                        ),
                      ],
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.messageReply.value?.sender?.name ?? '',
                              style: StyleThemeData.size12Weight600(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              controller.messageReply.value?.files?.first.fileType?.getFileCategory ==
                                      FileCategory.IMAGE
                                  ? 'image_line'.tr
                                  : controller.messageReply.value?.files?.first.fileType?.getFileCategory ==
                                          FileCategory.VIDEO
                                      ? 'video_line'.tr
                                      : 'attachment_line'.tr,
                              style: StyleThemeData.size8Weight400(color: appTheme.grayColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Row(
                    children: [
                      const ImageAssetCustom(imagePath: IconsAssets.replyIcon),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.messageReply.value?.sender?.name ?? '',
                              style: StyleThemeData.size12Weight600(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              controller.messageReply.value?.message ?? '',
                              style: StyleThemeData.size8Weight400(color: appTheme.grayColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: controller.removeReplyMessage,
            child: Icon(Icons.close, size: 24.w, color: appTheme.grayColor),
          ),
        ],
      ),
    );
  }
}
