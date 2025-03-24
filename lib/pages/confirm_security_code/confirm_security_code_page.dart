import 'package:chats/main.dart';
import 'package:chats/pages/confirm_security_code/confirm_security_code_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmSecurityCodePage extends GetWidget<ConfirmSecurityCodeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.allSidesColor,
      appBar: AppBar(backgroundColor: appTheme.allSidesColor),
      body: Padding(
        padding: padding(all: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Text(
              'enter_passcode'.tr,
              style: StyleThemeData.size16Weight600(),
            ),
            SizedBox(height: 24.h),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.maxDigits,
                  (index) => Padding(
                    padding: padding(horizontal: 12),
                    child: _buildRadioWidget(isSelected: controller.selectionStates[index]),
                  ),
                ),
              );
            }),
            SizedBox(height: 60.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberWidget('1', controller.addDigit),
                SizedBox(width: 40.w),
                _buildNumberWidget('2', controller.addDigit),
                SizedBox(width: 40.w),
                _buildNumberWidget('3', controller.addDigit),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberWidget('4', controller.addDigit),
                SizedBox(width: 40.w),
                _buildNumberWidget('5', controller.addDigit),
                SizedBox(width: 40.w),
                _buildNumberWidget('6', controller.addDigit),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberWidget('7', controller.addDigit),
                SizedBox(width: 40.w),
                _buildNumberWidget('8', controller.addDigit),
                SizedBox(width: 40.w),
                _buildNumberWidget('9', controller.addDigit),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberWidget('', (_) {}),
                SizedBox(width: 40.w),
                _buildNumberWidget('0', controller.addDigit),
                SizedBox(width: 40.w),
                InkWell(
                  onTap: controller.deleteLast,
                  borderRadius: BorderRadius.circular(1000),
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    alignment: Alignment.center,
                    child: const ImageAssetCustom(imagePath: ImagesAssets.unionCloseImage),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioWidget({required bool isSelected, double? size}) {
    return Container(
      width: size ?? 18.w,
      height: size ?? 18.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? null : Border.all(color: appTheme.appColor, width: 2.w),
        color: isSelected ? appTheme.appColor : null,
      ),
    );
  }

  Widget _buildNumberWidget(String number, Function(String number) onPressed) {
    return InkWell(
      onTap: () => onPressed(number),
      borderRadius: BorderRadius.circular(1000),
      child: Container(
        width: 70.w,
        height: 70.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: number.isNotEmpty ? appTheme.whiteColor : null,
        ),
        child: Text(number, style: StyleThemeData.size24Weight600()),
      ),
    );
  }
}
