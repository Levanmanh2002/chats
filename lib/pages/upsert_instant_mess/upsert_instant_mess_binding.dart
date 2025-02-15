import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_controller.dart';
import 'package:get/get.dart';

class UpsertInstantMessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UpsertInstantMessController(
        messagesRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
