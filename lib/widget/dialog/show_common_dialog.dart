import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCommonDialog({
  required String title,
  String? buttonTitle,
  String? buttonCancelTitle,
  VoidCallback? onSubmit,
}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 16),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: padding(all: 16),
                  child: Text(
                    title,
                    style: StyleThemeData.size16Weight600(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: Get.back,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                        child: Container(
                          padding: padding(vertical: 12, horizontal: 8),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: appTheme.allSidesColor),
                              right: BorderSide(color: appTheme.allSidesColor, width: 0.5),
                            ),
                          ),
                          child: Text(
                            buttonCancelTitle ?? 'cancel'.tr,
                            style: StyleThemeData.size14Weight600(color: appTheme.appColor),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          onSubmit!();
                        },
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        child: Container(
                          padding: padding(vertical: 12, horizontal: 8),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: appTheme.allSidesColor),
                              left: BorderSide(color: appTheme.allSidesColor, width: 0.5),
                            ),
                          ),
                          child: Text(
                            buttonTitle ?? 'confirm'.tr,
                            style: StyleThemeData.size14Weight600(color: appTheme.errorColor),
                          ),
                        ),
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
