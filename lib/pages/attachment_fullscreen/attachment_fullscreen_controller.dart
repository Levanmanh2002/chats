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

  var isShowAppBar = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(parameter.index);
    });
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


  void toggleShowAppBar() {
    isShowAppBar.value = !isShowAppBar.value;
  }
}
