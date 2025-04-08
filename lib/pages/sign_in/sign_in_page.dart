import 'package:chats/main.dart';
import 'package:chats/pages/sign_in/sign_in_controller.dart';
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

class SignInPage extends GetWidget<SignInController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: padding(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage, size: 111.w),
                      SizedBox(height: 24.h),
                      Text('login'.tr, style: StyleThemeData.size24Weight600()),
                      SizedBox(height: 4.h),
                      Text(
                        'login_message'.tr,
                        style: StyleThemeData.size12Weight400(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: controller.phoneController,
                        titleText: 'phone_number'.tr,
                        hintText: 'enter_phone'.tr,
                        showStar: false,
                        showBorder: false,
                        isStatus: true,
                        colorLine: appTheme.appColor,
                        contentPadding: padding(vertical: 8),
                        inputType: TextInputType.phone,
                        errorText: controller.phoneError.value.isNotEmpty ? controller.phoneError.value : '',
                        onChanged: controller.validatePhone,
                        formatter: FormatterUtil.phoneFormatter,
                        onValidate: (value) {
                          return CustomValidator.validatePhone(value);
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: controller.passwordController,
                        titleText: 'password'.tr,
                        hintText: 'enter_password'.tr,
                        showStar: false,
                        showBorder: false,
                        colorLine: appTheme.appColor,
                        contentPadding: padding(vertical: 8),
                        isPassword: true,
                        errorText: controller.passwordError.value.isNotEmpty ? controller.passwordError.value : '',
                        onChanged: controller.validatePassword,
                        formatter: FormatterUtil.passwordFormatter,
                        onValidate: (value) {
                          if (value.isEmpty) {
                            return 'field_is_required'.trParams({'field': 'password'.tr});
                          } else {
                            return '';
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                          child: Text(
                            '${'forgot_password'.tr}?',
                            style: StyleThemeData.size14Weight400(color: appTheme.appColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Obx(
                        () => CustomButton(
                          buttonText: 'login'.tr,
                          isLoading: controller.isLoading.isTrue,
                          onPressed: controller.isFormValid.isTrue ? controller.onConfirm : null,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(text: '${'no_account'.tr}? ', style: StyleThemeData.size14Weight400()),
                          TextSpan(
                            text: 'register'.tr,
                            style: StyleThemeData.size14Weight400(color: appTheme.appColor),
                            recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.SIGN_UP),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
