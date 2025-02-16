import 'package:chats/pages/sync_contact/sync_contact_controller.dart';
import 'package:get/get.dart';

class SyncContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SyncContactController(
        profileRepository: Get.find(),
      ),
    );
  }
}
