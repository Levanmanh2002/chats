import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/messages/message_models.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/animation/animation_reply_message.dart';
import 'package:chats/widget/dynamic_grid_item_view.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/images/selectable_image_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/message_text_view.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/video/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChastListView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(() {
        final data = controller.messageModel.value?.listMessages ?? [];
        if (data.isEmpty) {
          return const SizedBox();
        }

        return ListLoader(
          onRefresh: () => controller.fetchChatList(controller.messageId),
          onLoad: () => controller.fetchChatList(controller.messageId, isRefresh: false),
          hasNext: controller.messageModel.value?.hasNext ?? false,
          color: appTheme.cardSendTimeColor,
          child: ListView.separated(
            controller: controller.scrollController,
            itemCount: data.length,
            reverse: true,
            separatorBuilder: (context, index) => const SizedBox(),
            itemBuilder: (context, int index) {
              final item = data[index];
              final previousItem = index < data.length - 1 ? data[index + 1] : null;

              final shouldShowTime = previousItem == null ||
                  item.createdAt?.formatToHourMinute != previousItem.createdAt?.formatToHourMinute;

              return Column(
                children: [
                  if (shouldShowTime)
                    Container(
                      margin: padding(all: 12),
                      padding: padding(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: appTheme.grayB9Color,
                      ),
                      child: Text(
                        item.createdAt?.formatToHourMinute ?? '',
                        style: StyleThemeData.size12Weight400(color: appTheme.whiteColor),
                      ),
                    ),
                  Padding(
                    padding: padding(horizontal: 16),
                    child: Column(
                      children: [
                        AnimationReplyMessage(
                          key: UniqueKey(),
                          swipeSensitivity: 5,
                          onRightSwipe: (details) {
                            controller.updateReplyMessage(item);
                          },
                          onLeftSwipe: (details) {
                            controller.updateReplyMessage(item);
                          },
                          child: _itemListMessage(
                            text: item.message ?? '',
                            isCurrentUser: item.sender?.id == Get.find<ProfileController>().user.value?.id,
                            status: item.status,
                            replyMessage: item.replyMessage,
                          ),
                        ),
                        if ((item.files ?? []).isNotEmpty) ...[
                          AnimationReplyMessage(
                            key: UniqueKey(),
                            swipeSensitivity: 5,
                            onRightSwipe: (details) {
                              controller.updateReplyMessage(item);
                            },
                            onLeftSwipe: (details) {
                              controller.updateReplyMessage(item);
                            },
                            child: Align(
                              alignment: item.sender?.id == Get.find<ProfileController>().user.value?.id
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 300.w),
                                    child: DynamicGridItemView<FilesModels>(
                                      items: item.files ?? [],
                                      borderRadius: 8,
                                      itemBuilder: (file, index) {
                                        return LayoutBuilder(
                                          builder: (context, constraint) => Padding(
                                            padding: padding(all: 4),
                                            child: InkWell(
                                              onTap: () => Get.toNamed(
                                                Routes.ATTACHMENT_FULLSCREEN,
                                                arguments: AttachmentFullscreenParameter(
                                                  files: item.files ?? [],
                                                  index: index,
                                                  user: item.sender,
                                                ),
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                              child: _buildAttachFileView(file, constraint.maxWidth.w),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (item.status == MessageStatus.sending) ...[
                                    SizedBox(width: 4.w),
                                    Icon(Icons.watch_later, size: 16, color: appTheme.cardSendTimeColor),
                                  ] else if (item.status == MessageStatus.failed) ...[
                                    SizedBox(width: 4.w),
                                    Icon(Icons.error, size: 16, color: appTheme.errorColor),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _itemListMessage({
    required String text,
    required bool isCurrentUser,
    MessageStatus status = MessageStatus.success,
    ReplyMessage? replyMessage,
  }) {
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
                          child: (replyMessage.files ?? []).isNotEmpty
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildAttachFileView(replyMessage.files!.first, 32.w, borderRadius: 2),
                                    SizedBox(width: 8.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          replyMessage.sender?.name ?? '',
                                          style: StyleThemeData.size12Weight600(color: appTheme.whiteColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          replyMessage.files?.first.fileType?.getFileCategory == FileCategory.IMAGE
                                              ? 'image_line'.tr
                                              : replyMessage.files?.first.fileType?.getFileCategory ==
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
                                            replyMessage.sender?.name ?? '',
                                            style: StyleThemeData.size10Weight600(color: appTheme.whiteColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            replyMessage.message ?? '',
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

  Widget _buildAttachFileView(FilesModels item, double size, {double borderRadius = 8.0}) {
    switch (item.fileType?.getFileCategory) {
      case FileCategory.IMAGE:
        return SelectableImageView(
          fileUrl: item.fileUrl ?? '',
          isLocal: item.isLocal,
          size: size,
          borderRadius: borderRadius,
        );
      case FileCategory.VIDEO:
        return Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayerWidget(videoPath: item.fileUrl ?? '', isLocal: item.isLocal),
            const ImageAssetCustom(imagePath: IconsAssets.playVideoIcon)
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
