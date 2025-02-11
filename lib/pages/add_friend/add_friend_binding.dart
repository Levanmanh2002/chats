import 'package:chats/pages/add_friend/add_friend_controller.dart';
import 'package:get/get.dart';

class AddFriendBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AddFriendController(
        contactRepository: Get.find(),
      ),
    );
  }
}
