import 'package:chats/models/messages/media_file_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/options/options_parameter.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OptionsController extends GetxController {
  final IMessagesRepository messagesRepository;
  final OptionsParameter parameter;

  OptionsController({required this.messagesRepository, required this.parameter});

  Rx<MediaFileModel?> mediaImageModel = Rx<MediaFileModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _fetchImages();
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

  void onShowSearchMessage() {
    Get.find<MessageController>().isShowSearch.value = false;
    Get.back();
  }
}
