import 'package:chats/main.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_message/view/group_bottom_send_mess_view.dart';
import 'package:chats/pages/group_message/view/group_chast_list_view.dart';
import 'package:chats/pages/group_message/view/group_quick_message_view.dart';
import 'package:chats/pages/group_message/view/group_reply_message_view.dart';
import 'package:chats/pages/group_message/view/group_selected_images_list.dart';
import 'package:chats/pages/group_message/view/group_tickers_view.dart';
import 'package:chats/pages/group_option/group_option_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/gif_utils.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/group_avatar_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupMessagePage extends GetWidget<GroupMessageController> {
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
                  onTap: controller.messageModel.value != null
                      ? () => Get.toNamed(
                            Routes.GROUP_OPTION,
                            arguments: GroupOptionParameter(
                              chat: controller.messageModel.value?.chat,
                              isHideMessage: controller.messageModel.value?.chat?.isHide ?? false,
                            ),
                          )
                      : null,
                  child: Row(
                    children: [
                      GroupAvatarWidget(
                        imageUrls:
                            controller.messageModel.value?.chat?.users?.map((e) => e.avatar ?? '').toList() ?? [],
                        size: 46.w,
                        showBoder: true,
                        colorBoder: appTheme.allSidesColor,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.messageModel.value?.chat?.name ?? 'not_updated_yet'.tr,
                              style: StyleThemeData.size14Weight600(color: appTheme.whiteColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'field_members'.trParams(
                                {'field': controller.messageModel.value?.chat?.users?.length.toString() ?? '0'},
                              ),
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
            onPressed: () => Get.toNamed(Routes.CALL),
          ),
        ),
        body: Column(
          children: [
            // GroupMessageHeaderView(),
            // Obx(
            //   () => (controller.messageModel.value == null)
            //       ? InfoContactWidget(contact: controller.parameter.contact)
            //       : const SizedBox(),
            // ),
            Expanded(
              child: Stack(
                children: [
                  Obx(() => controller.isLoading.isTrue
                      ? Center(child: Image.asset(GifUtils.noDataImageGif))
                      : GroupChastListView()),
                  Obx(
                    () => controller.isShowScrollToBottom.value
                        ? Positioned(bottom: 12, right: 16, child: _buildScrollToBottomMess())
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            Obx(() => (controller.messageReply.value != null) ? GroupReplyMessageView() : const SizedBox()),
            GroupSelectedImagesList(),
            Obx(() => (controller.quickMessage.value != null) ? GroupQuickMessageView() : const SizedBox()),
            GroupBottomSendMessView(),
            Obx(() => controller.isTickers.isTrue ? GroupTickersView() : const SizedBox()),
          ],
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
