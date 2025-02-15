import 'package:chats/main.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAllView extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
          : ListLoader(
              onRefresh: controller.fetchChatList,
              forceScrollable: true,
              child: Column(
                children: (controller.chatsModels.value?.chat ?? []).map((e) => _buildChatItem(e)).toList(),
              ),
            ),
    );
  }

  Widget _buildChatItem(ChatDataModel e) {
    final otherUsers = e.users?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);

    return InkWell(
      onTap: e.isGroup == 1
          ? () => Get.toNamed(
                Routes.GROUP_MESSAGE,
                arguments: GroupMessageParameter(chatId: e.latestMessage?.chatId),
              )
          : () => Get.toNamed(
                Routes.MESSAGE,
                arguments: MessageParameter(chatId: e.latestMessage?.chatId, contact: otherUsers),
              ),
      child: Container(
        padding: padding(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            CustomImageWidget(
              imageUrl: otherUsers?.avatar ?? '',
              size: 54,
              noImage: false,
              showBoder: true,
              colorBoder: appTheme.allSidesColor,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.isGroup == 1 ? e.name ?? '' : otherUsers?.name ?? '',
                    style: StyleThemeData.size16Weight600(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    e.latestMessage?.message ?? '',
                    style: StyleThemeData.size12Weight400(color: appTheme.grayF8Color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
