import 'package:chats/main.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/group_option/group_option_controller.dart';
import 'package:chats/pages/instant_message/instant_message_parameter.dart';
import 'package:chats/pages/view_group_members/view_group_members_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/border_title_icon_widget.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/dialog/show_update_namegroup_dialog.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupOptionPage extends GetWidget<GroupOptionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const ImageAssetCustom(imagePath: ImagesAssets.topBgChatImage),
                Positioned(
                  bottom: 12,
                  left: 8,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: ImageAssetCustom(imagePath: IconsAssets.arrowLeftIcon, color: appTheme.whiteColor),
                      ),
                      Text('options'.tr, style: StyleThemeData.size16Weight600(color: appTheme.whiteColor)),
                      const IconButton(onPressed: null, icon: SizedBox()),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: padding(horizontal: 16),
              child: Column(
                children: [
                  CustomImageWidget(
                    imageUrl: '',
                    size: 100,
                    showBoder: true,
                    colorBoder: appTheme.allSidesColor,
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: controller.chatDataModel.value?.name ?? '',
                            style: StyleThemeData.size20Weight600(),
                          ),
                          WidgetSpan(
                            child: InkWell(
                              onTap: () {
                                showUpdateNameGroupDialog(
                                  groupName: controller.chatDataModel.value?.name ?? '',
                                  onSubmit: controller.renameGroup,
                                );
                              },
                              borderRadius: BorderRadius.circular(1000),
                              child: Container(
                                margin: padding(left: 8.w),
                                padding: padding(all: 6),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.allSidesColor),
                                child: const ImageAssetCustom(imagePath: IconsAssets.pen2Icon),
                              ),
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(1000),
                          child: Column(
                            children: [
                              Container(
                                padding: padding(all: 8),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.allSidesColor),
                                child: ImageAssetCustom(
                                    imagePath: IconsAssets.searchIcon, color: appTheme.blackColor, size: 24.w),
                              ),
                              SizedBox(height: 4.h),
                              Text('search_messages'.tr, style: StyleThemeData.size12Weight400()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Flexible(
                        child: InkWell(
                          onTap: () => Get.toNamed(
                            Routes.CREATE_GROUP,
                            arguments: CreateGroupParameter(
                              type: CreateGroupType.joinGroup,
                              users: controller.chatDataModel.value?.users,
                              groupId: controller.chatDataModel.value?.id,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: padding(all: 8),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.allSidesColor),
                                child: ImageAssetCustom(
                                    imagePath: IconsAssets.addGroupIcon, color: appTheme.blackColor, size: 24.w),
                              ),
                              SizedBox(height: 4.h),
                              Text('add_member'.tr, style: StyleThemeData.size12Weight400()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.downloadIcon,
                    title: 'export_pdf_file'.tr,
                  ),
                  SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.chatRoundLineIcon,
                    title: 'manage_instant_messages'.tr,
                    onTap: () => Get.toNamed(
                      Routes.INSTANT_MESSAGE,
                      arguments: InstantMessageParameter(
                        chatId: controller.parameter.chat!.id!,
                        type: InstantMessageType.group,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.galleryBorderIcon,
                    title: 'images_files_links'.tr,
                    child: Container(
                      margin: padding(top: 12),
                      padding: padding(horizontal: 6, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: appTheme.allSidesColor,
                      ),
                      child: Row(
                        children: [
                          const ImageAssetCustom(imagePath: IconsAssets.borderAlbumIcon),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              'media_files_in_the_conversation_will_appear_here'.tr,
                              style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.userGroupIcon,
                    title: 'view_group_members'.tr,
                    onTap: () => Get.toNamed(
                      Routes.VIEW_GROUP_MEMBERS,
                      arguments: ViewGroupMembersParameter(chatGroup: controller.chatDataModel.value),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BorderTitleIconWidget(
                    icon: IconsAssets.trashBinIcon,
                    title: 'delete_conversation'.tr,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
