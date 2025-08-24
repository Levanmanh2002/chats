import 'package:chats/main.dart';
import 'package:chats/pages/enter_code_mumber/enter_code_mumber_parameter.dart';
import 'package:chats/pages/security_code/security_code_controller.dart';
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

class SecurityCodePage extends GetWidget<SecurityCodeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'security_code_configuration'.tr),
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
                    isActive: controller.user.value?.isEnableSecurity ?? false,
                    onChange: () => Get.toNamed(
                      Routes.ENTER_CODE_MUMBER,
                      arguments: EnterCodeMumberParameter(
                        user: controller.user.value,
                        action: controller.user.value?.isEnableSecurity == true
                            ? EnterCodeMumberAction.disable
                            : EnterCodeMumberAction.enable,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if ((controller.user.value?.isEnableSecurity ?? false) == true) {
              return Column(
                children: [
                  LineWidget(color: appTheme.allSidesColor),
                  InkWell(
                    onTap: () => Get.toNamed(
                      Routes.ENTER_CODE_MUMBER,
                      arguments: EnterCodeMumberParameter(
                        user: controller.user.value,
                        action: EnterCodeMumberAction.change,
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
        () => controller.user.value?.isEnableSecurity == true
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
