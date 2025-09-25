import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/notes/note_category_model.dart';
import 'package:chats/models/notes/note_model.dart';
import 'package:chats/pages/notes/notes_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/note_status.dart';
import 'package:chats/utils/calendar_config_util.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/custom_text_field.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNotesDialog(NotesController controller, {NoteItem? note}) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Rx<NoteCategoryModel?> selectedCategoryLocal = Rx<NoteCategoryModel?>(null);
  Rx<NoteStatusEnum?> selectedStatusLocal = Rx<NoteStatusEnum?>(null);

  var titleValue = ''.obs;
  var contentValue = ''.obs;

  if (note != null) {
    titleController.text = note.title;
    contentController.text = note.content;
    titleValue.value = note.title;
    contentValue.value = note.content;
    // controller.selectCategory(controller.categories.firstWhere((element) => element.id == note.id));
    selectedCategoryLocal.value = controller.categories
        .firstWhere((element) => element.id == note.category?.id, orElse: () => controller.categories.first);
    if (note.startDate.isNotEmpty) {
      controller.selectStartReminder(note.startDate.toDateTime);
    }
    if (note.endDate.isNotEmpty) {
      controller.selectEndReminder(note.endDate.toDateTime);
    }
    if (note.noteStatus != null) {
      selectedStatusLocal.value = NoteStatusEnum.values.firstWhere((e) => e.name == note.noteStatus?.key);
    }
  }

  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: padding(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: padding(all: 16),
            child: Obx(
              () => SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: padding(horizontal: 16, bottom: 16),
                      child: Text(
                        note != null ? 'edit_note'.tr : 'create_note'.tr,
                        style: StyleThemeData.size16Weight600(),
                      ),
                    ),
                    CustomTextField(
                      controller: titleController,
                      titleText: 'title'.tr,
                      hintText: 'enter_note_title'.tr,
                      showLine: false,
                      colorBorder: appTheme.silverColor,
                      onChanged: (value) => titleValue.value = value,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: contentController,
                      titleText: 'content'.tr,
                      hintText: 'enter_note_content'.tr,
                      maxLines: 5,
                      showLine: false,
                      colorBorder: appTheme.silverColor,
                      onChanged: (value) => contentValue.value = value,
                    ),
                    SizedBox(height: 12.w),
                    Padding(
                      padding: padding(bottom: 8),
                      child: Row(
                        children: [
                          Text('category'.tr, style: StyleThemeData.size12Weight600()),
                          SizedBox(width: 4.w),
                          Text('*', style: StyleThemeData.size12Weight600(color: appTheme.errorColor)),
                        ],
                      ),
                    ),
                    DropdownButtonFormField<NoteCategoryModel>(
                      value: selectedCategoryLocal.value,
                      dropdownColor: appTheme.whiteColor,
                      icon: Icon(Icons.keyboard_arrow_down, size: 24.w),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                        ),
                      ),
                      style: StyleThemeData.size14Weight400(),
                      borderRadius: BorderRadius.circular(12),
                      hint: Text(
                        'select_category'.tr,
                        style: StyleThemeData.size14Weight400(color: appTheme.hintColor),
                      ),
                      items: controller.categories.map((NoteCategoryModel category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name.isNotEmpty ? category.name : 'select_category'.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedCategoryLocal.value = value;
                      },
                    ),
                    SizedBox(height: 12.w),
                    // Padding(
                    //   padding: padding(bottom: 8),
                    //   child: Row(
                    //     children: [
                    //       Text('Nhắc nhở'.tr, style: StyleThemeData.size12Weight600()),
                    //       SizedBox(width: 4.w),
                    //       Text('*', style: StyleThemeData.size12Weight600(color: appTheme.errorColor)),
                    //     ],
                    //   ),
                    // ),
                    CustomTextField(
                      controller: TextEditingController(
                        text: controller.selectedStartReminder.value != null
                            ? controller.selectedStartReminder.value.toddMMyyyyDash
                            : '',
                      ),
                      titleText: 'start_date'.tr,
                      hintText: 'select_start_date'.tr,
                      showLine: false,
                      colorBorder: appTheme.silverColor,
                      readOnly: true,
                      showBorder: true,
                      onTap: () async {
                        final ranges = await showCalendarDatePicker2Dialog(
                          context: Get.context!,
                          config: CalendarConfigUtil.getDefaultConfig(
                            Get.context!,
                            singleMode: true,
                            firstDate: DateTime.now().add(const Duration(days: 1)),
                            lastDate: controller.selectedEndReminder.value,
                          ),
                          dialogSize: Size(Get.width, Get.width),
                          borderRadius: BorderRadius.circular(15),
                          value: [
                            controller.selectedStartReminder.value ?? DateTime.now().add(const Duration(days: 1)),
                          ],
                          dialogBackgroundColor: appTheme.whiteColor,
                        );
                        if (ranges != null) {
                          controller.selectStartReminder(ranges.isNotEmpty ? ranges.first : null);
                        }
                      },
                    ),
                    SizedBox(height: 12.w),
                    CustomTextField(
                      controller: TextEditingController(
                        text: controller.selectedEndReminder.value != null
                            ? controller.selectedEndReminder.value.toddMMyyyyDash
                            : '',
                      ),
                      titleText: 'end_date'.tr,
                      hintText: 'select_end_date'.tr,
                      showLine: false,
                      colorBorder: appTheme.silverColor,
                      readOnly: true,
                      showBorder: true,
                      onTap: () async {
                        final ranges = await showCalendarDatePicker2Dialog(
                          context: Get.context!,
                          config: CalendarConfigUtil.getDefaultConfig(
                            Get.context!,
                            singleMode: true,
                            firstDate: DateTime.now().add(const Duration(days: 1)),
                          ),
                          dialogSize: Size(Get.width, Get.width),
                          borderRadius: BorderRadius.circular(15),
                          value: [
                            controller.selectedEndReminder.value ?? DateTime.now().add(const Duration(days: 1)),
                          ],
                          dialogBackgroundColor: appTheme.whiteColor,
                        );
                        if (ranges != null) {
                          controller.selectEndReminder(ranges.isNotEmpty ? ranges.first : null);
                        }
                      },
                    ),
                    if (note != null) ...[
                      SizedBox(height: 12.w),
                      Padding(
                        padding: padding(bottom: 8),
                        child: Row(
                          children: [
                            Text('Trạng thái'.tr, style: StyleThemeData.size12Weight600()),
                            SizedBox(width: 4.w),
                            Text('*', style: StyleThemeData.size12Weight600(color: appTheme.errorColor)),
                          ],
                        ),
                      ),
                      DropdownButtonFormField<NoteStatusEnum>(
                        value: selectedStatusLocal.value,
                        dropdownColor: appTheme.whiteColor,
                        icon: Icon(Icons.keyboard_arrow_down, size: 24.w),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                          ),
                        ),
                        style: StyleThemeData.size14Weight400(),
                        borderRadius: BorderRadius.circular(12),
                        hint: Text(
                          'Trạng thái'.tr,
                          style: StyleThemeData.size14Weight400(color: appTheme.hintColor),
                        ),
                        items: NoteStatusEnum.values.map((NoteStatusEnum status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.dislayName.isNotEmpty ? status.dislayName : 'Chọn trạng thái'.tr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedStatusLocal.value = value;
                        },
                      ),
                    ],
                    // DropdownButtonFormField<String>(
                    //   value: selectedReminder.value,
                    //   dropdownColor: appTheme.whiteColor,
                    //   icon: Icon(Icons.keyboard_arrow_down, size: 24.w),
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide(style: BorderStyle.solid, width: 1.w, color: appTheme.silverColor),
                    //     ),
                    //   ),
                    //   style: StyleThemeData.size14Weight400(),
                    //   borderRadius: BorderRadius.circular(12),
                    //   items: reminders.map((reminder) {
                    //     return DropdownMenuItem(value: reminder, child: Text(reminder));
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     selectedReminder.value = value ?? '';
                    //   },
                    // ),
                    LineWidget(margin: padding(vertical: 12)),
                    Row(
                      children: [
                        Expanded(
                          child: CustomBorderButtonWidget(
                            buttonText: 'close'.tr,
                            onPressed: () => Get.back(),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Obx(() {
                            final isValid = titleValue.value.isNotEmpty &&
                                contentValue.value.isNotEmpty &&
                                selectedCategoryLocal.value != null &&
                                controller.selectedStartReminder.value != null &&
                                controller.selectedEndReminder.value != null;

                            return CustomButton(
                              buttonText: note != null ? 'edit'.tr : 'create'.tr,
                              onPressed: isValid
                                  ? () => note != null
                                      ? controller.updateNote(
                                          id: note.id!,
                                          title: titleValue.value,
                                          content: contentValue.value,
                                          categoryId: selectedCategoryLocal.value!.id!,
                                          status: selectedStatusLocal.value,
                                        )
                                      : controller.createNote(
                                          title: titleValue.value,
                                          content: contentValue.value,
                                          categoryId: selectedCategoryLocal.value!.id!,
                                        )
                                  : null,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
