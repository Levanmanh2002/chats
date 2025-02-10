import 'package:chats/pages/change_password/change_password_controller.dart';
import 'package:get/get.dart';

class ChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChangePasswordController(
        authRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
