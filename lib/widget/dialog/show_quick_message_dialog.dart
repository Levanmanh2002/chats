import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showQuickMessageDialog(VoidCallback? onSubmit) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 16),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              Text('delete_this_quick_message'.tr, style: StyleThemeData.size16Weight600()),
              SizedBox(height: 16.h),
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
                        child: Text('cancel'.tr, style: StyleThemeData.size14Weight400()),
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
                        child: Text('confirm'.tr, style: StyleThemeData.size14Weight600(color: appTheme.errorColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
