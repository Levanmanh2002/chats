import 'package:chats/main.dart';
import 'package:chats/pages/update_profile/update_profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfilePage extends GetWidget<UpdateProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: DefaultAppBar(title: 'personal_information'.tr),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: padding(all: 16),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CustomImageWidget(
                          imageUrl: controller.user?.avatar ?? '',
                          size: 100,
                          noImage: false,
                          colorBoder: appTheme.whiteColor,
                          showBoder: true,
                          sizeBorder: 2.w,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: controller.pickImageAvatar,
                            child: ImageAssetCustom(imagePath: ImagesAssets.cameraBorderImage, size: 32.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(controller.user?.name ?? '', style: StyleThemeData.size16Weight600()),
                    SizedBox(height: 2.h),
                    Text(
                      controller.user?.phone?.replaceFirst(controller.phoneCode.value.getCodeAsString(), '0') ?? '',
                      style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
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
                    // CustomTextField(
                    //   controller: controller.addressController,
                    //   titleText: 'address'.tr,
                    //   hintText: 'enter_address'.tr,
                    //   contentPadding: padding(vertical: 8),
                    //   showBorder: false,
                    //   isStatus: true,
                    //   showStar: false,
                    //   formatter: FormatterUtil.addressFormatter,
                    //   onValidate: (value) {
                    //     return CustomValidator.validateAddress(value);
                    //   },
                    // ),
                    // SizedBox(height: 24.h),
                    // Obx(
                    //   () => GestureDetector(
                    //     onTap: () {
                    //       showGenderBottomSheet(
                    //         selectedGender: controller.selectGender.value,
                    //         onSelected: controller.saveGender,
                    //       );
                    //     },
                    //     child: CustomTextField(
                    //       titleText: 'gender'.tr,
                    //       hintText: controller.selectGender.value?.title ?? 'select_gender'.tr,
                    //       hintStyle: controller.selectGender.value != null ? StyleThemeData.size14Weight400() : null,
                    //       contentPadding: padding(vertical: 8),
                    //       showBorder: false,
                    //       showStar: false,
                    //       isEnabled: false,
                    //       suffixIcon: const IconButton(
                    //         onPressed: null,
                    //         icon: ImageAssetCustom(imagePath: IconsAssets.arrowDownIcon),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 24.h),
                    // Obx(
                    //   () => GestureDetector(
                    //     onTap: () {
                    //       showDateBottomSheet(
                    //         selectDate: controller.selectDate.value,
                    //         onChanged: controller.saveDate,
                    //       );
                    //     },
                    //     child: CustomTextField(
                    //       titleText: 'date_of_birth'.tr,
                    //       hintText: controller.selectDate.value != null
                    //           ? controller.selectDate.value.toddMMyyyyDash
                    //           : 'select_date'.tr,
                    //       hintStyle: controller.selectDate.value != null ? StyleThemeData.size14Weight400() : null,
                    //       contentPadding: padding(vertical: 8),
                    //       showBorder: false,
                    //       showStar: false,
                    //       isEnabled: false,
                    //       suffixIcon: const IconButton(
                    //         onPressed: null,
                    //         icon: ImageAssetCustom(imagePath: IconsAssets.calendarIcon),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 24.h),
                    CustomTextField(
                      controller: controller.autoMessage,
                      titleText: 'auto_message'.tr,
                      hintText: 'enter_auto_message_content'.tr,
                      contentPadding: padding(vertical: 8),
                      showBorder: false,
                      isStatus: true,
                      showStar: false,
                      formatter: FormatterUtil.addressFormatter,
                    ),
                    SizedBox(height: 24.h),
                    Obx(
                      () => CustomButton(
                        buttonText: 'save'.tr,
                        isLoading: controller.isLoading.isTrue,
                        onPressed: controller.isFormValid.isTrue ? controller.updateProfile : null,
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
