import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app_enums.dart';
import 'package:chats/widget/app_radio_view.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showGenderBottomSheet({
  Gender? selectedGender,
  required Function(Gender) onSelected,
}) {
  final selectedGenderRx = Rx<Gender?>(selectedGender);
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
                Text('gender'.tr, style: StyleThemeData.size16Weight600()),
                IconButton(onPressed: Get.back, icon: const Icon(Icons.clear)),
              ],
            ),
            Obx(
              () => Padding(
                padding: padding(top: 12, horizontal: 16, bottom: 24),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        selectedGenderRx.value = Gender.male;
                      },
                      child: Row(
                        children: [
                          AppRadioView(isSelected: selectedGenderRx.value == Gender.male),
                          SizedBox(width: 12.w),
                          Text('male'.tr, style: StyleThemeData.size14Weight400()),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    InkWell(
                      onTap: () {
                        selectedGenderRx.value = Gender.female;
                      },
                      child: Row(
                        children: [
                          AppRadioView(isSelected: selectedGenderRx.value == Gender.female),
                          SizedBox(width: 12.w),
                          Text('female'.tr, style: StyleThemeData.size14Weight400()),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    InkWell(
                      onTap: () {
                        selectedGenderRx.value = Gender.other;
                      },
                      child: Row(
                        children: [
                          AppRadioView(isSelected: selectedGenderRx.value == Gender.other),
                          SizedBox(width: 12.w),
                          Text('other'.tr, style: StyleThemeData.size14Weight400()),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Obx(
                      () => CustomButton(
                        buttonText: 'save'.tr,
                        onPressed: selectedGenderRx.value != null
                            ? () {
                                onSelected(selectedGenderRx.value!);
                                Get.back();
                              }
                            : null,
                      ),
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
