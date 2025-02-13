import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/extension/data/file_extension.dart';
import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app/file_content_type.dart';
import 'package:chats/utils/icons_assets.dart';
import 'package:chats/utils/images_assets.dart';
import 'package:chats/widget/custom_image_widget.dart';
import 'package:chats/widget/image_asset_custom.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chats/widget/video/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentFullscreenPage extends GetWidget<AttachmentFullscreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: controller.toggleShowAppBar,
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.parameter.files?.length,
              itemBuilder: (context, index) {
                final attachment = controller.parameter.files?[index];
                if (attachment?.fileType?.getFileCategory == FileCategory.IMAGE) {
                  return GestureDetector(
                    onDoubleTap: () => controller.resetZoom(index),
                    child: InteractiveViewer(
                      transformationController: controller.controllers[index],
                      panEnabled: true,
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: attachment?.isLocal == true
                          ? Image.file(
                              File(attachment?.fileUrl ?? ''),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: attachment?.fileUrl ?? '',
                              placeholder: (context, url) => const ImageAssetCustom(
                                imagePath: ImagesAssets.placeholder,
                                boxFit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => const ImageAssetCustom(
                                imagePath: ImagesAssets.placeholder,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                    ),
                  );
                } else {
                  return VideoPlayerChewie(
                    videoPath: attachment?.fileUrl ?? '',
                    isLocal: attachment?.isLocal ?? false,
                  );
                }
              },
            ),
          ),
          Obx(() {
            if (controller.isShowAppBar.value) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: padding(all: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            minimumSize: Size.zero,
                            fixedSize: Size(36.w, 36.w),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            maximumSize: Size(36.w, 36.w),
                          ),
                          icon: ImageAssetCustom(imagePath: IconsAssets.arrowLeftIcon, color: appTheme.whiteColor),
                          onPressed: Get.back,
                        ),
                        SizedBox(width: 8.w),
                        CustomImageWidget(
                          imageUrl: controller.parameter.user?.avatar ?? '',
                          size: 46.w,
                          colorBoder: appTheme.appColor,
                          showBoder: true,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.parameter.user?.name ?? 'not_updated_yet'.tr,
                                style: StyleThemeData.size14Weight600(color: appTheme.whiteColor),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                controller.parameter.user?.lastOnline?.timeAgo ?? '',
                                style: StyleThemeData.size10Weight400(color: appTheme.whiteColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        IconButton(
                          style: IconButton.styleFrom(
                            minimumSize: Size.zero,
                            fixedSize: Size(36.w, 36.w),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            maximumSize: Size(36.w, 36.w),
                          ),
                          icon: ImageAssetCustom(imagePath: IconsAssets.downloadIcon, color: appTheme.whiteColor),
                          onPressed: () {
                            final attachment =
                                controller.parameter.files?[controller.pageController.page?.toInt() ?? 0];
                            if (attachment?.fileUrl != null) {
                              controller.saveImage(attachment?.fileUrl ?? '');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
