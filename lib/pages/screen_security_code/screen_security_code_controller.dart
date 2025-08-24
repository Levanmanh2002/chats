import 'dart:developer';

import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/screen_security_code/screen_security_code_parameter.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ScreenSecurityCodeController extends GetxController {
  final IProfileRepository profileRepository;
  final ScreenSecurityCodeParameter parameter;

  ScreenSecurityCodeController({required this.profileRepository, required this.parameter});

  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = parameter.user;
  }

  void updateProfile(UserModel newUser) {
    user.value = newUser;
    user.refresh();
  }

  void onLogoutPasscode() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await profileRepository.logoutPasscode('srceen');

      if (response.isOk) {
        String? savedLanguage = LocalStorage.getString(SharedKey.language);

        await LocalStorage.clearAll();
        try {
          await FirebaseMessaging.instance.deleteToken();
        } catch (e) {
          log("Firebase deleteToken failed: $e", name: 'logout');
        }

        if (savedLanguage.isNotEmpty) {
          await LocalStorage.setString(SharedKey.language, savedLanguage);
        }

        DialogUtils.showSuccessDialog(response.body['message']);

        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
