import 'package:chats/main.dart';
import 'package:chats/pages/dashboard/dashboard_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DashboardPage extends GetWidget<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: controller.animateToTab,
              children: [...controller.pages],
            ),
          ),
          Obx(
            () => Container(
              padding: padding(left: 13, right: 13, top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: appTheme.whiteColor,
                border: Border(top: BorderSide(color: appTheme.allSidesColor, width: 1.w)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.documentIcon,
                    iconEmpty: IconsAssets.documentIcon,
                    page: 0,
                    label: 'Dashboard'.tr,
                  ),

                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.noteIcon,
                    iconEmpty: IconsAssets.noteIcon,
                    page: 1,
                    label: 'work'.tr,
                  ),
                  InkWell(
                    onTap: () => controller.goToTab(2),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: padding(all: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appTheme.appColor,
                      ),
                      child: Center(
                        child: ImageAssetCustom(
                          imagePath: ImagesAssets.cloudImage,
                          width: 30.w,
                          height: 30.w,
                          color: appTheme.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  if (AppConstants.isHideFeatureApp == true &&
                      Get.find<ProfileController>().systemSetting.value?.hideChat == true)
                    _bottomAppBarItem(
                      context,
                      icon: IconsAssets.chatsIcon,
                      iconEmpty: IconsAssets.chatEmptyIcon,
                      page: 3,
                      label: 'Trò chuyện'.tr,
                    ),
                  if (AppConstants.isHideFeatureApp == true)
                    _bottomAppBarItem(
                      context,
                      icon: IconsAssets.contacsIcon,
                      iconEmpty: IconsAssets.contactEmptyIcon,
                      page: 4,
                      label: 'contacts'.tr,
                    ),
                  // _bottomAppBarItem(
                  //   context,
                  //   icon: IconsAssets.chatsIcon,
                  //   iconEmpty: IconsAssets.chatEmptyIcon,
                  //   page: 3,
                  //   label: 'Cloud'.tr,
                  // ),

                  if (AppConstants.isHideFeatureApp == false)
                    _bottomAppBarItem(
                      context,
                      icon: IconsAssets.userGroupTwoIcon,
                      iconEmpty: IconsAssets.userGroupTwoIcon,
                      page: 6,
                      label: 'AI BOT'.tr,
                    ),
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.userIcon,
                    iconEmpty: IconsAssets.userEmptyIcon,
                    page: 5,
                    label: 'personal'.tr,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required String icon,
    required String iconEmpty,
    required int page,
    required String label,
    Widget? avatar,
    Widget? widget,
  }) {
    return ZoomTapAnimation(
      onTap: () => controller.goToTab(page),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              avatar == null
                  ? (controller.currentPage.value == page)
                      ? ImageAssetCustom(
                          imagePath: icon,
                          width: 24.w,
                          height: 24.w,
                          color: appTheme.appColor,
                        )
                      : ImageAssetCustom(
                          imagePath: iconEmpty,
                          width: 24.w,
                          height: 24.w,
                          color: appTheme.grayColor,
                        )
                  : const SizedBox(),
              widget ?? Container(),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: controller.currentPage.value == page
                ? StyleThemeData.size10Weight600(color: appTheme.appColor)
                : StyleThemeData.size10Weight400(color: appTheme.grayColor),
          ),
        ],
      ),
    );
  }
}
