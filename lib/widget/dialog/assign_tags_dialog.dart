import 'package:chats/main.dart';
import 'package:chats/models/chat_tags/chat_tags_model.dart';
import 'package:chats/models/chats/chat_data_model.dart';
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

class AssignTagsDialog extends GetView<ChatsController> {
  final ChatDataModel chat;

  const AssignTagsDialog({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        height: double.infinity,
        padding: padding(all: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'assign_tags'.tr,
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
            Obx(() {
              final selectedTags = controller.selectedTags;

              return Container(
                width: double.infinity,
                padding: padding(all: 12),
                decoration: BoxDecoration(
                  color: appTheme.allSidesColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'selected_tags'.tr,
                          style: StyleThemeData.size12Weight600(color: appTheme.grayColor),
                        ),
                        Text(
                          '${selectedTags.length}/4',
                          style: StyleThemeData.size12Weight600(
                            color: selectedTags.length >= 4 ? appTheme.errorColor : appTheme.grayColor,
                          ),
                        ),
                      ],
                    ),
                    if (selectedTags.isEmpty)
                      Padding(
                        padding: padding(top: 8),
                        child: Text(
                          'no_tags_selected'.tr,
                          style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                        ),
                      )
                    else ...[
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: selectedTags.map((tag) {
                          final tagColor = _parseColor(tag.color);
                          return Container(
                            padding: padding(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: tagColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: tagColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(tag.icon ?? '🏷️', style: StyleThemeData.size14Weight400()),
                                SizedBox(width: 4.w),
                                Text(
                                  tag.name ?? '',
                                  style: StyleThemeData.size12Weight600(color: tagColor),
                                ),
                                SizedBox(width: 4.w),
                                InkWell(
                                  onTap: () {
                                    controller.selectedTags.remove(tag);
                                  },
                                  child: Icon(Icons.close, size: 14.w, color: tagColor),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );
            }),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTags.isTrue && controller.chatTagsModel.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tags = controller.chatTagsModel.value?.data ?? [];

                if (tags.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const NoDataWidget(),
                        SizedBox(height: 16.h),
                        TextButton.icon(
                          onPressed: () {
                            Get.back();
                            controller.showTagManagementDialog();
                          },
                          icon: Icon(Icons.add, color: appTheme.appColor),
                          label: Text(
                            'create_new_tag'.tr,
                            style: StyleThemeData.size14Weight600(color: appTheme.appColor),
                          ),
                        ),
                      ],
                    ),
                  );
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
                      buttonText: 'save'.tr,
                      isLoading: controller.isLodingTag.value,
                      onPressed: () => _saveTagAssignments(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagItem(ChatCategory tag) {
    final tagColor = _parseColor(tag.color);

    return Obx(() {
      final isSelected = controller.selectedTags.any((t) => t.id == tag.id);
      final isMaxReached = controller.selectedTags.length >= 4 && !isSelected;

      return CheckboxListTile(
        value: isSelected,
        onChanged: isMaxReached
            ? null
            : (value) {
                if (value == true) {
                  if (controller.selectedTags.length < 4) {
                    controller.selectedTags.add(tag);
                  } else {
                    DialogUtils.showErrorDialog('maximum_4_tags_allowed'.tr);
                  }
                } else {
                  controller.selectedTags.removeWhere((t) => t.id == tag.id);
                }
              },
        activeColor: tagColor,
        checkColor: appTheme.whiteColor,
        enabled: !isMaxReached,
        subtitle: tag.chatsCount != null && tag.chatsCount! > 0
            ? Opacity(
                opacity: isMaxReached ? 0.5 : 1.0,
                child: Text(
                  'used_in_chats'.trParams({'count': tag.chatsCount.toString()}),
                  style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                ),
              )
            : null,
        title: Opacity(
          opacity: isMaxReached ? 0.5 : 1.0,
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(tag.icon ?? '🏷️', style: StyleThemeData.size16Weight400()),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(tag.name ?? '', style: StyleThemeData.size14Weight600()),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _saveTagAssignments() async {
    final currentTagIds = (chat.tags ?? []).map((t) => t.id!).toList();
    final selectedTagIds = controller.selectedTags.map((t) => t.id!).toList();

    final hasChanges =
        currentTagIds.length != selectedTagIds.length || !currentTagIds.every((id) => selectedTagIds.contains(id));

    if (!hasChanges) {
      Get.back();
      return;
    }

    try {
      if (selectedTagIds.isEmpty) {
        if (currentTagIds.isNotEmpty) {
          await controller.removeTagsFromChat(chat.id!, currentTagIds);
        }
      } else {
        await controller.assignTagsToChat(chat.id!, selectedTagIds);
      }
    } catch (e) {
      print('Error saving tag assignments: $e');
    }
  }

  // void _saveTagAssignments() async {
  //   final currentTagIds = (chat.tags ?? []).map((t) => t.id!).toList();
  //   final selectedTagIds = controller.selectedTags.map((t) => t.id!).toList();

  //   final tagsToAdd = selectedTagIds.where((id) => !currentTagIds.any((id2) => id2 == id)).toList();
  //   final tagsToRemove = currentTagIds.where((id) => !selectedTagIds.any((id2) => id2 == id)).toList();

  //   // Assign new tags
  //   if (tagsToAdd.isNotEmpty) {
  //     await controller.assignTagsToChat(chat.id!, tagsToAdd);
  //   }

  //   // Remove unselected tags
  //   if (tagsToRemove.isNotEmpty) {
  //     await controller.removeTagsFromChat(chat.id!, tagsToRemove);
  //   }

  //   // If no changes
  //   if (tagsToAdd.isEmpty && tagsToRemove.isEmpty) {
  //     Get.back();
  //   }
  // }

  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return appTheme.appColor;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return appTheme.appColor;
    }
  }
}
