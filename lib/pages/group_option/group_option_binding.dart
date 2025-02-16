import 'package:chats/pages/group_option/group_option_controller.dart';
import 'package:get/get.dart';

class GroupOptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GroupOptionController(
        groupsRepository: Get.find(),
        messagesRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
