import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNotiDialog(String content) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 16),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: padding(top: 16, horizontal: 16, bottom: 12),
                  child: Column(
                    children: [
                      Text('notification'.tr, style: StyleThemeData.size16Weight600()),
                      SizedBox(height: 8.h),
                      Text(
                        content,
                        style: StyleThemeData.size14Weight400(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const LineWidget(),
                InkWell(
                  onTap: Get.back,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: padding(all: 12),
                    child: Text(
                      'close'.tr,
                      style: StyleThemeData.size14Weight600(color: appTheme.appColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
