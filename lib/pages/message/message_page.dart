import 'package:chats/main.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/message/view/bottom_send_mess_view.dart';
import 'package:chats/pages/message/view/chast_list_view.dart';
import 'package:chats/pages/message/view/message_header_view.dart';
import 'package:chats/pages/message/view/reply_message_view.dart';
import 'package:chats/pages/message/widget/info_contact_widget.dart';
import 'package:chats/pages/message/widget/selected_images_list.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends GetWidget<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.blueFFColor,
      body: Column(
        children: [
          MessageHeaderView(),
          Obx(
            () => (controller.messageModel.value == null)
                ? InfoContactWidget(contact: controller.parameter.contact)
                : const SizedBox(),
          ),
          Expanded(
            child: Stack(
              children: [
                ChastListView(),
                Obx(
                  () => controller.isShowScrollToBottom.value
                      ? Positioned(bottom: 12, right: 16, child: _buildScrollToBottomMess())
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          Obx(() => (controller.messageReply.value != null) ? ReplyMessageView() : const SizedBox()),
          SelectedImagesList(),
          BottomSendMessView(),
        ],
      ),
    );
  }

  Widget _buildScrollToBottomMess() {
    return InkWell(
      onTap: controller.scrollToBottom,
      borderRadius: BorderRadius.circular(8),
      child: controller.isShowNewMessScroll.value
          ? Container(
              padding: padding(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: appTheme.whiteColor),
              child: Row(
                children: [
                  Text(
                    'new_messages'.tr,
                    style: StyleThemeData.size12Weight600(color: appTheme.appColor),
                  ),
                  SizedBox(width: 5.w),
                  ImageAssetCustom(
                    imagePath: IconsAssets.doubleArrowDownIcon,
                    color: appTheme.appColor,
                  ),
                ],
              ),
            )
          : Container(
              padding: padding(all: 8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.whiteColor),
              child: const ImageAssetCustom(imagePath: IconsAssets.doubleArrowDownIcon),
            ),
    );
  }
}
