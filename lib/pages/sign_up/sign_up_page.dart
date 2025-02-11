import 'package:chats/main.dart';
import 'package:chats/pages/sign_up/sign_up_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app_enums.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/bottom_sheet/date_bottom_sheet.dart';
import 'package:chats/widget/bottom_sheet/gender_bottom_sheet.dart';
import 'package:chats/widget/checked_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends GetWidget<SignUpController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const DefaultAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: padding(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage, size: 111.w),
                SizedBox(height: 24.h),
                Text('register'.tr, style: StyleThemeData.size24Weight600()),
                SizedBox(height: 4.h),
                Text(
                  'register_message'.tr,
                  style: StyleThemeData.size12Weight400(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.nameController,
                  titleText: 'your_name'.tr,
                  hintText: 'enter_your_name'.tr,
                  contentPadding: padding(vertical: 8),
                  showBorder: false,
                  isStatus: true,
                  showStar: false,
                  formatter: FormatterUtil.fullNameFormatter,
                  onValidate: (value) {
                    return CustomValidator.validateName(value);
                  },
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CustomTextField(
                    controller: controller.phoneController,
                    titleText: 'phone_number'.tr,
                    hintText: 'enter_phone'.tr,
                    contentPadding: padding(vertical: 8),
                    showBorder: false,
                    isStatus: true,
                    showStar: false,
                    inputType: TextInputType.phone,
                    formatter: FormatterUtil.phoneFormatter,
                    errorText: controller.phoneError.value.isNotEmpty ? controller.phoneError.value : '',
                    onChanged: controller.validatePhone,
                    onValidate: (value) {
                      return CustomValidator.validatePhone(value);
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CustomTextField(
                    controller: controller.passwordController,
                    titleText: 'password'.tr,
                    hintText: 'enter_password'.tr,
                    contentPadding: padding(vertical: 8),
                    showBorder: false,
                    isPassword: true,
                    showStar: false,
                    formatter: FormatterUtil.passwordFormatter,
                    errorText: controller.passwordError.value.isNotEmpty ? controller.passwordError.value : '',
                    onChanged: controller.validatePassword,
                    onValidate: (value) {
                      controller.showPassword.value = value;
                      return CustomValidator.validatePassword(value);
                    },
                  ),
                ),
                Obx(() {
                  if (controller.showPassword.value.isEmpty &&
                      CustomValidator.validatePassword(controller.showPassword.value).isEmpty) {
                    return Padding(
                      padding: padding(top: 8),
                      child: Text(
                        'validate_password'.tr,
                        style: StyleThemeData.size12Weight400(
                            color: CustomValidator.validatePassword(controller.showPassword.value).isEmpty
                                ? appTheme.redColor
                                : appTheme.blackColor),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: controller.addressController,
                  titleText: 'address'.tr,
                  hintText: 'enter_address'.tr,
                  contentPadding: padding(vertical: 8),
                  showBorder: false,
                  isStatus: true,
                  showStar: false,
                  formatter: FormatterUtil.addressFormatter,
                  onValidate: (value) {
                    return CustomValidator.validateAddress(value);
                  },
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      showGenderBottomSheet(
                        selectedGender: controller.selectGender.value,
                        onSelected: controller.saveGender,
                      );
                    },
                    child: CustomTextField(
                      titleText: 'gender'.tr,
                      hintText: controller.selectGender.value?.title ?? 'select_gender'.tr,
                      contentPadding: padding(vertical: 8),
                      showBorder: false,
                      showStar: false,
                      isEnabled: false,
                      suffixIcon: const IconButton(
                        onPressed: null,
                        icon: ImageAssetCustom(imagePath: IconsAssets.arrowDownIcon),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: () {
                    showDateBottomSheet();
                  },
                  child: CustomTextField(
                    titleText: 'date_of_birth'.tr,
                    hintText: 'select_date'.tr,
                    contentPadding: padding(vertical: 8),
                    showBorder: false,
                    showStar: false,
                    isEnabled: false,
                    suffixIcon: const IconButton(
                      onPressed: null,
                      icon: ImageAssetCustom(imagePath: IconsAssets.calendarIcon),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: padding(right: 8),
                              child: CheckedWidget(
                                isSelect: controller.isPolicyChecked.value,
                                onTap: () {
                                  controller.isPolicyChecked.value = !controller.isPolicyChecked.value;
                                },
                              ),
                            ),
                          ),
                          TextSpan(text: 'you_agree_to'.tr, style: StyleThemeData.size12Weight400()),
                          TextSpan(
                            text: ' ${'policy'.tr} '.tr,
                            style: StyleThemeData.size12Weight400(color: appTheme.appColor),
                            recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.HTML),
                          ),
                          TextSpan(
                            text: 'our'.tr,
                            style: StyleThemeData.size12Weight400(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CustomButton(
                    buttonText: 'register'.tr,
                    isLoading: controller.isLoading.isTrue,
                    onPressed: controller.isFormValid.isTrue ? controller.confirm : null,
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
                      recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.SIGN_IN),
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
