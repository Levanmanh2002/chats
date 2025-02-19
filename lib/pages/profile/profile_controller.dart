import 'dart:developer';

import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/image_utils.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final IProfileRepository profileRepository;
  final IDashboardRepository dashboardRepository;

  ProfileController({required this.profileRepository, required this.dashboardRepository});

  Rx<UserModel?> user = Rx<UserModel?>(null);

  var avatarFile = Rxn<XFile>();

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  @override
  void onInit() async {
    await _getProfile();
    _systemSettingPusher();
    super.onInit();
  }

  Future<void> onRefresh() async {
    _getProfile();
  }

  Future<void> _getProfile() async {
    try {
      final response = await profileRepository.profile();

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['data']);
        PusherService().connect();
      }
    } catch (e) {
      print(e);
    }
  }

  void updateProfile(UserModel newUser) {
    user.value = newUser;
    user.refresh();
  }

  void pickImageAvatar() async {
    avatarFile.value = await ImageUtils.pickImage();

    if (avatarFile.value != null) {
      updateAvatar();
    }
  }

  void updateAvatar() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      List<MultipartBody> multipartBody = [
        MultipartBody('avatar', avatarFile.value),
      ];

      final response = await profileRepository.updateAvatar(multipartBody);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        _getProfile();
        user.refresh();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void logout({bool isShowTitle = false}) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await profileRepository.logout();
      String? savedLanguage = LocalStorage.getString(SharedKey.language);

      await LocalStorage.clearAll();

      if (savedLanguage.isNotEmpty) {
        await LocalStorage.setString(SharedKey.language, savedLanguage);
      }

      if (isShowTitle) DialogUtils.showSuccessDialog(response.body['message']);
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      log(e.toString(), name: 'logout');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void deleteAccount() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await profileRepository.deleteAccount();

      if (response.statusCode == 200) {
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

  void _systemSettingPusher() async {
    try {
      final response = await dashboardRepository.systemSettings();

      if (response.statusCode == 200) {
        await LocalStorage.setString(SharedKey.PUSHER_API_KEY, response.body['data']['pusher']['key']);
        // log(response.body['data']['pusher']['key'], name: 'PUSHER_API_KEY');
        Get.find<ChatsController>().initStreamPusher();
      }
    } catch (e) {
      print(e);
    }
  }
}
