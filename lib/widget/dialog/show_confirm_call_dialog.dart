import 'package:chats/main.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showConfirmCallDialog() {
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
            child: Padding(
              padding: padding(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onPressed: () {
                      final androidUrl = Get.find<ProfileController>().systemSetting.value?.androidUrl ?? '';
                      openUrlInBrowser(androidUrl);
                    },
                    buttonText: '${'download'.tr} ${'android'.tr}',
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    buttonText: '${'download'.tr} ${'ios'.tr}',
                    onPressed: () {
                      final iosUrl = Get.find<ProfileController>().systemSetting.value?.iosUlr ?? '';
                      openUrlInBrowser(iosUrl);
                    },
                  ),
                  SizedBox(height: 24.h),
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
        ),
      );
    },
  );
}
