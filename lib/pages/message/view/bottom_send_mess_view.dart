import 'package:chats/main.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSendMessView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(bottom: 24),
      color: appTheme.whiteColor,
      child: Row(
        children: [
          InkWell(
            onTap: controller.toggleTickers,
            child: Padding(
              padding: padding(left: 12),
              child: const ImageAssetCustom(imagePath: IconsAssets.emojiIcon),
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: controller.messageController,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: appTheme.appColor,
              decoration: InputDecoration(
                hintText: 'message'.tr,
                border: InputBorder.none,
                contentPadding: padding(all: 12),
                hintStyle: StyleThemeData.size14Weight400(color: appTheme.grayColor),
              ),
              style: StyleThemeData.size14Weight400(),
              maxLines: 5,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              onChanged: controller.updateMessage,
              inputFormatters: FormatterUtil.chatMessageFormatter,
              onTap: () => controller.isTickers.value = false,
            ),
          ),
          Obx(
            () => controller.isLoadingSendMess.isTrue
                ? Center(
                    child: Container(
                      margin: padding(horizontal: 14),
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(color: appTheme.appColor),
                    ),
                  )
                : controller.messageValue.value.isEmpty
                    ? Padding(
                        padding: padding(horizontal: 12),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: controller.pickedFile,
                              icon: ImageAssetCustom(imagePath: IconsAssets.paperclipIcon, color: appTheme.grayColor),
                            ),
                            IconButton(
                              onPressed: controller.pickImages,
                              icon: const ImageAssetCustom(imagePath: IconsAssets.galleryIcon),
                            ),
                          ],
                        ),
                      )
                    : IconButton(
                        onPressed: controller.onSendMessage,
                        icon: const ImageAssetCustom(imagePath: IconsAssets.sendIcon),
                      ),
          ),
        ],
      ),
    );
  }
}
