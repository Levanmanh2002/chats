import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/notes_detail/notes_detail_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesDetailPage extends GetWidget<NotesDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.appColor,
        elevation: 0,
        title: Text(
          'note_detail'.tr,
          style: StyleThemeData.size20Weight700(color: appTheme.whiteColor),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: appTheme.whiteColor),
        actions: [
          Container(
            margin: padding(right: 8.w, top: 8.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: appTheme.whiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: appTheme.whiteColor,
                size: 20.w,
              ),
              onPressed: controller.deleteNote,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
            : SingleChildScrollView(
                padding: padding(all: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.noteDetail.value?.title ?? '', style: StyleThemeData.size20Weight600()),
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
                            controller.noteDetail.value?.category?.name ?? '',
                            style: StyleThemeData.size14Weight400(color: appTheme.appColor),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 12.w),
                              Icon(Icons.access_time, size: 16.w, color: appTheme.greyColor),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  '${controller.noteDetail.value?.startDate.toDayMonthYear} - ${controller.noteDetail.value?.endDate.toDayMonthYear}',
                                  style: StyleThemeData.size14Weight400(color: appTheme.greyColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(controller.noteDetail.value?.content ?? '', style: StyleThemeData.size14Weight400()),
                  ],
                ),
              ),
      ),
    );
  }
}
