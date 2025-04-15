import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/pages/forward/forward_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/gif_utils.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/chats/attach_file_widget.dart';
import 'package:chats/widget/check_circle_widget.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/dynamic_grid_item_view.dart';
import 'package:chats/widget/group_avatar_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForwardPage extends GetWidget<ForwardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'forward'.tr),
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(child: Image.asset(GifUtils.noDataImageGif))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: padding(vertical: 12, horizontal: 8),
                    child: Container(
                      padding: padding(all: 4),
                      decoration: BoxDecoration(
                        color: appTheme.blueFFColor,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                controller.tabForward.value = TabForward.chat;
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: padding(all: 12),
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: controller.tabForward.value == TabForward.chat ? appTheme.appColor : null,
                                ),
                                child: Text(
                                  'Đoạn chat gần đây',
                                  style: controller.tabForward.value == TabForward.chat
                                      ? StyleThemeData.size14Weight600(color: appTheme.whiteColor)
                                      : StyleThemeData.size14Weight400(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                controller.tabForward.value = TabForward.friend;
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: padding(all: 12),
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: controller.tabForward.value == TabForward.friend ? appTheme.appColor : null,
                                ),
                                child: Text(
                                  'Bạn bè',
                                  style: controller.tabForward.value == TabForward.friend
                                      ? StyleThemeData.size14Weight600(color: appTheme.whiteColor)
                                      : StyleThemeData.size14Weight400(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.tabForward.value == TabForward.chat) {
                        return ListLoader(
                          onRefresh: () => controller.fetchChatList(isShowLoad: false),
                          onLoad: () => controller.fetchChatList(isRefresh: false),
                          hasNext: controller.chatsModels.value?.hasNext ?? false,
                          forceScrollable: true,
                          child: (controller.chatsModels.value?.chat ?? []).isNotEmpty
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: (controller.chatsModels.value?.chat ?? []).map((e) {
                                      return _buildUserChatItem(e);
                                    }).toList(),
                                  ),
                                )
                              : const Center(child: NoDataWidget()),
                        );
                      } else if (controller.tabForward.value == TabForward.friend) {
                        return ListLoader(
                          onRefresh: () => controller.fetchContacts(isShowLoad: false),
                          onLoad: () => controller.fetchContacts(isRefresh: false),
                          hasNext: controller.contactModel.value?.hasNext ?? false,
                          forceScrollable: true,
                          child: (controller.contactModel.value?.data ?? []).isNotEmpty
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: (controller.contactModel.value?.data ?? []).map((e) {
                                      return _buildFriendItem(e);
                                    }).toList(),
                                  ),
                                )
                              : const Center(child: NoDataWidget()),
                        );
                      }

                      return const SizedBox();
                    }),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Obx(
        () => controller.selectChatsModels.isNotEmpty || controller.selectContactModel.isNotEmpty
            ? Container(
                padding: padding(top: 12, horizontal: 16, bottom: 24),
                decoration: BoxDecoration(
                  color: appTheme.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ((controller.parameter.message ?? '').isNotEmpty)
                            Text(controller.parameter.message ?? '', style: StyleThemeData.size14Weight400()),
                          if ((controller.parameter.files ?? []).isNotEmpty) ...[
                            Container(
                              constraints: BoxConstraints(maxWidth: 300.w),
                              child: DynamicGridItemView<FilesModels>(
                                items: controller.parameter.files ?? [],
                                borderRadius: 8,
                                itemBuilder: (file, index) {
                                  return LayoutBuilder(
                                    builder: (context, constraint) => Padding(
                                      padding: padding(all: 4),
                                      child: InkWell(
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
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    IconButton(
                      onPressed: controller.onSendForwardMessage,
                      icon: const ImageAssetCustom(imagePath: IconsAssets.sendIcon),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildUserChatItem(ChatDataModel e) {
    final otherUsers = e.users?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);

    return Obx(
      () => InkWell(
        onTap: () => controller.selectChat(e),
        child: Padding(
          padding: padding(horizontal: 16, vertical: 8),
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
                    Text(
                      e.isGroup == 1 ? e.name ?? '' : otherUsers?.name ?? '',
                      style: StyleThemeData.size14Weight600(),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      e.latestMessage?.createdAt?.formattedTimeAgoChats ?? '',
                      style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              CheckCircleWidget(
                isSelect: controller.selectChatsModels.any((user) => user.id == e.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendItem(ContactModel e) {
    return Obx(
      () => InkWell(
        onTap: () => controller.selectFrinend(e),
        child: Padding(
          padding: padding(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CustomImageWidget(
                imageUrl: e.friend?.avatar ?? '',
                size: 54.w,
                noImage: false,
                showBoder: true,
                colorBoder: appTheme.allSidesColor,
                name: e.friend?.name ?? '',
                isShowNameAvatar: true,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.friend?.name ?? '',
                      style: StyleThemeData.size14Weight600(),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      e.friend?.lastOnline?.formattedTimeAgoChats ?? '',
                      style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              CheckCircleWidget(isSelect: controller.selectContactModel.any((user) => user.id == e.id)),
            ],
          ),
        ),
      ),
    );
  }
}
