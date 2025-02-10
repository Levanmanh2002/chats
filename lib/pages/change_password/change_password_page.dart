import 'package:chats/main.dart';
import 'package:chats/pages/change_password/change_password_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends GetWidget<ChangePasswordController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: padding(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage, size: 111.w),
                SizedBox(height: 24.h),
                Text('change_password'.tr, style: StyleThemeData.size24Weight600()),
                SizedBox(height: 4.h),
                Text(
                  'please_enter_new_password'.tr,
                  style: StyleThemeData.size12Weight400(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.newPasswordController,
                  titleText: 'new_password'.tr,
                  hintText: 'enter_password'.tr,
                  contentPadding: padding(vertical: 8),
                  showBorder: false,
                  isPassword: true,
                  onChanged: controller.validatePassword,
                  formatter: FormatterUtil.passwordFormatter,
                  onValidate: (value) {
                    controller.showPassword.value = value;
                    return CustomValidator.validatePassword(value);
                  },
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.confirmNewPasswordController,
                  titleText: 'confirm_new_password'.tr,
                  hintText: 'enter_password'.tr,
                  contentPadding: padding(vertical: 8),
                  showBorder: false,
                  isPassword: true,
                  formatter: FormatterUtil.passwordFormatter,
                  onChanged: controller.validateConfirmPassword,
                  onValidate: (value) {
                    if (value != controller.newPasswordController.text) {
                      return 'passwords_do_not_match'.tr;
                    }
                    return '';
                  },
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CustomButton(
                    buttonText: 'confirm'.tr,
                    isLoading: controller.isLoading.isTrue,
                    onPressed: controller.isFormValid.isTrue ? controller.onConfirm : null,
                  ),
                ),
                SizedBox(height: 40.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(text: '${'already_have_an_account'.tr}? ', style: StyleThemeData.size14Weight400()),
                    TextSpan(
                      text: 'login'.tr,
                      style: StyleThemeData.size14Weight400(color: appTheme.appColor),
                      recognizer: TapGestureRecognizer()..onTap = () => Get.offAllNamed(Routes.SIGN_IN),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
