import 'package:chats/pages/call/call_controller.dart';
import 'package:get/get.dart';

class CallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CallController(
        parameter: Get.arguments,
        messagesRepository: Get.find(),
      ),
    );
  }
}
