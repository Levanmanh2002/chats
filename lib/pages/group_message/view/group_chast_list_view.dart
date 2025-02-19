import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/messages/message_models.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_message/widget/group_list_message_widget.dart';
import 'package:chats/pages/message/widget/reaction_popup_widget.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/animation/animation_reply_message.dart';
import 'package:chats/widget/chats/attach_file_widget.dart';
import 'package:chats/widget/dynamic_grid_item_view.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChastListView extends GetView<GroupMessageController> {
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

              final isLastItem = index == 0;

              final DateTime? currentDateTime =
                  item.createdAt != null && item.createdAt!.isNotEmpty ? DateTime.tryParse(item.createdAt!) : null;
              final DateTime? previousDateTime = previousItem?.createdAt != null && previousItem!.createdAt!.isNotEmpty
                  ? DateTime.tryParse(previousItem.createdAt!)
                  : null;
              final shouldShowGroupAvatar = previousItem == null ||
                  (currentDateTime != null &&
                      previousDateTime != null &&
                      currentDateTime.difference(previousDateTime).inMinutes >= 5) ||
                  (item.sender?.id != previousItem.sender?.id);

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
                  (item.hasUserAddedToGroup == true ||
                          item.hasUserRemovedFromGroup == true ||
                          item.hasUserLeftGroup == true)
                      ? Container(
                          margin: padding(all: 8),
                          padding: padding(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: appTheme.whiteColor,
                          ),
                          child: Text(
                            item.message ?? '',
                            style: StyleThemeData.size8Weight400(color: appTheme.appColor),
                          ),
                        )
                      : item.isRollback == true
                          ? Align(
                              alignment: item.sender?.id == Get.find<ProfileController>().user.value?.id
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: padding(horizontal: 16, vertical: 2),
                                constraints: BoxConstraints(maxWidth: 300.w),
                                padding: padding(all: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: item.sender?.id == Get.find<ProfileController>().user.value?.id
                                      ? appTheme.appColor
                                      : appTheme.whiteColor,
                                ),
                                child: Text(
                                  'message_rollback'.tr,
                                  style: StyleThemeData.size12Weight400(color: appTheme.blueBFFColor),
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                Padding(
                                  padding: padding(horizontal: 16, bottom: (item.likes ?? []).isNotEmpty ? 20 : 0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          showReactionPopup(
                                            item.message ?? '',
                                            isCurrentUser:
                                                item.sender?.id == Get.find<ProfileController>().user.value?.id,
                                            onRevoke: item.sender?.id == Get.find<ProfileController>().user.value?.id
                                                ? () => controller.onRevokeMessageLocal(item.id)
                                                : null,
                                            onHeart: () => controller.onHeartMessageLocal(item.id),
                                          );
                                        },
                                        child: AnimationReplyMessage(
                                          key: UniqueKey(),
                                          swipeSensitivity: 5,
                                          onRightSwipe: (details) {
                                            controller.updateReplyMessage(item);
                                          },
                                          onLeftSwipe: (details) {
                                            controller.updateReplyMessage(item);
                                          },
                                          child: GroupListMessageWidget(
                                            text: item.message ?? '',
                                            avatar: item.sender?.avatar ?? '',
                                            isShowAvatar: shouldShowGroupAvatar,
                                            isCurrentUser:
                                                item.sender?.id == Get.find<ProfileController>().user.value?.id,
                                            status: item.status,
                                            replyMessage: item.replyMessage,
                                          ),
                                        ),
                                      ),
                                      if ((item.files ?? []).isNotEmpty) ...[
                                        GestureDetector(
                                          onLongPress: () {
                                            showReactionPopup(
                                              item.message ?? '',
                                              isCurrentUser:
                                                  item.sender?.id == Get.find<ProfileController>().user.value?.id,
                                              onRevoke: () => controller.onRevokeMessageLocal(item.id),
                                              onHeart: () => controller.onHeartMessageLocal(item.id),
                                            );
                                          },
                                          child: AnimationReplyMessage(
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
                                                              child: AttachFileWidget(
                                                                item: file,
                                                                size: constraint.maxWidth.w,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  if (item.status == MessageStatus.sending) ...[
                                                    SizedBox(width: 4.w),
                                                    Icon(Icons.watch_later,
                                                        size: 16, color: appTheme.cardSendTimeColor),
                                                  ] else if (item.status == MessageStatus.failed) ...[
                                                    SizedBox(width: 4.w),
                                                    Icon(Icons.error, size: 16, color: appTheme.errorColor),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if ((item.likes ?? []).isNotEmpty && item.isRollback == false)
                                  Positioned(
                                    left: item.sender?.id == Get.find<ProfileController>().user.value?.id ? null : 0,
                                    right: item.sender?.id == Get.find<ProfileController>().user.value?.id ? 0 : null,
                                    bottom: 0,
                                    child: Container(
                                      margin: padding(horizontal: 16, bottom: 6),
                                      padding: padding(vertical: 2, horizontal: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: appTheme.allSidesColor),
                                        color: appTheme.whiteColor,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ImageAssetCustom(imagePath: IconsAssets.heartColorIcon, width: 15.w),
                                          SizedBox(width: 2.w),
                                          Text(
                                            item.likes?.length.toString() ?? '',
                                            style: StyleThemeData.size10Weight600(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                  if (isLastItem) SizedBox(height: 16.h),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
