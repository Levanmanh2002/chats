import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/make_friends/make_friends_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MakeFriendsPage extends GetWidget<MakeFriendsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'make_friends'.tr),
      body: Padding(
        padding: padding(all: 16),
        child: Container(
          padding: padding(all: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [appTheme.blueFCColor, appTheme.appColor],
              stops: const [0.0048, 0.8952],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageWidget(
                imageUrl: controller.contact?.avatar ?? '',
                size: 101.w,
                colorBoder: appTheme.appColor,
                showBoder: true,
              ),
              SizedBox(height: 8.h),
              Text(controller.contact?.name ?? '', style: StyleThemeData.size16Weight600(color: appTheme.whiteColor)),
              SizedBox(height: 2.h),
              Text(
                '(${controller.contact?.phone?.formatPhoneCode})',
                style: StyleThemeData.size16Weight600(color: appTheme.whiteColor),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  // if (controller.contact?.isFriend == true) ...[
                  Flexible(
                    child: Obx(
                      () => CustomBorderButtonWidget(
                        buttonText: 'send_message'.tr,
                        radius: 50,
                        color: appTheme.whiteColor,
                        textColor: appTheme.whiteColor,
                        isLoading: controller.isLoadingMessage.isTrue,
                        onPressed: controller.onMessage,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // ],
                  Flexible(
                    child: Obx(
                      () => controller.contact?.isSenderRequestFriend == true
                          ? CustomButton(
                              buttonText: 'revoke'.tr,
                              textColor: appTheme.blackColor,
                              color: appTheme.whiteColor,
                              colorLoading: appTheme.blackColor,
                              isLoading: controller.isLoadingRemove.isTrue,
                              onPressed: controller.removeFriend,
                            )
                          : controller.contact?.isFriend == true
                              ? CustomButton(
                                  buttonText: 'unfriend'.tr,
                                  radius: 50,
                                  textColor: appTheme.errorColor,
                                  color: appTheme.whiteColor,
                                  colorLoading: appTheme.errorColor,
                                  isLoading: controller.isLoadingUnfriend.isTrue,
                                  onPressed: controller.unfriend,
                                )
                              : CustomButton(
                                  buttonText: 'make_friends'.tr,
                                  radius: 50,
                                  textColor: appTheme.appColor,
                                  color: appTheme.whiteColor,
                                  colorLoading: appTheme.appColor,
                                  isLoading: controller.isLoadingAdd.isTrue,
                                  onPressed: controller.addFriend,
                                ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: padding(all: 24),
        child: IconButton(onPressed: null, icon: ImageAssetCustom(imagePath: ImagesAssets.logoTitleImage, size: 65.w)),
      ),
    );
  }
}
