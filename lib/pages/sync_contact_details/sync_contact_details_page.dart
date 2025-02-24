import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/sync_contact/sync_contact_model.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/pages/sync_contact_details/sync_contact_details_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncContactDetailsPage extends GetWidget<SyncContactDetailsController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: DefaultAppBar(title: 'sync_contacts'.tr),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if ((controller.syncContactModel.value?.lastSyncContacts ?? '').isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: padding(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('last_updated_contacts'.tr, style: StyleThemeData.size12Weight400()),
                          SizedBox(height: 4.h),
                          Text(
                            controller.syncContactModel.value?.lastSyncContacts?.tohhmmSpaceddMMyyyy ?? '',
                            style: StyleThemeData.size14Weight600(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            }),
            LineWidget(height: 8.h, color: appTheme.allSidesColor),
            Obx(
              () => Padding(
                padding: padding(vertical: 12, horizontal: 16),
                child: CustomTextField(
                  hintText: 'search'.tr,
                  prefixIcon: IconButton(
                    onPressed: null,
                    icon: ImageAssetCustom(imagePath: IconsAssets.searchIcon, color: appTheme.grayColor),
                  ),
                  showLine: false,
                  showBorder: false,
                  fillColor: appTheme.allSidesColor,
                  onChanged: controller.onSearch,
                  onSubmit: (value) => controller.fetchSyncContacts(search: value),
                  suffixIcon: controller.isLoading.isTrue
                      ? IconButton(
                          onPressed: null,
                          icon: SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: CircularProgressIndicator(color: appTheme.appColor, strokeWidth: 2.w),
                          ),
                        )
                      : controller.searchValue.value.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                controller.searchValue.value = '';
                                controller.fetchSyncContacts();
                              },
                              icon: const ImageAssetCustom(imagePath: IconsAssets.closeCircleIcon),
                            )
                          : null,
                ),
              ),
            ),
            Padding(
              padding: padding(horizontal: 16),
              child: Text('new_contact'.tr, style: StyleThemeData.size12Weight600()),
            ),
            Expanded(
              child: Obx(
                () => controller.isLoading.isTrue
                    ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
                    : ListLoader(
                        onRefresh: controller.fetchSyncContacts,
                        onLoad: () => controller.fetchSyncContacts(isRefresh: false),
                        hasNext: controller.syncContactModel.value?.hasNext ?? false,
                        forceScrollable: true,
                        child: (controller.syncContactModel.value?.contacts ?? []).isNotEmpty
                            ? SingleChildScrollView(
                                child: Column(
                                  children: (controller.syncContactModel.value?.contacts ?? []).map((e) {
                                    return _buildContactItem(e);
                                  }).toList(),
                                ),
                              )
                            : const Center(child: NoDataWidget()),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(SyncContact e) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.MAKE_FRIENDS,
        arguments: MakeFriendsParameter(
          id: e.id!,
          contact: e.userContact,
          type: MakeFriendsType.friend,
        ),
      ),
      child: Padding(
        padding: padding(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CustomImageWidget(
              imageUrl: e.userContact?.avatar ?? '',
              size: 41.w,
              noImage: false,
              name: e.userContact?.name ?? '',
              isShowNameAvatar: true,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.contactName ?? '', style: StyleThemeData.size14Weight600()),
                  SizedBox(height: 2.h),
                  Text(
                    e.userContact?.lastOnline?.timeAgo ?? '',
                    style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // IconButton(
            //   onPressed: () => Get.toNamed(Routes.CALL),
            //   icon: const ImageAssetCustom(imagePath: IconsAssets.phoneIcon),
            // ),
          ],
        ),
      ),
    );
  }
}
