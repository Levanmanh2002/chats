import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/pages/media_files/media_files_controller.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/widget/chats/attach_file_widget.dart';
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (controller.mediaFileModel.value?.items ?? []).groupByMonth().entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: padding(horizontal: 16, vertical: 8),
                                child: Text(entry.key, style: StyleThemeData.size12Weight600()),
                              ),
                              ...entry.value.map((e) {
                                final fileCategory = e.fileType?.getFileCategory;

                                if (fileCategory == FileCategory.VIDEO) {
                                  return _buildVideoItem(e);
                                }

                                return _buildFileItem(e);
                                // return InkWell(
                                //   onTap: () {
                                //     if (e.fileType?.getFileCategory == FileCategory.VIDEO) {
                                //       Get.toNamed(
                                //         Routes.ATTACHMENT_FULLSCREEN,
                                //         arguments: AttachmentFullscreenParameter(
                                //           files: e.fileUrl != null ? [e] : [],
                                //           index: 0,
                                //         ),
                                //       );
                                //       return;
                                //     }
                                //     openUrlInBrowser(e.fileUrl ?? '');
                                //   },
                                //   child: IgnorePointer(
                                //     ignoring: true,
                                //     child: ConstrainedBox(
                                //       constraints: BoxConstraints(
                                //           // maxHeight:
                                //           //     e.fileType?.getFileCategory == FileCategory.VIDEO ? 200 : double.infinity,
                                //           ),
                                //       child: Padding(
                                //         padding: padding(vertical: 8, horizontal: 16),
                                //         child: AttachFileWidget(item: e, size: 24.w),
                                //       ),
                                //     ),
                                //   ),
                                // );
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

  Widget _buildVideoItem(FilesModels e) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.ATTACHMENT_FULLSCREEN,
          arguments: AttachmentFullscreenParameter(files: [e], index: 0),
        );
      },
      child: Container(
        margin: padding(horizontal: 16, vertical: 4),
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: appTheme.allSidesColor,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AttachFileWidget(
              item: e,
              size: 24.w,
              heightVideo: 180.h,
            ),
            Center(
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: appTheme.blackColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: appTheme.whiteColor, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(FilesModels e) {
    return InkWell(
      onTap: () {
        openUrlInBrowser(e.fileUrl ?? '');
      },
      child: Container(
        margin: padding(horizontal: 16, vertical: 4),
        padding: padding(all: 12),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appTheme.oldSilverColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: _getFileColor(e.fileType),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getFileIcon(e.fileType), color: appTheme.whiteColor, size: 24.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                e.fileUrl ?? 'Unknown file',
                style: StyleThemeData.size14Weight600(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.w, color: appTheme.oldSilverColor),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String? fileType) {
    switch (fileType?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String? fileType) {
    switch (fileType?.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'zip':
      case 'rar':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
