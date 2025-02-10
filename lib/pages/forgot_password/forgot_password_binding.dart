import 'package:chats/pages/forgot_password/forgot_password_controller.dart';
import 'package:get/get.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ForgotPasswordController(
        contactRepository: Get.find(),
      ),
    );
  }
}
