import 'package:chats/pages/enter_code_mumber/enter_code_mumber_controller.dart';
import 'package:get/get.dart';

class EnterCodeMumberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EnterCodeMumberController(
        profileRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
