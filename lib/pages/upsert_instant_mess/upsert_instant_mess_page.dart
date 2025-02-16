import 'package:chats/main.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_controller.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_parameter.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpsertInstantMessPage extends GetWidget<UpsertInstantMessController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appTheme.allSidesColor,
        appBar: DefaultAppBar(title: 'create_instant_message'.tr),
        body: Container(
          padding: padding(all: 16),
          color: appTheme.whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller.shortcutController,
                titleText: 'shortcut'.tr,
                hintText: 'Vd: Xinchao',
                showLine: false,
                colorBorder: appTheme.grayB9Color,
                titleStyle: StyleThemeData.size12Weight400(),
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: Container(
                    padding: padding(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: appTheme.allSidesColor),
                    child: Text('/', style: StyleThemeData.size12Weight400()),
                  ),
                ),
                formatter: FormatterUtil.shortcutFormatter,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: controller.contentController,
                titleText: 'content'.tr,
                hintText: 'enter_message_content'.tr,
                maxLines: 5,
                showLine: false,
                colorBorder: appTheme.grayB9Color,
                titleStyle: StyleThemeData.size12Weight400(),
                formatter: FormatterUtil.notesFormatter,
              ),
              if (controller.parameter.type == UpsertInstantMessType.update) ...[
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () {
                    showCommonDialog(
                      title: 'delete_this_quick_message'.tr,
                      onSubmit: controller.deleteInstantMess,
                    );
                  },
                  child: Text(
                    'delete_quick_message'.tr,
                    style: StyleThemeData.size12Weight600(color: appTheme.errorColor),
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            padding: padding(top: 12, horizontal: 16, bottom: 24),
            color: appTheme.whiteColor,
            child: CustomButton(
              buttonText: 'save'.tr,
              isLoading: controller.isLoading.isTrue,
              onPressed: controller.isFormValid.isTrue ? controller.submitInstantMess : null,
            ),
          ),
        ),
      ),
    );
  }
}
