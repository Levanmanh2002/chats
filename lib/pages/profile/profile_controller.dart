import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/models/setting/system_setting.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/image_utils.dart';
import 'package:chats/utils/launch_url.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart' as ver;

class ProfileController extends GetxController {
  final IProfileRepository profileRepository;
  final IDashboardRepository dashboardRepository;

  ProfileController({required this.profileRepository, required this.dashboardRepository});

  Rx<UserModel?> user = Rx<UserModel?>(null);

  var avatarFile = Rxn<XFile>();

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());
  Rx<SystemSetting?> systemSetting = Rx<SystemSetting?>(null);

  var phoneSupport = ''.obs;

  Timer? _timer;

  @override
  void onInit() async {
    await _getProfile();
    _systemSettingPusher();
    _trackingTimeOnline();
    _startTrackingTimerOnline();
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
      await FirebaseMessaging.instance.deleteToken();

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
        phoneSupport.value = response.body['data']['page']['contact_phone'];
        systemSetting.value = SystemSetting.fromJson(response.body['data']);
        await LocalStorage.setString(SharedKey.PUSHER_API_KEY, response.body['data']['pusher']['key']);
        Get.find<ChatsController>().initStreamPusher();
        _checkAppVersion();
      }
    } catch (e) {
      print(e);
    }
  }

  void _startTrackingTimerOnline() {
    _timer = Timer.periodic(const Duration(minutes: AppConstants.timeTrackingOnline), (timer) {
      _trackingTimeOnline();
    });
  }

  void _trackingTimeOnline() async {
    await dashboardRepository.trackingTimeOnline();
    log('Tracking time online');
  }

  Future<void> _checkAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;
    if (systemSetting.value == null) return;
    final version =
        Platform.isAndroid ? systemSetting.value?.androidVersion ?? '' : systemSetting.value?.iosVersion ?? '';
    if (version.isEmpty || currentVersion.isEmpty) return;

    final remoteVersion = ver.Version.parse(version);
    final localVersion = ver.Version.parse(currentVersion);
    if (remoteVersion <= localVersion || Get.context == null) return;
    showCupertinoModalPopup(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: Text('update'.tr, style: StyleThemeData.size16Weight700()),
            content: Text('update_desc'.trParams({'version': version}), style: StyleThemeData.size14Weight400()),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  launchUrlLink(
                    Platform.isAndroid ? systemSetting.value?.androidUrl ?? '' : systemSetting.value?.iosUlr ?? '',
                    isOpenBrowser: true,
                  );
                },
                child: Text('update'.tr),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
