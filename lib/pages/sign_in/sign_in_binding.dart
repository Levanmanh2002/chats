import 'package:chats/pages/sign_in/sign_in_controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SignInController(
        authRepository: Get.find(),
      ),
    );
  }
}
