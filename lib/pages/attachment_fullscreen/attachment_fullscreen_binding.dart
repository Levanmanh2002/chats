import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_controller.dart';
import 'package:get/get.dart';

class AttachmentFullscreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AttachmentFullscreenController(
        parameter: Get.arguments,
      ),
    );
  }
}
