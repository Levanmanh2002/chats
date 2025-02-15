import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:get/get.dart';

class GroupMessageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GroupMessageController(
        messagesRepository: Get.find(),
        groupsRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
