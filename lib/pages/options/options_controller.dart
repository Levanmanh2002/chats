import 'dart:io';

import 'package:chats/constant/date_format_constants.dart';
import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/options/options_parameter.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/download_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class OptionsController extends GetxController {
  final IMessagesRepository messagesRepository;
  final OptionsParameter parameter;

  OptionsController({required this.messagesRepository, required this.parameter});

  Rx<MediaFileModel?> mediaImageModel = Rx<MediaFileModel?>(null);

  var isHideMessage = false.obs;
  final earningRangeDate = DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
    _fetchImages();
    isHideMessage.value = parameter.isHideMessage;
  }

  Future<void> _fetchImages() async {
    try {
      final response = await messagesRepository.getImageFileByChatId(parameter.chatId, 'image');

      if (response.statusCode == 200) {
        mediaImageModel.value = MediaFileModel.fromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteChat() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.deleteChat(parameter.chatId);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<ChatsController>().removeChat(parameter.chatId);
        Get.close(2);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void onHideMessage() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.hideChat(parameter.chatId);

      if (response.statusCode == 200) {
        isHideMessage.value = !isHideMessage.value;
        Get.find<MessageController>().messageModel.value?.chat?.isHide = isHideMessage.value;
        Get.find<ChatsController>().fetchChatList();
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void changeRangeDate(DateTimeRange range) {
    earningRangeDate.value = range;
    _fetchExportMessage();
  }

  void _fetchExportMessage() async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          print("Quyền truy cập bộ nhớ bị từ chối!");
          return;
        }
      }

      final response = await messagesRepository.exportMessage(
        parameter.chatId,
        startDate: earningRangeDate.value.start.toyyyyMMdd,
        endDate: earningRangeDate.value.end.toyyyyMMdd,
      );

      if (response.statusCode == 200) {
        await downloadPdfToPublicDirectory(
          response.body['download_url'],
          'export_message_${DateFormat(DateConstants.yyyyMMddMMmmss).format(DateTime.now())}.pdf',
        );
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void changePrimaryName(String value) async {
    if (parameter.user == null) return;

    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.changePrimaryName(parameter.user!.id!, value);

      if (response.statusCode == 200) {
        Get.find<ChatsController>().fetchChatList();
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.until((route) => Get.currentRoute == Routes.DASHBOARD);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void onShowSearchMessage() {
    Get.find<MessageController>().isShowSearch.value = false;
    Get.back();
  }
}
