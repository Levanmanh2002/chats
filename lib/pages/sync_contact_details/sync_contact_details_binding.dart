import 'package:chats/pages/sync_contact_details/sync_contact_details_controller.dart';
import 'package:get/get.dart';

class SyncContactDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SyncContactDetailsController(
        contactRepository: Get.find(),
      ),
    );
  }
}
