import 'package:chats/main.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/contacts/view/contacts_view.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/popup/popup.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/search_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsPage extends GetWidget<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppbar(
        backgroundColor: appTheme.appColor,
        title: 'contacts'.tr,
        isSearch: false,
        action: Padding(
          padding: padding(all: 16),
          child: CustomPopup(
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
                    Get.toNamed(
                      Routes.CREATE_GROUP,
                      arguments: CreateGroupParameter(type: CreateGroupType.createGroup),
                    );
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
        ),
      ),
      body: Column(
        children: [
          // TabBar(
          //   controller: controller.tabController,
          //   indicatorColor: appTheme.blackColor,
          //   dividerColor: appTheme.allSidesColor,
          //   labelColor: appTheme.blackColor,
          //   unselectedLabelColor: appTheme.grayColor,
          //   labelStyle: StyleThemeData.size14Weight600(),
          //   unselectedLabelStyle: StyleThemeData.size14Weight600(color: appTheme.grayColor),
          //   indicator: BoxDecoration(
          //     border: Border(bottom: BorderSide(color: appTheme.blackColor, width: 1.w)),
          //   ),
          //   indicatorSize: TabBarIndicatorSize.tab,
          //   onTap: (value) {
          //     if (value == 1) {
          //       Get.toNamed(Routes.SYNC_CONTACT_DETAILS);
          //       controller.tabController.index = 0;
          //     }
          //   },
          //   tabs: [
          //     Tab(text: 'friends'.tr + ' (${controller.contactModel.value?.data?.length ?? '0'})'.tr),
          //     Tab(text: 'contacts'.tr),
          //   ],
          // ),
          InkWell(
            onTap: () => Get.toNamed(Routes.SENT_REQUEST_CONTACT),
            child: Padding(
              padding: padding(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ImageAssetCustom(imagePath: ImagesAssets.contactBorderImage, size: 32.w),
                      Obx(() {
                        if ((controller.friendRequest.value?.data ?? []).isNotEmpty) {
                          return Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: appTheme.errorColor,
                              ),
                            ),
                          );
                        }

                        return const SizedBox();
                      }),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Row(
                    children: [
                      Text('friend_requests'.tr, style: StyleThemeData.size14Weight400()),
                      // SizedBox(width: 2.w),
                      // Obx(
                      //   () => Text(
                      //     '(${controller.contactModel.value?.data?.length ?? '0'})'.tr,
                      //     style: StyleThemeData.size14Weight400(color: appTheme.grayColor),
                      //   ),
                      // ),
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
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
