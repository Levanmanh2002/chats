import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/group_avatar_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAllView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListLoader(
        onRefresh: () => controller.fetchChatList(isShowLoad: false),
        onLoad: () => controller.fetchChatList(isRefresh: false),
        hasNext: controller.chatsModels.value?.hasNext ?? false,
        forceScrollable: true,
        child: (controller.chatsModels.value?.chat ?? []).isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: List.generate((controller.chatsModels.value?.chat ?? []).length, (index) {
                    return _buildChatItem(
                      (controller.chatsModels.value?.chat ?? [])[index],
                      isShowLine: index != (controller.chatsModels.value?.chat ?? []).length - 1,
                    );
                  }),
                ),
              )
            : const Center(child: NoDataWidget()),
      ),
    );
  }

  Widget _buildChatItem(ChatDataModel e, {bool isShowLine = true}) {
    final otherUsers = e.users?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);

    return Column(
      children: [
        Dismissible(
          key: ValueKey(e.id),
          direction: DismissDirection.endToStart,
          dismissThresholds: const {DismissDirection.endToStart: 0.2},
          confirmDismiss: (direction) async {
            showCommonDialog(
              title: 'are_you_sure_you_want_to_delete_the_conversation'.tr,
              onSubmit: () => controller.deleteChat(e.id!),
            );
            return null;
          },
          background: Container(
            padding: padding(horizontal: 20),
            color: appTheme.errorColor,
            alignment: Alignment.centerRight,
            child: ImageAssetCustom(imagePath: IconsAssets.trashBinIcon, size: 24.w, color: appTheme.whiteColor),
          ),
          child: InkWell(
            onTap: () {
              if (e.isGroup == 1) {
                controller.isGroup.value = true;
              } else {
                controller.isGroup.value = false;
              }
              // if (e.isGroup == 1) {
              //   // Get.toNamed(
              //   //   Routes.GROUP_MESSAGE,
              //   //   arguments: GroupMessageParameter(chatId: e.latestMessage?.chatId),
              //   // );
              //   controller.getMessageList(e.latestMessage!.chatId!);
              // } else {
              //   // Get.toNamed(
              //   //   Routes.MESSAGE,
              //   //   arguments: MessageParameter(chatId: e.latestMessage?.chatId, contact: otherUsers),
              //   // );
              //   controller.getMessageList(e.latestMessage!.chatId!);
              // }
              controller.getMessageList(e.latestMessage!.chatId!);
              controller.updateReadStatus(e.latestMessage!.chatId!);
            },
            child: Container(
              padding: padding(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  e.isGroup == 1
                      ? GroupAvatarWidget(
                          imageUrls: e.users?.map((e) => e.avatar ?? '').toList() ?? [],
                          size: 54.w,
                          showBoder: true,
                          colorBoder: appTheme.allSidesColor,
                        )
                      : CustomImageWidget(
                          imageUrl: otherUsers?.avatar ?? '',
                          size: 54.w,
                          noImage: false,
                          showBoder: true,
                          colorBoder: appTheme.allSidesColor,
                          name: otherUsers?.name ?? '',
                          isShowNameAvatar: true,
                        ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.isGroup == 1 ? e.name ?? '' : otherUsers?.name ?? '',
                                style: StyleThemeData.size16Weight600(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              e.latestMessage?.createdAt?.formattedTimeAgoChats ?? '',
                              style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.latestMessage?.isCall == true
                                    ? e.latestMessage?.missedCall == true
                                        ? 'missed_call'.tr
                                        : e.latestMessage?.isCanceldId != null &&
                                                (e.latestMessage?.callJoinedAt ?? '').isEmpty
                                            ? 'call_canceled'.tr
                                            : e.latestMessage?.isRejectCallId != null
                                                ? 'receiver_declined_the_call'.tr
                                                : e.latestMessage?.isDontPickUp == true
                                                    ? 'call_not_answered'.tr
                                                    : e.latestMessage?.sender?.id ==
                                                            Get.find<ProfileController>().user.value?.id
                                                        ? 'outgoing_call'.tr
                                                        : e.latestMessage?.sender?.id !=
                                                                Get.find<ProfileController>().user.value?.id
                                                            ? 'incoming_call'.tr
                                                            : 'voice_call'.tr
                                    : e.latestMessage?.message ??
                                        (e.latestMessage?.sticker != null
                                            ? 'Sticker'
                                            : (e.latestMessage?.files ?? []).isNotEmpty
                                                ? (e.latestMessage?.files?.first.fileType?.getFileCategory ==
                                                        FileCategory.IMAGE)
                                                    ? '[${'images'.tr}]'
                                                    : '[${'document'.tr}]'
                                                : ''),
                                style: e.isRead == false
                                    ? StyleThemeData.size12Weight600()
                                    : StyleThemeData.size12Weight400(color: appTheme.grayF8Color),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (e.isRead == false) ...[
                              SizedBox(width: 12.w),
                              Container(
                                width: 9.w,
                                height: 9.w,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.errorColor),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isShowLine)
          Padding(
            padding: padding(left: (16 + 54 + 8).w),
            child: LineWidget(color: appTheme.allSidesColor),
          ),
      ],
    );
  }
}
