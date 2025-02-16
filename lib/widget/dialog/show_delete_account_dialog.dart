import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDeleteAccountDialog(VoidCallback onDeleteAccount) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 16),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: padding(top: 16, left: 16, right: 16, bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('delete_account'.tr, style: StyleThemeData.size16Weight600()),
                SizedBox(height: 12.h),
                const LineWidget(),
                SizedBox(height: 8.h),
                const ImageAssetCustom(imagePath: IconsAssets.trashBinIcon),
                SizedBox(height: 8.h),
                Text(
                  'conform_delete_account'.tr,
                  style: StyleThemeData.size14Weight400(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Flexible(
                      child: CustomBorderButtonWidget(
                        buttonText: 'cancel'.tr,
                        color: appTheme.silverColor,
                        textColor: appTheme.blackColor,
                        onPressed: Get.back,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: CustomButton(
                        buttonText: 'confirm'.tr,
                        color: appTheme.redColor,
                        onPressed: onDeleteAccount,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
