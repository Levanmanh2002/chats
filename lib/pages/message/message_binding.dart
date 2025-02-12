import 'package:chats/pages/message/message_controller.dart';
import 'package:get/get.dart';

class MessageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MessageController(
        messagesRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
