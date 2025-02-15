import 'package:chats/main.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickMessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: padding(all: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          color: const Color(0xE5FFFFFF),
          border: Border(
            bottom: BorderSide(color: appTheme.allSidesColor, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '/${controller.quickMessage.value?.shortKey}',
              style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              controller.quickMessage.value?.content ?? '',
              style: StyleThemeData.size14Weight400(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
