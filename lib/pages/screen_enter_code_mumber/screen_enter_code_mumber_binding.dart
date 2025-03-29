import 'package:chats/pages/screen_enter_code_mumber/screen_enter_code_mumber_controller.dart';
import 'package:get/get.dart';

class ScreenEnterCodeMumberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ScreenEnterCodeMumberController(
        profileRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
