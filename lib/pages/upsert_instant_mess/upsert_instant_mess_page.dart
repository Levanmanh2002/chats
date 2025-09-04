import 'package:chats/main.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_controller.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_parameter.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/formatter_util.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UpsertInstantMessPage extends GetWidget<UpsertInstantMessController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildCustomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 24.h),

                // Header section
                _buildHeaderSection(),

                SizedBox(height: 32.h),

                // Form section
                _buildFormSection(),

                SizedBox(height: 24.h),

                // Preview section
                _buildPreviewSection(),

                if (controller.parameter.type == UpsertInstantMessType.update) ...[
                  SizedBox(height: 24.h),
                  _buildDeleteSection(),
                ],

                SizedBox(height: 100.h), // Space for bottom button
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildSaveButton(),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: appTheme.blackColor,
            size: 18.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        controller.parameter.type == UpsertInstantMessType.create
            ? 'create_instant_message'.tr
            : 'edit_instant_message'.tr,
        style: StyleThemeData.size18Weight600(color: appTheme.blackColor),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.appColor.withOpacity(0.1),
            appTheme.appColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appTheme.appColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon với gradient background
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  appTheme.appColor,
                  appTheme.appColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: appTheme.appColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              controller.parameter.type == UpsertInstantMessType.create ? Icons.add_comment : Icons.edit_note,
              color: Colors.white,
              size: 28.w,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            controller.parameter.type == UpsertInstantMessType.create ? 'create_new_template'.tr : 'edit_template'.tr,
            style: StyleThemeData.size18Weight700(color: appTheme.blackColor),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          Text(
            controller.parameter.type == UpsertInstantMessType.create
                ? 'create_template_desc'.tr
                : 'edit_template_desc'.tr,
            style: StyleThemeData.size12Weight400(
              color: appTheme.greyColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: appTheme.appColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'template_details'.tr,
                style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Shortcut field
          _buildCustomTextField(
            controller: controller.shortcutController,
            label: 'shortcut'.tr,
            hint: 'example_shortcut'.tr,
            icon: Icons.bolt,
            hasPrefix: true,
            formatter: FormatterUtil.shortcutFormatter,
            onChanged: (value) => controller.validateShortcut(value),
          ),

          SizedBox(height: 20.h),

          // Content field
          _buildCustomTextField(
            controller: controller.contentController,
            label: 'content'.tr,
            hint: 'enter_message_content'.tr,
            icon: Icons.message_outlined,
            maxLines: 5,
            formatter: FormatterUtil.notesFormatter,
            onChanged: (value) => controller.validateContent(value),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool hasPrefix = false,
    List<TextInputFormatter>? formatter,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label với icon
        Row(
          children: [
            Icon(
              icon,
              size: 18.w,
              color: appTheme.appColor,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // Text field với custom design
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: appTheme.greyColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            inputFormatters: formatter,
            style: StyleThemeData.size16Weight400(color: appTheme.blackColor),
            cursorColor: appTheme.appColor,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: StyleThemeData.size14Weight400(
                color: appTheme.greyColor.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
              prefixIcon: hasPrefix
                  ? Container(
                      margin: EdgeInsets.only(left: 16.w, right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: appTheme.appColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '/',
                        style: StyleThemeData.size14Weight600(
                          color: appTheme.appColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: appTheme.greyColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview,
                color: appTheme.appColor,
                size: 18.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'preview'.tr,
                style: StyleThemeData.size14Weight600(color: appTheme.blackColor),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: appTheme.appColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: appTheme.appColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shortcut preview
                Obx(
                  () => controller.shortcutValue.value.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: appTheme.appColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: appTheme.appColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bolt,
                                size: 12.w,
                                color: appTheme.appColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '/${controller.shortcutController.text}',
                                style: StyleThemeData.size12Weight500(
                                  color: appTheme.appColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          'shortcut_preview'.tr,
                          style: StyleThemeData.size12Weight400(
                            color: appTheme.greyColor.withOpacity(0.6),
                          ),
                        ),
                ),

                SizedBox(height: 8.h),

                // Content preview
                Obx(
                  () => Text(
                    controller.contentValue.value.isNotEmpty ? controller.contentValue.value : 'content_preview'.tr,
                    style: StyleThemeData.size14Weight400(
                      color: controller.contentValue.value.isNotEmpty
                          ? appTheme.blackColor.withOpacity(0.8)
                          : appTheme.greyColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: Colors.red,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'danger_zone'.tr,
                style: StyleThemeData.size14Weight600(color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showCommonDialog(
                  title: 'delete_this_quick_message'.tr,
                  onSubmit: controller.deleteInstantMess,
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 18.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'delete_quick_message'.tr,
                      style: StyleThemeData.size14Weight600(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(
          () => Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: controller.isFormValid.isTrue
                    ? [
                        appTheme.appColor,
                        appTheme.appColor.withOpacity(0.8),
                      ]
                    : [
                        appTheme.greyColor.withOpacity(0.3),
                        appTheme.greyColor.withOpacity(0.3),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: controller.isFormValid.isTrue
                  ? [
                      BoxShadow(
                        color: appTheme.appColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.isFormValid.isTrue ? controller.submitInstantMess : null,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: controller.isLoading.isTrue
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'saving'.tr,
                              style: StyleThemeData.size16Weight600(color: Colors.white),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              controller.parameter.type == UpsertInstantMessType.create
                                  ? 'create_template'.tr
                                  : 'save_changes'.tr,
                              style: StyleThemeData.size16Weight600(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
