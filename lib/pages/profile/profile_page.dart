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
              HeaderProfileView(),
              SizedBox(height: 24.h),
              _buildProfileSections(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSections() {
    return Padding(
      padding: padding(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('account_settings'.tr),
          SizedBox(height: 12.h),
          _buildProfileCard([
            _buildProfileItem(
              icon: IconsAssets.userEmptyIcon,
              title: 'personal_information'.tr,
              onTap: () => Get.toNamed(
                Routes.UPDATE_PROFILE,
                arguments: UpdateProfileParameter(user: controller.user.value),
              ),
            ),
            _buildDivider(),
            _buildProfileItem(
              icon: IconsAssets.smartPhoneIcon,
              title: 'sync_contacts'.tr,
              onTap: () => Get.toNamed(Routes.SYNC_CONTACT),
            ),
            _buildDivider(),
            _buildProfileItem(
              icon: IconsAssets.lockPasswordIcon,
              title: 'update_password'.tr,
              onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionHeader('messages_security'.tr),
          SizedBox(height: 12.h),
          _buildProfileCard([
            _buildProfileItem(
              icon: IconsAssets.chatRoundLineIcon,
              title: 'manage_instant_messages'.tr,
              onTap: () => Get.toNamed(
                Routes.INSTANT_MESSAGE,
                arguments: InstantMessageParameter(
                  type: InstantMessageType.noChatId,
                ),
              ),
            ),
            _buildDivider(),
            _buildProfileItem(
              icon: IconsAssets.keyholeIcon,
              title: 'security_code_configuration'.tr,
              onTap: () => Get.toNamed(
                Routes.SECURITY_CODE,
                arguments: SecurityCodeParameter(user: controller.user.value),
              ),
            ),
            _buildDivider(),
            _buildProfileItem(
              icon: IconsAssets.keyholeIcon,
              title: 'screen_lock_code_configuration'.tr,
              onTap: () => Get.toNamed(
                Routes.SCREEN_SECURITY_CODE,
                arguments: ScreenSecurityCodeParameter(user: controller.user.value),
              ),
            ),
          ]),
          SizedBox(height: 24.h),
          _buildSectionHeader('support_help'.tr),
          SizedBox(height: 12.h),
          _buildProfileCard([
            _buildProfileItem(
              icon: IconsAssets.phoneIcon,
              title: 'contact_support'.tr,
              onTap: () {
                makePhoneCall(controller.phoneSupport.value);
              },
            ),
            if ((controller.systemSetting.value?.documentUrl ?? '').isNotEmpty) ...[
              _buildDivider(),
              _buildProfileItem(
                icon: IconsAssets.documentIcon,
                title: 'instructions_for_use'.tr,
                onTap: () {
                  launchUrlLink(controller.systemSetting.value?.documentUrl ?? '');
                },
              ),
            ],
          ]),
          SizedBox(height: 24.h),
          _buildSectionHeader('account_management'.tr),
          SizedBox(height: 12.h),
          _buildProfileCard([
            _buildProfileItem(
              icon: IconsAssets.trashBinIcon,
              title: 'delete_account'.tr,
              colorIcon: appTheme.errorColor,
              colorTitle: appTheme.errorColor,
              onTap: () {
                showDeleteAccountDialog(controller.deleteAccount);
              },
            ),
            _buildDivider(),
            _buildProfileItem(
              icon: IconsAssets.logoutIcon,
              title: 'log_out'.tr,
              colorIcon: appTheme.errorColor,
              colorTitle: appTheme.errorColor,
              onTap: () => controller.logout(isShowTitle: true),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: StyleThemeData.size16Weight600(color: const Color(0xFF1A1D29)),
    );
  }

  Widget _buildProfileCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildProfileItem({
    required String icon,
    required String title,
    VoidCallback? onTap,
    Color? colorTitle,
    Color? colorIcon,
  }) {
    return Material(
      color: appTheme.transparentColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: padding(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color:
                      colorIcon != null ? colorIcon.withOpacity(0.1) : appTheme.primaryGradientStart.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: ImageAssetCustom(
                    imagePath: icon,
                    size: 20.w,
                    color: colorIcon ?? appTheme.primaryGradientStart,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: StyleThemeData.size15Weight500(
                    color: colorTitle ?? const Color(0xFF1A1D29),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: const Color(0xFF8E8E93),
                size: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: padding(left: 76),
      child: const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
    );
  }
}

class ProfilePageAlternative extends GetWidget<ProfileController> {
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
              HeaderProfileView(),
              SizedBox(height: 24.h),
              Column(
                children: [
                  _buildModernProfile(
                    icon: IconsAssets.userEmptyIcon,
                    title: 'personal_information'.tr,
                    subtitle: 'manage_your_account_info'.tr,
                    onTap: () => Get.toNamed(
                      Routes.UPDATE_PROFILE,
                      arguments: UpdateProfileParameter(user: controller.user.value),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.smartPhoneIcon,
                    title: 'sync_contacts'.tr,
                    subtitle: 'sync_phone_contacts'.tr,
                    onTap: () => Get.toNamed(Routes.SYNC_CONTACT),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.lockPasswordIcon,
                    title: 'update_password'.tr,
                    subtitle: 'change_account_password'.tr,
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.chatRoundLineIcon,
                    title: 'manage_instant_messages'.tr,
                    subtitle: 'configure_quick_replies'.tr,
                    onTap: () => Get.toNamed(
                      Routes.INSTANT_MESSAGE,
                      arguments: InstantMessageParameter(
                        type: InstantMessageType.noChatId,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.keyholeIcon,
                    title: 'security_code_configuration'.tr,
                    subtitle: 'setup_security_pin'.tr,
                    onTap: () => Get.toNamed(
                      Routes.SECURITY_CODE,
                      arguments: SecurityCodeParameter(user: controller.user.value),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.keyholeIcon,
                    title: 'screen_lock_code_configuration'.tr,
                    subtitle: 'setup_screen_lock'.tr,
                    onTap: () => Get.toNamed(
                      Routes.SCREEN_SECURITY_CODE,
                      arguments: ScreenSecurityCodeParameter(user: controller.user.value),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.phoneIcon,
                    title: 'contact_support'.tr,
                    subtitle: 'get_help_support'.tr,
                    onTap: () {
                      makePhoneCall(controller.phoneSupport.value);
                    },
                  ),
                  SizedBox(height: 12.h),
                  if ((controller.systemSetting.value?.documentUrl ?? '').isNotEmpty) ...[
                    _buildModernProfile(
                      icon: IconsAssets.documentIcon,
                      title: 'instructions_for_use'.tr,
                      subtitle: 'app_user_guide'.tr,
                      onTap: () {
                        launchUrlLink(controller.systemSetting.value?.documentUrl ?? '');
                      },
                    ),
                    SizedBox(height: 12.h),
                  ],
                  _buildModernProfile(
                    icon: IconsAssets.trashBinIcon,
                    title: 'delete_account'.tr,
                    subtitle: 'permanently_delete_account'.tr,
                    colorIcon: appTheme.errorColor,
                    colorTitle: appTheme.errorColor,
                    colorSubtitle: appTheme.errorColor.withOpacity(0.7),
                    onTap: () {
                      showDeleteAccountDialog(controller.deleteAccount);
                    },
                  ),
                  SizedBox(height: 12.h),
                  _buildModernProfile(
                    icon: IconsAssets.logoutIcon,
                    title: 'log_out'.tr,
                    subtitle: 'sign_out_account'.tr,
                    colorIcon: appTheme.errorColor,
                    colorTitle: appTheme.errorColor,
                    colorSubtitle: appTheme.errorColor.withOpacity(0.7),
                    onTap: () => controller.logout(isShowTitle: true),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernProfile({
    required String icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? colorTitle,
    Color? colorIcon,
    Color? colorSubtitle,
  }) {
    return Padding(
      padding: padding(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: appTheme.blackColor.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: padding(all: 20),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: colorIcon != null ? colorIcon.withOpacity(0.1) : const Color(0xFF667EEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: ImageAssetCustom(
                        imagePath: icon,
                        size: 22.w,
                        color: colorIcon ?? const Color(0xFF667EEA),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: StyleThemeData.size15Weight600(
                            color: colorTitle ?? const Color(0xFF1A1D29),
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            subtitle,
                            style: StyleThemeData.size13Weight400(
                              color: colorSubtitle ?? const Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: const Color(0xFF8E8E93),
                    size: 20.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
