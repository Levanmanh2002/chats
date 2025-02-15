import 'package:chats/pages/instant_message/instant_message_controller.dart';
import 'package:get/get.dart';

class InstantMessageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => InstantMessageController(
        messagesRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
