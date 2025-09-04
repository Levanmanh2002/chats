import 'package:chats/main.dart';
import 'package:chats/pages/instant_message/instant_message_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/profile/view/header_profile_view.dart';
import 'package:chats/pages/screen_security_code/screen_security_code_parameter.dart';
import 'package:chats/pages/security_code/security_code_parameter.dart';
import 'package:chats/pages/update_profile/update_profile_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/widget/dialog/show_delete_account_dialog.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListLoader(
        onRefresh: controller.onRefresh,
        forceScrollable: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              HeaderProfileView(),
              SizedBox(height: 32.h),
              _buildMenuSection(
                title: 'account_settings'.tr,
                items: [
                  _buildMenuItemData(
                    icon: IconsAssets.userEmptyIcon,
                    title: 'personal_information'.tr,
                    subtitle: 'manage_your_profile_info'.tr,
                    onTap: () => Get.toNamed(
                      Routes.UPDATE_PROFILE,
                      arguments: UpdateProfileParameter(user: controller.user.value),
                    ),
                  ),
                  _buildMenuItemData(
                    icon: IconsAssets.smartPhoneIcon,
                    title: 'sync_contacts'.tr,
                    subtitle: 'sync_your_phone_contacts'.tr,
                    onTap: () => Get.toNamed(Routes.SYNC_CONTACT),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _buildMenuSection(
                title: 'security'.tr,
                items: [
                  _buildMenuItemData(
                    icon: IconsAssets.lockPasswordIcon,
                    title: 'update_password'.tr,
                    subtitle: 'change_your_password'.tr,
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  ),
                  _buildMenuItemData(
                    icon: IconsAssets.keyholeIcon,
                    title: 'security_code_configuration'.tr,
                    subtitle: 'setup_security_code'.tr,
                    onTap: () => Get.toNamed(
                      Routes.SECURITY_CODE,
                      arguments: SecurityCodeParameter(user: controller.user.value),
                    ),
                  ),
                  _buildMenuItemData(
                    icon: IconsAssets.keyholeIcon,
                    title: 'screen_lock_code_configuration'.tr,
                    subtitle: 'setup_screen_lock'.tr,
                    onTap: () => Get.toNamed(
                      Routes.SCREEN_SECURITY_CODE,
                      arguments: ScreenSecurityCodeParameter(user: controller.user.value),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _buildMenuSection(
                title: 'chat_settings'.tr,
                items: [
                  _buildMenuItemData(
                    icon: IconsAssets.chatRoundLineIcon,
                    title: 'manage_instant_messages'.tr,
                    subtitle: 'customize_message_settings'.tr,
                    onTap: () => Get.toNamed(
                      Routes.INSTANT_MESSAGE,
                      arguments: InstantMessageParameter(
                        type: InstantMessageType.noChatId,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              _buildMenuSection(
                title: 'support_help'.tr,
                items: [
                  _buildMenuItemData(
                    icon: IconsAssets.phoneIcon,
                    title: 'contact_support'.tr,
                    subtitle: 'get_help_support'.tr,
                    onTap: () {
                      makePhoneCall(controller.phoneSupport.value);
                    },
                  ),
                  if ((controller.systemSetting.value?.documentUrl ?? '').isNotEmpty)
                    _buildMenuItemData(
                      icon: IconsAssets.documentIcon,
                      title: 'instructions_for_use'.tr,
                      subtitle: 'view_user_guide'.tr,
                      onTap: () {
                        launchUrlLink(controller.systemSetting.value?.documentUrl ?? '');
                      },
                    ),
                ],
              ),

              SizedBox(height: 24.h),

              // Danger zone
              _buildMenuSection(
                title: 'danger_zone'.tr,
                isDangerZone: true,
                items: [
                  _buildMenuItemData(
                    icon: IconsAssets.trashBinIcon,
                    title: 'delete_account'.tr,
                    subtitle: 'permanently_delete_account'.tr,
                    isDestructive: true,
                    onTap: () {
                      showDeleteAccountDialog(controller.deleteAccount);
                    },
                  ),
                  _buildMenuItemData(
                    icon: IconsAssets.logoutIcon,
                    title: 'log_out'.tr,
                    subtitle: 'sign_out_of_your_account'.tr,
                    isDestructive: true,
                    onTap: () => controller.logout(isShowTitle: true),
                  ),
                ],
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<MenuItemData> items,
    bool isDangerZone = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Text(
              title,
              style: StyleThemeData.size16Weight600(
                color: isDangerZone ? appTheme.errorColor : appTheme.greyColor,
              ),
            ),
          ),

          // Menu items container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
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
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    _buildMenuItem(
                      icon: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      onTap: item.onTap,
                      isDestructive: item.isDestructive,
                    ),
                    if (!isLast)
                      Padding(
                        padding: EdgeInsets.only(left: 64.w),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: appTheme.greyColor.withOpacity(0.1),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              // Icon container với background tròn
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: isDestructive ? appTheme.errorColor.withOpacity(0.1) : appTheme.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: ImageAssetCustom(
                    imagePath: icon,
                    size: 20.w,
                    color: isDestructive ? appTheme.errorColor : appTheme.appColor,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StyleThemeData.size16Weight500(
                        color: isDestructive ? appTheme.errorColor : appTheme.blackColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: StyleThemeData.size14Weight400(
                        color: appTheme.greyColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.chevron_right,
                size: 20.w,
                color: appTheme.greyColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MenuItemData _buildMenuItemData({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return MenuItemData(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      isDestructive: isDestructive,
    );
  }
}

// Data class để lưu thông tin menu item
class MenuItemData {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isDestructive = false,
  });
}
