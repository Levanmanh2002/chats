import 'package:chats/routes/pages.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final isLoggedIn = LocalStorage.getBool(SharedKey.isLoggedIn);
  final isSecurity = LocalStorage.getBool(SharedKey.IS_SHOW_SECURITY_SCREEN);

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(milliseconds: 500)).then((value) => init());
  }

  void init() async {
    if (isSecurity) {
      Get.offAllNamed(Routes.CONFIRM_SECURITY_CODE);
    } else if (isLoggedIn) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.offAllNamed(Routes.SIGN_IN);
    }
  }
}
