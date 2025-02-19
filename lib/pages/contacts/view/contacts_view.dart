import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsView extends GetView<ContactsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
          : ListLoader(
              onRefresh: controller.getContacts,
              onLoad: () => controller.getContacts(isRefresh: false),
              hasNext: controller.contactModel.value?.hasNext ?? false,
              child: (controller.contactModel.value?.data ?? []).isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: controller.groupedContacts.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: padding(horizontal: 16, vertical: 12),
                                child: Text(entry.key, style: StyleThemeData.size16Weight600()),
                              ),
                              ...entry.value.map((e) => _buildContactItem(e)),
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  : const Center(child: NoDataWidget()),
            ),
    );
  }

  Widget _buildContactItem(ContactModel e) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.MAKE_FRIENDS,
        arguments: MakeFriendsParameter(
          id: e.id!,
          contact: e.friend,
          type: MakeFriendsType.friend,
        ),
      ),
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
            IconButton(
              onPressed: () {},
              icon: const ImageAssetCustom(imagePath: IconsAssets.phoneIcon),
            ),
          ],
        ),
      ),
    );
  }
}
