import 'package:chats/pages/forward/forward_controller.dart';
import 'package:get/get.dart';

class ForwardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ForwardController(
        chatsRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
