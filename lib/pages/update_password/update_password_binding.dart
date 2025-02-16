import 'package:chats/pages/update_password/update_password_controller.dart';
import 'package:get/get.dart';

class UpdatePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UpdatePasswordController(
        profileRepository: Get.find(),
      ),
    );
  }
}
