import 'package:chats/pages/screen_security_code/screen_security_code_controller.dart';
import 'package:get/get.dart';

class ScreenSecurityCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ScreenSecurityCodeController(
        parameter: Get.arguments,
      ),
    );
  }
}
