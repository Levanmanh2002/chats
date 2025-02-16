import 'package:chats/main.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/profile/view/header_profile_view.dart';
import 'package:chats/pages/security_code/security_code_parameter.dart';
import 'package:chats/pages/update_profile/update_profile_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
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
      backgroundColor: appTheme.allSidesColor,
      body: ListLoader(
        onRefresh: controller.onRefresh,
        forceScrollable: true,
        child: Column(
          children: [
            HeaderProfileView(),
            SizedBox(height: 24.h),
            _buildProfile(
              icon: IconsAssets.userEmptyIcon,
              title: 'personal_information'.tr,
              onTap: () => Get.toNamed(
                Routes.UPDATE_PROFILE,
                arguments: UpdateProfileParameter(user: controller.user.value),
              ),
            ),
            SizedBox(height: 8.h),
            _buildProfile(
              icon: IconsAssets.smartPhoneIcon,
              title: 'sync_contacts'.tr,
              onTap: () => Get.toNamed(Routes.SYNC_CONTACT),
            ),
            SizedBox(height: 8.h),
            _buildProfile(
              icon: IconsAssets.lockPasswordIcon,
              title: 'update_password'.tr,
              onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
            ),
            SizedBox(height: 8.h),
            _buildProfile(
              icon: IconsAssets.keyholeIcon,
              title: 'security_code_configuration'.tr,
              onTap: () => Get.toNamed(
                Routes.SECURITY_CODE,
                arguments: SecurityCodeParameter(user: controller.user.value),
              ),
            ),
            SizedBox(height: 8.h),
            _buildProfile(
              icon: IconsAssets.trashBinIcon,
              title: 'delete_account'.tr,
              onTap: () {
                showDeleteAccountDialog(controller.deleteAccount);
              },
            ),
            SizedBox(height: 8.h),
            _buildProfile(
              icon: IconsAssets.logoutIcon,
              title: 'log_out'.tr,
              colorIcon: appTheme.errorColor,
              colorTitle: appTheme.errorColor,
              onTap: () => controller.logout(isShowTitle: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile({
    required String icon,
    required String title,
    VoidCallback? onTap,
    Color? colorTitle,
    Color? colorIcon,
  }) {
    return Padding(
      padding: padding(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: padding(all: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appTheme.whiteColor,
          ),
          child: Row(
            children: [
              ImageAssetCustom(imagePath: icon, size: 24.w, color: colorIcon),
              SizedBox(width: 12.w),
              Text(title, style: StyleThemeData.size14Weight400(color: colorTitle)),
            ],
          ),
        ),
      ),
    );
  }
}
