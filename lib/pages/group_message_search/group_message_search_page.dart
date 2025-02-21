import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_message_search/group_message_search_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMessageSearchPage extends GetWidget<GroupMessageSearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: (() {
          final myId = Get.find<ProfileController>().user.value?.id;
          final user = controller.searchMessage.chat?.users?.firstWhereOrNull((u) => u.id != myId);
          return user?.name ?? '';
        })(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: (controller.searchMessage.highlightedMessages ?? []).asMap().entries.map((entry) {
            final index = entry.key;
            final message = entry.value;
            final page = (controller.searchMessage.highlightedPages ?? [])[index];

            return InkWell(
              onTap: () {
                Get.find<GroupMessageController>().fetchChatListUntilPage(
                  chatId: controller.searchMessage.chat!.id!,
                  targetPage: page,
                  messageId: message.id!,
                );
                Get.back();
              },
              child: Padding(
                padding: padding(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    CustomImageWidget(
                      imageUrl: message.sender?.avatar ?? '',
                      size: 54.w,
                      noImage: false,
                      showBoder: true,
                      colorBoder: appTheme.allSidesColor,
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender?.name ?? '',
                          style: StyleThemeData.size16Weight600(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: message.message ?? '',
                                style: StyleThemeData.size12Weight400(color: appTheme.grayF8Color),
                              ),
                              TextSpan(
                                text: ' • ',
                                style: StyleThemeData.size12Weight400(color: appTheme.grayF8Color),
                              ),
                              TextSpan(
                                text: message.createdAt.toHHmmddMMyyyy,
                                style: StyleThemeData.size12Weight400(color: appTheme.grayF8Color),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
