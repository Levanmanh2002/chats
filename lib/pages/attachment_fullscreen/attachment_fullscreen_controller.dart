import 'dart:io';

import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';

class AttachmentFullscreenController extends GetxController {
  final AttachmentFullscreenParameter parameter;

  AttachmentFullscreenController({required this.parameter});

  final pageController = PageController();
  List<TransformationController> controllers = [];

  var isShowAppBar = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(parameter.index);
    });
    initControllers(parameter.files?.length ?? 0);
  }

  Future<void> saveImage(String url) async {
    try {
      if (url.isEmpty) return;
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final path = await FileDownloader.downloadFile(
        url: url,
        name: url,
        onProgress: (fileName, progress) {},
        onDownloadCompleted: (String path) {
          print('FILE DOWNLOADED TO PATH: $path');
        },
        onDownloadError: (String error) {},
      );

      if (path != null) {
        DialogUtils.showSuccessDialog('download_successful'.tr);
      } else {
        DialogUtils.showErrorDialog('download_failed'.tr);
      }
    } catch (e) {
      print('Error saving image: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveVideo(String url) async {
    try {
      if (url.isEmpty) return;

      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      // ✅ Tạo tên file với timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = url.split('.').last.split('?').first;
      final fileName = 'VID_$timestamp.$extension';

      print('📹 Downloading video: $fileName');
      print('🔗 URL: $url');

      final path = await FileDownloader.downloadFile(
        url: url,
        name: fileName,
        downloadDestination: DownloadDestinations.publicDownloads,
        onProgress: (fileName, progress) {
          print('📥 Progress: $progress%');
        },
        onDownloadCompleted: (String path) {
          print('✅ Downloaded to: $path');
        },
        onDownloadError: (String error) {
          print('❌ Error: $error');
        },
      );

      if (path != null) {
        final file = File(path.path);

        if (await file.exists()) {
          final fileSize = await file.length();
          print('📊 File size: $fileSize bytes');

          if (fileSize > 0) {
            DialogUtils.showSuccessDialog('download_successful'.tr);
          } else {
            print('❌ File is empty');
            DialogUtils.showErrorDialog('download_failed'.tr);
          }
        } else {
          print('❌ File not found at: $path');
          DialogUtils.showErrorDialog('download_failed'.tr);
        }
      } else {
        print('❌ Download path is null');
        DialogUtils.showErrorDialog('download_failed'.tr);
      }
    } catch (e) {
      print('❌ Error saving video: $e');
      DialogUtils.showErrorDialog('download_failed'.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void toggleShowAppBar() {
    isShowAppBar.value = !isShowAppBar.value;
  }

  void initControllers(int count) {
    controllers = List.generate(count, (_) => TransformationController());
  }

  void resetZoom(int index) {
    controllers[index].value = Matrix4.identity();
  }

  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
