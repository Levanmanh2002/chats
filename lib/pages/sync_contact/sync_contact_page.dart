import 'package:chats/pages/sync_contact/sync_contact_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncContactPage extends GetWidget<SyncContactController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'sync_contacts'.tr),
      body: Padding(
        padding: padding(all: 16),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            ImageAssetCustom(imagePath: ImagesAssets.unionSyncImage, size: 170.w),
            SizedBox(height: 24.h),
            Text('sync_contacts_print'.tr, style: StyleThemeData.size24Weight600()),
            SizedBox(height: 12.h),
            Text(
              'sync_contacts_content_1'.tr,
              style: StyleThemeData.size12Weight400(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'sync_contacts_content_2'.tr,
              style: StyleThemeData.size12Weight400(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Obx(
              () => CustomButton(
                buttonText: 'sync_contacts'.tr,
                isLoading: controller.isLoading.isTrue,
                // onPressed: controller.onSubmitContact,
                onPressed: controller.syncContacts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
