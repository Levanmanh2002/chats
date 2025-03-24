import 'package:chats/pages/confirm_security_code/confirm_security_code_controller.dart';
import 'package:get/get.dart';

class ConfirmSecurityCodeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ConfirmSecurityCodeController(),
    );
  }
}
