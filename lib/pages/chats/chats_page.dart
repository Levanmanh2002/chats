import 'package:chats/main.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/view/chat_all_view.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(
        () => Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: appTheme.appColor,
            elevation: 0,
            title: controller.isSearch.isTrue
                ? CustomTextField(
                    controller: controller.searchController,
                    showLine: false,
                    hintText: 'search'.tr,
                    onSubmit: controller.onSearchChat,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.onSearchChat(controller.searchController.text);
                      },
                      icon: ImageAssetCustom(imagePath: IconsAssets.searchIcon, size: 24.w, color: appTheme.appColor),
                    ),
                  )
                : Text(
                    'chat'.tr,
                    style: StyleThemeData.size20Weight700(color: Colors.white),
                  ),
            centerTitle: false,
            actions: [
              // Search button
              Container(
                margin: EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    controller.isSearch.isTrue ? Icons.close : Icons.search,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  onPressed: controller.toggleSearch,
                ),
              ),

              // Lock button (conditional)
              Obx(() {
                if (Get.find<ProfileController>().user.value?.isEnableSecurityScreen == true) {
                  return Container(
                    margin: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _showLockConfirmation(),
                      icon: Icon(
                        Icons.lock_outline,
                        size: 20.w,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
          body: Column(
            children: [
              // Enhanced header section
              // _buildHeaderSection(),

              // SizedBox(height: 16.h),

              // Chat list
              Expanded(child: ChatAllView()),
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(),
        ),
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text(
              'welcome_back'.tr,
              style: StyleThemeData.size14Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            SizedBox(height: 4.h),

            // User name or title
            Text(
              'your_conversations'.tr,
              style: StyleThemeData.size24Weight700(color: Colors.white),
            ),

            SizedBox(height: 16.h),

            // Stats row
            _buildStatsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(
      () => Row(
        children: [
          _buildStatCard(
            icon: Icons.chat_outlined,
            label: 'active_chats'.tr,
            value: '${(controller.chatsModels.value?.chat ?? []).length}',
            color: Colors.white,
          ),
          SizedBox(width: 12.w),
          _buildStatCard(
            icon: Icons.circle,
            label: 'unread_messages'.tr,
            value: '${(controller.chatsModels.value?.chat ?? []).where((chat) => chat.isRead == false).length}',
            color: Colors.orange,
          ),
          SizedBox(width: 12.w),
          _buildStatCard(
            icon: Icons.people_outline,
            label: 'groups'.tr,
            value: '${(controller.chatsModels.value?.chat ?? []).where((chat) => chat.isGroup == 1).length}',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 18.w,
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: StyleThemeData.size16Weight700(color: Colors.white),
            ),
            Text(
              label,
              style: StyleThemeData.size10Weight400(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.appColor,
            appTheme.appColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appTheme.appColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          _showCreateOptions();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 24.w,
        ),
      ),
    );
  }

  void _showCreateOptions() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: appTheme.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'start_new_conversation'.tr,
              style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
            ),

            SizedBox(height: 20.h),

            _buildBottomSheetOption(
              icon: Icons.person_add_outlined,
              title: 'add_friend'.tr,
              subtitle: 'add_new_contact_to_chat'.tr,
              onTap: () {
                Get.back();
                Get.toNamed(Routes.ADD_FRIEND);
              },
            ),

            SizedBox(height: 16.h),

            _buildBottomSheetOption(
              icon: Icons.group_add_outlined,
              title: 'create_group'.tr,
              subtitle: 'start_group_conversation'.tr,
              onTap: () {
                Get.back();
                Get.toNamed(
                  Routes.CREATE_GROUP,
                  arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
                );
              },
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
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
            border: Border.all(
              color: appTheme.greyColor.withOpacity(0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: appTheme.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: appTheme.appColor,
                  size: 22.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
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
    );
  }

  void _showLockConfirmation() {
    showCommonDialog(
      title: 'lock_chat_confirmation'.tr,
      onSubmit: () {
        Get.offAllNamed(Routes.CONFIRM_SECURITY_CODE);
      },
      buttonTitle: 'lock'.tr,
    );
  }
}
