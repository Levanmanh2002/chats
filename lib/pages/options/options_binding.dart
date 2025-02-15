import 'package:chats/pages/options/options_controller.dart';
import 'package:get/get.dart';

class OptionsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OptionsController(
        parameter: Get.arguments,
      ),
    );
  }
}
