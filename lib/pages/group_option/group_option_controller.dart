import 'dart:io';

import 'package:chats/constant/date_format_constants.dart';
import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_option/group_option_parameter.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/download_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupOptionController extends GetxController {
  final IGroupsRepository groupsRepository;
  final IMessagesRepository messagesRepository;
  final GroupOptionParameter parameter;

  GroupOptionController({required this.groupsRepository, required this.messagesRepository, required this.parameter});

  Rx<ChatDataModel?> chatDataModel = Rx<ChatDataModel?>(null);
  Rx<MediaFileModel?> mediaImageModel = Rx<MediaFileModel?>(null);

  var isHideMessage = false.obs;
  final earningRangeDate = DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  @override
  void onInit() {
    chatDataModel.value = parameter.chat;
    _fetchImages();
    isHideMessage.value = parameter.isHideMessage;
    super.onInit();
  }

  Future<void> renameGroup(String groupName) async {
    try {
      if (parameter.chat == null) return;
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await groupsRepository.renameGroup(parameter.chat!.id!, groupName);

      if (response.statusCode == 200) {
        chatDataModel.value?.name = groupName;
        chatDataModel.refresh();
        Get.find<GroupMessageController>().updateGroupName(groupName);
        Get.find<ChatsController>().updateGroupName(parameter.chat!.id!, groupName);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _fetchImages() async {
    try {
      final response = await messagesRepository.getImageFileByChatId(parameter.chat!.id!, 'image');

      if (response.statusCode == 200) {
        mediaImageModel.value = MediaFileModel.fromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteChat() async {
    if (parameter.chat == null) return;
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.deleteChat(parameter.chat!.id!);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<ChatsController>().removeChat(parameter.chat!.id!);
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
    if (parameter.chat == null) return;
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.hideChat(parameter.chat!.id!);

      if (response.statusCode == 200) {
        isHideMessage.value = !isHideMessage.value;
        Get.find<GroupMessageController>().messageModel.value?.chat?.isHide = isHideMessage.value;
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
        parameter.chat!.id!,
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

  void removeUserInChatGroup(UserModel user) {
    chatDataModel.value?.users?.remove(user);
    chatDataModel.refresh();
  }

  void updateNewDataUserChat(ChatDataModel chat) {
    chatDataModel.value = chatDataModel.value?.copyWith(users: chat.users);
    chatDataModel.refresh();
  }

  void updateNameGroupEvent(String name) {
    chatDataModel.value = chatDataModel.value?.copyWith(name: name);
    chatDataModel.refresh();
  }

  void onShowSearchMessage() {
    Get.find<GroupMessageController>().isShowSearch.value = false;
    Get.back();
  }
}
