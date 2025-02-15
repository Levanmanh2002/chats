import 'package:chats/models/messages/quick_message.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/instant_message/instant_message_parameter.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:get/get.dart';

class InstantMessageController extends GetxController {
  final IMessagesRepository messagesRepository;
  final InstantMessageParameter parameter;

  InstantMessageController({required this.messagesRepository, required this.parameter});

  RxList<QuickMessage> quickMessages = <QuickMessage>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuickMessage();
  }

  Future<void> fetchQuickMessage() async {
    try {
      isLoading.value = true;
      final response = await messagesRepository.getInstantMess(parameter.chatId);

      if (response.statusCode == 200) {
        quickMessages.value = QuickMessage.listFromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void removeQuickMessage(int id) async {
    quickMessages.removeWhere((element) => element.id == id);
    quickMessages.refresh();
  }

  void updateQuickMessage(List<QuickMessage> quickMessage) {
    quickMessages.value = quickMessage;
    if (parameter.type == InstantMessageType.chat) {
      Get.find<MessageController>().updateNewDataQuickMessage(quickMessage);
    } else if (parameter.type == InstantMessageType.group) {
      Get.find<GroupMessageController>().updateNewDataQuickMessage(quickMessage);
    }
  }
}
