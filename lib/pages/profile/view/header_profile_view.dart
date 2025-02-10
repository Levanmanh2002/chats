import 'package:chats/main.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: padding(bottom: 50),
                child: const ImageAssetCustom(imagePath: ImagesAssets.bgTopProfileImage),
              ),
              Positioned(
                bottom: 0,
                child: Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: controller.user.value?.avatar ?? '',
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
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(controller.user.value?.name ?? '', style: StyleThemeData.size16Weight600()),
          SizedBox(height: 2.h),
          Text(controller.user.value?.phone ?? '', style: StyleThemeData.size12Weight400(color: appTheme.grayColor)),
        ],
      ),
    );
  }
}
