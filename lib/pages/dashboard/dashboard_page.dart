import 'package:chats/main.dart';
import 'package:chats/pages/dashboard/dashboard_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.chatsIcon,
                    iconEmpty: IconsAssets.chatEmptyIcon,
                    page: 0,
                    label: 'message'.tr,
                  ),
                  SizedBox(width: 24.w),
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.contacsIcon,
                    iconEmpty: IconsAssets.contactEmptyIcon,
                    page: 1,
                    label: 'contacts'.tr,
                  ),
                  SizedBox(width: 24.w),
                  _bottomAppBarItem(
                    context,
                    icon: IconsAssets.userIcon,
                    iconEmpty: IconsAssets.userEmptyIcon,
                    page: 2,
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
                        )
                      : ImageAssetCustom(
                          imagePath: iconEmpty,
                          width: 24.w,
                          height: 24.w,
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
