import 'package:chats/main.dart';
import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/pages/media_files/media_files_controller.dart';
import 'package:chats/pages/media_files/widget/attach_file_widget.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/widget/dynamic_grid_item_view.dart';
import 'package:chats/widget/list_loader.dart';
import 'package:chats/widget/no_data_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagesView extends GetView<MediaFilesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoadingImage.isTrue
          ? Center(child: CircularProgressIndicator(color: appTheme.appColor))
          : ListLoader(
              onRefresh: controller.fetchImages,
              onLoad: () => controller.fetchImages(isRefresh: false),
              hasNext: controller.mediaImageModel.value?.hasNext ?? false,
              child: SingleChildScrollView(
                child: (controller.mediaImageModel.value?.items ?? []).isNotEmpty
                    ? DynamicGridItemView<FilesModels>(
                        items: controller.mediaImageModel.value?.items ?? [],
                        borderRadius: 8,
                        itemBuilder: (file, index) {
                          return LayoutBuilder(
                            builder: (context, constraint) => Padding(
                              padding: padding(all: 4),
                              child: InkWell(
                                onTap: () => Get.toNamed(
                                  Routes.ATTACHMENT_FULLSCREEN,
                                  arguments: AttachmentFullscreenParameter(
                                    files: controller.mediaImageModel.value?.items ?? [],
                                    index: index,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                child: AttachFileWidget(item: file, size: constraint.maxWidth.w),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: NoDataWidget(height: 200.h)),
              ),
            ),
    );
  }
}
