import 'package:chats/main.dart';
import 'package:chats/pages/screen_enter_code_mumber/screen_enter_code_mumber_parameter.dart';
import 'package:chats/pages/screen_security_code/screen_security_code_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/app_switch.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/dialog/show_logout_confirmation.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSecurityCodePage extends GetWidget<ScreenSecurityCodeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'screen_lock_code_configuration'.tr),
      body: Column(
        children: [
          Padding(
            padding: padding(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('set_passcode'.tr, style: StyleThemeData.size14Weight400()),
                SizedBox(width: 12.w),
                Obx(
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
              ],
            ),
          ),
          Obx(() {
            if ((controller.user.value?.isEnableSecurityScreen ?? false) == true) {
              return Column(
                children: [
                  LineWidget(color: appTheme.allSidesColor),
                  InkWell(
                    onTap: () => Get.toNamed(
                      Routes.ENTER_CODE_MUMBER_SCREEN,
                      arguments: ScreenEnterCodeMumberParameter(
                        user: controller.user.value,
                        action: ScreenEnterCodeMumberAction.change,
                      ),
                    ),
                    child: Padding(
                      padding: padding(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('change_passcode'.tr, style: StyleThemeData.size14Weight400()),
                          SizedBox(width: 12.w),
                          const ImageAssetCustom(imagePath: IconsAssets.altArrowRightImage),
                        ],
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
      bottomNavigationBar: Obx(
        () => (controller.user.value?.securityCodeScreen ?? '').isNotEmpty
            ? CustomButton(
                margin: padding(bottom: 36, horizontal: 16, top: 16),
                buttonText: 'logout_reset_security'.tr,
                onPressed: () {
                  showLogoutConfirmation(controller.onLogoutPasscode);
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
