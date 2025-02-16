import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/scroll_date/scroll_date_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDateBottomSheet({DateTime? selectDate, void Function(DateTime)? onChanged}) {
  Rx<DateTime?> dateTime = Rx<DateTime?>(selectDate ?? DateTime.now());
  Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime.now());

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
                Text('date_of_birth'.tr, style: StyleThemeData.size16Weight600()),
                IconButton(onPressed: Get.back, icon: const Icon(Icons.clear)),
              ],
            ),
            SizedBox(height: 12.h),
            ScrollDateView(
              date: dateTime.value,
              onChanged: (date) {
                selectedDate.value = date;
              },
            ),
            Obx(
              () => Padding(
                padding: padding(top: 24, horizontal: 16, bottom: 24),
                child: CustomButton(
                  buttonText: 'save'.tr,
                  onPressed: selectedDate.value != null
                      ? () {
                          onChanged?.call(selectedDate.value!);
                          Get.back();
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
