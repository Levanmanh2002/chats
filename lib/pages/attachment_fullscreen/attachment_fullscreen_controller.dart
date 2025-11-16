import 'dart:html' as html;
import 'dart:io';

import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_parameter.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

      // ✅ KIỂM TRA PLATFORM
      if (kIsWeb) {
        // 🌐 WEB
        await _downloadFileWeb(url, isVideo: false);
      } else {
        // 📱 MOBILE (iOS/Android)
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final extension = url.split('.').last.split('?').first;
        final fileName = 'IMG_$timestamp.$extension';

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

        if (path != null && await File(path.path).exists()) {
          DialogUtils.showSuccessDialog('download_successful'.tr);
        } else {
          DialogUtils.showErrorDialog('download_failed'.tr);
        }
      }
    } catch (e) {
      print('❌ Error saving image: $e');
      DialogUtils.showErrorDialog('download_failed'.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> saveVideo(String url) async {
    try {
      if (url.isEmpty) return;

      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      // ✅ KIỂM TRA PLATFORM
      if (kIsWeb) {
        // 🌐 WEB
        await _downloadFileWeb(url, isVideo: true);
      } else {
        // 📱 MOBILE
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final extension = url.split('.').last.split('?').first;
        final fileName = 'VID_$timestamp.$extension';

        print('📹 Downloading video: $fileName');

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
              DialogUtils.showErrorDialog('download_failed'.tr);
            }
          } else {
            DialogUtils.showErrorDialog('download_failed'.tr);
          }
        } else {
          DialogUtils.showErrorDialog('download_failed'.tr);
        }
      }
    } catch (e) {
      print('❌ Error saving video: $e');
      DialogUtils.showErrorDialog('download_failed'.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

// ✅ FUNCTION DOWNLOAD CHO WEB
  Future<void> _downloadFileWeb(String url, {required bool isVideo}) async {
    try {
      print('🌐 Downloading from web: $url');

      // 1. Download file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      final bytes = response.bodyBytes;
      print('📊 Downloaded ${bytes.length} bytes');

      // 2. Tạo tên file
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = url.split('.').last.split('?').first;
      final fileName = isVideo ? 'VID_$timestamp.$extension' : 'IMG_$timestamp.$extension';

      // 3. Tạo blob và trigger download
      final blob = html.Blob([bytes]);
      final blobUrl = html.Url.createObjectUrlFromBlob(blob);

      // 4. Tạo anchor element để download
      final anchor = html.AnchorElement(href: blobUrl)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      // 5. Thêm vào DOM, click, và xóa
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();

      // 6. Cleanup
      html.Url.revokeObjectUrl(blobUrl);

      print('✅ File downloaded: $fileName');

      DialogUtils.showSuccessDialog('download_successful'.tr);
    } catch (e) {
      print('❌ Web download error: $e');
      DialogUtils.showErrorDialog('download_failed'.tr);
      rethrow;
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
