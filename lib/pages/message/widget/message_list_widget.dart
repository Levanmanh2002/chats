import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/chats/attach_file_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/message_text_view.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageListWidget extends StatelessWidget {
  const MessageListWidget({
    super.key,
    required this.text,
    required this.isCurrentUser,
    this.status = MessageStatus.success,
    this.replyMessage,
  });

  final String text;
  final bool isCurrentUser;
  final MessageStatus status;
  final ReplyMessage? replyMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding(vertical: 2),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 300.w),
              padding: padding(all: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isCurrentUser ? appTheme.appColor : appTheme.whiteColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  replyMessage != null
                      ? Padding(
                          padding: padding(bottom: 10),
                          child: (replyMessage?.files ?? []).isNotEmpty
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AttachFileWidget(item: replyMessage!.files!.first, size: 32.w, borderRadius: 2),
                                    SizedBox(width: 8.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          replyMessage?.sender?.name ?? '',
                                          style: StyleThemeData.size12Weight600(color: appTheme.whiteColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          replyMessage?.files?.first.fileType?.getFileCategory == FileCategory.IMAGE
                                              ? 'image_line'.tr
                                              : replyMessage?.files?.first.fileType?.getFileCategory ==
                                                      FileCategory.VIDEO
                                                  ? 'video_line'.tr
                                                  : 'attachment_line'.tr,
                                          style: StyleThemeData.size8Weight400(color: appTheme.blueBFFColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const ImageAssetCustom(imagePath: IconsAssets.replyBorderIcon),
                                    SizedBox(width: 8.w),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            replyMessage?.sender?.name ?? '',
                                            style: StyleThemeData.size10Weight600(color: appTheme.whiteColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            replyMessage?.message ?? '',
                                            style: StyleThemeData.size10Weight400(color: appTheme.blueBFFColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      : const SizedBox(),
                  MessageTextView(
                    message: text,
                    textStyle: StyleThemeData.size14Weight400(
                      color: isCurrentUser ? appTheme.whiteColor : appTheme.blackColor,
                    ),
                    color: isCurrentUser ? appTheme.whiteColor : appTheme.blackColor,
                  ),
                ],
              ),
            ),
            if (status == MessageStatus.sending) ...[
              SizedBox(width: 4.w),
              Icon(Icons.watch_later, size: 16, color: appTheme.cardSendTimeColor),
            ] else if (status == MessageStatus.failed) ...[
              SizedBox(width: 4.w),
              Icon(Icons.error, size: 16, color: appTheme.errorColor),
            ],
          ],
        ),
      ),
    );
  }
}
