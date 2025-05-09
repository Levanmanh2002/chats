import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/message_web/view/bottom_send_mess_view.dart';
import 'package:chats/pages/chats/message_web/view/chast_list_view.dart';
import 'package:chats/pages/chats/message_web/view/quick_message_view.dart';
import 'package:chats/pages/chats/message_web/view/reply_message_view.dart';
import 'package:chats/pages/chats/message_web/view/selected_images_list.dart';
import 'package:chats/pages/chats/message_web/view/status_friend_view.dart';
import 'package:chats/pages/chats/message_web/view/tickers_view.dart';
import 'package:chats/pages/message/widget/info_contact_widget.dart';
import 'package:chats/pages/options/options_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/gif_utils.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/dialog/show_confirm_call_dialog.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageWebPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final otherUsers = controller.messageModel.value?.chat?.users
          ?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);

      return Scaffold(
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
              SizedBox(width: 24.w),
              Flexible(
                child: GestureDetector(
                  onTap: controller.chatsModels.value?.chat != null
                      ? () => Get.toNamed(
                            Routes.OPTIONS,
                            arguments: OptionsParameter(
                              user: otherUsers,
                              chatId: controller.chatsModels.value!.chat!.firstOrNull!.id!,
                              isHideMessage: controller.messageModel.value?.chat?.isHide ?? false,
                            ),
                          )
                      : null,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CustomImageWidget(
                            imageUrl: otherUsers?.avatar ??
                                (controller.messageModel.value?.chat?.users ?? [])
                                    .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                    ?.avatar ??
                                '',
                            size: 46.w,
                            colorBoder: appTheme.appColor,
                            showBoder: true,
                            noImage: false,
                            name: otherUsers?.name ??
                                (controller.messageModel.value?.chat?.users ?? [])
                                    .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                    ?.name ??
                                '',
                            isShowNameAvatar: true,
                          ),
                          if ((otherUsers?.isChecked ??
                                  (controller.messageModel.value?.chat?.users ?? [])
                                      .firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id)
                                      ?.isChecked ??
                                  '') ==
                              true)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: padding(all: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appTheme.greenColor,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 10.w,
                                  color: appTheme.whiteColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              otherUsers?.name ??
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
                              otherUsers?.lastOnline?.timeAgo ??
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
              DialogUtils.showWarningDialog('please_download_the_app_to_use_this_feature'.tr);
              showConfirmCallDialog();
            },
          ),
        ),
        body: Column(
          children: [
            (controller.messageModel.value?.isFriend != true) ? StatusFriendWebView() : const SizedBox(),
            (controller.isLoading.isFalse &&
                    controller.messageModel.value == null &&
                    (controller.messageModel.value?.listMessages ?? []).isEmpty)
                ? InfoContactWidget(contact: otherUsers)
                : const SizedBox(),
            Expanded(
              child: Stack(
                children: [
                  Obx(() => controller.isLoading.isTrue
                      ? Center(child: Image.asset(GifUtils.noDataImageGif))
                      : ChastListWebView()),
                  Obx(
                    () => controller.isShowScrollToBottom.value
                        ? Positioned(bottom: 12, right: 16, child: _buildScrollToBottomMess())
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            (controller.messageReply.value != null) ? ReplyMessageWebView() : const SizedBox(),
            SelectedImagesListWebView(),
            (controller.quickMessage.value != null) ? QuickMessageWebView() : const SizedBox(),
            BottomSendMessWebView(),
            controller.isTickers.isTrue ? TickersWebView() : const SizedBox(),
          ],
        ),
      );
    });
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
