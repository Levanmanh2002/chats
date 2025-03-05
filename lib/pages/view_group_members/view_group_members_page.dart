import 'package:chats/main.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/view_group_members/view_group_members_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/bottom_sheet/show_asign_owner_boottom_sheet.dart';
import 'package:chats/widget/bottom_sheet/show_info_memeber_bottom_sheet.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewGroupMembersPage extends GetWidget<ViewGroupMembersController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text('manage_members'.tr, style: StyleThemeData.size16Weight600(color: appTheme.whiteColor)),
                      Obx(() {
                        if (controller.chatGroupData.value?.owner?.id == Get.find<ProfileController>().user.value?.id) {
                          return IconButton(
                            onPressed: () => Get.toNamed(
                              Routes.CREATE_GROUP,
                              arguments: CreateGroupParameter(
                                type: CreateGroupType.joinGroup,
                                users: controller.chatGroupData.value?.users,
                                groupId: controller.chatGroupData.value?.id,
                                updateAddMemberLocal: true,
                              ),
                            ),
                            icon: ImageAssetCustom(imagePath: IconsAssets.addGroupIcon, color: appTheme.whiteColor),
                          );
                        } else {
                          return const IconButton(onPressed: null, icon: SizedBox());
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: padding(all: 16),
              child: CustomTextField(
                controller: controller.searchController,
                hintText: 'search_members'.tr,
                colorBorder: appTheme.allSidesColor,
                fillColor: appTheme.allSidesColor,
                showLine: false,
                formatter: FormatterUtil.createGroupFormatter,
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: ImageAssetCustom(imagePath: IconsAssets.searchIcon, color: appTheme.grayColor),
                ),
                onChanged: (value) {
                  controller.chatValue.value = value;
                },
                suffixIcon: controller.chatValue.value.isNotEmpty
                    ? IconButton(
                        onPressed: controller.clearSearch,
                        icon: const ImageAssetCustom(imagePath: IconsAssets.closeCircleIcon),
                      )
                    : null,
              ),
            ),
            Obx(
              () => Padding(
                padding: padding(vertical: 12, horizontal: 16),
                child: Text(
                  'manage_members_field'.trParams({'field': '${controller.chatGroupData.value?.users?.length ?? '0'}'}),
                  style: StyleThemeData.size12Weight600(),
                ),
              ),
            ),
            // ...(controller.chatGroup?.users ?? []).map((e) {
            //   return _buildContactItem(e, owner: controller.chatGroup?.owner);
            // }),
            Obx(() {
              final usersToDisplay = controller.filteredUsers;
              return Column(
                children: usersToDisplay.map((e) {
                  return _buildContactItem(e, owner: controller.chatGroupData.value?.owner);
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(UserModel e, {UserModel? owner}) {
    final isLeader = owner != null && e.id == owner.id;

    return Padding(
      padding: padding(left: 16, vertical: 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CustomImageWidget(
                imageUrl: e.avatar ?? '',
                size: 41.w,
                noImage: false,
              ),
              if (isLeader)
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    padding: padding(all: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appTheme.grayColor,
                    ),
                    alignment: Alignment.center,
                    child: ImageAssetCustom(imagePath: IconsAssets.keyIcon, size: 10.w),
                  ),
                ),
            ],
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.name ?? '',
                  style: StyleThemeData.size14Weight600(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  isLeader
                      ? "group_leader".tr
                      : (e.phone?.startsWith(controller.phoneCode.value.getCodeAsString()) == true
                          ? e.phone!.replaceFirst(controller.phoneCode.value.getCodeAsString(), '0')
                          : e.phone ?? ''),
                  style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: () {
              if (owner?.id == Get.find<ProfileController>().user.value?.id) {
                if (isLeader) {
                  showAssignOwnerBottomSheet(
                    users: controller.chatGroupData.value?.users
                        ?.where((user) => user.id != controller.chatGroupData.value?.owner?.id)
                        .toList(),
                    phoneCode: controller.phoneCode.value.getCodeAsString(),
                    onConfirm: (UserModel user) {
                      showCommonDialog(
                        title: 'are_you_sure_you_want_to_leave_the_group'.tr,
                        buttonTitle: 'leave_the_group'.tr,
                        onSubmit: () => controller.transferOwnership(user),
                      );
                    },
                  );
                } else {
                  showInfoMemeberBottomBottomSheet(
                    e,
                    chatId: controller.chatGroupData.value?.id,
                    onDelete: () {
                      showCommonDialog(
                        title: 'remove_field_from_the_group'.trParams({'field': e.name ?? ''}),
                        buttonTitle: 'remove_from_group'.tr,
                        onSubmit: () => controller.removeMemberFromGroup(e),
                      );
                    },
                    onSendChat: () => controller.onMessage(e),
                  );
                }
              } else if (e.id == Get.find<ProfileController>().user.value?.id) {
                showCommonDialog(
                  title: 'are_you_sure_you_want_to_leave_the_group'.tr,
                  buttonTitle: 'leave_the_group'.tr,
                  onSubmit: () => controller.memberOutGroup(),
                );
              } else {
                showInfoMemeberBottomBottomSheet(
                  e,
                  chatId: controller.chatGroupData.value?.id,
                  title: isLeader ? 'leader_member_info'.tr : null,
                  onSendChat: () => controller.onMessage(e),
                );
              }
            },
            icon: const ImageAssetCustom(imagePath: IconsAssets.menuDotsIcon),
          ),
        ],
      ),
    );
  }
}
