import 'package:chats/models/messages/quick_message.dart';
import 'package:chats/pages/instant_message/instant_message_controller.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_parameter.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UpsertInstantMessController extends GetxController {
  final IMessagesRepository messagesRepository;
  final UpsertInstantMessParameter parameter;

  UpsertInstantMessController({required this.messagesRepository, required this.parameter});

  late TextEditingController shortcutController;
  late TextEditingController contentController;

  var isFormValid = false.obs;
  var isLoading = false.obs;

  var contentValue = ''.obs;
  var shortcutValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    shortcutController = TextEditingController(text: parameter.quickMessage?.shortKey ?? '')
      ..addListener(_validateForm);
    contentController = TextEditingController(text: parameter.quickMessage?.content ?? '')..addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value = shortcutController.text.isNotEmpty && contentController.text.isNotEmpty;
  }

  void submitInstantMess() {
    if (parameter.type == UpsertInstantMessType.create) {
      addInstantMess();
    } else {
      updateInstantMess();
    }
  }

  void addInstantMess() async {
    try {
      isLoading.value = true;

      Map<String, String> params = {
        if (parameter.chatId != null) "chat_id": parameter.chatId.toString(),
        'short_key': shortcutController.text.trim(),
        'content': contentController.text.trim(),
      };

      final response = await messagesRepository.addInstantMess(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);

        Get.find<InstantMessageController>().updateQuickMessage(
          QuickMessage.listFromJson(response.body['data']),
        );
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void updateInstantMess() async {
    try {
      if (parameter.quickMessage == null) return;
      isLoading.value = true;

      Map<String, String> params = {
        'id': parameter.quickMessage!.id.toString(),
        'short_key': shortcutController.text.trim(),
        'content': contentController.text.trim(),
      };

      final response = await messagesRepository.updateInstantMess(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);

        Get.find<InstantMessageController>().updateQuickMessage(
          QuickMessage.listFromJson(response.body['data']),
        );
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void deleteInstantMess() async {
    try {
      if (parameter.quickMessage == null) return;
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.deleteInstantMess(parameter.quickMessage!.id!);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<InstantMessageController>().removeQuickMessage(parameter.quickMessage!.id!);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void validateContent(String value) {
    contentValue.value = value;
    _validateForm();
  }

  void validateShortcut(String value) {
    shortcutValue.value = value;
    _validateForm();
  }

  @override
  void dispose() {
    super.dispose();
    shortcutController.dispose();
    contentController.dispose();
  }
}
