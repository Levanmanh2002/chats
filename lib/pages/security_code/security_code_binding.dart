import 'package:chats/pages/security_code/security_code_controller.dart';
import 'package:get/get.dart';

class SecurityCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SecurityCodeController(
        profileRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
