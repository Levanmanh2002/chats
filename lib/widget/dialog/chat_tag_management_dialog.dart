import 'package:chats/main.dart';
import 'package:chats/models/chat_tags/chat_tags_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTagManagementDialog extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600.w,
        height: 700.h,
        padding: padding(all: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'manage_tags'.tr,
                    style: StyleThemeData.size20Weight600(),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: appTheme.blackColor),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: controller.tagSearchController,
              hintText: 'search_tags'.tr,
              onSubmit: controller.onSearchTag,
              showLine: false,
              colorBorder: appTheme.hintColor,
              onChanged: (value) {
                controller.tagSearchValue.value = value;
              },
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  controller.onSearchTag(controller.tagSearchController.text);
                },
                icon: ImageAssetCustom(
                  imagePath: IconsAssets.searchIcon,
                  size: 24.w,
                  color: appTheme.appColor,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTags.isTrue && controller.chatTagsModel.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tags = controller.chatTagsModel.value?.data ?? [];

                if (tags.isEmpty) {
                  return const Center(child: NoDataWidget());
                }

                return ListLoader(
                  onLoad: () => controller.fetchChatTags(isRefresh: false),
                  hasNext: controller.chatTagsModel.value?.hasNext ?? false,
                  child: ListView.separated(
                    itemCount: tags.length,
                    separatorBuilder: (_, __) => Divider(color: appTheme.allSidesColor),
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      return _buildTagItem(tag);
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                icon: Icon(Icons.add, color: appTheme.whiteColor),
                buttonText: 'create_new_tag'.tr,
                onPressed: () => _showCreateTagDialog(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagItem(ChatCategory tag) {
    final tagColor = _parseColor(tag.color);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: tagColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(tag.icon ?? '🏷️', style: const TextStyle(fontSize: 20)),
        ),
      ),
      title: Text(
        tag.name ?? '',
        style: StyleThemeData.size14Weight600(),
      ),
      subtitle: tag.chatsCount != null && tag.chatsCount! > 0
          ? Text(
              'used_in_chats'.trParams({'count': tag.chatsCount.toString()}),
              style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showEditTagDialog(tag),
            icon: Icon(Icons.edit_outlined, size: 20.w, color: appTheme.appColor),
          ),
          IconButton(
            onPressed: () => controller.deleteTag(tag.id!, tag.chatsCount ?? 0),
            icon: Icon(Icons.delete_outline, size: 20.w, color: appTheme.errorColor),
          ),
        ],
      ),
    );
  }

  void _showCreateTagDialog() {
    final nameController = TextEditingController();
    final selectedColor = Rx<Color>(appTheme.appColor);
    final selectedIcon = Rx<String>('🏷️');

    final colorOptions = [
      appTheme.appColor,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];

    final iconOptions = ['🏷️', '⭐', '❤️', '💼', '🎯', '📌', '🔥', '✨'];

    Get.dialog(
      Dialog(
        backgroundColor: appTheme.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400.w,
          padding: padding(all: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'create_new_tag'.tr,
                style: StyleThemeData.size18Weight600(),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: nameController,
                hintText: 'tag_name'.tr,
                showLine: false,
                colorBorder: appTheme.hintColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'select_color'.tr,
                style: StyleThemeData.size14Weight600(),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: colorOptions.map((color) {
                    final isSelected = selectedColor.value == color;
                    return InkWell(
                      onTap: () => selectedColor.value = color,
                      borderRadius: BorderRadius.circular(1000),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: appTheme.blackColor, width: 1.w) : null,
                        ),
                        child: isSelected ? Icon(Icons.check, color: appTheme.whiteColor, size: 20.w) : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'select_icon'.tr,
                style: StyleThemeData.size14Weight600(),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: iconOptions.map((icon) {
                    final isSelected = selectedIcon.value == icon;
                    return InkWell(
                      onTap: () => selectedIcon.value = icon,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectedColor.value.withOpacity(0.2)
                              : appTheme.allSidesColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected ? Border.all(color: selectedColor.value, width: 1.w) : null,
                        ),
                        child: Center(
                          child: Text(icon, style: StyleThemeData.size20Weight600()),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomBorderButtonWidget(buttonText: 'cancel'.tr, onPressed: () => Get.back()),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        buttonText: 'create'.tr,
                        isLoading: controller.isLoadingCreateTag.value,
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            DialogUtils.showErrorDialog('please_enter_tag_name'.tr);
                            return;
                          }

                          controller.createTag(
                            name: nameController.text.trim(),
                            color: _colorToHex(selectedColor.value),
                            icon: selectedIcon.value,
                          );
                        },
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
  }

  void _showEditTagDialog(ChatCategory tag) {
    final nameController = TextEditingController(text: tag.name);
    final selectedColor = Rx<Color>(_parseColor(tag.color));
    final selectedIcon = Rx<String>(tag.icon ?? '🏷️');

    final colorOptions = [
      appTheme.appColor,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
    ];

    final iconOptions = ['🏷️', '⭐', '❤️', '💼', '🎯', '📌', '🔥', '✨'];

    Get.dialog(
      Dialog(
        backgroundColor: appTheme.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400.w,
          padding: padding(all: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'edit_tag'.tr,
                style: StyleThemeData.size18Weight600(),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: nameController,
                hintText: 'tag_name'.tr,
                showLine: false,
                colorBorder: appTheme.hintColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'select_color'.tr,
                style: StyleThemeData.size14Weight600(),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: colorOptions.map((color) {
                    final isSelected = selectedColor.value == color;
                    return InkWell(
                      onTap: () => selectedColor.value = color,
                      borderRadius: BorderRadius.circular(1000),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: appTheme.blackColor, width: 1.w) : null,
                        ),
                        child: isSelected ? Icon(Icons.check, color: appTheme.whiteColor, size: 20.w) : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.h),
              Text('select_icon'.tr, style: StyleThemeData.size14Weight600()),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: iconOptions.map((icon) {
                    final isSelected = selectedIcon.value == icon;
                    return InkWell(
                      onTap: () => selectedIcon.value = icon,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectedColor.value.withOpacity(0.2)
                              : appTheme.allSidesColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected ? Border.all(color: selectedColor.value, width: 1.w) : null,
                        ),
                        child: Center(
                          child: Text(icon, style: StyleThemeData.size20Weight600()),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomBorderButtonWidget(
                      buttonText: 'cancel'.tr,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(
                      () => CustomButton(
                        buttonText: 'update'.tr,
                        isLoading: controller.isLoadingUpdateTag.value,
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            DialogUtils.showErrorDialog('please_enter_tag_name'.tr);
                            return;
                          }

                          controller.updateTag(
                            id: tag.id!,
                            name: nameController.text.trim(),
                            color: _colorToHex(selectedColor.value),
                            icon: selectedIcon.value,
                          );
                        },
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
  }

  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return appTheme.appColor;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return appTheme.appColor;
    }
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
