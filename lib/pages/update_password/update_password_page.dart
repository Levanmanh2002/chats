import 'package:chats/pages/update_password/update_password_controller.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordPage extends GetWidget<UpdatePasswordController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: DefaultAppBar(title: 'update_password'.tr),
        body: Padding(
          padding: padding(all: 16),
          child: Column(
            children: [
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
                  controller.isHidePassword.value = false;
                  return CustomValidator.validatePassword(value);
                },
              ),
              // Obx(() {
              //   if (CustomValidator.validatePassword(controller.showPassword.value).isEmpty) {
              //     return Padding(
              //       padding: padding(top: 8),
              //       child: Text('validate_password'.tr, style: StyleThemeData.size12Weight400()),
              //     );
              //   } else if (controller.isHidePassword.isTrue) {
              //     return Padding(
              //       padding: padding(top: 8),
              //       child: Text('validate_password'.tr, style: StyleThemeData.size12Weight400()),
              //     );
              //   }
              //   return const SizedBox();
              // }),
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
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => CustomButton(
            margin: padding(top: 12, horizontal: 16, bottom: 24),
            buttonText: 'save'.tr,
            isLoading: controller.isLoading.isTrue,
            onPressed: controller.isFormValid.isTrue ? controller.updatePassword : null,
          ),
        ),
      ),
    );
  }
}
