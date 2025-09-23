import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/notes/note_model.dart';
import 'package:chats/pages/notes/notes_controller.dart';
import 'package:chats/pages/notes/view/tab_note_view.dart';
import 'package:chats/pages/notes_detail/notes_detail_parameter.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/calendar_config_util.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesPage extends GetWidget<NotesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.appColor,
        elevation: 0,
        title: Text(
          'notes'.tr,
          style: StyleThemeData.size20Weight700(color: appTheme.whiteColor),
        ),
        centerTitle: false,
        actions: [
          Obx(
            () => Stack(
              children: [
                InkWell(
                  onTap: () async {
                    final ranges = await showCalendarDatePicker2Dialog(
                      context: Get.context!,
                      config: CalendarConfigUtil.getDefaultConfig(Get.context!),
                      dialogSize: Size(Get.width, Get.width),
                      borderRadius: BorderRadius.circular(15),
                      value: [
                        controller.filterDate.value?.start,
                        controller.filterDate.value?.end,
                      ],
                      dialogBackgroundColor: appTheme.whiteColor,
                    );
                    if (ranges != null) {
                      controller.selectFilterDate(
                        DateTimeRange(
                          start: ranges[0]!,
                          end: ranges.length == 1 ? ranges[0]! : ranges[1]!,
                        ),
                      );
                    }
                  },
                  splashColor: appTheme.transparentColor,
                  hoverColor: appTheme.transparentColor,
                  highlightColor: appTheme.transparentColor,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: padding(right: 8.w, top: 8.h, bottom: 8.h),
                    decoration: BoxDecoration(
                      color: appTheme.whiteColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: appTheme.whiteColor,
                        size: 20.w,
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
                if (controller.filterDate.value != null)
                  Positioned(
                    right: 4.w,
                    top: 4.h,
                    child: Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        color: appTheme.redColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: appTheme.whiteColor, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            margin: padding(right: 8.w, top: 8.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: appTheme.whiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: appTheme.whiteColor,
                size: 20.w,
              ),
              onPressed: controller.showAddNote,
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: padding(vertical: 12, horizontal: 16),
              child: Row(
                children: controller.categories
                    .map((e) => Padding(
                          padding: padding(right: 8),
                          child: TabNoteView(
                            isSelect: controller.selectedCategory.value?.id == e.id,
                            title: e.name,
                            onTap: () => controller.loadNoteListToCategory(e),
                            color: e.color,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: Column(
                children: (controller.notes.value?.notes ?? []).map((e) {
                  return _itemNoteWidget(e);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemNoteWidget(NoteItem e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // controller.showEditNote(e);
            Get.toNamed(Routes.NOTES_DETAIL, arguments: NotesDetailParameter(noteId: e.id!));
          },
          child: Padding(
            padding: padding(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: (e.category?.color ?? '').toColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.note,
                    color: (e.category?.color ?? '').toColor,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: StyleThemeData.size16Weight600(color: appTheme.blackColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${e.startDate.toDayMonthYear} - ${e.endDate.toDayMonthYear}',
                            style: StyleThemeData.size14Weight400(color: appTheme.greyColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        e.content,
                        style: StyleThemeData.size14Weight400(color: appTheme.hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Container(
                            padding: padding(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: appTheme.appColor.withOpacity(0.1),
                            ),
                            child: Text(
                              e.category?.name ?? '',
                              style: StyleThemeData.size14Weight400(color: appTheme.appColor),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              controller.showEditNote(e);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: appTheme.appColor,
                              size: 16.w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const LineWidget(),
      ],
    );
  }
}
