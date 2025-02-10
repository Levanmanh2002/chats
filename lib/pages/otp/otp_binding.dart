import 'package:chats/pages/otp/otp_controller.dart';
import 'package:get/get.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OtpController(
        authRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
