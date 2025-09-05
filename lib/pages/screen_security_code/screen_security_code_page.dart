import 'package:chats/main.dart';
import 'package:chats/pages/screen_enter_code_mumber/screen_enter_code_mumber_parameter.dart';
import 'package:chats/pages/screen_security_code/screen_security_code_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/app_switch.dart';
import 'package:chats/widget/dialog/show_logout_confirmation.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSecurityCodePage extends GetWidget<ScreenSecurityCodeController> {
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

              // Screen lock header với illustration
              _buildScreenLockHeader(),

              SizedBox(height: 32.h),

              // Main settings card
              _buildSettingsCard(),

              SizedBox(height: 24.h),

              // Screen lock features
              _buildScreenLockFeatures(),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildLogoutButton(),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: appTheme.blackColor,
            size: 18.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        'screen_lock_code_configuration'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildScreenLockHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.indigo.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Screen lock icon với phone frame
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  color: Colors.indigo,
                  size: 40.w,
                ),
                Positioned(
                  bottom: 18.h,
                  child: Icon(
                    Icons.lock,
                    color: Colors.indigo,
                    size: 16.w,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'screen_lock_protection'.tr,
            style: StyleThemeData.size20Weight700(color: appTheme.blackColor),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            'screen_lock_protection_desc'.tr,
            style: StyleThemeData.size14Weight400(
              color: appTheme.greyColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
          // Enable screen lock setting
          _buildSettingItem(
            icon: Icons.screen_lock_portrait_outlined,
            title: 'set_passcode'.tr,
            subtitle: 'enable_screen_lock_passcode'.tr,
            trailing: Obx(
              () => AppSwitch(
                isActive: controller.user.value?.isEnableSecurityScreen ?? false,
                onChange: () => Get.toNamed(
                  Routes.ENTER_CODE_MUMBER_SCREEN,
                  arguments: ScreenEnterCodeMumberParameter(
                    user: controller.user.value,
                    action: controller.user.value?.isEnableSecurityScreen == true
                        ? ScreenEnterCodeMumberAction.disable
                        : ScreenEnterCodeMumberAction.enable,
                  ),
                ),
              ),
            ),
          ),

          // Change screen lock passcode (conditional)
          Obx(() {
            if ((controller.user.value?.isEnableSecurityScreen ?? false) == true) {
              return Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: appTheme.greyColor.withOpacity(0.1),
                    indent: 64.w,
                  ),
                  _buildSettingItem(
                    icon: Icons.screen_lock_rotation_outlined,
                    title: 'change_passcode'.tr,
                    subtitle: 'update_screen_lock_passcode'.tr,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: appTheme.greyColor.withOpacity(0.5),
                      size: 20.w,
                    ),
                    onTap: () => Get.toNamed(
                      Routes.ENTER_CODE_MUMBER_SCREEN,
                      arguments: ScreenEnterCodeMumberParameter(
                        user: controller.user.value,
                        action: ScreenEnterCodeMumberAction.change,
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.indigo,
                    size: 20.w,
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
                      style: StyleThemeData.size16Weight500(color: appTheme.blackColor),
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

              // Trailing widget
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenLockFeatures() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appTheme.greyColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_outline,
                color: Colors.amber,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'screen_lock_features'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...(_getScreenLockFeatures().map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 16.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: StyleThemeData.size12Weight400(
                        color: appTheme.greyColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  List<String> _getScreenLockFeatures() {
    return [
      'auto_lock_when_inactive'.tr,
      'protect_private_messages'.tr,
      'prevent_unauthorized_access'.tr,
      'works_in_background'.tr,
    ];
  }

  Widget _buildLogoutButton() {
    return Obx(
      () => (controller.user.value?.securityCodeScreen ?? '').isNotEmpty
          ? Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        appTheme.errorColor,
                        appTheme.errorColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.errorColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showLogoutConfirmation(controller.onLogoutPasscode);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'logout_reset_security'.tr,
                              style: StyleThemeData.size16Weight600(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
