import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDateBottomSheet() {
  showModalBottomSheet(
    context: Get.context!,
    backgroundColor: appTheme.whiteColor,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: Get.back, icon: const SizedBox()),
                Text('Ngày sinh'.tr, style: StyleThemeData.size16Weight600()),
                IconButton(onPressed: Get.back, icon: const Icon(Icons.clear)),
              ],
            ),
            Obx(
              () => Padding(
                padding: padding(top: 12, horizontal: 16, bottom: 24),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    CustomButton(
                      buttonText: 'save'.tr,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
