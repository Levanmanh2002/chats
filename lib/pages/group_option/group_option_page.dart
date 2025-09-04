import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/group_option/group_option_controller.dart';
import 'package:chats/pages/media_files/media_files_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/view_group_members/view_group_members_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/calendar_config_util.dart';
import 'package:chats/widget/app_switch.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/dialog/show_update_namegroup_dialog.dart';
import 'package:chats/widget/group_avatar_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupOptionPage extends GetWidget<GroupOptionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildCustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 24.h),

              // Group header section
              _buildGroupHeader(),

              SizedBox(height: 32.h),

              // Quick actions
              _buildQuickActions(),

              SizedBox(height: 32.h),

              // Options section
              _buildOptionsSection(),

              SizedBox(height: 40.h),
            ],
          ),
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
        'options'.tr,
        style: StyleThemeData.size20Weight700(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Group avatar với enhanced design
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appTheme.appColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: GroupAvatarWidget(
              imageUrls: controller.chatDataModel.value?.users?.map((e) => e.avatar ?? '').toList() ?? [],
              size: 100.w,
              showBoder: true,
              colorBoder: Colors.white,
            ),
          ),

          SizedBox(height: 16.h),

          // Group name with edit button
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      controller.chatDataModel.value?.name ?? '',
                      style: StyleThemeData.size20Weight700(color: appTheme.blackColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    decoration: BoxDecoration(
                      color: appTheme.appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showUpdateNameGroupDialog(
                            groupName: controller.chatDataModel.value?.name ?? '',
                            onSubmit: controller.renameGroup,
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.w,
                            color: appTheme.appColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          SizedBox(height: 8.h),

          // Group info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: appTheme.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'group_members_count'.trParams({'count': '${controller.chatDataModel.value?.users?.length ?? 0}'}),
              style: StyleThemeData.size12Weight500(color: appTheme.appColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
          Text(
            'quick_actions'.tr,
            style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
          ),
          SizedBox(height: 16.h),
          IntrinsicHeight(
            child: Row(
              children: [
                // Search messages
                Expanded(
                  child: _buildQuickActionItem(
                    icon: Icons.search,
                    title: 'search_messages'.tr,
                    onTap: controller.onShowSearchMessage,
                  ),
                ),

                if (controller.chatDataModel.value?.owner?.id == Get.find<ProfileController>().user.value?.id) ...[
                  SizedBox(width: 16.w),
                  // Add member
                  Expanded(
                    child: _buildQuickActionItem(
                      icon: Icons.person_add_outlined,
                      title: 'add_member'.tr,
                      onTap: () => Get.toNamed(
                        Routes.CREATE_GROUP,
                        arguments: CreateGroupParameter(
                          type: CreateGroupType.joinGroup,
                          users: controller.chatDataModel.value?.users,
                          groupId: controller.chatDataModel.value?.id,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: appTheme.appColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: appTheme.appColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: appTheme.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: appTheme.appColor,
                  size: 20.w,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: StyleThemeData.size12Weight500(color: appTheme.blackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'group_settings'.tr,
            style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
          ),

          SizedBox(height: 16.h),

          // Export PDF
          _buildOptionCard(
            icon: Icons.picture_as_pdf_outlined,
            title: 'export_pdf_file'.tr,
            subtitle: 'export_chat_history_pdf'.tr,
            onTap: () async {
              final ranges = await showCalendarDatePicker2Dialog(
                context: Get.context!,
                config: CalendarConfigUtil.getDefaultConfig(Get.context!),
                dialogSize: Size(Get.width, Get.width),
                borderRadius: BorderRadius.circular(15),
                value: [
                  controller.earningRangeDate.value.start,
                  controller.earningRangeDate.value.end,
                ],
                dialogBackgroundColor: Colors.white,
              );
              if (ranges?.isEmpty ?? true) return;
              controller.changeRangeDate(
                DateTimeRange(
                  start: ranges![0]!,
                  end: ranges.length == 1 ? ranges[0]! : ranges[1]!,
                ),
              );
            },
          ),

          SizedBox(height: 12.h),

          // Hide messages
          _buildSwitchCard(
            icon: Icons.visibility_off_outlined,
            title: 'hide_message'.tr,
            subtitle: 'hide_messages_from_preview'.tr,
            value: controller.isHideMessage.value,
            onChanged: controller.onHideMessage,
          ),

          SizedBox(height: 12.h),

          // Media files
          _buildMediaCard(),

          SizedBox(height: 12.h),

          // View members
          _buildOptionCard(
            icon: Icons.group_outlined,
            title: 'view_group_members'.tr,
            subtitle: 'manage_group_members'.tr,
            onTap: () => Get.toNamed(
              Routes.VIEW_GROUP_MEMBERS,
              arguments: ViewGroupMembersParameter(chatGroup: controller.chatDataModel.value),
            ),
          ),

          SizedBox(height: 24.h),

          // Danger zone
          _buildDangerZone(),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: appTheme.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: appTheme.appColor,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: StyleThemeData.size12Weight400(
                          color: appTheme.greyColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: appTheme.greyColor.withOpacity(0.5),
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required VoidCallback onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Obx(() => Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: appTheme.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: appTheme.appColor,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: StyleThemeData.size12Weight400(
                        color: appTheme.greyColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              AppSwitch(
                isActive: controller.isHideMessage.value,
                onChange: onChanged,
              ),
            ],
          )),
    );
  }

  Widget _buildMediaCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(
            Routes.MEDIA_FILES,
            arguments: MediaFilesParameter(chatId: controller.parameter.chat!.id!),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: appTheme.appColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.photo_library_outlined,
                        color: appTheme.appColor,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'images_files'.tr,
                            style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'view_shared_media_files'.tr,
                            style: StyleThemeData.size12Weight400(
                              color: appTheme.greyColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: appTheme.greyColor.withOpacity(0.5),
                      size: 20.w,
                    ),
                  ],
                ),

                // Media preview
                Obx(() => _buildMediaPreview()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (controller.mediaImageModel.value != null && (controller.mediaImageModel.value?.items ?? []).isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 12.h),
        height: 60.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (controller.mediaImageModel.value?.items ?? []).take(6).length,
          itemBuilder: (context, index) {
            if (index == 5 && (controller.mediaImageModel.value?.items ?? []).length > 6) {
              return Container(
                width: 60.w,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: appTheme.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '+${(controller.mediaImageModel.value?.items ?? []).length - 5}',
                    style: StyleThemeData.size12Weight600(color: appTheme.appColor),
                  ),
                ),
              );
            }

            final item = (controller.mediaImageModel.value?.items ?? [])[index];
            return Container(
              margin: EdgeInsets.only(right: 8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item.fileUrl ?? '',
                  size: 60,
                  borderRadius: 8,
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: appTheme.appColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.photo_outlined,
            color: appTheme.greyColor.withOpacity(0.5),
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'media_files_in_the_conversation_will_appear_here'.tr,
              style: StyleThemeData.size12Weight400(
                color: appTheme.greyColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: Colors.red,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'danger_zone'.tr,
                style: StyleThemeData.size14Weight600(color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showCommonDialog(
                  title: 'are_you_sure_you_want_to_delete_the_conversation'.tr,
                  onSubmit: controller.deleteChat,
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20.w,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'delete_conversation'.tr,
                            style: StyleThemeData.size14Weight600(color: Colors.red),
                          ),
                          Text(
                            'permanently_delete_group_chat'.tr,
                            style: StyleThemeData.size12Weight400(
                              color: Colors.red.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
