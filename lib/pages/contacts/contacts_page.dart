import 'package:chats/main.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/contacts/view/contacts_view.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/popup/popup.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsPage extends GetWidget<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              const ImageAssetCustom(imagePath: ImagesAssets.topBgChatImage),
              Positioned(
                bottom: 12,
                left: 16,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('contacts'.tr, style: StyleThemeData.size30Weight600(color: appTheme.whiteColor)),
                    CustomPopup(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.toNamed(Routes.ADD_FRIEND);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImageAssetCustom(imagePath: IconsAssets.userPlusRoundedIcon, size: 24.w),
                                SizedBox(width: 12.w),
                                Text('add_friend'.tr, style: StyleThemeData.size14Weight400()),
                                SizedBox(width: 24.w),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.toNamed(Routes.CREATE_GROUP);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ImageAssetCustom(imagePath: IconsAssets.addGroupIcon, size: 24.w),
                                SizedBox(width: 12.w),
                                Text('create_group'.tr, style: StyleThemeData.size14Weight400()),
                                SizedBox(width: 24.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: const ImageAssetCustom(imagePath: IconsAssets.addIcon),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TabBar(
            controller: controller.tabController,
            indicatorColor: appTheme.blackColor,
            dividerColor: appTheme.allSidesColor,
            labelColor: appTheme.blackColor,
            unselectedLabelColor: appTheme.grayColor,
            labelStyle: StyleThemeData.size14Weight600(),
            unselectedLabelStyle: StyleThemeData.size14Weight600(color: appTheme.grayColor),
            indicator: BoxDecoration(
              border: Border(bottom: BorderSide(color: appTheme.blackColor, width: 1.w)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: 'friends'.tr),
              Tab(text: 'groups'.tr),
            ],
          ),
          InkWell(
            onTap: () => Get.toNamed(Routes.SENT_REQUEST_CONTACT),
            child: Padding(
              padding: padding(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  ImageAssetCustom(imagePath: ImagesAssets.contactBorderImage, size: 32.w),
                  SizedBox(width: 12.w),
                  Row(
                    children: [
                      Text('friend_requests'.tr, style: StyleThemeData.size14Weight400()),
                      SizedBox(width: 2.w),
                      Text(
                        '(${controller.contactModel.value?.data?.length ?? '0'})'.tr,
                        style: StyleThemeData.size14Weight400(color: appTheme.grayColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          LineWidget(height: 8, color: appTheme.allSidesColor),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                ContactsView(),
                _buildFriends(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriends() {
    return Container();
  }
}
