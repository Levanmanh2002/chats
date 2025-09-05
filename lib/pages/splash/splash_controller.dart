import 'package:chats/models/profile/user_model.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final IProfileRepository profileRepository;

  SplashController({required this.profileRepository});

  final isLoggedIn = LocalStorage.getBool(SharedKey.isLoggedIn);

  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(milliseconds: 500)).then((value) => init());
  }

  void init() async {
    final token = LocalStorage.getString(SharedKey.token);

    if (token.isNotEmpty) {
      try {
        final response = await profileRepository.profile();

        if (response.isOk) {
          user.value = UserModel.fromJson(response.body['data']);
          if (user.value != null && user.value?.isEnableSecurityScreen == true) {
            Get.offAllNamed(Routes.CONFIRM_SECURITY_CODE);
          } else {
            onToPage();
          }
        } else {
          onToPage();
        }
      } catch (_) {
        onToPage();
      }
    } else {
      onToPage();
    }

    // if (isSecurity) {
    //   // Get.offAllNamed(Routes.CONFIRM_SECURITY_CODE);

    // } else if (isLoggedIn) {
    //   Get.offAllNamed(Routes.DASHBOARD);
    // } else {
    //   Get.offAllNamed(Routes.SIGN_IN);
    // }
  }

  void onToPage() {
    if (isLoggedIn) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.offAllNamed(Routes.SIGN_IN);
    }
  }
}
