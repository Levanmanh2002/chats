import 'package:chats/pages/temp/_controller.dart';
import 'package:get/get.dart';

class TStateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TStateController());
  }
}
