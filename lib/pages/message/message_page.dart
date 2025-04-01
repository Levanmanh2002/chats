import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/message/view/bottom_send_mess_view.dart';
import 'package:chats/pages/message/view/chast_list_view.dart';
import 'package:chats/pages/message/view/quick_message_view.dart';
import 'package:chats/pages/message/view/reply_message_view.dart';
import 'package:chats/pages/message/view/status_friend_view.dart';
import 'package:chats/pages/message/view/tickers_view.dart';
import 'package:chats/pages/message/widget/info_contact_widget.dart';
import 'package:chats/pages/message/widget/selected_images_list.dart';
import 'package:chats/pages/options/options_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/gif_utils.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends GetWidget<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: appTheme.blueFFColor,
        appBar: SearchAppbar(
          backgroundColor: appTheme.appColor,
          isShowBack: true,
          isOffSearch: true,
          sizeAction: 16.w,
          toggleNotifier: controller.isShowSearch.value,
          onSubmitted: controller.onSearchMessage,
          isLoadingSearch: controller.isLoadingSearch.isTrue,
          widgetTitle: Row(
            children: [
              IconButton(
                onPressed: Get.back,
                icon: ImageAssetCustom(imagePath: IconsAssets.arrowLeftIcon, color: appTheme.whiteColor, size: 24.w),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: controller.parameter.chatId != null
                      ? () => Get.toNamed(
                            Routes.OPTIONS,
                            arguments: OptionsParameter(
                              user: controller.parameter.contact,
                              chatId: controller.parameter.chatId!,
                              isHideMessage: controller.messageModel.value?.chat?.isHide ?? false,
                            ),
                          )
                      : null,
                  child: Row(
                    children: [
                      CustomImageWidget(
                        imageUrl: controller.parameter.contact?.avatar ??
                            (controller.messageModel.value?.chat?.users ?? [])
                                .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                ?.avatar ??
                            '',
                        size: 46.w,
                        colorBoder: appTheme.appColor,
                        showBoder: true,
                        noImage: false,
                        name: controller.parameter.contact?.name ??
                            (controller.messageModel.value?.chat?.users ?? [])
                                .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                ?.name ??
                            '',
                        isShowNameAvatar: true,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.parameter.contact?.name ??
                                  (controller.messageModel.value?.chat?.users ?? [])
                                      .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                      ?.name ??
                                  'not_updated_yet'.tr,
                              style: StyleThemeData.size14Weight600(color: appTheme.whiteColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              controller.parameter.contact?.lastOnline?.timeAgo ??
                                  (controller.messageModel.value?.chat?.users ?? [])
                                      .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                      ?.lastOnline
                                      ?.timeAgo ??
                                  '',
                              style: StyleThemeData.size10Weight400(color: appTheme.whiteColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          action: IconButton(
              style: IconButton.styleFrom(
                minimumSize: Size.zero,
                fixedSize: Size(36.w, 36.w),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                maximumSize: Size(36.w, 36.w),
              ),
              icon: ImageAssetCustom(imagePath: IconsAssets.phoneIcon, color: appTheme.whiteColor),
              onPressed: () {
                final contact = controller.messageModel.value?.chat?.users?.firstWhereOrNull(
                  (e) => e.id != Get.find<ProfileController>().user.value?.id,
                );

                if (contact == null) return;

                Get.toNamed(
                  Routes.CALL,
                  arguments: CallCallParameter(
                    id: contact.id ?? DateTime.now().millisecondsSinceEpoch,
                    messageId: controller.messageModel.value!.chat!.id!,
                    callId: null,
                    name: contact.name ?? '',
                    avatar: contact.avatar ?? '',
                    channel: 'channel',
                    type: CallType.call,
                  ),
                );
              }),
        ),
        body: Obx(
          () => Column(
            children: [
              // MessageHeaderView(),
              (controller.messageModel.value?.isFriend != true) ? StatusFriendView() : const SizedBox(),
              (controller.isLoading.isFalse &&
                      controller.messageModel.value == null &&
                      (controller.messageModel.value?.listMessages ?? []).isEmpty)
                  ? InfoContactWidget(contact: controller.parameter.contact)
                  : const SizedBox(),
              Expanded(
                child: Stack(
                  children: [
                    Obx(() => controller.isLoading.isTrue
                        ? Center(child: Image.asset(GifUtils.noDataImageGif))
                        : ChastListView()),
                    Obx(
                      () => controller.isShowScrollToBottom.value
                          ? Positioned(bottom: 12, right: 16, child: _buildScrollToBottomMess())
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
              (controller.messageReply.value != null) ? ReplyMessageView() : const SizedBox(),
              SelectedImagesList(),
              (controller.quickMessage.value != null) ? QuickMessageView() : const SizedBox(),
              BottomSendMessView(),
              controller.isTickers.isTrue ? TickersView() : const SizedBox(),
            ],
          ),
        ),
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
