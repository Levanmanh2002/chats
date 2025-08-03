import 'package:chats/routes/pages.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:get/get.dart';

class FeaturesController extends GetxController {
  void restartAnimation() {
    // Animation will automatically restart due to repeat()
  }

  void navigateToNext() {
    LocalStorage.setBool(SharedKey.IS_SHOW_FEATURES_SCREEN, true);
    Get.offAllNamed(Routes.SIGN_IN);
  }
}
