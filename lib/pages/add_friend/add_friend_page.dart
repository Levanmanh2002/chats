import 'package:chats/main.dart';
import 'package:chats/pages/add_friend/add_friend_controller.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendPage extends GetWidget<AddFriendController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appTheme.allSidesColor,
        appBar: DefaultAppBar(title: 'add_friend'.tr),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Container(
                    padding: padding(vertical: 24, horizontal: 16),
                    color: appTheme.whiteColor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ImageAssetCustom(imagePath: ImagesAssets.addFriendImage),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Flexible(
                              child: CustomTextField(
                                controller: controller.phoneController,
                                hintText: 'enter_phone_number'.tr,
                                showLine: false,
                                colorBorder: appTheme.grayB9Color,
                                prefixIcon: const IconButton(
                                  onPressed: null,
                                  icon: ImageAssetCustom(imagePath: IconsAssets.phoneRoundedIcon),
                                ),
                                inputType: TextInputType.phone,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Obx(
                              () => InkWell(
                                onTap: controller.isFormValid.value ? controller.onSearchAccount : null,
                                borderRadius: BorderRadius.circular(1000),
                                child: Container(
                                  padding: padding(all: 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: appTheme.grayB9Color,
                                    gradient: controller.isFormValid.value
                                        ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [appTheme.blueFCColor, appTheme.appColor],
                                            stops: const [0.0048, 0.8952],
                                          )
                                        : null,
                                  ),
                                  child: const ImageAssetCustom(imagePath: IconsAssets.arrowRightWhiteIcon),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: Get.back,
                    child: Container(
                      color: appTheme.whiteColor,
                      child: Padding(
                        padding: padding(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            ImageAssetCustom(imagePath: ImagesAssets.contactBorderImage, width: 32.w),
                            SizedBox(width: 12.w),
                            Text('friend_list'.tr, style: StyleThemeData.size14Weight400()),
                            SizedBox(width: 4.w),
                            Text(
                              '(${Get.find<ContactsController>().contactModel.value?.data?.length ?? '0'})',
                              style: StyleThemeData.size14Weight400(color: appTheme.grayColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: padding(all: 16),
                    child: Text(
                      'view_your_friends_list_on_the_contacts_page'.tr,
                      style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                    ),
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
