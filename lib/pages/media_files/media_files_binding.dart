import 'package:chats/pages/media_files/media_files_controller.dart';
import 'package:get/get.dart';

class MediaFilesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MediaFilesController(
        messagesRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
