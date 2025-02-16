import 'package:chats/pages/view_group_members/view_group_members_controller.dart';
import 'package:get/get.dart';

class ViewGroupMembersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ViewGroupMembersController(
        parameter: Get.arguments,
        groupsRepository: Get.find(),
      ),
    );
  }
}
