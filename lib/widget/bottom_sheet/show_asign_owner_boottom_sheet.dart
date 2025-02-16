import 'package:chats/main.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/check_circle_widget.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAssignOwnerBottomSheet({
  List<UserModel>? users,
  required String phoneCode,
  required Function(UserModel) onConfirm,
}) {
  Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

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
            Padding(
              padding: padding(horizontal: 12, vertical: 16),
              child: Column(
                children: [
                  Text('transfer_group_ownership'.tr, style: StyleThemeData.size16Weight600()),
                  SizedBox(height: 4.h),
                  Text(
                    'select_a_member_to_become_the_new_group_owner'.tr,
                    style: StyleThemeData.size14Weight400(color: appTheme.grayColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: padding(vertical: 12, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: (users ?? []).map((e) {
                      return Padding(
                        padding: padding(bottom: 12),
                        child: InkWell(
                          onTap: () => selectedUser.value = e,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    CustomImageWidget(
                                      imageUrl: e.avatar ?? '',
                                      size: 41.w,
                                      noImage: false,
                                    ),
                                    SizedBox(width: 8.w),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name ?? '',
                                            style: StyleThemeData.size14Weight600(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            (e.phone?.startsWith(phoneCode) == true
                                                ? e.phone!.replaceFirst(phoneCode, '0')
                                                : e.phone ?? ''),
                                            style: StyleThemeData.size10Weight400(color: appTheme.grayColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Obx(() => CheckCircleWidget(isSelect: selectedUser.value == e)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: padding(horizontal: 16, bottom: 24),
              child: Row(
                children: [
                  Flexible(
                    child: CustomBorderButtonWidget(
                      buttonText: 'cancel'.tr,
                      radius: 8,
                      onPressed: Get.back,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: Obx(
                      () => CustomButton(
                        buttonText: 'confirm'.tr,
                        radius: 8,
                        onPressed: selectedUser.value != null
                            ? () {
                                Get.back();
                                onConfirm(selectedUser.value!);
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
