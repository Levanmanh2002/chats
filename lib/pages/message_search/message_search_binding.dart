import 'package:chats/pages/message_search/message_search_controller.dart';
import 'package:get/get.dart';

class MessageSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MessageSearchController(
        parameter: Get.arguments,
      ),
    );
  }
}
