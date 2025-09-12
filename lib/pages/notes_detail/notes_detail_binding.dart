import 'package:chats/pages/notes_detail/notes_detail_controller.dart';
import 'package:get/get.dart';

class NotesDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => NotesDetailController(
        parameter: Get.arguments,
        notesRepository: Get.find(),
        notesController: Get.find(),
      ),
    );
  }
}
