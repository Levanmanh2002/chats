import 'package:chats/main.dart';
import 'package:chats/models/chat_tags/chat_tags_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
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

class FilterTagsDialog extends GetView<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appTheme.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500.w,
        height: 600.h,
        padding: padding(all: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'filter_by_tags'.tr,
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
              final selectedCount = controller.selectedFilterTagIds.length;

              return Container(
                width: double.infinity,
                padding: padding(all: 12),
                decoration: BoxDecoration(
                  color: appTheme.allSidesColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCount > 0
                          ? 'selected_filters'.trParams({'count': selectedCount.toString()})
                          : 'no_filters_selected'.tr,
                      style: StyleThemeData.size12Weight600(
                        color: selectedCount > 0 ? appTheme.appColor : appTheme.grayColor,
                      ),
                    ),
                    if (selectedCount > 0)
                      TextButton(
                        onPressed: () {
                          controller.clearTagFilter();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'clear_all'.tr,
                          style: StyleThemeData.size12Weight600(color: appTheme.errorColor),
                        ),
                      ),
                  ],
                ),
              );
            }),
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTags.isTrue && controller.chatTagsModel.value == null) {
                  return Center(child: CircularProgressIndicator(color: appTheme.appColor));
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
                      return _buildTagFilterItem(tag);
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
                    buttonText: 'clear_filters'.tr,
                    onPressed: () {
                      controller.clearTagFilter();
                      Get.back();
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    buttonText: 'apply_filters'.tr,
                    onPressed: () {
                      controller.applyTagFilter();
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagFilterItem(ChatCategory tag) {
    final tagColor = _parseColor(tag.color);

    return Obx(() {
      final isSelected = controller.selectedFilterTagIds.contains(tag.id);

      return CheckboxListTile(
        value: isSelected,
        onChanged: (value) {
          controller.toggleFilterTag(tag.id!);
        },
        activeColor: tagColor,
        checkColor: appTheme.whiteColor,
        title: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: tagColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(tag.icon ?? '🏷️', style: StyleThemeData.size18Weight600()),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag.name ?? '',
                    style: StyleThemeData.size14Weight600(),
                  ),
                  if (tag.chatsCount != null && tag.chatsCount! > 0)
                    Text(
                      'chats_count'.trParams({'count': tag.chatsCount.toString()}),
                      style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return appTheme.appColor;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return appTheme.appColor;
    }
  }
}
