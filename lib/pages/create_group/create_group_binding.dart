import 'package:chats/pages/create_group/create_group_controller.dart';
import 'package:get/get.dart';

class CreateGroupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateGroupController(
        contactRepository: Get.find(),
        groupsRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
