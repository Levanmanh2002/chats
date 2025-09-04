import 'package:chats/main.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/view_group_members/view_group_members_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/bottom_sheet/show_asign_owner_boottom_sheet.dart';
import 'package:chats/widget/bottom_sheet/show_info_memeber_bottom_sheet.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewGroupMembersPage extends GetWidget<ViewGroupMembersController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: Column(
          children: [
            // Header section
            _buildHeaderSection(),

            // Search section
            _buildSearchSection(),

            // Members list
            Expanded(
              child: _buildMembersList(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: appTheme.appColor,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        'manage_members'.tr,
        style: StyleThemeData.size20Weight700(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        Obx(() {
          if (controller.chatGroupData.value?.owner?.id == Get.find<ProfileController>().user.value?.id) {
            return Container(
              margin: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => Get.toNamed(
                  Routes.CREATE_GROUP,
                  arguments: CreateGroupParameter(
                    type: CreateGroupType.joinGroup,
                    users: controller.chatGroupData.value?.users,
                    groupId: controller.chatGroupData.value?.id,
                    updateAddMemberLocal: true,
                  ),
                ),
                icon: Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            appTheme.appColor,
            appTheme.appColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.appColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
          children: [
            // Icon container
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.group,
                color: Colors.white,
                size: 28.w,
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              'group_members'.tr,
              style: StyleThemeData.size20Weight700(color: Colors.white),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            Text(
              'manage_group_member_permissions'.tr,
              style: StyleThemeData.size14Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Member count
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 16.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'total_members_count'
                            .trParams({'count': '${controller.chatGroupData.value?.users?.length ?? 0}'}),
                        style: StyleThemeData.size14Weight600(color: Colors.white),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.search,
                color: appTheme.appColor,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'search_members'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: appTheme.greyColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller.searchController,
              inputFormatters: FormatterUtil.createGroupFormatter,
              onChanged: (value) {
                controller.chatValue.value = value;
              },
              cursorColor: appTheme.appColor,
              style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
              decoration: InputDecoration(
                hintText: 'search_members'.tr,
                hintStyle: StyleThemeData.size14Weight400(
                  color: appTheme.greyColor.withOpacity(0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.w),
                prefixIcon: Container(
                  padding: EdgeInsets.all(16.w),
                  child: Icon(
                    Icons.search,
                    color: appTheme.greyColor.withOpacity(0.5),
                    size: 20.w,
                  ),
                ),
                suffixIcon: controller.chatValue.value.isNotEmpty
                    ? IconButton(
                        onPressed: controller.clearSearch,
                        icon: Icon(
                          Icons.clear,
                          color: appTheme.greyColor.withOpacity(0.5),
                          size: 20.w,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
              child: Obx(() => Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: appTheme.appColor,
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'members_list'.tr,
                        style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: appTheme.appColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${controller.filteredUsers.length}',
                          style: StyleThemeData.size12Weight600(
                            color: appTheme.appColor,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),

            // Members list
            Expanded(
              child: Obx(() {
                final usersToDisplay = controller.filteredUsers;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: usersToDisplay.length,
                  itemBuilder: (context, index) {
                    final user = usersToDisplay[index];
                    return _buildMemberItem(user, owner: controller.chatGroupData.value?.owner);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem(UserModel e, {UserModel? owner}) {
    final isLeader = owner != null && e.id == owner.id;
    final isCurrentUser = e.id == Get.find<ProfileController>().user.value?.id;
    final isOwner = controller.chatGroupData.value?.owner?.id == Get.find<ProfileController>().user.value?.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleMemberTap(e, isLeader, isCurrentUser, isOwner),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            children: [
              // Avatar with leader badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Stack(
                    children: [
                      CustomImageWidget(
                        imageUrl: e.avatar ?? '',
                        size: 48.w,
                        noImage: false,
                        name: e.name ?? '',
                        isShowNameAvatar: true,
                      ),
                      if (e.isChecked == true)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.circle,
                              size: 8.w,
                              color: Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isLeader)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.star,
                          size: 10.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 16.w),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.name ?? '',
                            style: StyleThemeData.size16Weight500(color: appTheme.blackColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: appTheme.appColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'you'.tr,
                              style: StyleThemeData.size10Weight600(
                                color: appTheme.appColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        if (isLeader)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'group_leader'.tr,
                              style: StyleThemeData.size10Weight600(color: Colors.amber.shade700),
                            ),
                          )
                        else
                          Text(
                            e.phone?.startsWith(controller.phoneCode.value.getCodeAsString()) == true
                                ? e.phone!.replaceFirst(controller.phoneCode.value.getCodeAsString(), '0')
                                : e.phone ?? '',
                            style: StyleThemeData.size12Weight400(
                              color: appTheme.greyColor.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action menu
              Container(
                decoration: BoxDecoration(
                  color: appTheme.greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () => _handleMemberTap(e, isLeader, isCurrentUser, isOwner),
                  icon: Icon(
                    Icons.more_vert,
                    color: appTheme.greyColor.withOpacity(0.7),
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMemberTap(UserModel e, bool isLeader, bool isCurrentUser, bool isOwner) {
    if (isOwner) {
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
    } else if (isCurrentUser) {
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
  }
}
