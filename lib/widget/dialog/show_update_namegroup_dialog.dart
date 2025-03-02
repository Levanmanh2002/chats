import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showUpdateNameGroupDialog({
  required String groupName,
  required Function(String name) onSubmit,
  String? title,
  String? content,
}) {
  final TextEditingController groupNameController = TextEditingController();

  groupNameController.text = groupName;

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
              SizedBox(height: 12.h),
              Text(title ?? 'set_group_name'.tr, style: StyleThemeData.size16Weight600()),
              Padding(
                padding: padding(horizontal: 12, vertical: 12),
                child: CustomTextField(
                  controller: groupNameController,
                  hintText: content ?? 'enter_the_new_group_name'.tr,
                  formatter: FormatterUtil.createGroupFormatter,
                  colorBorder: appTheme.allSidesColor,
                  showLine: false,
                ),
              ),
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
                        onSubmit(groupNameController.text.trim());
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
                        child: Text('confirm'.tr, style: StyleThemeData.size14Weight600(color: appTheme.appColor)),
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
