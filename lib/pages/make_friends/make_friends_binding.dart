import 'package:chats/pages/make_friends/make_friends_controller.dart';
import 'package:get/get.dart';

class MakeFriendsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MakeFriendsController(
        contactRepository: Get.find(),
        messagesRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
