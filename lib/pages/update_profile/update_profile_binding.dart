import 'package:chats/pages/update_profile/update_profile_controller.dart';
import 'package:get/get.dart';

class UpdateProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => UpdateProfileController(
        profileRepository: Get.find(),
        parameter: Get.arguments,
      ),
    );
  }
}
