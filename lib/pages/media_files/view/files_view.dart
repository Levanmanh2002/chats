import 'package:chats/main.dart';
import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/pages/media_files/media_files_controller.dart';
import 'package:chats/pages/media_files/widget/attach_file_widget.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesView extends GetView<MediaFilesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingFile.isTrue
          ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
          : ListLoader(
              onRefresh: controller.fetchFiles,
              onLoad: () => controller.fetchFiles(isRefresh: false),
              hasNext: controller.mediaFileModel.value?.hasNext ?? false,
              child: SingleChildScrollView(
                child: (controller.mediaFileModel.value?.items ?? []).isNotEmpty
                    ? Column(
                        children: (controller.mediaFileModel.value?.items ?? []).groupByMonth().entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: padding(horizontal: 16, vertical: 8),
                                child: Text(entry.key, style: StyleThemeData.size12Weight600()),
                              ),
                              ...entry.value.map((e) {
                                return InkWell(
                                  onTap: () {
                                    openUrlInBrowser(e.fileUrl ?? '');
                                  },
                                  child: Padding(
                                    padding: padding(vertical: 8, horizontal: 16),
                                    child: AttachFileWidget(item: e, size: 24.w),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      )
                    : Center(child: NoDataWidget(height: 200.h)),
              ),
            ),
    );
  }
}
