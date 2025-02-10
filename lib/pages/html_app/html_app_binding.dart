import 'package:chats/pages/html_app/html_app_controller.dart';
import 'package:get/get.dart';

class HtmlAppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HtmlAppController());
  }
}
