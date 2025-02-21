import 'package:chats/pages/group_message_search/group_message_search_controller.dart';
import 'package:get/get.dart';

class GroupMessageSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GroupMessageSearchController(
        parameter: Get.arguments,
      ),
    );
  }
}
