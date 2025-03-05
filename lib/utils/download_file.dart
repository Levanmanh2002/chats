import 'dart:developer';
import 'dart:io';

import 'package:chats/main.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadPdfToPublicDirectory(String url, String fileName) async {
  var status = await Permission.storage.request();

  if (status.isGranted) {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Directory directory;
        String folderPath;

        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
          folderPath = '${directory.path}/Pictures';
        } else {
          directory = await getApplicationDocumentsDirectory();
          folderPath = directory.path;
        }

        String filePath = '$folderPath/$fileName';
        await Directory(folderPath).create(recursive: true);
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        log('PDF downloaded to: $filePath');

        DialogUtils.showSuccessDialog('document_downloaded_successfully'.tr);
      } else {
        DialogUtils.showErrorDialog('error_downloading_document'.tr);
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    } finally {
      EasyLoading.dismiss();
    }
  } else if (status.isDenied) {
    showPermissionDialog('permission_denied'.tr);
  } else if (status.isPermanentlyDenied) {
    showPermissionDialog('storage_permission_denied_permanently'.tr);
  }
}

void showPermissionDialog(String title) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Padding(
        padding: padding(horizontal: 16),
        child: Dialog(
          backgroundColor: appTheme.whiteColor,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: padding(top: 32, left: 16, right: 16, bottom: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: StyleThemeData.size20Weight600(color: appTheme.appColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 19.h),
                Padding(
                  padding: padding(horizontal: 36),
                  child: Text(
                    'please_enable_storage_permission_in_the_app_settings'.tr,
                    style: StyleThemeData.size12Weight400(color: appTheme.grayColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Flexible(
                      child: CustomBorderButtonWidget(
                        buttonText: 'open_settings'.tr,
                        color: appTheme.grayColor,
                        textColor: appTheme.appColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                          openAppSettings();
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: CustomButton(
                        buttonText: 'cancel'.tr,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
