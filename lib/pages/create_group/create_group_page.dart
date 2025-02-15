import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/pages/create_group/create_group_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/check_circle_widget.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupPage extends GetWidget<CreateGroupController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                const ImageAssetCustom(imagePath: ImagesAssets.topBgChatImage),
                Positioned(
                  bottom: 12,
                  left: 8,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: ImageAssetCustom(imagePath: IconsAssets.arrowLeftIcon, color: appTheme.whiteColor),
                      ),
                      Column(
                        children: [
                          Text('new_group'.tr, style: StyleThemeData.size16Weight600(color: appTheme.whiteColor)),
                          SizedBox(height: 4.h),
                          Obx(
                            () => Text(
                              'selected_field'.trParams({'field': controller.selectedContacts.length.toString()}),
                              style: StyleThemeData.size12Weight400(color: appTheme.whiteColor),
                            ),
                          ),
                        ],
                      ),
                      const IconButton(onPressed: null, icon: SizedBox()),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: padding(all: 16),
              child: CustomTextField(
                controller: controller.groupNameController,
                hintText: 'set_group_name'.tr,
                showBorder: false,
                onChanged: (value) {
                  controller.createGroupValue.value = value;
                },
                formatter: FormatterUtil.createGroupFormatter,
              ),
            ),
            Obx(
              () => Padding(
                padding: padding(all: 16),
                child: CustomTextField(
                  controller: controller.searchController,
                  hintText: 'search_by_name_or_phone_number'.tr,
                  colorBorder: appTheme.allSidesColor,
                  fillColor: appTheme.allSidesColor,
                  showLine: false,
                  prefixIcon: IconButton(
                    onPressed: null,
                    icon: ImageAssetCustom(imagePath: IconsAssets.searchIcon, color: appTheme.grayColor),
                  ),
                  onSubmit: (value) {
                    controller.getContacts(search: value);
                  },
                  onChanged: (value) {
                    controller.chatValue.value = value;
                  },
                  suffixIcon: controller.chatValue.value.isNotEmpty
                      ? IconButton(
                          onPressed: controller.clearSearch,
                          icon: const ImageAssetCustom(imagePath: IconsAssets.closeCircleIcon),
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: ListLoader(
                onRefresh: controller.getContacts,
                onLoad: () => controller.getContacts(isRefresh: false),
                hasNext: controller.contactModel.value?.hasNext ?? false,
                child: (controller.contactModel.value?.data ?? []).isNotEmpty
                    ? Column(
                        children: (controller.contactModel.value?.data ?? []).map((e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildContactItem(e),
                            ],
                          );
                        }).toList(),
                      )
                    : const Center(child: NoDataWidget()),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => controller.selectedContacts.isNotEmpty
              ? Container(
                  padding: padding(top: 12, horizontal: 16, bottom: 24),
                  decoration: BoxDecoration(
                    color: appTheme.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.selectedContacts.map((e) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: padding(right: 8),
                                    child: CustomImageWidget(
                                      imageUrl: e.friend?.avatar ?? '',
                                      size: 41.w,
                                      noImage: false,
                                      showBoder: true,
                                      colorBoder: appTheme.allSidesColor,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () => controller.selectedContacts.remove(e),
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Container(
                                        padding: padding(all: 4),
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme.errorColor),
                                        child: Icon(Icons.clear, size: 8, color: appTheme.whiteColor),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      if (controller.createGroupValue.value.isNotEmpty)
                        IconButton(
                          onPressed: controller.createGroup,
                          icon: const ImageAssetCustom(imagePath: IconsAssets.sendIcon),
                        ),
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildContactItem(ContactModel e) {
    return Obx(
      () => InkWell(
        onTap: () => controller.selectContact(e),
        child: Padding(
          padding: padding(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CustomImageWidget(
                imageUrl: e.friend?.avatar ?? '',
                size: 41.w,
                noImage: false,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.friend?.name ?? '', style: StyleThemeData.size14Weight600()),
                    SizedBox(height: 2.h),
                    Text(
                      e.friend?.lastOnline?.timeAgo ?? '',
                      style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              CheckCircleWidget(isSelect: controller.selectedContacts.any((contact) => contact.id == e.id)),
            ],
          ),
        ),
      ),
    );
  }
}
