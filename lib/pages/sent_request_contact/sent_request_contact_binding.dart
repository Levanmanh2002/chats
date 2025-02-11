import 'package:chats/pages/sent_request_contact/sent_request_contact_controller.dart';
import 'package:get/get.dart';

class SentRequestContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SentRequestContactController(
        contactRepository: Get.find(),
      ),
    );
  }
}
